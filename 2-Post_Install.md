## Step 1 - Permanent IP

I use my router to assign the IP I want for each device.
This is why during installation we set each devices MAC address.
In previous testing i've ended up with all 4 modules receiving the same default MAC address.

## macchanger via boot script

If for some reason, you can't/won't do things that way, this process will create a systemd service to run macchanger at boot time. (No guarantees)

Install and setup macchanger
```
apt install macchanger net-tools

ip a

sudo macchanger --show end0

macchanger --mac=<mac_address> end0
```

Create systemd service file to run on startup
```
sudo nano /etc/systemd/system/changemac@.service

[Unit]
Description=changes mac for %I
Wants=network.target
Before=network.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
ExecStart=/usr/bin/macchanger -m <mac_address> %I
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

Enable the service
```
sudo systemctl enable changemac@<interface_name>.service
```

## Step 2 - Data drive/s

The advice seems to be 'Do NOT run the database files, docker folders etc, on the eMMC storage.'
And I am following this thought process. I have a 500Gb NVME drive, and I have mapped that to /home.This way anything I do will be hasppening on the NVME and not hammering the mmc flash.

If you have any form of additional storage that you are going to auto mount at boot, then do it here.

[Some Random Guide](https://siberoloji.com/how-to-enable-automatic-mounting-of-drives-on-boot-in-debian-12-bookworm/#method-2-using-systemd-automount)

some useful commands
```
sudo mkdir /mnt/mydrive
sudo chmod 777 /mnt/mydrive
sudo chown -R dev /mnt/mydrive
sudo nano /etc/fstab
```

## Reboot

## END?

At this point I would consider the M4N Modules "Up and ready". They are all installed, working SSH connections and repeatable connections.

But...

Next there is a collection of Ansible playbooks to explore. My intent is have k3s or some version of Kubernetes running across them, maybe docker, definitely distributed llama.

If you dont know ansible I suggest a [Helpful Video Here](https://www.youtube.com/watch?v=5hycyr-8EKs) by NetworkChuck
