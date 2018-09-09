# MBXUB - a remasterable linux distro, based on the official Xubuntu 18.04.1

MBXUB is a linux distro by mbinnun that focuses on being super easy to remaster and based on Xubuntu (Ubuntu + XFCE desktop).

The XFCE desktop is known in its lightweight graphics. Therefore, MBXUB will not take a lot of resources from your computer.
On the other hand, Xubuntu is known to be a fully functional linux distro and a very popular one, what makes MBXUB very useful and gives it a familiar look.

You can get MBXUB here:<br>
https://github.com/mbinnun/MBXUB/releases/tag/V1.0

# A "remasterable disto", is it really so easy?

Yes, it is really so easy! You can install the live system to you hard drive in less than 3 minutes, using only one command and without needing all the "wizards" on the way.<br>
After modifying the system in your hard drive - you can save it back as your own live system, in one command again.

<b>Installation:</b><br>
1. Download the ISO and use it to create a bootable USB stick (using netbootin, etcher, rufus or any other ISO2USB app).
2. Boot your bootable USB stick (or load the MBXUB ISO file in a VM).
3. Use GParted from the live system to format the partition that your want to install to (must be formatted as ext4 or ext3).
4. From the live system, type <b>./restore.sh sda1 sda</b> and change "sda1" to be the partition you want to install to, and "sda" to be the drive you want to boot from (GRUB2 bootloader will be installed there).<br><br>
<i>Note: the restore command is able to run on both text mode and graphical mode.<br>
  The restore process should take 2-3 minutes, depends on you hard drive and USB speed.</i><br><br>
5. Reboot and take out the USB. MBXUB should be able to run from your hard drive now.

<b>Remaster:</b><br>
1. After modifying the system that is installed on your hard drive, boot the live system again.
2. From the live system, type <b>./remaster.sh sda1 sda2</b> and change "sda1" to be the source partition where the modified MBXUB is installed, and "sda2" to be the target partition where the filesystem.squashfs file will be generated.<br><br>
<i>Note: the remaster command is able to run on both text mode and graphical mode.<br>The remaster process will create a temporary directory called "remasterd" on the target partition.</i><br><br>
5. After the squashfs file has been generated, open the MBXUB ISO file with "isomaster" (or winISO if you're using windows). On the /casper directory, replace the original filesystem.squashfs file with the newly generated one and save the ISO.
6. There you go, you should now have a new ISO file with a live system that behaves exacly as the modified installed system does.

# MBXUB is coming in four "flavors"

<b>MBXUB Basic</b><br>
Useful as a rescue CD/USB and also good for starting a fresh remaster project.<br>
Download link: https://github.com/mbinnun/MBXUB/releases/download/V1.0/mbxub-basic-en-v1.0.iso<br><br>
For 32bit computers, use the following build: https://github.com/mbinnun/MBXUB/releases/download/V1.0/mbxub-basic-en-v1.0-32bit.iso

<b>MBXUB TV/Streamer</b><br>
Intended to run on a streamer and includes some media player such as VLC and KODI.<br>
Download link: https://github.com/mbinnun/MBXUB/releases/download/V1.0/mbxub-tvstreamer-en-v1.0.iso<br><br>
For 32bit streamers/computers, use the following build: https://github.com/mbinnun/MBXUB/releases/download/V1.0/mbxub-tvstreamer-en-v1.0-32bit.iso

<b>MBXUB VM</b><br>
Intended to run virtual machines (even from the live system), and includes virtualzation software such as VirtualBox and VMware-Player.<br>
Download link: https://github.com/mbinnun/MBXUB/releases/download/V1.0/mbxub-vm-en-v1.0.iso

<b>MBXUB DEV</b><br>
Intended for programming and development. Includes a lot of programming apps and compilers, such as: Eclipse, FPC, NodeJS, Atom, Android Studio and much more.<br>
Download link: <i>still being uploaded, will be prepared soon ...</i>

# Known Issues

<b>After running the restore script, booting the system from the hard drive takes a lot of time - espacially the part of local-premount.</b>
Easy to fix! After booting the installed system for the first time, activate a swap partition (using the swapon command or via GParted or use your own method to enable swap). Right after having the swap activated, run <b>sudo update-initramfs -u</b>. The system should boot much faster from now on.

<b>On a tablet pc with a touch screen, I can't move to portrait mode</b>
You should enable the service "iio-sensor-proxy". I also created a script called rotate-screen.sh that is useful to rotate the screen manually and also to transform the pointer device.
Download the script here: https://github.com/mbinnun/MBXUB/releases/download/V1.0/rotate-screen.sh
