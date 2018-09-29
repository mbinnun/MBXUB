#!/bin/bash

if [ ! -f "/livemedia.distrib" ]
  then
    echo " "
    echo "The remaster script should only be run from a live media"
    echo "and not from the source partition itself!"
    echo " "
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]
  then
    echo " "
    echo "Remaster script usage example: ./remaster.sh sda1 sda2"
    echo " "
    echo "Change both 'sda1' and 'sda2' to your needs, where:"
    echo "/dev/sda1 is the partition that holds your modified installed system"
    echo "/dev/sda2 is the workspace partition ('filesystem.squashfs' will be generated there)"
    echo " "
    echo "Also make sure that:"
    echo "-both partitions 'sda1' and 'sda2' exist, and their filesystem-type is ext4/ext3 "
    echo "-partition 'sda2' has enough space, approximately [1.7 * actual-data-size-in-sda1] "
    echo " "
    echo "** Use at your own risk if not sticking to the instructions."
    echo " "
    exit 1
fi

SRC_DRIVE="$1"
TRGT_DRIVE="$2"

# SUDO PASSWORD
sudo echo " "

# MOUNT
echo "Unmounting drives '/dev/$SRC_DRIVE' and '/dev/$TRGT_DRIVE' ..."
sudo umount /dev/$SRC_DRIVE
sudo umount /dev/$TRGT_DRIVE
echo " "
echo "Mounting drives '/dev/$SRC_DRIVE' and '/dev/$TRGT_DRIVE' ..."
sudo rm -rf /mnt/$SRC_DRIVE
sudo rm -rf /mnt/$TRGT_DRIVE
sudo mkdir -p /mnt/$SRC_DRIVE
sudo mkdir -p /mnt/$TRGT_DRIVE
sudo mount /dev/$SRC_DRIVE /mnt/$SRC_DRIVE
sudo mount /dev/$TRGT_DRIVE /mnt/$TRGT_DRIVE

# REMASTER
echo " "
echo "Cleaning old workspace, please wait ..."
sudo rm -f /mnt/$TRGT_DRIVE/filesystem.squashfs
sudo rm -rf /mnt/$TRGT_DRIVE/remastered
sudo mkdir -p /mnt/$TRGT_DRIVE/remastered
sync
echo " "
echo "Copying files from source to workspace, please wait ..."
sudo rsync -a /mnt/$SRC_DRIVE/ /mnt/$TRGT_DRIVE/remastered --exclude=/mnt/$SRC_DRIVE/{dev,live,lib/live/mount,cdrom,mnt,proc,sys,media,run,tmp,var/run,var/tmp,rofs,cow,casper-rw-backing,lost+found}
sync
sudo rm -f /mnt/$TRGT_DRIVE/remastered/livemedia.distrib
sudo touch /mnt/$TRGT_DRIVE/remastered/livemedia.distrib
sync
echo " "
echo "Packing up filesystem, please wait ..."
sudo mksquashfs /mnt/$TRGT_DRIVE/remastered/ /mnt/$TRGT_DRIVE/filesystem.squashfs -comp lz4 -Xhc
sync
echo " "
echo "The 'filesystem.squashfs' should be now generated and prepared on /mnt/$TRGT_DRIVE."
echo "Use this file to overwrite an existing 'filesystem.squashfs' from the /casper directory on the ISO."
echo "By doing this, the ISO is remastered to peform exactly as your modified system."
echo " "

