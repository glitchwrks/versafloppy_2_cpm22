IOBYTE on the SMB and SMB-II
============================

The IOBYTE for SMB and SMB-II systems follows the assignments from Zapple as 
closely as possible. The initial IOBYTE is read from I/O port 0x76, which is 
used as the IOBYTE storage register on the SMB/SMB-II when running with the 
Zapple monitor. The IOBYTE may be changed under CP/M, but the changes will not 
be written back to port 0x76.

Console devices BAT: and UC1: are unimplemented and fall through to the TTY: 
driver routines.

Standard Device Notes
---------------------

Bit 7 is stripped when reading from CRT: or TTY: devices by name.

When using TTY as the RDR: device, bit 7 is not stripped -- the full 8 bits are
read in from the reader device.

User-Supplied IOBYTE Devices
----------------------------

Assigning the user-supplied devices (LPT:, UL1:, UP1:, UP2:, UR1:, UR2:, UC1:)
requires providing routines for those devices as Zapple just contains a vector
address, and does not implement the routines in the standard ROM. With a SMB-II
it is possible to have these routines in ROM, the original SMB expects you to
have loaded them in the SMB's onboard RAM above 0xF800. 

If you wish to make use of these devices under CP/M only, it's probably easiest
to modify the CBIOS and put your routines there.

If you wish to use them with an original SMB, we recommend writing a small
loader program to populate the routines in the SMB's onboard RAM on startup.

With the SMB-II, memory above 0xF800 may be ROM, depending on your system
configuration. With ROM above 0xF800 it may be possible to store your drivers
in ROM. Do note that the 1K utility ROM supplied with many SMB-II boards is not
compatible with this setup.