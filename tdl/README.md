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
| `TDLSMB5.IMD`  | ImageDisk | 48K 5.25" DSDD 35 track disk image            |
| `BOOTROM5.ASM` | ZASM      | Zapple K command boot ROM source              |
| `BOOTROM5.HEX` | Intel HEX | Zapple K command boot ROM HEX file            |
| `BOOTROM5.BIN` | binary    | Zapple K command boot ROM binary              |

ZASM files should be assembled with TDL's Z80 Assembler.

ImageDisk files are ready-to-run diskette images captures with Dave Dunfield's [ImageDisk program](http://dunfield.classiccmp.org/img/), which is a disk imaging utility that runs under MS-DOS.

As this customization includes `IOBYTE` support, a copy of Kermit-80 v4.11 customized for generic CP/M 2.2 is included in disk image(s).

`PCGET` and `PCPUT` XMODEM transfer customizations are included in the provided disk images. Source can be found [on GitHub](https://github.com/glitchwrks/pcget_pcput/tree/master/smb).

Boot ROM Files
--------------

`BOOTROM5.ASM` is the source for a Zapple monitor extension that implements the `K` command and boots a 5.25" diskette on the VersaFloppy II.

If you have a SMB-II, this code can be programmed into an EPROM and located at `0xF800` on the SMB-II. Doing so will provide automatic "installation" of the `K` command: once the Zapple monitor is started, the command will be immediately available.

If you have an original SMB, this code can be loaded into user RAM at `0xF800` to provide the `K` command.

Building the 5.25" CBIOS
------------------------

In addition to `GWV2BTD5.ASM` you will also need `V2LOADR1.HEX` and `V2SASG5.HEX` from the parent directory. Follow the instructions in [the main README](/documentation/readme.txt) for assembling and constructing the CP/M self-sysgen image.