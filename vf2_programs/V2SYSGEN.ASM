;**********************************************
;*              V2SYSGEN.ASM                  *	
;*              USED FOR CP/M                 *
;*              DEC 15, 2003
;**********************************************


	.Z80
	.PABS
	.PHEX
	.XLINK
	.XSYM
	.LOC	100H

	TRUE	==	0FFFFH
	FALSE	==	#TRUE

;THIS PROGRAM WILL READ THE SYSTEM TRACKS FROM THE SPECIFIED
;DISK & WRITE THEM TO THE SPECIFIED DESTINATION DISK


;BDOS FUNCTIONS

	GCON	==	1	;GET CONSOL
	WCON	==	2	;OUTPUT CONSOL
	PRINTS	==	9	;PRINT STRING
	GBUF	==	10	;GET CONSOL BUFFER
	RESET	==	13
	DMA	==	26	;SET DMA ADDRESS

; WORK ADREAS

	DMAB	==	3300H	;TEMP. DMA BUFFER
	
	NDMADD	==	900H	;DMA SAVE ADDRESS
	MAXS	==	32	;BASE NUMBER OF SECTORS
	TMAX	==	36	;ACTUAL NUMBER OF SECTORS


;SYSTEM LOCATIONS

	BDOS	==	5	;LOC OF ENTRY
	BPTR	==	1	;BIOS POINTER
	VHOME	==	21	;HOME DISK OFFSET
	VSELD	==	24	;SET DRIVE
	VSTRK	==	27	;SET TRACK
	VSSEC	==	30	;SET SECTOR
	VSDMA	==	33	;SET DMA
	VREAD	==	36	;READ DISK
	VWRITE	==	39	;WRITE DISK

	CTLC	==	3
	CR	==	13
	LF	==	10
	CLEAR	==	26
	BELL	==	7


;SET UP ADDRESSES FOR DIRECT BIOS ENTRY FOR SYSTEM TRACK COPY


INIT:	LXI	SP,100H		;PUT HERE
	CALL	SBPOT		;SET UP BIOS POINTERS



;SIGN ON AND ASK QUESTIONS

SIGON:
	MVI	C,PRINTS		;TELL USER WHAT'S UP
	LXI	D,MESS1		;AND GET SOURCE DRIVE
	CALL	BDOS		;IF ANY

;GET SOURCE DRIVE, IF ANY

	LXI	H,OKDRIV
	CALL	GETOK
	STA	SOURCE		;PUT IN RAM
	CPI	CR
	JZ	GDES
	STA	SRC

;ASK FOR 'CR' TO CONTINUE

	LXI	D,MESS4
	MVI	C,PRINTS
	CALL	BDOS
	MVI	C,GCON
	CALL	BDOS
	CPI	CTLC
	JZ	GOBAK



	LXI	B,NDMADD	;INITIALIZE DMA XFER
	SBCD	TADD		;REMEMBER XFER ADDRESS
	CALL	SDMA		;SET THE DMA LOCATION
	LDA	SOURCE		;GET SOURCE DRIVE
	CPI	CR		;IF 'CR' GO WRITER
	JZ	GDES		;ROUTINE

	DCR	A
	ANI	0FH

	LXI	B,0		;CLEAR BC
	MOV	C,A		;PUT IN C REG
	CALL	SELDSK		;AND SET DISK

	MOV	A,H
	ORA	L
	JNZ	OKRED

	LXI	D,MESS6
	MVI	C,PRINTS
	CALL	BDOS
	JMP	INIT

OKRED:


	LXI	B,0		;CLEAR BC
	CALL	STRACK		;SET TRACK 0

;THE READ LOOP CHECKS THE TRACK NUMBER 
;SO THAT THE DDB ON TRACK 0 IS SKIPPED


