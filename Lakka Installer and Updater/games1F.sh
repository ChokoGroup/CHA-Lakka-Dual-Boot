# ! /bin/sh
# For Choko Hack 10.0.0+

RUNNINGFROM="$(dirname "$(realpath "$0")")"

mkdir -p /tmp/flash
BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
mount /dev/${BOOTDISK}p1 /tmp/flash
if [ -f /tmp/flash/sun8i-h3-orangepi-plus2e.dtb ] && [ -f /tmp/flash/KERNEL ] && [ -f /tmp/flash/SYSTEM ]
then
  # Put files in FAT partition
  cp -R "$RUNNINGFROM/flash"/* /tmp/flash/
  umount /tmp/flash

  # Put files in EXT4 partition
  cp -R "$RUNNINGFROM/storage"/* /
  cp "$RUNNINGFROM/storage/.profile" /
  cp "$RUNNINGFROM/storage/.config"/* /.config/
  ln -s /storage/usr/share/roms /roms
  touch /.please_resize_me

  # Activate Lakka autostart service to wait for swap buttons combo
  mkdir -p /.config/system.d/retroarch.service.wants
  ln -s /usr/lib/systemd/system/retroarch-autostart.service /.config/system.d/retroarch.service.wants/retroarch-autostart.service

  # Delete playlist with old name
  if [ -e /playlists/1-BOOT_CHA.lpl ]
  then
    rm /playlists/1-BOOT_CHA.lpl
    rm /assets/xmb/monochrome/png/1-BOOT_CHA*
  fi

  cp "$RUNNINGFROM/lakkaauto.nfo" /.choko/games2S.nfo
  cp "$RUNNINGFROM/lakkaauto.sh" /.choko/games2S.sh
  # If this is the first list of games being copied then install the menu
  [ -x /.choko/usb_exec.sh ] || ( cp "$RUNNINGFROM/usb_exec.sh" /.choko/ ; "cp $RUNNINGFROM"/*.rgba /.choko/ )
  echo -e "Menu option assigned to [P2 S]."

  if [ -f /.choko/games2I.nfo ]
  then
    # Wait for buttons to be released before asking to delete
    /usr/sbin/evtest --query /dev/input/event3 EV_KEY BTN_BASE
    CHA2S=$?
    /usr/sbin/evtest --query /dev/input/event2 EV_KEY BTN_TOP
    CHA1A=$?
    until [ "$CHA2S$CHA1A" = "00" ]
    do
      sleep 1
      /usr/sbin/evtest --query /dev/input/event3 EV_KEY BTN_BASE
      CHA2S=$?
      /usr/sbin/evtest --query /dev/input/event2 EV_KEY BTN_TOP
      CHA1A=$?
    done
    GAMES2I="$(cat /.choko/games2I.nfo)"
    echo -e "\nDo you want to delete \"$GAMES2I\" option assigned to [P2 I]?\e[m\nPress \e[1;94m[P2 START]\e[m to delete or [P1 A] to cancel."
    COUNTDOWN=10
    while [ "$CHA2S$CHA1A" = "00" ] && [ $COUNTDOWN -ge 0 ]
    do
      echo -ne "\rWaiting $COUNTDOWN seconds... "
      COUNTDOWN=$(($COUNTDOWN - 1))
      sleep 1
      /usr/sbin/evtest --query /dev/input/event3 EV_KEY BTN_BASE
      CHA2S=$?
      /usr/sbin/evtest --query /dev/input/event2 EV_KEY BTN_TOP
      CHA1A=$?
    done
    echo -e "\n"
    if [ "$CHA2S$CHA1A" = "100" ]
    then
      rm -rf /.choko/games2I*
      echo "[P2 I] option deleted."
    fi
  fi
  until [ "$CHA2S$CHA1A" = "00" ]
  do
    sleep 1
    /usr/sbin/evtest --query /dev/input/event3 EV_KEY BTN_BASE
    CHA2S=$?
    /usr/sbin/evtest --query /dev/input/event2 EV_KEY BTN_TOP
    CHA1A=$?
  done
else
  [ -f /tmp/flash/sun8i-h3-orangepi-plus2e.dtb ] || echo "The file \"sun8i-h3-orangepi-plus2e.dtb\" is missing."
  [ -f /tmp/flash/KERNEL ] || echo "The file \"KERNEL\" is missing."
  [ -f /tmp/flash/SYSTEM ] || echo "The file \"SYSTEM\" is missing."
  umount /tmp/flash
fi

[ -x /.choko/usb_exec.sh ] && exec "/.choko/usb_exec.sh" || exec "$RUNNINGFROM/usb_exec.sh"
