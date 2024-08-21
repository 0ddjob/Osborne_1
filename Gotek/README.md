# Manipulating Disk Images (on MacOS)
Certainly not exhaustive but I've found this works, especially as I currently only have Single Density (SD) disk support.

## Gotek Disk Images (IMD->HFE)
I use the [HxC Floppy Emulator](https://hxc2001.com) software to convert from ImageDisk (IMD) format to HQE format, which [FlashFloppy](https://github.com/keirf/flashfloppy) is quite happy with.

## Extracting Individual CP/M Files (IMD->IMG)
The idea is that a lot of disk images are Double Density (DD) which my OCC1 doesn't support.  So I need to extract the files of interest from these DD disk images and copy them to an empty SD disk image.


First, I use the [disk-analyse](https://github.com/keirf/Disk-Utilities) tool to convert an IMD file to IMG:
```
% disk-analyse FOGCPM.027.imd FOGCPM.027.img
Side 0:
 T0-39: IBM-MFM DD (5 1024-byte sectors, 5120 bytes)
 T40-83: Unformatted
Side 1:
 T0-83: Unformatted
```
Then I can use the [cpmtools](https://github.com/lipro-cpm4l/cpmtools) set of programs to list (cpmls) and copy (cpmcp) files on disk images:
```
% cpmls -f osborne1 FOGCPM.027.img
0:
--fogcpm.027
-02-00.86
-cpm027.doc
gpib.com
gpib.doc
gpib.pas
slist.com
slist.doc
slistctl.dat
slistins.com
slistins.dta
slistins.msg
slistrsv.dat
system.dat
turbo.doc
turbo.pas
turbosav.com
turbosav.doc
```
Then extract the file of interest:
```
% cpmcp -f osborne1 FOGCPM.027.img 0:gpib.pas gpib.pas
```
Richard Oxley has a good writeup on his [blog](https://www.richardloxley.com/2018/04/27/osborne-restoration-part-16-transferring-cpm-software/).
