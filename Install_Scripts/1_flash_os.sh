#!/bin/bash

# ==============================================================================
# First create the FS and flash the OS

{

    echo "-----------------Flashing OS--------------"
    echo "Making Filesystem"

    # First check the filesystems are named as expected
    if [ -b /dev/mmcblk1 ] && [ -b /dev/mmcblk0 ]; then
        # If they are there then create the FS
        dd if=/dev/mmcblk1 of=/dev/mmcblk0 bs=3M count=1 conv=fsync
        sync
    else # Otherwise crash out, and install manually
        echo "Error: /dev/mmcblk1 or /dev/mmcblk0 does not exist. Please install manually"
        exit 1
    fi

    echo "FS Created"
    echo
    echo "Flashing Boot"

    # Flash the bootloader
    dd if=/dev/mmcblk1p1 of=/dev/mmcblk0p1 bs=64M conv=fsync
    sync

    echo
    echo "Boot Flashed"
    echo
    echo "Flashing OS"

    # Flash and check the OS
    dd if=/dev/mmcblk1p2 of=/dev/mmcblk0p2 bs=1G conv=sparse,fsync status=progress
    fsck -y /dev/mmcblk0p2
    sync

    echo
    echo "-----------------OS Flashed--------------"
}


# ==============================================================================
# Now Expand the FS to fill the eMMC

{
    echo
    echo "-----------------Expanding FS--------------"

    parted /dev/mmcblk0 resizepart 2 100% --script
    resize2fs /dev/mmcblk0p2
    sync

    echo "-----------------FS Expanded--------------"
    echo
}


# ==============================================================================

echo "-----------------Rebooting--------------"
echo
echo "-----------------3--------------"
echo
sleep 1
echo "-----------------2--------------"
echo
sleep 1
echo "-----------------1--------------"
sleep 1

reboot