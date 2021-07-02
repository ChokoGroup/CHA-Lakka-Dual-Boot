# ! /bin/sh
# For Choko Hack 12.0.0+

RUNNINGFROM="$(dirname "$(realpath "$0")")"

mkdir -p /tmp/flash
BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
mount /dev/${BOOTDISK}p1 /tmp/flash
if [ -f /tmp/flash/sun8i-h3-orangepi-plus2e.dtb ] && [ -f /tmp/flash/KERNEL ] && [ -f /tmp/flash/SYSTEM ]
then
  # Put files in FAT partition
  cp -r "$RUNNINGFROM/flash"/* /tmp/flash/
  umount /tmp/flash

  # Put files in EXT4 partition
  cp -r "$RUNNINGFROM/storage"/* /
  cp "$RUNNINGFROM/storage/.profile" /
  cp -r "$RUNNINGFROM/storage/.config"/* /.config/
#  ln -s /storage/usr/share/roms /roms
  mkdir -p /roms
  touch /.please_resize_me

  # Activate Lakka autostart script service to load our /storage/.config/autostart.sh
  mkdir -p /.config/system.d/retroarch.service.wants
  ln -s /usr/lib/systemd/system/retroarch-autostart.service /.config/system.d/retroarch.service.wants/retroarch-autostart.service

  # Delete playlist with old name
  if [ -e /playlists/1-BOOT_CHA.lpl ]
  then
    rm /playlists/1-BOOT_CHA.lpl
    rm /assets/xmb/monochrome/png/1-BOOT_CHA*
  fi

  cp "$RUNNINGFROM/Run RetroArch automatic resolution."* /.choko/
  chmod 644 /.choko/*.nfo
  chmod 644 /.choko/*.rgba
  chmod 644 /.choko/*.png
  echo -e "Menu option installed."
else
  [ -f /tmp/flash/sun8i-h3-orangepi-plus2e.dtb ] || echo "The file \"sun8i-h3-orangepi-plus2e.dtb\" is missing."
  [ -f /tmp/flash/KERNEL ] || echo "The file \"KERNEL\" is missing."
  [ -f /tmp/flash/SYSTEM ] || echo "The file \"SYSTEM\" is missing."
  umount /tmp/flash
fi

COUNTDOWN=10
while [ $COUNTDOWN -ge 0 ]
do
  echo -ne "\rRebooting in $COUNTDOWN seconds... "
  COUNTDOWN=$((COUNTDOWN - 1))
  sleep 1
done
echo -ne "\r\e[K"
exit 200
