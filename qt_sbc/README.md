Quick & Timely/CompuTime SBC 2/4 Support
========================================

This customization supports CP/M 2.2 on the Quick & Timely (CompuTime) SBC 2/4 board with VersaFloppy II disk controller.

Files
-----

This directory contains the following files:

| Name           | Format    | Description                                   |
|----------------|-----------|-----------------------------------------------|
| `GWV2BQTS.ASM` | ZASM      | CBIOS source for 3.5" microfloppy drives      |
| `QTSBC35.IMD`  | ImageDisk | 48K 3.5" DSDD 80 track disk image (1.66 MB)   |

ZASM files should be assembled with TDL's Z80 Assembler.

ImageDisk files are ready-to-run diskette images captures with Dave Dunfield's [ImageDisk program](http://dunfield.classiccmp.org/img/), which is a disk imaging utility that runs under MS-DOS.

`PCGET` and `PCPUT` XMODEM transfer customizations are included in the provided disk images. Source can be found [on GitHub](https://github.com/glitchwrks/pcget_pcput/tree/master/qt_sbc_24).

Building the 3.5" CBIOS
-----------------------

In addition to `GWV2BQTS.ASM` you will also need `V2LOADR1.HEX` and `V2SASG5.HEX` from the parent directory. Follow the instructions in [the main README](/documentation/readme.txt) for assembling and constructing the CP/M self-sysgen image.

Drive Cabling
-------------

The VersaFloppy II can be used with standard PC style 3.5" HD diskette drives without modifying the drives or changing jumpers. A custom cable is required, but is easily constructed from a standard "IBM PC twist" floppy cable. Follow the [cabling instructions here](/documentation/cables.txt) (extracted from the larger [getstart.txt](/documentation/getstart.txt) which includes detailed instructions for using many types of floppy drives with the VersaFloppy II).
