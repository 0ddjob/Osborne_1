# Osborne Model 1
## [ROMs](/ROM)
- [2732] Original Osborne BIOS vers. 1.40 (from my Osborne)
- [2732] Original Osborne BIOS vers. 1.44 (latest)
- [2732] 3rd Party Micro Management OZROM 1E (thanks to user [neglin](https://forum.vcfed.org/index.php?threads/osborne-1-screen-flash.1245908/post-1400583) on VCFED Forums)
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
[Coming Soon] ROM daughterboard to accomodate 28-pin 2764 (8KByte) EPROM in the Osborne's 24-pin 2732 (4KByte) BIOS socket.

## [Gotek Single Density Disk Images](/Gotek/SingleDensity)
Big thanks to [Dave Dunfield](http://dunfield.classiccmp.org/index.htm) for the original ImageDisk-format (IMD) disk images.