RLOOP:

	LXI	H,STRK		;POINT TO TRACK COUNTER
	MOV	A,M
	ORA	A
	JRZ	..NINC
	MVI	A,37		;DO ONE MORE 512 BYTES
	JMPR	..YINC
 ..NINC:MVI	A,MAXS		;ELSE DO ONLY 31 SECTORS
	LXI	H,SCOUNT	;SKIP THE NEXT ONE
	MOV	C,M		;THEN DO THE LAST FOUR
	CMP	C
	JRNZ	..NINE
	INR	C
	MOV	M,C
 ..NINE:MVI	A,37

 ..YINC:LXI	H,SCOUNT	;POINT TO SECTOR COUNT
	MOV	C,M		;AND PUT CURRENT COUNT IN C
	CMP	C		;SEE IF OVER MAX
	JZ	SFIX		;IF SO DO TRACK & SECTOR RESET
	MOV	A,C		;O.K. PUT IN C
	INR	A		;UPDATE SECTOR COUNT
	STA	SCOUNT		;UPDATE FOR NEXT SECTOR
	CALL	SETSEC		;AND SET IT
	CALL	SREAD		;NOW GO READ CURRENT SECTOR
	LHLD	TADD		;GET LAST DMA ADD.
	LXI	D,128		;PUT RECORD LENGTH IN DE
	DAD	D		;UPDATE OLD DMA ADDRESS
	SHLD	TADD		;AND SAVE IT
	PUSH	H		;PUT ON STACK
	POP	B		;FOR BC TO GET
	CALL	SDMA		;AND GO SET NEW DMA ADD.
	JMPR	RLOOP		;DO NEXT SECTOR

;WE NOW RESET SECTOR COUNTER AND UPDATE TRACK COUNTER
;IF TRACK IS = 1 WE'RE DONE WITH READ

SFIX:	MVI	A,1		;SET SECTOR TO 1
	STA	SCOUNT
	LDA	STRK		;GET TRACK COUNT
	CPI	1
	JZ	GDES		;DONE SYSTEM READ
	INR	A
	STA	STRK		;ELSE UPDATE STRK
	LXI	B,1
	CALL	STRACK		;GO SET NEXT TRACK
	JMP	RLOOP		;NOW READ IN TRACK 1



GDES:
	MVI	C,PRINTS		;ASK USER FOR DESTINATION
	LXI	D,MESS2
	CALL	BDOS


	LXI	H,OKDRIV
	CALL	GETOK

	CPI	CR
	JZ	GOBAK
	STA	DESTIN		;SAVE IT HERE
	STA	DST

	LXI	D,MESS5
	MVI	C,PRINTS
	CALL	BDOS
	MVI	C,GCON
	CALL	BDOS
	CPI	CTLC
	JZ	GOBAK


;THE SYSTEM TRACK WRITER POINTS BACK TO DATA READ IN
;AND STORES IT ON THE DESTINATION DRIVE TRACKS


WRITER:
	CALL	HDEST		;HOME THE DRIVE

MORE:
	LDA	DESTIN
	DCR	A
	LXI	B,0		;ELSE CLEAR BC
	ANI	0FH		;STRIP DESTINATION
	MOV	C,A		;PUT IN C
	CALL	SELDSK		;AND SELECT DISK
	MOV	A,H
	ORA	L
	JNZ	OKWRT

	LXI	D,MESS6
	MVI	C,PRINTS
	CALL	BDOS
	JMP	GDES


OKWRT:
	LXI	B,0		;CLEAR BC
	CALL	STRACK		;SELECT TRACK 0
IDMA1:	LXI	B,NDMADD	;INITIALIZE DMA XFER
	SBCD	TADD		;REMEMBER XFER ADDRESS
	MVI	A,1		;SET SECTOR 1
	STA	SCOUNT		;SAVE IT
	MVI	A,0		;INIT TRACK COUNTER
	STA	STRK		;SAVE IT
	CALL	SDMA		;SET DMA ADDRESS

;WE NEXT WRITE THE TWO SYSTEM TRACKS

