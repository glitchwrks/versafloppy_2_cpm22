TDL SMB and TDL/CDL SMB-II Support
==================================

This customization supports CP/M 2.2 on the TDL SMB and TDL/CDL SMB-II boards with VersaFloppy II disk controller.

Files
-----

This directory contains the following files:

| Name           | Format    | Description                                   |
|----------------|-----------|-----------------------------------------------|
| `BOOT5.MD`     | text      | Type-in boot routine for Zapple monitor       |
| `GWV2BTD5.ASM` | ZASM      | CBIOS source for 5.25" minifloppy drives      |
| `IOBYTE.MD`    | text      | Description of IOBYTE facilities              |
| `TDLSMB5.IMD`  | ImageDisk | 5.25" DSDD 35 track disk image,ready-to-run   |

ZASM files should be assembled with TDL's Z80 Assembler.

ImageDisk files are ready-to-run diskette images captures with Dave Dunfield's [ImageDisk program](http://dunfield.classiccmp.org/img/), which is a disk imaging utility that runs under MS-DOS.

As this customization includes `IOBYTE` support, a copy of Kermit-80 v4.11 customized for generic CP/M 2.2 is included in disk image(s).

`PCGET` and `PCPUT` XMODEM transfer customizations are included in the provided disk images. Source can be found [on GitHub](https://github.com/glitchwrks/pcget_pcput/tree/master/smb).

Building the 5.25" CBIOS
------------------------

In addition to `GWV2BTD5.ASM` you will also need `V2LOADR1.HEX` and `V2SASG5.HEX` from the parent directory. Follow the instructions in [the main README](/documentation/readme.txt) for assembling and constructing the CP/M self-sysgen image.