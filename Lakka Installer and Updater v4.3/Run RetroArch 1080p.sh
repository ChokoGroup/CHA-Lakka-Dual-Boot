#! /bin/sh
# For Choko Hack 10.0.0+

mkdir -p /tmp/flash
BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
mount /dev/${BOOTDISK}p1 /tmp/flash
cp /tmp/flash/extlinux/extlinux.conf.1080p /tmp/flash/extlinux/extlinux.conf
[ "$BOOTDISK" = "mmcblk1" ] && BOOTDISK="mmcblk2"
sed -i "s/CHOKOMOD/$BOOTDISK/g" /tmp/flash/extlinux/extlinux.conf
umount /tmp/flash 2>/dev/null

# Call for safe unmount and reboot
exit 200