WLOOP:

	LXI	H,STRK		;POINT TO TRACK VAL
	MOV	A,M
	CPI	0
	JRZ	..NINC		;DON'T ALLOW WRITING ON DDB
	MVI	A,37
	JMPR	..YINC
 ..NINC:MVI	A,MAXS
	LXI	H,SCOUNT
	MOV	C,M
	CMP	C
	JRNZ	..NINE		;WRITE AFTER DDB
	INR	C
	MOV	M,C
 ..NINE:MVI	A,37

 ..YINC:LXI	H,SCOUNT	;POINT TO SECTOR COUNT
	MOV	C,M		;PUT IN C
	CMP	C		;SEE IF OVER MAX
	JZ	SFIX1		;DO TRACK & SECTOR RESET
	MOV	A,C
	INR	A
	STA	SCOUNT		;UPDATE FOR NEXT SECTOR
	CALL	SETSEC
	CALL	SWRITE
	LHLD	TADD		;GET LAST DMA ADD.
	LXI	D,128
	DAD	D		;UQDATE IT
	SHLD	TADD
	PUSH	H
	POP	B		;MAKE BC NEW ADDRESS
	CALL	SDMA
	JMPR	WLOOP

SFIX1:	MVI	A,1		;SET SECTOR TO 1
	STA	SCOUNT
	LDA	STRK		;GET TRACK COUNT
	CPI	1
	JRZ	HOMIT		;LOOP BACK FOR ANOTHER SYSGEN
	INR	A
	STA	STRK		;ELSE UPDATE STRK
	LXI	B,1
	CALL	STRACK		;GO SET NEXT TRACK
	JMP	WLOOP

HOMIT:
	CALL	HOME	
GDES0:	MVI	A,CR		;ACC. = 'CR'
	STA	SOURCE		;RESET SOURCE TO 'CR'
	JMP	GDES		;LOOP FOR NEXT DESTINATION

;ENDING MESSAGE FROM HERE

EMESS:	MVI	C,PRINTS
	LXI	D,MESS3		;POINT TO SYSGEN COMPLETE MESS.
	CALL	BDOS		;PRINT IT
	LDA	DESTIN
	CPI	'A'
	JNZ	GOBAK

	MVI	C,PRINTS
	LXI	D,MESSA
	CALL	BDOS
	HLT

MESSA:	.BYTE	CR,LF,LF
	.ASCII	\SYGEN WAS ON A, HALTING FOR REBOOT :$\
	



MESS1:

	.BYTE	CLEAR,LF,CR
	.ASCII	\FLOPPY DISK SYSGEN - USE ONLY WITH AN INSTALLED VFBIOS \
	.BYTE	LF,CR
	.ASCII	\SOURCE DRIVE OR  <RETURN> $\


MESS2:	.BYTE	10,LF,CR
	.ASCII	\DESTINATION DRIVE  OR  <RETURN> $\


MESS3:	.BYTE	LF,CR
	.ASCII	\SYSGEN COMPLETE \
	.BYTE	LF,CR,24H


MESS4:	.BYTE	10,13
	.ASCII	\SOURCE ON \

SRC:	.BYTE	'A'

	.ASCII	\ THEN TYPE  <RETURN> $\


MESS5:
	.BYTE	10,13
	.ASCII	\DESTINATION ON \

DST:	.BYTE	'B'

	.ASCII	\ THEN TYPE  <RETURN> $\


MESS6:
	.BYTE	10,10,13,7
	.ASCII	\BAD DRIVE SELECTION $\



;LOCAL JUMP TABLE FOR BIOS ACCESS STARTS HERE

HOME:	LHLD	PHOME
	PCHL
SELDSK:	LHLD	PSELD
	PCHL
SDMA:	LHLD	PSDMA
	PCHL
SETSEC:	LHLD	PSSEC
	PCHL
SREAD:	LHLD	PREAD
	PCHL
STRACK:	LHLD	PSTRK
	PCHL
SWRITE:	LHLD	PWRITE
	PCHL



;IN CASE OF MULTI-SYSGENS HOME THE DESTINATION DRIVE
;EACH TIME TO ALLOW FOR MECHANICAL SHOCK

HDEST:

	LDA	DESTIN
	ANI	7
	DCR	A
	LXI	B,0
	MOV	C,A
	CALL	SELDSK
	LXI	B,DMAB
	CALL	SDMA
	LXI	B,1
	CALL	SETSEC
	CALL	HOME
	CALL	SREAD
	RET


;NOW SET UP BIOS POINTERS TO PRODUCE A LOCAL JUMP TABLE
;ACCESSED VIA A CALL TO PCHL ROUTINE

