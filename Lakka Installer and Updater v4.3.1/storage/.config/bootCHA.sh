#/bin/sh

systemctl stop retroarch
BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'boot=/dev/'}; BOOTDISK=${BOOTDISK%'p1 '*}
mount -o remount,rw /dev/${BOOTDISK}p1 /flash
rm /flash/extlinux/extlinux.conf
mount -o remount,ro /dev/${BOOTDISK}p1 /flash
reboot
