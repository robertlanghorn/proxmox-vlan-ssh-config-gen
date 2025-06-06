#!/bin/bash

# proxmox-vlan-ssh-config-gen.sh

# Directory containing your SSH private keys
KEYS_DIR="$HOME/.ssh"
CONFIG_FILE="$KEYS_DIR/config"

# Backup existing config if it exists
[ -f "$CONFIG_FILE" ] && cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# Start new config file with preserved Ciphers line
> "$CONFIG_FILE"
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com" >> "$CONFIG_FILE"

# Iterate through all container-* key files (no .pub)
for key_path in $(ls "$KEYS_DIR"/container-*-key | sort -t'-' -k2n); do
  # Skip if this is a .pub key
  [[ "$key_path" == *.pub ]] && continue

  key_file=$(basename "$key_path")
  container_id=$(echo "$key_file" | cut -d'-' -f2)

  # Calculate VLAN and IP octets
  vlan=$((10 * ${container_id:0:${#container_id}-2}))
  ip_last_octet=$((10#${container_id: -2}))
  ip="10.0.$vlan.$ip_last_octet"

  # Write to SSH config
  cat >> "$CONFIG_FILE" <<EOF
Host vm$container_id
  HostName $ip
  User ubuntu
  IdentityFile $KEYS_DIR/$key_file

EOF

done

# Set correct permissions
chmod 600 "$CONFIG_FILE"
echo "SSH config regenerated at $CONFIG_FILE"

