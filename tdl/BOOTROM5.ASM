;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BOOTROM5.ASM -- Boot 5.25" Disk on VF2/TDL SMB
;
;This file contains code to boot a 5.25" diskette on the
;SD Systems VersaFloppy II with the TDL SMB. This code can
;be ROMed for use in a TDL/CDL SMB-II or loaded into user
;RAM above 0xF800. It implements the "K" user command.
;
;Z80 opcodes are used, but Zapple requires Z80 anyway.
;
;Based on V2BOOTX5.ASM from Bruce Jones.
;
;Copyright (c) 2022 Glitch Works, LLC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.XLINK
	.Z80			;Z80 OPCODES USED
	.PHEX
	.PABS

	.PAGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Control Character Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CR	==	13
LF	==	10
BELL	==	7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VersaFloppy II Port Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DCMD	==	063H		;DMA DISC CONTROL PORT
WDC	==	064H		;WDC 179X BASE ADDRESS
WCMD	==	WDC+0		;COMMAND REGISTER
WSTAT	==	WDC+0		;STATUS REGISTER
WTRACK	==	WDC+1		;TRACK REGISTER
WSECT	==	WDC+2		;SECTOR REGISTER
WDATA	==	WDC+3		;DATA REGISTER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CP/M Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOOT	==	0		;TRACK LOADER GOES HERE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;TDL Zapple Monitor Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
USERTAB	==	0F800H		;Start of Zapple user routines jump table
KCMD	==	0F81EH		;K user command vector
USERSPC == 	0F824H		;First location past jump table

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Start of user space jump table/vectors. See the TDL Zapple
;monitor documentation for use of this space.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.LOC	USERTAB
	.BLKB	KCMD-USERTAB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;By locating a jump to the BOOT5 routine at KCMD, the Zapple
;monitor will be able to vector into this command. So, 
;entering 'K' at Zapple with this code loaded from 0xF81E up
;will boot the VersaFloppy II.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.LOC	KCMD
	JMP	BOOT5

	.LOC	USERSPC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BOOT5 -- Boot a 5.25" drive on VersaFloppy II
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOOT5:	MVI	A,1EH		;SELECT DRIVE 0, LOWER HEAD, 5", DOUBLE DENSITY
	OUT	DCMD		

RETRY:
	LXI	H,BOOT
..HOME:
	MVI	A,0BH		;RESTORE DRIVE
	OUT	WCMD		;SEND TO CONTROLLER
	MVI	B,200		;DELAY TILL VALID STATUS
..WAIT:	DJNZ	..WAIT

..NB:	IN	WSTAT		;GET STATUS
	BIT	0,A		;BUSY (y/n)
	JRNZ	..NB		;YES,KEEP WAITING

	MVI	A,1		;START WITH SECTOR 1
	OUT	WSECT		;SET SECTOR REG
SECTOR:
	MVI	A,88H		;ISSUE READ SECTOR COMMAND 
	OUT	WCMD
	LXI	B,0067H		;SET UP BC FOR PIO READ NEXT
	INIR			;DO PIO SECTOR READ
	INIR

	MVI	B,200		;DELAY TILL VALID STATUS
..WAIT:	DJNZ	..WAIT

..NB:	IN	WSTAT		;GET STATUS
	BIT	0,A		;BUSY (y/n)
	JRNZ	..NB		;YES,KEEP WAITING
	ANI	9DH		;WAS READ SUCCESSFUL(y/n)
	JZ	BOOT		;GET SYSTEM
	JMPR	RETRY

	.END
