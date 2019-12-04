# aoede-dev
Development repository for Aoede Linux

Aoede Linux is an Arch Linux based audio engineering oriented distribution in the vein of the Ubuntu Studio, AV Linux, and KXStudio projects -- to name only a few of the inspirations for this project.

The bulk of the modifications to the Arch-provided releng scripts can be sussed out from the Arch Wiki entry on Professional Audio https://wiki.archlinux.org/index.php/Professional_audio. 

PREREQUISITES:
1. A running Arch Linux instance with packages "arch-install-scripts" and "archiso" installed; can be a live USB system but keep in mind final builds are ~2GB in size.
2. Custom repository containing your own build of "linux-rt" AUR package; alternately uncomment the [coderkun] repository in pacman.conf

BUILDING:

$ ./build.sh

when the build is complete you will find a file named aoedelinux-<date>-x86_64.iso in the "out" directory at the project root

TROUBLESHOOTING
My build was interrupted, and I don't want to reinstall the whole filesystem or start from scratch
  -- remove the files ending in ".build" from the "work" directory
  -- modify the pacstrap script (`which pacstrap` for path) and add "--if-needed" flag to call to pacstrap ## check notes on this detail

See https://wiki.archlinux.org/index.php/archiso for more information

CONFIG TECHNICALS:
As mentioned, the tweaks are specified in the Professional Audio article in the Arch Wiki, and the article is included in the /root directory by default
