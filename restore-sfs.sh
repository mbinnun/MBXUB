#!/bin/bash

if [ ! -f "/livemedia.distrib" ]
  then
    echo " "
    echo "The restore script should only be run from a live media"
    echo "and not from the partition itself!"
    echo " "
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then
    echo " "
    echo "Restore script usage example: ./restore.sh sda1 sda /cdrom/casper/filesystem.squashfs"
    echo " "
    echo "Change 'sda1' and 'sda' to your needs, where:"
    echo "/dev/sda1 is the target partition, where you want to install the system"
    echo "/dev/sda1 is freshly formatted to ext4/ext3 filesystem-type"
    echo "/dev/sda1 has enough space, approximately [2.8 * live-system-size]"
    echo "/dev/sda is the drive where you want to install GRUB to the MBR "
    echo "/dev/sda contains a swap partition"
    echo " "
    echo "Make sure to use the correct path to the SquashFS file."
    echo " "
    echo "** Use at your own risk if not sticking to the instructions."
    echo " "
    exit 1
fi

TRGT_DRIVE="$1"
MBR_DRIVE="$2"
SFS_FILE="$3"

# SUDO PASSWORD
sudo echo " "

# MOUNT
echo "Unmounting drive '/dev/$TRGT_DRIVE' ..."
sudo umount /dev/$TRGT_DRIVE
echo " "
echo "Mounting drives '/dev/$TRGT_DRIVE' ..."
sudo rm -rf /mnt/$TRGT_DRIVE
sudo mkdir -p /mnt/$TRGT_DRIVE
sudo mount /dev/$TRGT_DRIVE /mnt/$TRGT_DRIVE
echo " "

# RESTORE
echo "Copying files to the target partition, please wait ..."
sudo unsquashfs -f -d /mnt/$TRGT_DRIVE $SFS_FILE
sync
echo " "
echo "Restoring system ..."
sync
echo " "
echo "Cleaning up, please wait ..."
sudo rm -f /mnt/$TRGT_DRIVE/livemedia.distrib
if [ -f "/mnt/$TRGT_DRIVE/usr/sbin/update-initramfs.distrib" ]
  then
    sudo rm -f /mnt/$TRGT_DRIVE/usr/sbin/update-initramfs
    sudo mv /mnt/$TRGT_DRIVE/usr/sbin/update-initramfs.distrib /mnt/$TRGT_DRIVE/usr/sbin/update-initramfs
fi
sync
echo " "

# GRUB2 INSTALL
echo "Installing GRUB, please wait ..."
echo " "
sudo mount --bind /dev /mnt/$TRGT_DRIVE/dev
sudo mount --bind /proc /mnt/$TRGT_DRIVE/proc
sudo mount --bind /sys /mnt/$TRGT_DRIVE/sys
sudo chroot /mnt/$TRGT_DRIVE /bin/bash -c "grub-install /dev/$MBR_DRIVE"
sudo chroot /mnt/$TRGT_DRIVE /bin/bash -c "update-grub"
sudo chroot /mnt/$TRGT_DRIVE /bin/bash -c "update-initramfs -u"
sudo chroot /mnt/$TRGT_DRIVE /bin/bash -c "update-grub"
sudo chroot /mnt/$TRGT_DRIVE /bin/bash -c "dpkg-reconfigure openssh-server"
sudo rm -f /mnt/$TRGT_DRIVE/root/.bash_history
sync
echo " "
echo "-------------------------------------------------------------------------------------------------------"
echo "Attention: on the first boot, the local-premount script may take a long time waiting for a swap device."
echo "To avoid this on next boots, run 'update-initramfs -u' as soon as the swap device is activated."
echo "-------------------------------------------------------------------------------------------------------"
echo " "
echo "-------------------------------------------------------------------------------------------------------------------"
echo "Attention: when upgrading linux-kernel, on some cases you'll need to reconfigure kernel modules for virtualization."
echo "For VirtualBox: run 'sudo dpkg-reconfigure virtualbox-dkms' and you're done."
echo "For VMware: it is done automatically while opening vmplayer, but you may need to re-run the unlocker script."
echo "-------------------------------------------------------------------------------------------------------------------"
echo " "
echo "Done restore!"
echo "You can now turn off the system and eject the live media."
echo "Afterwards, you should be able to boot the installed system."
echo " "

