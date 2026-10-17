# AMPGuide: SiPeed Nanocluster — M4N/Maix-IV Dock  AI Homelab Setup

**THIS IS A WORK IN PROGRESS**

A Morons Personal Guide, for setting up a SiPeed Nanocluster with 4 MAIX-IV as an AI homelab.

I came up with this setup going down a few rabbit holes. I tried updating the kernel, tried u-boot, and figured out the USB-C serial on these modules. I expanded the boot partition and renamed files — came to the conclusion I'm stuck with the default 5.15.73 kernel. I'm thinking it's a custom kernel, and they've stuck the fat16 64MB boot partition to prevent any automatic updates so new kernel headers don't mess with programs you're trying to install with ansible playbooks you're currently learning and understanding. I learned something about something new, and I decided to share.

## What This Repo Is

Personal homelab setup guide and automation for a **SiPeed NanoCluster** with 4 M4N modules. Running Debian-based OS with Ansible provisioning of; ax-llm, nomad, k3s (Kubernetes), and Docker-based homelab apps.

## Critical Gotchas

- **Kernel is stuck at 5.15.73.** Custom kernel — cannot update without u-boot/serial access.
- **All M4N modules ship with the same MAC address.** Must set unique `ethaddr`/`eth1addr` in `config.txt` on the BOOT partition before flashing each module.
- **Do NOT put data on eMMC.** Map NVMe/external storage to `/home` before installing anything heavy.
- **`Cluster_Details.txt` contains plaintext credentials and Nomad ACL tokens.** It is `.gitignore`d — never commit it. Use `Cluster_Details_template.txt` as a safe template.

## Quickstart

1. Flash OS to SD card (see [`1-NanoCluster_Setup.md`](1-NanoCluster_Setup.md))
2. Set unique MAC addresses per module
3. Boot live system and run install scripts
4. Configure permanent IPs and mount NVMe to `/home`
5. Run Ansible playbooks for k3s/Docker setup

## Project Structure

| Path | Purpose |
|---|---|
| [`1-NanoCluster_Setup.md`](1-NanoCluster_Setup.md) | Hardware setup (flash OS, set MAC, SSH, repeat per module) |
| [`2-Post_Install.md`](2-Post_Install.md) | Post-install (permanent IP, data drives, macchanger fallback) |
| [`3-Ansible_Lists.md`](3-Ansible_Lists.md) | Ansible prerequisites, k3s setup notes |
| [`ansible-playbooks/`](ansible-playbooks/) | Ansible automation (forked from [`rishavnandi/ansible_homelab`](https://github.com/rishavnandi/ansible_homelab)) |
| [`Install_Scripts/`](Install_Scripts/) | Bash scripts run from live SD card (flash OS, users, SSH) |
| [`M4N_OS/`](M4N_OS/) | OS images and resources (gitignored) |

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

## Security

- `.ignore` blocks `/secrets/**`, `*.crt`, `*.key`, `*.pem`, `.env*` files.
- Nomad ACL bootstrap tokens are stored in `Cluster_Details.txt` (gitignored).
- SSH root login is temporarily enabled during setup, then disabled by `3_ssh_setup.sh`.

## Architecture Target

End goal: k3s cluster across 4 M4N nodes with distributed workloads (LLM inference, homelab services). Current state: nodes provisioned via Ansible, k3s in progress.

## Credits

- **SiPeed** — [M4N-Dock](https://wiki.sipeed.com/hardware/zh/maixIV/m4ndock/system-update.html)
- **BalenaEtcher** — OS flashing
- **NetworkChuck** — [Ansible tutorial](https://www.youtube.com/watch?v=5hycyr-8EKs)
- **rishavnandi** — [`ansible_homelab`](https://github.com/rishavnandi/ansible_homelab)
- **Jeff Geerling** — [Ansible for DevOps](https://www.ansiblefordevops.com/)
- **linuxserver.io** — Docker containers
- **Authelia**, **Traefik**, **Cloudflare** — Reverse proxy & 2FA
- **HashiCorp** — Terraform docs

## License

MIT License — feel free to use, modify, and share. Just let me know if it works!
