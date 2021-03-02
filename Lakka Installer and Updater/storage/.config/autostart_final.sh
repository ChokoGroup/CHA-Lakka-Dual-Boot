#!/bin/sh

#wifi seems to not start automatically so I added this
connmanctl enable wifi
connmanctl scan wifi

if [ -d /storage/roms/CHOKO/CHA_LAKKA ]
then
	systemctl stop tmp-assets.mount
	systemctl stop tmp-overlays.mount
	mount --bind /storage/roms/CHOKO/CHA_LAKKA/assets /tmp/assets
	mount --bind /storage/roms/CHOKO/CHA_LAKKA/overlays /tmp/overlays
	mount --bind /storage/roms/CHOKO/CHA_LAKKA/playlists /storage/playlists
	mount --bind /storage/roms/CHOKO/CHA_LAKKA/thumbnails /storage/thumbnails
	mount --bind /storage/roms/CHOKO/CHA_LAKKA/.config/retroarch/config /storage/.config/retroarch/config
	mount --bind /storage/roms/CHOKO/CHA_LAKKA/.config/retroarch/retroarch.cfg  /storage/.config/retroarch/retroarch.cfg

	cd /storage/roms/CHOKO/CHA_LAKKA/cores
	for f in $(ls *.info)
	do
	  cp /storage/roms/CHOKO/CHA_LAKKA/cores/$f /storage/cores/$f
	done
	for f in $(ls *.so)
	do
	  cp /storage/roms/CHOKO/CHA_LAKKA/cores/$f /storage/cores/$f
	  chmod 755 /storage/cores/$f
	done
fi
