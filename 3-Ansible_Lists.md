# Prerequisites

```
ansible-galaxy collection install community.general
```

# Setup Inventory

Inventory contents
```
m4ncluster:
    hosts:
        10.69.0.51:
        10.69.0.52:
        10.69.0.53:
        10.69.0.54:
    vars:
        ansible_user: <Username_we_made>
        ansible_password: <Password_we_made>
        ansible_ssh_private_key_file: /home/<Username_we_made>/.ssh/id_ed25519
```



































## k3s

This is the distribution of Kubernetes that SiPeed has on their own site. Looking at their instructions, there is no specific actions to take for our devices. So...

k3s Ansible Playbooks by the k3s team. [https://github.com/k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible)

Download the repo

Goto `/playbooks/site.yml`
    - Line 9:
        - REMOVE: `role: raspberrypi`

We want a 'Standard' Debian install. The RasPi tweaks break things.

