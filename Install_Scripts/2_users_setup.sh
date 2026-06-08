#!/bin/bash

# ==============================================================================
# We need to change the default root password

echo
echo "Lets get the system setup for use"
echo "Begin by changing the root password"

passwd
echo

# ==============================================================================
# Create new user for running programs

echo "Now we will create a new User"
echo "This will be the User account for running programs"

echo "Enter username:"
read username

adduser $username
echo "New User ($username) created"

usermod -aG sudo $username
echo "User ($username) added to sudo group"
echo

# ==============================================================================

# Add setting to TEMPORARILY allow root login
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/allow-root.conf
echo "Config file created"

# Install some basic requirements
apt install git python3-full ca-certificates curl -y # Ansible Requirements
echo

# Reboot. Login with new account
echo "All done. Next up......SSH access."
echo "After rebooting login with the NEW USER ACCOUNT. Then run the next script."
read -p "Press any key to continue..." -n 1 -s
echo
echo "-----------------Rebooting--------------"
echo
sleep 1
echo "-----------------3--------------"
echo
sleep 1
echo "-----------------2--------------"
echo
sleep 1
echo "-----------------1--------------"
sleep 1

reboot