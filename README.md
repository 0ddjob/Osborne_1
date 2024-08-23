# Osborne Model 1
## [ROMs](/ROM)
- [2732] Original Osborne BIOS vers. 1.40 (from my Osborne)
- [2732] Original Osborne BIOS vers. 1.44 (latest)
- [2732] 3rd Party Micro Management OZROM 1E (thanks to user [nelgin](https://forum.vcfed.org/index.php?threads/osborne-1-screen-flash.1245908/post-1400583) on VCFED Forums)
- OZROM manual (cleaned up version thanks to VCFED user booboo)
- [2764] Combined OCC v1.44 & OZROM (would require a daughterboard & switch)
- [2716] Original Osborne character generator ROM (from my Osborne)

Differences between ROM v1.4 and v1.44 include:
```
; CBOOT - added seek 10 tracks and home drive
; GKEY - fixed bell bug
; SENDEN - changed the number of retrys to NRETRY
; PSEKC - added disk head settle delay
; SELDRV - changed start up delay to 500 ms
```
### OCC v1.4 ROM
![Image of OCC v1.40 ROM](/images/OCC_v14.jpg)

### OCC Character Generator ROM
![Image of OCC character ROM](/images/OCC_char.jpg)

### Micro Management OZROM
![Image of OZROM](/images/OZROM_1E.jpg)

## [Daughterboard](/2732-to-2764)
[21-Aug-2024: test boards in transit]  
ROM daughterboard to accomodate 28-pin 2764 (8KByte) EPROM in the Osborne's 24-pin 2732 (4KByte) BIOS socket.  Idea is to allow switching between the official Osborne ROM and the 3rd party OZROM.  

Address pin A12 is pulled high by the 10KΩ resistor or can be switched to ground via a strapping or switch connected to the A12 pin headers.

![3D image of daughterboard](/images/Osborne_2732_to_2764.png)

## [Using A Gotek](/Gotek)
Big thanks to [Dave Dunfield](http://dunfield.classiccmp.org/index.htm) for the original ImageDisk-format (IMD) disk images.

How to tell if an Osborne 1 disk image is single density (SD) or double density (DD)?
* SD disks have ten 256 byte sectors per track (2560 bytes/track)
* DD disks have five 1024 byte sectors per track (5120 bytes/track)

Example output of ```fsed.cpm``` info command on an IMG disk image:
```
              Sector length: 1024
           Number of tracks: 40
          Sectors per track: 5
```