SBPOT:

	LHLD	BPTR		;GET BIOS POINTER
	SHLD	BLOC		;SAVE HERE
	MOV	A,M		;GET FIRST JUMP
	CPI	0C3H		;SEE IF IT IS
	JNZ	INIT		;SOMETHING'S WRONG
	LXI	D,21		;SET FIRST OFFSET
	DAD	D		;SET HOME VALUE
	SHLD	PHOME		;SAVE IT
	LXI	D,3
	DAD	D
	SHLD	PSELD
	DAD	D
	SHLD	PSTRK
	DAD	D
	SHLD	PSSEC
	DAD	D
	SHLD	PSDMA
	DAD	D
	SHLD	PREAD
	DAD	D
	SHLD	PWRITE
	RET


;****************************************************
; GET A CHARACTER FROM THE CONSOLE. IF THE CHARACTER
; IS UNACCEPTABLE, BEEP AND WAIT FOR ANOTHER. RETURN
; TO CP/M IF ^C IS ENTERED. (BDOS DOES RETURN ON ^C)
;****************************************************
; THE CCIR Z80 INSTRUCTION CHECKS ALL ACCEPTABLE
; CHARACTERS FROM THE TABLE POINTED TO BY HL
; A BAD INPUT CAUSES A BELL, PLUS A BACKSPACE
; BLANK-OVER AND BACKSPACE TO ERASE THE WRONG
; INPUT ON CONSOLE, THEN THE ROUTINE IS RE-ENTERED
;====================================================

GETOK:	
..RTRY:	PUSH	H	;SAVE OK TABLE ADDR
	MOV	C,M	;GET COUNT
	INX	H
	MVI	B,0
	CALL	CI	;GET A CHAR
	CPI	'Q'	;IS IT QUIT 
	JZ	GOBAK	;YES, GO BACK TO CP/M
	CCIR		;IS IT OKAY
	POP	H
	RZ		;YES, RETURN IT

	MVI	C,BELL	;NO, RING BELL
	CALL	CO
	MVI	C,8	;BACK SPACE
	CALL	CO
	MVI	C,' '
	CALL	CO
	MVI	C,8
	CALL	CO
	JMP	..RTRY	;KEEP TRYING

;***************************************************
;       GET A CHARACTER FROM THE CONSOLE.
;***************************************************

CI:	PUSH	B
	PUSH	D
	PUSH	H
	MVI	C,GCON	;CONSOLE INPUT
	CALL	BDOS	;GET THE CHARACTER
	POP	H
	POP	D
	POP	B
	RET

;**************************************************
;      WRITE A CHARACTER TO THE CONSOLE.
;**************************************************

CO:	PUSH	B
	PUSH	D
	PUSH	H
	MOV	A,C
	ANI	7FH
	MOV	E,A	;MOVE CHARACTER TO E
	MVI	C,2	;CONSOLE OUTPUT
	CALL	BDOS	;OUTPUT THE CHARACTER
	POP	H
	POP	D
	POP	B
	MOV	A,C	;FIX UP ACC
	RET

GOBAK:
	LXI	D,QUITER
	MVI	C,PRINTS
	CALL	BDOS
	JMP	0

QUITER:
	.BYTE	CR,LF,LF,LF
	.ASCII	\EXITING TO COMMAND PROMPT $\

OKDRIV:	.BYTE	7,'A','B','C','D','Q',CR,CTLC




		
;PROGRAM STORAGE

SOURCE:	.BLKB	1		;SAVE SOURCE
DESTIN:	.BLKB	1		;SAVE DESTINATION

;ADDRESS VALUES FOR LOCAL JUMP TABLE STORED HERE

PHOME:	.BLKW	1
PSELD:	.BLKW	1
PSTRK:	.BLKW	1
PSSEC:	.BLKW	1
PSDMA:	.BLKW	1
PREAD:	.BLKW	1
PWRITE:	.BLKW	1

;TEMP STORAGE HERE

SCOUNT:	.BYTE	1		;SECTOR COUNT
STRK:	.BYTE	0		;CURRENT TRACK
TADD:	.BLKW	1		;DMA ADDRESS
BLOC:	.BLKW	1		;BASE ADDRESS OF CBIOS
TEST:	.BYTE	0		;DDB WRITE FLAG




	.END
