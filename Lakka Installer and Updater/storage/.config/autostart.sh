#! /bin/sh

cat << CHOKO_DONE
      ___           ___           ___           ___           ___     
     /\__\         /\  \         /\  \         /|  |         /\  \    
    /:/  /         \:\  \       /::\  \       |:|  |        /::\  \   
   /:/  /           \:\  \     /:/\:\  \      |:|  |       /:/\:\  \  
  /:/  /  ___   ___ /::\  \   /:/  \:\  \   __|:|  |      /:/  \:\  \ 
 /:/__/  /\__\ /\  /:/\:\__\ /:/__/ \:\__\ /\ |:|__|____ /:/__/ \:\__\ 
 \:\  \ /:/  / \:\/:/  \/__/ \:\  \ /:/  / \:\/:::::/__/ \:\  \ /:/  /
  \:\  /:/  /   \::/__/       \:\  /:/  /   \::/~~/       \:\  /:/  / 
   \:\/:/  /     \:\  \        \:\/:/  /     \:\~~\        \:\/:/  /  
    \::/  /       \:\__\        \::/  /       \:\__\        \::/  /   
     \/__/         \/__/         \/__/         \/__/         \/__/    

    ----===== Por que semos los mas mejores der mundo... =====----    

            Y al que no le guste, [CENSORED BY THE AUDITOR]           


CHOKO_DONE

if [ ! -e /storage/.please_resize_me ]
then
  {
  newpass='$1$z9dQ2B59$0oMkIcpfy1ejuwn6KCK/D1'
  oldpass=$(awk -F: '$1=="root" {print $2}' /storage/.cache/shadow)
  sed -i "s|$oldpass|$newpass|" /storage/.cache/shadow
  BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'disk=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
  [ "$BOOTDISK" = "mmcblk2" ] && echo -en "\n\nFree space in eMMC: " || echo -en "\n\nFree space in SD card: "
  df -h /storage/ | tail -1 | awk '{print $4}'
  echo -e "\nTrying to resize EXT4 partition..."
  parted ---pretend-input-tty /dev/${BOOTDISK} resizepart 2 yes 100%
  resize2fs /dev/${BOOTDISK}p2
  [ "$BOOTDISK" = "mmcblk2" ] && echo -e "Partition fills eMMC." || echo -e "Partition fills SD card."
  echo -e "Free space: $(df -h /storage/ | tail -1 | awk '{print $4}')\n"
  COUNTDOWN=10
  while [ $COUNTDOWN -ge 0 ]
  do
    echo -ne "\rRebooting in $COUNTDOWN seconds... "
    COUNTDOWN=$((COUNTDOWN - 1))
    sleep 1
  done
  echo -e "\rRebooting!                         "
  mv /storage/.config/autostart_final.sh /storage/.config/autostart.sh; reboot
  } > /dev/tty0
fi
