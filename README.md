# 🧰 Proxmox VLAN SSH Config Generator

This script automatically generates a `~/.ssh/config` file to streamline SSH access to Proxmox VMs or containers. It's tailored for homelab environments that use a VLAN-based IP scheme derived from container IDs.

---

## 🔧 Overview

This script is built specifically for Robert Langhorn's Proxmox homelab setup. Each container ID corresponds directly to the VLAN and IP address the container is assigned to. For example:

* Container ID `856` is on **VLAN 80**
* It receives the IP address: `10.0.80.56`

  * `80` comes from the first digits (VLAN × 10)
  * `56` is derived from the last two digits of the ID

The script:

* Scans `~/.ssh/` for private keys named like `container-856-key`
* Extracts container IDs from the filenames
* Generates corresponding SSH config entries
* Inserts a standard `Ciphers` line at the top
* Sorts entries numerically by container ID
* Backs up the previous config to `config.bak`

Example entry generated:

```ssh
Host vm856
  HostName 10.0.80.56
  User ubuntu
  IdentityFile ~/.ssh/container-856-key
```

---

## 📥 Installation

```bash
cd ~
git clone git@github.com:robertlanghorn/proxmox-vlan-ssh-config-gen.git
cd proxmox-vlan-ssh-config-gen
chmod +x proxmox-vlan-ssh-config-gen.sh
```

---

## 🚀 Usage

⚠️ **Warning**: This script **overwrites** your existing `~/.ssh/config` file. Any existing configuration, including custom `Ciphers` lines, will be replaced.

To regenerate your SSH config:

```bash
./proxmox-vlan-ssh-config-gen.sh
```

This will:

* Backup your current config as `~/.ssh/config.bak`
* Generate a new, alphabetically sorted SSH config from available keys

---

## ✅ Requirements

* Private SSH keys are named `container-<id>-key`
* Keys are created after cloning a **cloud-init-enabled Proxmox VM template**
* Remote VMs/containers allow login with `User ubuntu`
* VLANs and IPs follow the ID-to-VLAN mapping scheme described above

---

## 🧠 Notes

* Ideal for homelabs with structured IP/VLAN assignment
* Run the script after provisioning or rekeying VMs

---

## 👤 Author

GitHub: [@robertlanghorn](https://github.com/robertlanghorn)
