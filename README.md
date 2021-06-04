# CHA Lakka Installer and Updater v4.3 for Choko Hack v12
Scripts and assets to use Lakka in Capcom Home Arcade either with or without SD card reader.


### Highlights

- The original system, with games and features is all there. You can continue to enjoy the CHA as it was made by the developers. This dual boot is compatible with all version of CHA at least until 1.6 (very likely to be compatible with future versions) and you can install official updates as usual.
- Even if your CHA doesn't have a SD card reader, the CHA has almost 3 GB of available internal memory and you can also use an USB flash drive to load ROMs and assets.
- Retroarch supports thousands of games, custom themes, bezels, Netplay, and more!
- With Lakka you can upload ROMs and other files to the CHA through your WiFi network, even update the cores.
- 3 players support with controllers plugged into USB EXT (only in games that support 3 players, obviously).


### How to Install

You'll find more detailled instructions with screenshots in the wiki, at https://cha-choko-mod.fandom.com/wiki/DUAL_BOOT_-_Installing_Lakka_in_the_CHA

1. Use a suitable tool to expand the first partition of the CHA to fit the Lakka system files. Around 500 MB is more than enough but *LEAVE 1 MB UNALLOCATED at start of the disc*;
2. Download a Lakka system image file from https://nightly.builds.lakka.tv (look for the latest file in a folder named 'H3.arm' and ending with ...-orangepi-plus2e.img.gz);
3. Open the downloaded file with 7-zip ( https://7-zip.org ) and extract the Lakka system files to the first partition of the CHA (KERNEL, SYSTEM and sun8i*);
4. Eject the CHA safely and put this 'Lakka Installer and Updater' folder in the root of an USB flash drive.
5. Insert the USB flash drive in the USB EXT port of the CHA. Power on the CHA and run this script to install the necessary files for swapping between the original CHA menu and RetroArch (Lakka Linux).

The firt time you boot into Lakka, the CHA will reboot twice. The firts time you'll see a message saying it can't resize the partition, but in the second try it will expand the partition to use all available space.
This will allow to use all eMMC space or (if you're running from SD) all SD card space.


### Notes

By default, the ROMs folder for RetroArch is /storage/roms, but you can browse to /storage/usr/share/roms and play the official 16 games.

The hotkey for RetroArch Quick Menu (in game menu) is set to "Select + Start".

Any USB drive you plug when running RetroArch will be mounted under ROMs folder. If you have ROMs in that pen they will be accessible from RetroArch.

When you set the WiFi in RetroArch it may show some error and won't connect. Just try again or reboot and it will automatically connect to WiFi. 


### Choko Hack Extra Feature

Besides loading ROMs (and playlists, assets, configuration files, etc.) from eMMC/SD card, this installation can also load those files from USB.

1. Label you pendisk "CHOKO" (exactly like that) and create a folder in the root named "CHA_LAKKA". The pendisk doesn't need to be empty, but must be formatted in FAT or EXT (the same as for running CHA games from USB).
2. Create the following structure (carefull, folders names are case sensitive), where you will put the necessary files for playlists, icons, overlays, ROMs, etc.:

```
Folder PATH listing for volume CHOKO

USB:\CHA_LAKKA
├───roms
├───cores
├───.config
│   └───retroarch
│       └───config
├───assets
│   ├───backgrounds
│   └───xmb
│       └───monochrome
│           └───png
├───playlists
├───overlays
└───thumbnails
    ├───PLAYLIST_NAME_1
    │   ├───Named_Boxarts
    │   ├───Named_Snaps
    │   └───Named_Titles
    └───PLAYLIST_NAME_2
        ├───Named_Boxarts
        ├───Named_Snaps
        └───Named_Titles
```

3. Now, if you boot into Lakka with this pendisk inserted in the USB EXT port, RetroArch will load the playlist and games from USB.

Unfortunately, for customizing the UI loading assets from USB we need to copy all the icons used by system into assets/xmb/monochrome/png from their original path ( /usr/share/retroarch-assets ). That can be done with a SSH terminal.

A way to build a folder with assets to load from USB is being developed in https://github.com/ChokoGroup/RetroArch-Playlists-with-Thumbnails but there is no estimated date for release. It is a very slow process to build extensive playlists with games that run well in the CHA.
