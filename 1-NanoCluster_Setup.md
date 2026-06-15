# AMPG: SiPeed Nanocluster - M4N Dock AI Homelab Setup

The following is what I came up with going down a few rabbit holes. I tried updating the kernel, tried u-boot, don't know serial stuff, and its usb-c serial on these, expanded the boot partition, renaming files, come to the conclusion im stuck with the default 5.15.73 kernel. Im thinking its a custom kernel, and they've stuck the fat16 64MB boot partition to prevent any automatic updates so new kernel headers don't mess with programs your trying to install with ansible playbooks your currently learning and understanding. I learned something about something new, and I decided to share

Items needed:
  - SiPeed Nanocluster
  - M4N Module (at least 1)
  - SDCard
  - PC
  - Mild cognitive function
  - 2 Screens
  - 2nd Keyboard (mouse optional, we're in the terminal)

Tools Used:
  - SiPeed WiKi - https://wiki.sipeed.com
    - Original Instructions: https://wiki.sipeed.com/hardware/zh/maixIV/m4ndock/system-update.html
  - BalenaEtcher - https://etcher.balena.io/
  - Ansible - [Helpful Video Here](https://www.youtube.com/watch?v=5hycyr-8EKs) by NetworkChuck

*Side note: Slap some masking tape on the back and write a number. I also provided a Cluster_Details.txt for you to fill in as you go along. It might just come in handy.*

# Step 1 - Update/Install Module

Download latest version from https://dl.sipeed.com/ (20250818 at time of writing)

I found the MEGA option more stable/accessible, but lacks some of the smaller development files, great for the image though.


## Install the OS

First we need to prep the SD Card.

1. Unpack the download. The final filename should be something like: sdcard-20250818.img .xz .zst ect...are all compressed. Just unpack them.

2. Flash the system image to your SDCard, or Use [balenaEtcher](https://etcher.balena.io/)
```
sudo dd if=sdcard.img of=/path/to/tfcard bs=4G conv=sparse,fsync status=progress
```

*In the past there was a problem that every module had the same MAC address, not good. Honestly dont know if tis still there, because im seeing this as good practice now. But, this way I can use my router to assign an IP to each modules MAC, meaning even if I flash again the IPs will work.*

Start by tweaking the config file and giving the install its MAC address.

1. Mount the new BOOT partition on the SD Card.

2. Copy `Install_Scripts` folder to the boot partition. 
  *Yes i know, but the Data partition is locked, and its only 2 bash scripts. If I had an m.2 for them obvs i'd put all on there and slap it in /mnt/foobar.*

3. Edit the config.txt
  - Find the line starting with 'dtb_img_name=' Add the correct file path:
    - dtbs/m4ncluster.dtb


##### 10. Set the MAC Address

Edit the config.txt

At the bottom add this:
```
## Module _ MAC Address
# ----------------------
ethaddr=d0:00:00:00:00:01
eth1addr=d0:00:00:00:00:02
```
(This will need altering before flashing a 2nd/3rd/4th device)


After `Safely, ejecting the SDCard!` Plug the SDCard into the module, and boot the Live System:
```
1. Insert the SDCard into the SDCard slot at the bottom left of the M4N-Dock tail. Labelled TF.

2. Plug the module into the Cluster.
   Plug in all peripherals, monitor and network.

3. At the Top, Back of the module, there is a tiny button. Labelled Boot. You may have to unfold your 6th and 7th fingers, but hold this button in, while connecting the power, for about 10 seconds? I can tell because the RGB keyboard lights up. *HDMI doesn't run until later*

4. As long as the blue and green LEDs are on, you should be good. Now just wait for the login page
```

Now we Install the OS onto the module


1. Login to the live system
    - User: root
    - Psswd: root

2. Open Terminal, and run the install script. `It will reboot the device`
```
cd /boot/Install_scripts
```
```
./1_flash_os.sh
```
*Its just a stupid simple bash script. AFAIK the parameters should never change. But please check?*

or manually
```
# Create and flash the FS, boot, and root

dd if=/dev/mmcblk1 of=/dev/mmcblk0 bs=3M count=1 conv=fsync
sync
dd if=/dev/mmcblk1p1 of=/dev/mmcblk0p1 bs=64M conv=fsync
dd if=/dev/mmcblk1p2 of=/dev/mmcblk0p2 bs=1G conv=sparse,fsync status=progress
fsck -y /dev/mmcblk0p2
sync

# Expand the FS to fill the eMMC

parted /dev/mmcblk0 resizepart 2 100%
    (Ignore warnings.)
resize2fs /dev/mmcblk0p2
sync
reboot
```

3. Now you can unplug the device, remove the SDCard, and start it up again. Or leave the card in whichever, im not your boss.


## Initial Setup


Now for the sensible setup bits. First passwords and user accounts. `It will reboot the device`

```
cd /boot/Install_scripts
```
```
./2_users_setup.sh
```

Login with the `New User`

Setup SSH with keygen `It will ASK to reboot the device`

```
cd /boot/Install_scripts
```
```
./3_ssh_setup.sh
```

# Repetition

Now....its time to.....uuurgh....repeat this, for each....and every module.

But once this is done, we can put away the 2nd grimy keyboard.
Return the desk to its normal layout, and continue through ssh.

Start by putting the SDCard back in your PC
Mount BOOT partition
- Edit config.txt
- Change the ethaddr.

goto [10](#####10.)


# FINALLY!!!
Now is the time to power it off, and plug in....ALL 4 MODULES!!!

Power on the machine.
```
POWER = True;

if (all 4 modules connect through ssh) && POWER {
  PARTY()
  ResetDesk()
  Continue
} else {
  Weep(inShower)
}
```

Share ssh keys between your systems. All 4 nodes will need to talk to each other across SSH.
```
ssh-copy-id root@10.69.30.51
```
