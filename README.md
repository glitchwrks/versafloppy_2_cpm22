## CP/M 2.2 for the SD Systems VersaFloppy II

This repository contains source and CBIOS customizations for Digital Research CP/M 2.2 on the SD Systems VersaFloppy II. The source is heavily based on the work of Bruce Jones and Bohdan Tashchuk, which was cleaned up and distributed by Herb Johnson. The original README stated that all original source was in the public domain. All Glitch Works contributions are released under the GNU GPL v3, a copy of which can be found in the LICENSE file in the project root.

### Glitch Works Source Changes

Changes reflected in this repository include:

* Stripping out old, unnecessary, or unused code
* Switching to consistent `NULL`-terminated strings
* Fixing typos and import errors (parity bit set in some chars)

General restructuring and cleanup included removal of old IOBYTE devices unlikely to be relevant to users' particular systems. Stuff like support for NEC Spinwriters. This makes the CBIOS smaller (more TPA available) and easier to understand.

### Building the Source

If you wish to build source for yourself, you will need a copy of TDL's ZASM, provided in the `assembler` subdirectory with its manual in PDF format. ZASM runs under CP/M 2.2. You can also run it under emulation, such as MYZ80 under DOS or DOSbox.

By far, the easiest way to get a new system bootstrapped with CP/M is to have another system already running CP/M. For the VersaFloppy II, any S-100 based CP/M 2.2 system with a Z80, at least 32K RAM and a floppy controller that can coexist with the VersaFloppy II makes a good development platform. Note that a Z80 *is required* for the code in this repository. See `documentation/guzis_sd.txt` for potential information on the use of double-density controllers on 8080/8085 systems. We used a North Star Horizon ([documented here](http://www.glitchwrks.com/2019/03/04/horizon-restore)) for the initial bring-up.

### Porting to Your Hardware

The big change required for most systems is the customization of console I/O routines for your particular console hardware, and the appropriate sizing of the system to available memory. Basic images provided in this repository always include a 48K version unless it is completely unnecessary, so that ROM can be left paged in during the development process. Once you've gotten a stable system up and running, your CBIOS may be updated to switch ROM out and occupy the full amount of memory available.

See `documentation\getstart.txt` for the original guide on getting this BIOS up and running on your hardware. It's correct enough to get started!
