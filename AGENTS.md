# AGENTS.md — SiPeed NanoCluster (M4N + K3S) Setup Guide

## What This Repo Is

Personal homelab setup guide and automation for a **SiPeed NanoCluster** with 4 M4N modules (RK3576, ARM64/aarch64) + 1 RISC-V switch. Running Debian-based OS with Ansible provisioning, k3s (Kubernetes), and Docker-based homelab apps.

## Critical Gotchas

- **Kernel is stuck at 5.15.73.** Custom kernel — cannot update without u-boot/serial access. See `notes`.
- **All M4N modules ship with the same MAC address.** Must set unique `ethaddr`/`eth1addr` in `config.txt` on the BOOT partition before flashing each module.
- **Do NOT put data on eMMC.** Map NVMe/external storage to `/home` before installing anything heavy.
- **`Cluster_Details.txt` contains plaintext credentials and Nomad ACL tokens.** It is `.gitignore`d — never commit it. Use `Cluster_Details_template.txt` as a safe template.

## Directory Map

| Path | Purpose |
|---|---|
| `1-NanoCluster_Setup.md` | Hardware setup (flash OS, set MAC, SSH, repeat per module) |
| `2-Post_Install.md` | Post-install (permanent IP, data drives, macchanger fallback) |
| `3-Ansible_Lists.md` | Ansible prerequisites, k3s setup notes |
| `ansible-playbooks/` | Ansible automation (forked from `rishavnandi/ansible_homelab`) |
| `ansible-playbooks/tasks/` | Individual task files (essential, docker, oh-my-zsh, etc.) |
| `ansible-playbooks/group_vars/all/vars.yml` | Main Ansible variables (user, dirs, packages, Docker config) |
| `Install_Scripts/` | Bash scripts run from live SD card (flash OS, users, SSH) |
| `M4N_OS/` | OS images and resources (gitignored) |
| `VERSION` | Version tag for GitHub releases (set `0.0.1`) |

## Branches

- `main` — active development branch (created from `master`).

## Ansible

**Working directory:** `ansible-playbooks/`

```bash
# Prerequisites
ansible-galaxy collection install community.general

# Run playbook (from ansible-playbooks/)
ansible-playbook main.yml
```

**Inventory** is at `ansible-playbooks/inventory` (set in `ansible.cfg`).

**Current playbook flow** (in `main.yml`):
1. `essential.yml` — timezone, apt update, packages, pip, create dirs
2. `oh_my_zsh.yml` — zsh + oh-my-zsh + powerlevel10k
3. `docker.yml` — Docker Engine (ARM64-aware) + `homelab` bridge network
4. `add_ownership.yml` — fix permissions on data/docker dirs
5. Reboot

**Docker app tasks** (duplicati, filebrowser, heimdall, monitoring, syncthing, uptime_kuma) are **commented out** and gated by a `server` variable. To enable, uncomment the loop in `main.yml` and set `server: true` in inventory.

**`server` variable:** Controls whether Docker app directories are created and app tasks run. Defaults to `false`.

## k3s Setup

- Use [k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible).
- **CRITICAL:** Remove the `raspberrypi` role from `site.yml` (line ~9). The RasPi tweaks break the M4N modules. Standard Debian install only.

## Install Scripts (Run from Live SD Card)

Order matters. Each script reboots before the next:

1. `1_flash_os.sh` — Flash OS from SD card to eMMC, expand filesystem
2. `2_users_setup.sh` — Change root password, create new user, install basics
3. `3_ssh_setup.sh` — Generate ed25519 key, share keys with control system

## Security

- `.ignore` blocks `/secrets/**`, `*.crt`, `*.key`, `*.pem`, `.env*` files.
- Nomad ACL bootstrap tokens are stored in `Cluster_Details.txt` (gitignored).
- SSH root login is temporarily enabled during setup, then disabled by `3_ssh_setup.sh`.

## Architecture Target

End goal: k3s cluster across 4 M4N nodes with distributed workloads (LLM inference, homelab services). Current state: nodes provisioned via Ansible, k3s in progress.

## Versioning

A `VERSION` file at the repo root tracks the release version for GitHub Releases. Current version: `0.0.1`. Update it before tagging a release.
