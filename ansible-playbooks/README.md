# AMPG Ansible Playbooks

Ansible playbooks adapted from [`rishavnandi/ansible_homelab`](https://github.com/rishavnandi/ansible_homelab) to configure the SiPeed M4N Nanocluster homelab. These playbooks run on a freshly provisioned Debian system and install Docker, Traefik (reverse proxy), Authelia (2FA), and other homelab apps.

## Upstream Credits

A huge thanks to the original authors whose work this is based on:

- **Jeff Geerling** – [Ansible for DevOps](https://www.ansiblefordevops.com/) – the definitive Ansible book and blog
- **rishavnandi** – [`ansible_homelab`](https://github.com/rishavnandi/ansible_homelab) – the base playbooks I adapted
- **linuxserver.io** – [Docker containers](https://linuxserver.io/) for almost everything
- **Wolfgang** – [`notthebee/infra`](https://github.com/notthebee/infra) – the Docker install fix for Ubuntu 22.04
- **Authelia** – [2FA service](https://www.authelia.com/)
- **Traefik** – [Reverse proxy](https://traefik.io/)
- **Cloudflare** – [Zero SSL](https://www.cloudflare.com/products/zero-ssl/)
- **HashiCorp** – [Terraform docs](https://learn.hashicorp.com/)
- **Awesome Selfhosted** – [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)

## Quickstart

1. Clone the repo to your local machine:

```bash
git clone https://github.com/rishavnandi/ansible_homelab.git
```

2. Update `inventory` with your server IPs and `group_vars/vars.yml` with your settings (pgid/puid via `id`, Cloudflare API token, Traefik auth hash, etc.)

3. Run the playbook:

```bash
ansible-playbook main.yml
```

## Notes

- Most apps don't expose ports; they're on a custom Docker network and accessed via Traefik.
- If you don't want certain apps, remove them from `main.yml` (all containers are tasks in the `tasks/` folder).
- See the [Authelia docs](https://www.authelia.com/configuration/notifications/smtp/) for SMTP setup.

## Included Terraform script

Terraform script to spin up an AWS instance to run the playbook on. See [HashiCorp's Terraform with AWS tutorial](https://learn.hashicorp.com/tutorials/terraform/aws-build).

## Goals

- [x] Add support for Ubuntu 22.04
- [x] Add support for Debian 11
- [x] Add support for RedHat based distros (Fedora, CentOS)
- [x] Find a permanent fix for the Docker install issue on Ubuntu 22.04
