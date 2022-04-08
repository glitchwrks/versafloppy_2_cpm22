TDL SMB and TDL/CDL SMB-II Support
==================================

This customization supports CP/M 2.2 on the SD Systems SBC-100 and SBC-200 boards with VersaFloppy II disk controller.

Files
-----

This directory contains the following files:

| Name           | Format    | Description                                   |
|----------------|-----------|-----------------------------------------------|
| `BOOT5.MD`     | text      | Type-in boot routine for SD Systems monitor   |
| `GWV2BIO5.ASM` | ZASM      | CBIOS source for 5.25" minifloppy drives      |
| `SBC548N.IMD`  | ImageDisk | 48K 5.25" DSDD 35T image, no ROM switch-out   |
| `SBC548.IMD`   | ImageDisk | 48K 5.25" DSDD 35T image, with ROM switch-out |
| `SBC564.IMD`   | ImageDisk | 64K 5.25" DSDD 35T image, with ROM switch-out |
| `BOOTROM5.ASM` | ZASM      | SBC-100/SBC-200 boot ROM source               |
| `BOOTROM5.HEX` | Intel HEX | SBC-100/SBC-200 boot ROM HEX file             |
| `BOOTROM5.BIN` | binary    | SBC-100/SBC-200 boot ROM binary               |
| `V2LD2001.ASM` | ZASM      | On-disk bootloader with ROM switch-out        |

ZASM files should be assembled with TDL's Z80 Assembler.

ImageDisk files are ready-to-run diskette images captures with Dave Dunfield's [ImageDisk program](http://dunfield.classiccmp.org/img/), which is a disk imaging utility that runs under MS-DOS.

`PCGET` and `PCPUT` XMODEM transfer customizations are included in the provided disk images. Source can be found [on GitHub](https://github.com/glitchwrks/pcget_pcput/tree/master/sbc_200).

ROM Switch-Out
--------------

The SBC-100/SBC-200 allow for disabling the onboard ROM and scratchpad RAM. This is necessary if CP/M is to use all 64K of system memory. We've provided images with and without ROM switch-out -- images with a N do not have ROM switch-out, the others do.

We recommend starting with a 48K image with no ROM switch-out. Once this image is successfully booting, try a 48K image *with* ROM switch-out to ensure the SBC is working properly -- we've encountered a SBC that was not able to switch ROM out.

Booting with SD Monitor
-----------------------

The SD Systems ROM monitor shipped with the SBC-100/SBC-200 does not have a boot command that works with this CP/M CBIOS. The monitor's floppy code expects to work with SDOS diskettes, which use a different track layout than this CBIOS. A type-in loader is provided in `BOOT5.MD` which can be loaded into system RAM and executed from the standard monitor.

Boot ROM Files
--------------

`BOOTROM5.ASM` is the source for a ROMable boot routine that boots a 5.25" diskette on the VersaFloppy II. Intel HEX and binary images are provided for convenience. This boot routine can be programmed into an EPROM and placed in a free socket in the SD Systems SBC-100/SBC-200. The code is relocatable so no change in origin is required.

It may be necessary to add addressing jumpers for a boot ROM, please consult the SBC-100/SBC-200 manual for the version of the SBC that you have. We typically place it in ROM socket #1 which is not occupied when using the regular SD Systems monitor ROMs. If installed in socket #1, the boot routine can be entered by typing `GE800` (case sensitive).

The boot code expects the console serial port to be set up and the stack pointer to be valid, so it can not be used directly in socket #0.

Building the 5.25" CBIOS
------------------------

In addition to `GWV2BIO5.ASM` you will also need `V2LD2001.HEX` or `V2LOADR1.HEX` and `V2SASG5.HEX`.  The latter two files are in the parent directory. Follow the instructions in [the main README](/documentation/readme.txt) for assembling and constructing the CP/M self-sysgen image.

Note that `V2LD2001.HEX` switches out the SBC-100/SBC-200 onboard ROM and scratchpad RAM. It also initialized the stack pointer to `0x0080`, as switching out the SBC's scratchpad will cause the monitor's stack to go away! Bruce Jones' original code did not initialize the stack pointer and would cause boot failures on systems with 62K or less of RAM.