#!/bin/bash

# ==============================================================================
# First we grab the variables we need

# Get the module number
echo "Enter Module Number:"
read num

# Get the users IP address
echo ""
echo "Enter IP address of control system:"
read outerip

# Grab username
echo ""
echo "Enter control username:"
read username

# Check variables
echo ""
echo "Setting node number to: $num"
echo "Control system: $username@$outerip"
echo "If these are wrong, restart the script."
read -p "Press any key to continue..." -n 1 -s

# ==============================================================================

# Create an SSH key
echo ""
ssh-keygen -t ed25519 -C "m4ncluster-node-$num" -q

# Share ssh keys between your systems. (Both ways)
echo ""
echo "Copying ssh keys to $username@$outerip"
ssh-copy-id $username@$outerip
echo
systemctl restart sshd

# Check ssh access
echo ""
echo "Now you need to goto your control system and do the same there."
echo "Please run - ssh-copy-id $username@<this ip>"
echo "After this you should have passwordless SSH access to this node."
read -p "Press any key to continue..." -n 1 -s

# After confirming ssh access without password
echo "Clearing up"
echo "Removing Root login from sshd_config"
sudo rm /etc/ssh/sshd_config.d/allow-root.conf

echo "All done"
echo "You now have full ssh access without password."
echo

read -p "Hit enter when ready to reboot" -n 1 -s

reboot