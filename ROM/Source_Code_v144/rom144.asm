;.Date: 2/4/1983
;.Author: Roger W. Chapman
;.Title: DOUBLE DENSITY ROM : REV 1.44
;.Comments: 

;	+-------------------------------+
;	|                               |
;	|     Double Density Monitor    |
;	|                               |
;	+-------------------------------+



;REV 1.44  
;		CBOOT  - added seek 10 tracks and home drive : tsk
;	   	GKEY   - fixed bell bug : tsk
;	   	SENDEN - changed the number of retrys to NRETRY : tsk
;	   	PSEKC  - added disk head settle delay : tsk
;	   	SELDRV - changed start up delay to 500 ms  : tsk
	  


	ORG	0		;FWA of memory


CBELL:	=	'G'-40h		;Ring the Bell
MCUP:	=	'K'-40h		;Move cursor up
MCRIGH:	=	'L'-40h		;Move cursor right
VCLRS:	=	'Z'-40h		;Clear and home cursor
VHOME:	=	'^'-40h		;Home Cursor

VLOCK:	=	'#'		;Lock Keyboard
VUNLK:	=	'"'		;Unlock Keyboard
VCAD:	=	'='		;Cursor Addressing
VSAD:	=	'S'		;Screen Addressing
VINC:	=	'Q'		;Insert Char
VDELC:	=	'W'		;Delete char
VINL:	=	'E'		;Insert line
VDELL:	=	'R'		;Delete line
VCEOL:	=	'T'		;Clear to end of line
VSHI:	=	')'		;Start half intensity
VEHI:	=	'('		;end
VSUL:	=	'l'		;Start underline
VEUL:	=	'm'		;end
VSGH:	=	'g'		;Start graphics
VEGH:	=	'G'		;End

ROW0M:	=	081H
SI.MRST	=	0_10_101_11b	;Master reset
SI.S16:	=	0_10_101_01b	;Select 16x clock, xmit/rec
SI.RRDY	=	01		;Receiver ready
SI.TRDY	=	02		;Transmit ready
NMIA:	=	66h		;NMI address
LVMEM:	=	128*32		;Length of video memory
VFLO:	=	-22		;First line video offset
VLL:	=	128		;Length of one video line
SCLFRE:	=	0B5H		;for DELAY routine
LF:	=	0Ah		;^J, LF = Line Feed
CR:	=	0Dh		;^M, CR = Carriage Return
ESC:	=	1Bh		;^[, ESC = Escape
ERC:	=	7Fh		;illegal key
BKS:	=	08h		;BACKSPACE
TAB:	=	09h		;TAB

KL_LEN:	=	3		;KEY LIST LENTH
KLE_LEN	=	2		;KEY LIST ENTRY LENTH
KL_USED	=	7		;KEYLIST ENTRY USED
KY_SRVD	=	6		;KEY SERVICED ONCE
KROW_M:	=	38H		;ROW NUMBER MASK
KCOL_M:	=	7H		;COL NUMBER MASK
DB_CT:	=	1		;DEBOUNCE COUNT
IRPTCT:	=	24		;INITIAL REPEAT COUNT (400MS)
SRPTCT:	=	6		;SECOND REPEAT COUNT (100MS)
TOT_ROW	=	7		;TOTAL ROWS
CTL_KY:	=	2		;COLUMN NUMBER OF CTL,ALPHA AND SHIFT KEYS
ALPH_KY	=	3
SHFT_KY	=	4
SLD_RCT	=	3		;REPEAT COUNT FOR SLIDE KEYS (50MS APPROX)
BRTBIT:	=	80h		;set brt/dim memory BRIGHT
DIMBIT:	=	00h		;set brt/dim memory DIM
NRETRY:	=	10		;NUMBER OF RETRYS
	TITLE	'RAM STORAGE LOCATIONS'

;MEMORY MAPPED I/O

D.CMDR:	=	02100H		;Floppy disk DISK COMMAND REG	(WRITE)
D.STSR:	=	D.CMDR		;STATUS REG		(READ)
D.TRKR:	=	D.CMDR+1	;TRACK REG
D.SECR:	=	D.CMDR+2	;SECTOR REG
D.DATR:	=	D.CMDR+3	;DATA REG		(R/W)
H.KEY:	=	02200H		;Keyboard
CPDRA:	=	02900H		;Peripheral/Direction register A
CCRA:	=	CPDRA+1		;Control register A
CPDRB:	=	CPDRA+2		;Peripheral/Direction register B
CCRB:	=	CPDRA+3		;Control register B
PA.DTA	=	CPDRA+0
PA.DIR	=	PA.DTA
PA.CTL	=	CPDRA+1
PB.DTA	=	CPDRA+2
PB.DIR	=	PB.DTA
PB.CTL	=	CPDRA+3
H.SCTRL	=	02A00H		;Set control reg	(write)
H.SSTS:	=	02A00H		;Status reg		(read)
H.SXMT:	=	02A00H+1	;Transmit address
H.SREC:	=	02A00H+1	;Receive (read from address)
H.VIO:	=	02C00H		;Video memory controls

;RAM MEMORY LOCATIONS

TEM:	=	0EF00H		;(1) USED IN BOOT ROUTINES
RTRY:	=	0EF05H		;(1) RETRY COUNTER
ROMRAM:	=	0EF08H		;(1) ROM/RAM FLAG
DSTSB:	=	0EF09H		;(1) SIX BYTES FOR DISK INFO
DMADR:	=	0EF0FH		;(1) DISK DMA ADDRESS
SEKDEL:	=	0EF13H		;(1) DISK STEP DELAY
SAVSEC:	=	0EF14H		;(1) SECTOR
SAVTRK:	=	0EF15H		;(1) TRACK
SDISK:	=	0EF17H		;(1) DISK
HSTACT:	=	0EF50H
UNASEC:	=	0EF55H
LOGSEC:	=	0EF56H
KEYLCK:	=	0EF59H		;(1) KEYBOARD LOCKED CELL
CURS:	=	0EF5AH
LKEY:	=	0EF5EH		;(1)
ESCH:	=	0EF60H
PIAAD:	=	0EF61H		;(1)
PIABD:	=	0EF62H		;(1)
DACTVE:	=	0EF6AH		;(1) DISK ACTIVE FLAG
BELCNT:	=	0EF6BH		;(1) IS BELL RINGING
LLIMIT:	=	0EF6CH
LDTRK:	=	0EF6EH
IESTK:	=	0EF6FH		;(2) SAVE STACK POINTER HERE
ISTK:	=	0EF99H		;(-40) INTERUPT STACK
ACIAD:	=	0EFC1H
ROMSTK:	=	0EFC1H		;(-40) ROM STACK
DSKSWP:	=	0EFC7H		;(1) DISK SWAPED CELL
NUMSEC:	=	0EFCAH		;(2) NUMBER OF SECTORS TO R/W
SEQ:	=	0EFCCH		;(2) COUNTER
SAVTYP	=	0EFD0H		;(1) DISK TYPE
R_WCOM:	=	0EFD1H		;(1) NUMBER OF SECTORS TO READ OR WRITE
CCPADR:	=	0EFD2H		;(2) This location is assigned in BIOS and filled in by loader in ROM
KEYLST:	=	0EFD4H		;(6) KEY LIST GOES HERE
SERFLG:	=	0EFDAH		;(1)
IE_ADRS	=	0EFDBH		;(1) device address
IE_CHAR	=	0EFDCH		;(1) IE inp char buffer
PIACTL	=	0EFDDH		;(1)
PP.MODE	=	0EFDEH		;(1) Parallel port input, output, undefined
VRTOFF:	=	0EFEFH		;(1) LAST VERICAL OFFSET
INTBL:	=	0EFF0h		;(16) interrupt vector table
FWAVM:	=	0F000H		;FIRST ADDRESS OF MEMORY MAP
	TITLE	'IEEE EQUATES'

;port ctl register constants.

PA.CDR	=	00101010b	;to address port a direction
PA.CDT	=	00101110b	;to address port a data and set
				;port a in input program handshake mode.
PB.CDR	=	00000000b	;to address port b direction
PB.CDT	=	00000100b	;to address port b data

;direction register constants

PA.DRO	=	0FFh		;port a output mode
PA.DRI	=	00h		;port a input mode
PB.DR	=	0BFh		;port b direction
PB.DTO	=	00000010b	;port b data for output
PB.DTI	=	00001011b	;port b data for input

PP.ORDY	=	01000000b	;output rdy bit in pib
PP.IRDY =	10000000b	;input rdy bit in pia ctl reg
STRB	=	00100000b	;strobe bit in port b

;port modes

PP.OUT	=	1
PP.IN	=	2

;IEEE control codes

IE_TALK	=	40h		;make talker
IE_UTLK =	5Fh		;make untalk
IE_LSTN =	20h		;make listener
IE_ULST =	3Fh		;make unlisten
	TITLE	'DISK EQUATES'

D.SEK:	=	010H		;SEEK
D.STP:	=	020H		;STEP
D.STPI:	=	040H		;STEP IN
D.STPO:	=	060H		;STEP OUT
D.RDS:	=	080H		;READ SECTOR
D.WRTS:	=	0A0H		;WRITE SECTOR
D.RDA:	=	0C0H		;READ ADDRESS
D.RDT:	=	0E0H		;READ TRACK
D.WRTT:	=	0F0H		;WRITE TRACK
D.FINT:	=	0D0H		;FORCE INTERRUPT


;MACRO DEFINITION

ENADIM:	MACRO
	OUT	2
	ENDM


DISDIM:	MACRO
	OUT	3
	ENDM
	TITLE	'Monitor Main Loop.'
*[1]

START:
;Initialize all dependent hardware.

	PROC
	LDK	SP,ROMSTK	;SET STACK

;DISABLE DIM BIT

	DISDIM

;SET INTERUPTS

	;SET MODE 2 INTERUPTS

	IM2

	;SET INTERRUPT REGISTER

	LDK	A,high INTBL
	MOV	I,A

	;SET KEYBOARD VECTOR

	LDK	HL,GKEY
	STO	HL,INTBL+(4*2)	;set keyboard interrupt

	;SET SERIAL VECTOR

	;SET IEEE VECTOR

*INITIALIZE MEMORY

;CLEAR ALL BUT INTERUPT VECTORS

	LDK	HL,0EF00H	;START
	LDK	B,0F0H		;LENTH

	XRA	A

:CLOOP:	STO	A,[HL]
	INC	HL
	DJNZ	:CLOOP		;CLEAR LOOP

;SET VALUES OF ONE

	INC	A		;A = ONE
	STO	A,KEYLCK	;indicate NOT locked

	MOV	C,A		;FOR "IE.CO"

;SET VALUES OF TWO

	INC	A		;A = TWO
	STO	A,SEKDEL	;set seek step rate FOR SEMIENS

	CALL	SPAO		;set up for output (SAVES REG C)

;Intialize IEEE port

	CALL	IE.CO		;REG C=1 (SAVES REG C)

;Set beginning line to 0

	DEC	C		;C=0
	CALL	OPBD

;set for -10 char position AND DOUBLE DENSITY

	LDK	C,VFLO
	CALL	OPAD

	LDK	A,VLL
	STO	A,LLIMIT	;set max line limit

;Reset-Master clear the SIO (ACIA)

	LK	C,SI.S16	;select 16x clock for 1200 baud
	CALL	SIRST		;reset

*SIGN ON PROMPT

	LDK	DE,IMSG
	CALL	OSTR		;Output initial message

	EI			;ENABLE INTERUPTS

	CALL	CI		;Get character
	CMP	ESC
	JZ	HCBOOT		;IF COLD BOOT OFF OF HARD DISK

	LK	HL,DSKSWP	;disk swap cell
	CMP	CR
	JZ	CBOOT		;if cold boot off of A

	INC	[hl]		;swap drives: A=B, B=A
	CMP	'"'
	JZ	CBOOT		;if cold boot off of B

	JR	START		;LOOP
	PAGE

*INTERUPT VECTOR FOR RESET BUTTON (NON MASKABLE INTERUPT)

	ORG	NMIA

	LDK	SP,ROMSTK	;Initialize stack to high RAM
	CALL	FORINT		;Clear disk command, if any

	JR	START		;START
	PAGE

SPAO:
;Set PIA for output
;ENTRY
;NONE

;EXIT
	;HL	=	H.VIO+2

;CHANGE
	;HL

	PROC

	LDK	HL,H.VIO+1	;H.VIO+1

	STO	3,[HL]		;set data direction

	DEC	HL		;H.VIO

	STO	0FFh,[HL]	;set all A lines as output

	INC	HL		;H.VIO+1
	INC	HL		;H.VIO+2
	INC	HL		;H.VIO+3

	STO	0,[HL]

	DEC	HL		;H.VIO+2

	STO	0FFH,[HL]	;set all B lines as output

	RET
	PAGE

OPAD:
;Output data to pia A register
;	PIA definition.
;	  7  6  5  4  3  2  1  0
;	+--+--+--+--+--+--+--+--+
;	|  horizontal offset |DD|
;	+--+--+--+--+--+--+--+--+

*NOTE	The DD(double density) bit is inverted and the jumper must be installed on the pc board.
;	If the 0 bit is LOW double density is set if it is HIGH single density is set.

*NOTE	Bit 0 of "PIAAD" :
;	set	=	single density
;	reset	=	double density

*NOTE*
;SAVE HL

;ENTRY
;C	=	data

;EXIT
;NONE
	PROC

	LDK	A,4+3
	STO	A,H.VIO+1

	MOV	A,C
	STO	A,PIAAD
	STO	A,H.VIO		;send data
	RET
	PAGE

OPBD:
;Output data to pia B register
;	PIA definition.
;	  7  6  5  4  3  2  1  0
;	+--+--+--+--+--+--+--+--+
;	|D1|D0|^G| vert  offset |
;	+--+--+--+--+--+--+--+--+

;ENTRY
;C	=	data

;EXIT
;NONE
	PROC

	LDK	A,4
	STO	A,H.VIO+3

	MOV	A,C
	STO	A,PIABD
	STO	A,H.VIO+2	;send data
	RET
	PAGE

ROMJP1:	LDK	DE,1633h	;offset in bios jump table
	JR	BIOJP


ROMJP2:	LDK	DE,1636h	;offset in bios jump taple

BIOJP:	LD	HL,CCPADR
	ADD	HL,DE		;form address
	JMP	[HL]
	PAGE

EMBOOT:	DB	CR,LF
	DB	'BOOT ERROR'
	DC	' '

EBOOT:
;BOOT ERROR MESSAGE ROUTINE
;ENTRY
;NONE

	PROC

	LDK	DE,EMBOOT	;HERE ON BOOT ERROR

;FALL THROUGH TO OSTR
	PAGE

OSTR:
;OUTPUT STRING TO CONSOLE
;NOTE:	OSTR RECOGNIZES 7F AS AN ESCAPE SEQUENCE TO REPEAT CHAR N TIMES.  FORMAT IS: 7F, REPEAT COUNT, CHAR
;ENTRY
;DE	=	FWA OF SOURCE

;EXIT
;NONE
	PROC

	LD	A,[DE]
	OR	A
	PUSH	AF

	AND	07FH
	CMP	07FH
	MOV	C,A
	JRNZ	:4		;IF NOT REPEAT

	INC	DE
	LD	A,[DE]
	DEC	A
	MOV	B,A		;REPEAT COUNT
	INC	DE
	LD	A,[DE]		;GET REPEAT CHAR
	MOV	C,A

:2:	CALL	COUT		;OUTPUT CHAR
	DJNZ	:2		;IF NOT DONE

:4:	CALL	COUT		;OUTPUT IT
	INC	DE

	POP	AF
	JP	OSTR		;IF NOT DONE

	RET
	PAGE

DELAY:
;'N' Milliseconds
;ENTRY
;A	=	Number of Milliseconds to delay
;SCLFRE	=	(Freq/1000)/25

;EXIT
;NONE
	PROC

	MOV	C,A
:1:	LDK	A,SCLFRE

:MLOOP:	DEC	A		;(4 tics)
	MOV	B,B		;(4 tics)
	MOV	C,C		;(4 tics)
	JRNZ	:MLOOP		;(10 tics) If 1 ms not elapsed

	DEC	C
	JRNZ	:1		;If requested msec not done

	RET

;SCLFRE	=	2000/22	;Z80, 2mhz
;...defined in OCCTXT.ast
	PAGE

	ORG	100h

;ROM JUMP TABLE
;	CBIOS	=	Jmps used mainly by CBIOS
;	SC	=	Jmps used mainly by SuperCalc

	JMP	CBOOT		;CBIOS	cold boot
	JMP	WBOOT		;CBIOS	warm boot
	JMP	SKEY		;CBIOS	keyboard status
	JMP	CI		;CBIOS	keyboard input
	JMP	COUT		;CBIOS	console output
	JMP	LIST		;CBIOS	list output
	JMP	LIST		;CBIOS	punch output
	JMP	READER		;CBIOS	reader input

;	Disk I/O

	JMP	RDRV		;CBIOS	HOME
	RET			;CBIOS	SELECT DISK
	NOP
	NOP
	JMP	READ		;	READ SECTOR
	JMP	WRITE		;	WRITE SECTOR
	JMP	RADR		;	READ SECTOR ANY SECTOR HEADER
	JMP	RSEC		;CBIOS	DISK SECTOR READ
	JMP	WSEC		;CBIOS	DISK SECTOR WRITE
	JMP	SLST		;CBIOS	List device status
	JMP	SENDEN		;CBIOS	SENSE THE DENSITY OF DRIVE
	JMP	ROMJP1		;CBIOS
	JMP	ROMJP2		;CBIOS
	JMP	FORMAT		;CBIOS	FORMATING ROUTINE

;	IEEE

	JMP	SIRST		;CBIOS	SIO reset
	JMP	IE.CO		;CBIOS	IEEE	Control Out
	JMP	IE.SI		;CBIOS		Status In
	JMP	IE.GTS		;CBIOS		Go To Standby
	JMP	IE.TC		;CBIOS		Take Control
	JMP	IE.OIM		;CBIOS		Output Interface Message
	JMP	IE.ODM		;CBIOS		Output Device Message
	JMP	IE.IDM		;CBIOS		Input Device Message
	JMP	IE.PP		;CBIOS		Parallel Poll

;	SuperCalc

	JMP	VLDDR		;SC	VIDEO BLOCK MOVE DEC
	JMP	VLDIR		;SC	VIDEO BLOCK MOVE INC
	JMP	STODIM		;SC	STO reg B IN [HL]

;	DISK I/O

	JMP	DMAWRT		;	DMA WRITE TO CONTROLER
	JMP	DMARD		;	DMA READ FROM CONTROLER
	JMP	HOME		;	HOME DISK DRIVE
	JMP	SEEK		;	SEEK TO TRACK
	JMP	STEP		;	STEP SAME DIRECTION
	JMP	STEPIN		;	STEP IN
	JMP	STEPOUT		;	STEP OUT
	JMP	FORINT		;	FORCE INTERUPT
	JMP	READTRK		;	READ TRACK
	JMP	FMTTRK		;	Format one track
	JMP	SELDRV		;	SELECT DRIVE
	JMP	ACISTAT		;CBIOS	SERIAL PORT STATUS
	JMP	SCTRKR		;	SET TRACK REGESTER IN CONTROLER CHIP WITH VALUE IN SAVTRK

	JMP	IEINSTAT	;CBIOS	IEEE
	JMP	IEOSTAT		;CBIOS	IEEE
	JMP	IEINP		;CBIOS	IEEE
	JMP	IEOUT		;CBIOS	IEEE

	JMP	PISTAT		;CBIOS	IEEE
	JMP	POSTAT		;CBIOS	IEEE
	JMP	PARINP		;CBIOS	IEEE
	JMP	PAROUT		;CBIOS	IEEE
	TITLE	'SIGN ON MESSAGE'

IMSG:	DB	'Z'-40h,lf,lf,lf,lf
	DB	07Fh, 11, ' '
	DB	ESC,VSGH
	DB	'Q'-40h
	DB	07Fh, 24, 'W'-40h
	DB	'E'-40h
	DB	ESC,VEGH

	DB	cr,lf
	DB	07Fh, 11, ' '
	DB	ESC,VSGH,1, ESC,VEGH
	DB	'       '
	DB	ESC,'l'
	DB	'OSBORNE 1'
	DB	ESC,'m'
	DB	'        '
	DB	ESC,VSGH,4, ESC,VEGH

	DB	cr,lf
	DB	07Fh, 11, ' '
	DB	ESC,VSGH
	DB	'A'-40h
	DB	07Fh,24,' '
	DB	'D'-40h
	DB	ESC,VEGH

	DB	cr,lf
	DB	07Fh, 11, ' '
	DB	ESC,VSGH
	DB	'A'-40h
	DB	ESC,VEGH
	DB	ESC,')'
	DB	'  Rev 1.44 (c) 1983 OCC '
	DB	ESC,'('
	DB	ESC,VSGH
	DB	'D'-40h
	DB	ESC,VEGH

	DB	cr,lf
	DB	07Fh, 11, ' '
	DB	ESC,VSGH
	DB	'Z'-40h
	DB	07Fh, 24, 'X'-40h
	DB	'C'-40h
	DB	ESC,VEGH

	DB	cr,lf,lf,lf
	DB	07Fh, 4, ' '
	DB	'Insert disk in Drive '
	DB	ESC,'l'
	DB	'A'
	DB	ESC,'m'
	DB	' and press RETURN'
	DC	'.'
	TITLE	'B o o t   C P / M   f r o m   d i s k.'
*[2]

CBOOT:
;LOAD ALL THE OPERATING SYSTEM INCLUDING THE CBIOS
;ENTRY
;NONE

;EXIT
;A	=	DRIVE TO BOOT FROM

	PROC

*SET "SAVTYP"


:1:	CALL	RDRV		;HOME DRIVE
	LDK	A,10		;SEEK TRACK 10
	STO	A,SAVTRK	;
	CALL	SEEK		;
	CALL	RDRV		;HOME DRIVE AGAIN	
	CALL	SENDEN		;DETERMINE DENSITY
	JRZ	:2		;IF GOOD

:ERR:	CALL	EBOOT		;PRINT ERROR
	JR	:1

*SET SAVTRK TO 0

:2:	XRA	A		;
	STO	A,SAVTRK	;SAVTRK=0

*READ AND SET FBA OF CCP

	LDK	HL,0D000H
	STO	HL,DMADR	;SET DMA

	PUSH	HL

:3:	LDK	A,1
	STO	A,SAVSEC	;SET SECTOR
	MOV	B,A
	CALL	RSEC		;READ SECTOR ONE
	JRZ	:4		;IF GOOD

	CALL	EBOOT		;PRINT ERROR
	JR	:3

*CHECK FIRST TWO BYTES OF THE CCP

:4:	POP	HL		;HL = 0D000H

	LD	A,[HL]		;FIRST BYTE
	CMP	0C3H
	JRNZ	:ERR		;IF NOT THE SAME

	INC	HL		;HL = 0D001H
	LD	A,[HL]		;SECOND BYTE
	CMP	05CH
	JRNZ	:ERR		;IF NOT THE SAME

	INC	HL		;HL = 0D002H

;SET LOAD ADDRESS

	LD	A,[HL]		;get ccp address/100h + 3
	SUB	3
	LDK	L,0
	MOV	H,A

*SET NUMBER OF 128 BYTE BLOCKS TO READ FOR BOOT

	LDK	B,60		;CCP/BDOS/CBIOS

*READ SYSTEM

	PUSH	HL		;SAVE FWA FOR "CCPADR"
	CALL	BCPM		;boot system
	POP	HL

*JUMP SYSTEM

	XRA	A		;DRIVE BOOTED FROM
	STO	HL,CCPADR	;SET "CCPADR"

	LDK	DE,1600h	;offset for bios
	ADD	HL,DE		;address of bios in hl
	JMP	[HL]		;enter cpm
	PAGE

WBOOT:
;LOAD ONLY THE CCP AND THE BDOS FROM DRIVE A
;ENTRY
;NONE

;EXIT
*NOTE*
*;	THIS ROUTINE DOES NOT EXIT. IT ONLY SETS PARAMITERS FOR BCPM:.

*;B	=	NUMBER OF 128 BYTE BLOCKS TO READ FOR BOOT
*;HL	=	DMA ADDR FOR CCP

	PROC

	LDK	B,44		;CCP/BDOS and don't read CBIOS
	LD	HL,CCPADR
	PAGE

BCPM:
;LOAD ALL OR PART OF CPM FROM THE DISK

*NOTE*
;	This loader will load single or double density and any number of sectors per track or bytes
;per sector. TEM is not zero if there are an uneven number of sectors to read. If this is true the
;last sector is read into a temporary buffer and the part needed is moved into the memory.

;ENTRY
;B	=	NUMBER OF 128 BYTE BLOCKS TO READ FOR BOOT
;HL	=	DMA ADDR FOR CCP

;EXIT
;NONE

	PROC

*SET "SDISK", "DMADR" AND "SAVSEC"

	STO	HL,DMADR	;SET DMA

	XRA	A
	STO	A,SDISK		;BOOT ONLY FROM DRIVE A
	STO	A,TEM		;MAKE TEM ZERO

	INC	A
	STO	A,SAVSEC	;set sector

*SET "SAVTYP" AND GET NUMBER OF SECTORS PER TRACK

	PUSH	BC		;SAVE NUMBER OF 128 BLOCKS

:RL1:	CALL	RDRV		;HOME DRIVE
	CALL	SENDEN		;DETERMINE DENSITY
	JRZ	:1		;IF GOOD

	CALL	EBOOT		;PRINT ERROR
	JR	:RL1

:1:	POP	DE		;D=NUMBER OF 128 BYTE BLOCKS
	PUSH	BC		;SAVE NUMBER OF SECTORS IN ONE TRACK

*SET NUMBER OF SECTORS TO READ

	LD	A,SAVTYP
	SRL	A
	SRL	A
	ANI	0000_0011B	;A=NUMBER OF BYTES IN ONE SECTOR(0-3)
	JRZ	:2		;IF 128 BYTES SECTORS

	;GET NUMBER TO DEVIDE BY

	MOV	B,A		;B=NUMBER OF BYTES IN ONE SECTOR(1-3)
	LDK	A,1

:1LOOP:	SLA	A		;TIMES TWO
	DJNZ	:1LOOP

	MOV	B,A		;NUMBER TO DIVIDE BY
	MOV	A,D		;A=NUMBER OF 128 BYTE BLOCKS
	LDK	D,0

:2LOOP:	SUB	B		;SUBTRACK WITH DIVISOR
	EX	AF		;SAVE FLAGS
	INC	D		;COUNT
	EX	AF		;RESTORE FLAGS
	JRZ	:2		;IF REZULT IS ZERO (NO PARTIAL SECTORS)

	JRNC	:2LOOP		;LOOP

	NEG	A		;2 COMP
	STO	A,TEM		;SAVE REMAINDER AND INDICATE A PARTIAL SECTOR

:2:	POP	BC		;B=NUMBER OF SECTORS IN ONE TRACK
	MOV	C,D		;C=NUMBER OF SECTORS TO READ
	PAGE

*READ SYSTEM

	XRA	A		;A=0
:TLOOP:	STO	A,SAVTRK	;SET TRACK

	;CHECK FOR ALL SECTORS READ

	MOV	A,C		;SECTORS TO READ
	ORA	A
	JRNZ	:3		;IF C IS NOT ZERO CONTINUE

		;CHECK FOR NO PARCIAL SECTOR

	LD	A,TEM
	ORA	A
	JRZ	:9		;STOP IF C=0 AND TEM=0

	JR	:7		;READ PARCIAL SECTOR

	;UPDATE NUMBER OF SECTORS LEFT TO READ

:3:	SUB	B		;SUBTRACK SECTORS IN ONE TRACK
	JRNC	:4		;A>B MORE THAN ONE TRACK LEFT TO READ

	;IF THIS IS LAST TRACK ZERO NUMBER OF SECTORS LEFT TO READ

	MOV	B,C		;READ ALL THE REMAINING SECTORS
	XRA	A		;THIS WILL ZERO REG C

	;CHECK FOR NONZERO VALUE IN TEM AND THE LAST SECTOR TO READ

:4:	MOV	C,A		;SAVE REMAINING SECTORS TO READ
	LD	A,TEM
	ORA	A
	JRZ	:5		;IF TEM IS ZERO SKIP THIS

	XRA	A
	ORA	C
	JRNZ	:5		;IF REG C IS NOT ZERO SKIP THIS(NOT LAST TRACK)

		;READ ONE LESS THAN THE LAST SECTOR

	DEC	B		;B=B-1
	JRZ	:7		;IF ONLY ONE SECTOR LEFT TO READ

	;READ ONE TRACK

:5:	CALL	RSEC		;READ (BC IS SAVED)
	JRZ	:6		;IF GOOD

	CALL	EBOOT		;REPORT ERROR
	JR	:5

	;UPDATE DMA

:6:	STO	HL,DMADR	;SET DMA

	;UPDATE TRACK

	LD	A,SAVTRK
	INC	A
	JR	:TLOOP		;TRACK LOOP
	PAGE

*READ A PARTIAL SECTOR

:7:	PUSH	HL		;SAVE ADDRESS TO WRITE TO

	LDK	HL,0EA80H	;ADDRESS OF HOST BUFFER IN BIOS
	STO	HL,DMADR	;SET DMA

	;SET TRACK IF NEEDED

	JRZ	:10		;IF B=0 THEN SAVTRK WAS NOT INCREMENTED

	LDK	HL,SAVTRK
	DEC	[HL]		;SAVTRK = SAVTRK - 1

	;SET THE SECTOR TO B + 1

:10:	INC	B
	MOV	A,B
	STO	A,SAVSEC	;SET SECTOR

	;READ SECTOR INTO HOST BUFF

	LDK	B,1
:RL2:	CALL	RSEC		;READ ONE SECTOR
	JRZ	:8		;IF GOOD

	CALL	EBOOT		;REPORT ERROR
	JR	:RL2

	;SET NUMBER OF BYTES TO TRANSFER

:8:	LD	A,TEM
	MOV	B,A		;B=NUMBER OF 128 BYTE BLOCK TO TRANSFER
	LDK	HL,0
	LDK	DE,128

:3LOOP:	ADD	HL,DE
	DJNZ	:3LOOP

	PUSH	HL
	POP	BC		;BC=NUMBER OF BYTES TO TRANSFER

	;TRANSFER BYTES

	LDK	HL,0EA80H	;SOURCE
	POP	DE		;DESTINATION
	LDIR			;MOVE
	PAGE

*CLEAR BUFFERS SET PARR. AND RETURN TO SYSTEM

:9:	LDK	HL,HSTACT

	STO	0,[hl]		; 1st byte

	LDK	BC,(LOGSEC-HSTACT)
	LDK	DE,HSTACT+1	;DE = HL + 1

	LDIR			; overlapping move

	LDK	A,0FFh
	STO	A,UNASEC

	LDK	A,VLL-1
	STO	A,LDTRK		;set other drive NOT int

	XRA	A		;Clear error indicator
	RET
	TITLE	'Keyboard and Console Routines.'
*[3]

SKEY:
;Get status of keyboard

;EXIT
;Cbit set if no data ready

	LD	A,KEYLCK
	OR	A
	RZ			;if locked keyboard

	LD	A,LKEY
	ORA	A		;CHECK FOR ZERO
	RZ

	ORI	0FFH		;IF NOT ZERO MAKE 0FFH
	RET			;IF DATA
	PAGE

CI:
RKEY:
;Read next key from keyboard

;EXIT
;A	=	last key

	PROC

	CALL	SKEY
	JRZ	RKEY		;if NO data

	DI
	LD	A,LKEY		;GET CHARACTER
	MOV	C,A
	XRA	A
	STO	A,LKEY		;clear key from hold
	MOV	A,C
	EI

	RET
	PAGE

;Bit definitions for ESCH flag byte
;Note Bit 7 is currently free.

EF_SCR:	=	32		;B5= Screen/Cursor Addressing
EF_ADR:	=	16		;B4= expegting address-chr
EF_ESC:	=	8		;B3=$last char was ESC
EF_UN:	=	4		;B2= Underline mode
EF_HA:	=	2		;B1= Half Intensity mode
EF_GR:	=	1		;B0= Graphics mode
EF_MSK:	=	EF_UN+EF_HA+EF_GR	;Mask to get mode.
	PAGE

;Vector (branch) table for video output mode selection
;controlled by ESCH mode

ESCHTB:
	DW	VNORM		;0 Normal mode
	DW	VGRAPH		;1 Graphics mode
	DW	VHALF		;2 Half intensity mode
	DW	VHA_GR		;3 Half and graphics
	DW	VUNDER		;4 Underline mode
	DW	VUN_GR		;5 Under and graphics
	DW	VUN_HA		;6 Under and half intensity
	DW	VUN_HA_GR	;7 Under and half and graphics
	PAGE

VALIDE:
;Valid ESC-Sequence Table
;3 bytes per entry:ascii char , "DW"-Vector. no. of entries is VALETS
;Following body of table is 2 byte No-Match adrs

	DB	VCAD	! DW	ESCCAD	;Cursor Addressing
	DB	VSAD	! DW	ESCSAD	;Screen Addressing
	DB	VSGH	! DW	ESCSGR	;Set graphics mode
	DB	VEGH	! DW	ESCCGR	;Clr graphics mode
	DB	VSHI	! DW	ESCSHA	;Set half int. mode
	DB	VEHI	! DW	ESCCHA	;Clr half int. mode
	DB	VSUL	! DW	ESCSUN	;Set underline mode
	DB	VEUL	! DW	ESCCUN	;Clr underline mode

	DB	VCLRS	! DW	ESCZZ	;Clear screen to blanks
	DB	VINC	! DW	EINSRT	;Insert char
	DB	VDELC	! DW	EDELC	;Delete char
	DB	VINL	! DW	ESCEE	;Insert line
	DB	VDELL	! DW	ESCRR	;Delete line
	DB	VCEOL	! DW	EEOL	;Clear to end of line
	DB	VLOCK	! DW	ESCLCK	;Lock Keyboard
	DB	VUNLK	! DW	ESCULK	;Unlock Keyboard

:end:	DW	COUT2	;No Match exit

;Ignore char upon undefined ESC-Sequence (to treat undefined char after ESC as a regular
;data char, should go to COUT2).

VALETS:	=	(:end-VALIDE)/3		;# of entries in table
	PAGE

VALIDC:
;Valid control character table
;3 bytes per entry: Ascii char , "DW"- Vector no. of entries is VALCTS
;Following body of table is 2 byte No-Match adrs

	DB	CR	! DW	VC_CR	;carriage return routine
	DB	LF	! DW	VC_LF	;line feed
	DB	BKS	! DW	VC_BKS	;back space
	DB	MCRIGH	! DW	VC_MCRT	;move cursor right
	DB	MCUP	! DW	VC_MCUP	;move cursor up
	DB	CBELL	! DW	VC_BEL	;Ring bell
	DB	VCLRS	! DW	VC_CLRS	;clear screen
	DB	VHOME	! DW	VC_HOME	;Cursor Home

	DW	VOUT97		;No match--ignore undef control char

VALCTS:	= ((*-2)-VALIDC)/3	;Number of valid entries
	PAGE

COUT:
;General output routine to Video Screen

;ENTRY
;C	=	Character
	;CURS	=	Cursor
	;ESCH	=	Flag+Mode

;CURS & ESCH updated, A=Character
;(bc, de, hl preserved)

;	ESCH is flag + mode byte as follows
;	=00	Normal mode & Last chr Esc flag false
;	=08	Normal mode & Last chr Esc flag True
;	=01,02,04 Mode is Graphics, Half, or Under, respectively and Last chr Esc flag is False.
;	=3,5,6,7	As above, but mode is combination
;	=9-15		Last chr Esc flag True;otherwise like 1-7.

	PROC

;RESET VETICAL OFFSET WITH VRTOFF

	PUSH	AF
	PUSH	BC
	LD	A,PIABD		;PRESENT VALUE
	AND	11100000B	;HOUSEKEEPING
	MOV	B,A
	LD	A,VRTOFF	;LAST VERTICAL OFFSET
	AND	00011111B	;ONLY VIDIO
	ORA	B		;ADD HOUSEKEEPING
	MOV	C,A
	CALL	OPBD		;SET OFFSET
	POP	BC
	POP	AF

	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	HL,CURS		;HL will usually be cursor/
	LD	A,ESCH
	MOV	B,A		;B will be ESCH for a while
	AND	EF_ESC		;test flag bit
	JRNZ	PSTESC		;IF last chr was ESC

;Current chr is NOT ESCaped. Is this chr ESC?

	MOV	A,C		;Chr
	CMP	ESC
	MOV	A,B		;(A=ESCH)
	JRZ	:ESC		;if this chr = ESC
	PAGE

;Here with A=B	=	ESCH

:out:	PUSH	HL
	LDK	HL,ESCHTB
	AND	EF_MSK		;Mode bits only
	ADD	A,A		;Times two
	MOV	E,A
	LDK	D,0		;DE = offset
	ADD	HL,DE		;HL = tbl addrs

VECTOR:				;entry point. note hl on stack.
	LD	A,[HL]		;1st byte (low order adrs)
	INC	HL
	LD	H,[HL]		;2nd byte (hi order adrs)
	MOV	L,A		;HL=adrs from table
	XTHL			;Restore hl from stack stack=tbl adrs
	MOV	A,C		;Chr. note B=ESCH byte value
	RET			;enter routine per table adrs.
	PAGE

COUT2:
	MOV	A,B		;recall ESCH value
	JR	:out		;output chr per current settings

:ESC:
;Current chr is ESC. Set flag and exit

	OR	EF_ESC		;indicate last char= ESC
	STO	A,ESCH
	JMP	VOUT97		;Exit
	PAGE

PSTESC:
;Last chr was ESC
;Entry
;A	=	EF_ESC
;B	=	ESCH
;C	=	Char to output
;HL	=	curs

	PROC

	BIT	4,B		;is this chr really an address?
	JRNZ	SETXY		;...if chr is part of an addr

;no cursor/screen addressing in effect:

	XOR	B		;Clr EF_ESC bit (for next time)
	MOV	B,A		;Set up B = ESCH byte value.
	STO	A,ESCH
	PUSH	HL		;save Curs
	LDK	HL,VALIDE	;Branch table adrs
	LDK	E,VALETS	;Table size
	MOV	A,C		;Chr to A
	JR	LOOKUPB		;Go to routine to branch per tbl
	PAGE

VNORM:
;NORMAL mode character processing.
;ENTRY
;A	=	char to output
;HL	=	curs

	CMP	' '
	JRC	:2		;IF control chr

VBRIGH:	DI
	ENADIM		;9th bit memory
	STO	BRTBIT,[hl]	;set this chr BRIGHT
	DISDIM
	EI

	JMP	VOUT80

:2:	PUSH	HL		;Save Curs
	LDK	HL,VALIDC	;Branch table adrs
	LDK	E,VALCTS	;Table size

;	JMP	LOOKUPB		;Scan table of valid control chrs and branch to appropriate routine.
	PAGE

LOOKUPB:
;Logic to scan 3 byte branch table
;	NOT a subroutine---do not CALL.
;ENTRY
;HL	=	1st byte of table (match code)
	;(2nd,3rd bytes = branch adrs)
	;(table repeats [3 byte entries])
;E	=	is table size (no. of entries)
	;(table body is followed with
	;2 byte "No-Match" adrs)
	;Stack has HL saved as top entry.
;C	=	char
;A	=	value to scan for possible match

	CMP	[HL]
	INC	HL	;(2nd byte of this 3 byte entry)
	JRZ	VECTOR	;If match process

	INC	HL	;(3rd byte of this entry)
	INC	HL	;1st byte of next entry
	DEC	E	;Dec count of entries remaining
	JRNZ	LOOKUPB	;Continue thru body of table

	JR	VECTOR	;No-Match. hl=points to vector
	PAGE

;PROCessing for modes other than normal.

;VGRAPH				;Normal mode EXCEPT: cntl chrs are printed

VUNDER:
;Underline only
	CMP	' '
	JRC	VNORM		;if cntl-chr, process as normal
;	JR	VUN_GR		;continue


VUN_GR:
;Underlined Graphics
	OR	80h		»underline bit
	JR	VBRIGH		;set this chr BRIGHT


VUN_HA:
;Underline and Half intensity
	CMP	' '
	JRC	VNORM		;if cntl-chr, process as normal
;	JR	VUN_HA_GR


VUN_HA_GR:
;Underline, Half Intensity, Graphics
	OR	80h		;set underline bit
;	JR	VHA_GR


VHALF:
;Half Intensity
	CMP	' '
	JRC	VNORM		;if cntl-chr, process as normal
;	JR	VHA_GR


VÈA_GR:
;C=Chr, HL=Curs
	DI
	ENADIM
	STO	DIMBIT,[hl]	;set dim field bit
	DISDIM
	EI
	JMP	VOUT80		;continue
	PAGE

SCREEN:
;SetXY for Screen movement
;ENTRY
;B	=	ESCH
;A	=	new co-ord val, NO OFFSET

	PROC

	BIT	6,B
	JRNZ	:sX		;if X-coordinate

:sY:	AND	0001_1111b	;mod 32
	MOV	C,A
	STO	A,VRTOFF	;SET VERTICAL OFFSET FOR COUT
	LD	A,PIABD
	AND	1110_0000b
	OR	C
	MOV	C,A
	CALL	OPBD		;set Y coordinate
	JR	:exitY

:sX:	ADD	A,A		;double A
	ADD	A,VFLO		;PIA A-reg magic offset constant
	AND	1111_1110b	;clear bit 0
	MOV	C,A

;SET DENSITY BIT

	LD	A,PIAAD		;GET OLD VALUE
	ANI	0000_0001B	;SAVE DENSITY BIT
	ORA	C		;OR IN HORIZONTAL OFFSET
	MOV	C,A
	CALL	OPAD		;FUNCTION PIA
	CBIT	5,B		;finished screen-addressing
	JR	:exitX
	PAGE

SETXY:
;Set X-Y value for Cursor/Screen Addressing
;ENTRY
;HL	=	cursor_addr
;B	=	ESCH
;C	=	chr

;EXIT
;to VOUT90; ESCH updated

	CALL	UN_CUR
	LDK	A,-(' ')
	ADD	C		;remove cursor bias
	BIT	5,B		;cursor/screen addressing?
	JRNZ	SCREEN		;if screen addressing

;cursor addressing:

	ADD	HL,HL		;shift HL left
	BIT	6,B		;X/Y coordinate?
	JRNZ	:cX		;if X coordinate

:cY:	MOV	H,A		;save
	LD	A,PIABD
	ADD	H		;offset by start-Y co-ord of video
	RAR			;bit0(A) -> CY, shift A right
	RR	L		;CY -> bit7(L)
	OR	0F0h		;turn on upper nybl
	MOV	H,A		;HL= new cursor addr

:exitY:	LDK	A,0100_0000b	;next addr-chr will be X-coord
	OR	B
	JR	:exit2

:cX:	RAL			;trash 7th bit
	SRA	H		;bit0(H) -> CY, bit7 stays 1
	RAR			;... CY -> bit7(A)
	MOV	L,A

:exitX:	LDK	A,EF_MSK
	AND	B		;finished addressing: reset addr bits

:exit2:	STO	A,ESCH
	JMP	VOUT90
	PAGE

;	Control Code character processing

VC_HOME:			;Home Cursor

	PROC

	CALL	UN_CUR
	LD	A,PIABD
	RAR			;bit0 => CY
	LDK	L,0
	RR	L		;CY => bit7, trash bit0
	MOV	H,A
	JR	:fixhl		;HL := HL or F000h
	PAGE

VC_MCUP:			;Move Cursor Up.
;A=C=Chr=MCUP. HL=Curs.

	CALL	UN_CUR
	PUSH	HL		;old cursor must be on stack
	LDK	BC,(-VLL)
	JR	:fwa		;...at this entry point


VC_BKS:
;HL=Curs=current (old) char

	CALL	UN_CUR		;clear 80h bit
	LDK	A,7Fh
	AND	L
	JRZ	:wrap		;if must wrap from col 0 to LLIMIT

	DEC	HL
	JMP	VOUT90		;Exit

:wrap:	PUSH	HL		;save old cursor
	LDK	BC,-(VLL+1)
	ADD	HL,BC		;HL = prev_line, (-1)st column
	LD	A,LLIMIT	;LLIMIT = #columns on screen
	MOV	C,A
	LDK	B,0

:fwa:	ADD	HL,BC
	XTHL			;get old cursor, save new
	ADD	HL,HL		;shift line# into H reg.
	LD	A,PIABD
	OR	1110_0000b	;A = line# of UL corner
	CMP	H		;set Zflag: @home?
	POP	HL		;get new cursor...
	JRNZ	:fixhl		;if NOT @video home

	LDK	BC,(24*VLL)	;wrap constant
	ADD	HL,BC

:fixhl:	LDK	A,0F0h
	OR	H		;modulo result: keep cursor
	MOV	H,A		;inside video memory.
	JR	VOUT90
	PAGE

VC_BEL:
;Ring the bell via setting PIAB 2**5 bit

	LD	A,PIABD
	OR	0010_0000b	;bell bit
	MOV	C,A
	CALL	OPBD		;function PIAB
	LDK	A,30		;ring bell for 30 ticks
	STO	A,BELCNT	;... = 1/2 second
	JR	VOUT97		;exit no change
	PAGE

VC_CLRS:

	LDK	HL,FWAVM
	CALL	CLRLN		;clear 1st line
	LDK	BC,LVMEM-VLL
	PUSH	DE
	POP	IX
	CALL	VLDIR		;clear remaining lines
	LD	A,PIABD		;Reset for 1st line of display mem
	AND	not(1_1111b)
	MOV	C,A
	CALL	OPBD
	XRA	A		;ZERO A
	STO	A,VRTOFF	;SET VERTICAL OFFSET FOR COUT
	LDK	HL,FWAVM	;new cursor
	JR	VOUT90		;Exit
	PAGE

VC_CR:
	CALL	UN_CUR		;erase cursor
	LDK	A,80h		;Carriage Return
	AND	L
	MOV	L,A
	JR	VOUT90

VC_LF:
	CALL	DO_LF		;Line Feed
	JR	VOUT90
	PAGE

VC_MCRT
;Move Cursor Right

	CALL	UN_CUR
	LD	A,[hl]
	JR	VOUT80		;re-echo current chr
	PAGE

VGRAPH:
	BIT	5,A
	JRZ	VOUT80
	BIT	6,A
	JRZ	VOUT80
	ANI	9FH

VOUT80:
;Exit points for COUT
;Here to store new data and to update cursor

	STO	A,[hl]		;This exit path stores A (new char)
	MOV	E,L
	CBIT	7,E		;E = col(cursor)
	LD	A,LLIMIT
	DEC	A		;A = last_legal_col
	SUB	E		;A = last_legal_col - col(cur)
	JRNZ	VOUT85		;if not @LLIMIT

	LDK	A,80h
	AND	L
	MOV	L,A		;do CR...
	CALL	DO_LF2		;...and LF.
	JR	VOUT90

VOUT85:	INC	HL		;move cursor

;Here if NO cursor update

VOUT90:	LD	A,[HL]		;This exit path turns on 80h bit

;Here if new data already in A

	RAL			;Make this chr cursor

VOUT96:	CMC			;invert cursor bit
	RAR
	STO	A,[hl]
	STO	HL,CURS		;update cursor

;Here if no change to cursor, restore reg and exit

VOUT97:	POP	BC
	POP	DE
	POP	HL
	MOV	A,C		;Exit with A=chr
	RET			;return, end of cout subr.

:First	= VOUT97 - (127 + 2)	;earliest possible JR

:Last	= VOUT80 + (128 - 2)	;latest possible JR
	PAGE

ESC_LCK:			;Lock Keyboard

	PROC

	XOR	A
	JR	:2

ESC_ULK	LDK	A,0FFh		;Unlock Keyboard

:2:	STO	A,KEYLCK
	JR	VOUT97
	PAGE

EEOL:
;Erase to end of line

	PUSH	HL		;save cursor
	CALL	CLRLN
	POP	HL

	JR	VOUT90
	PAGE

ESC_CAD:
;Cursor Addressing

	LDK	A,EF_MSK
	AND	B
	OR	EF_ESC or EF_ADR	;next chr will be Y-coord

:exit3:	STO	A,ESCH
	JR	VOUT97

ESC_SAD:
;Screen Addressing

	LDK	A,EF_MSK
	AND	B
	OR	EF_ESC or EF_ADR or EF_SCR
	JR	:exit3
	PAGE

EDELC:
;Delete Character

	PUSH	HL		;save cursor_addr

	CALL	CALC		;calculate BC
	PUSH	HL
	POP	IX
	INC	HL		;HL = cursor_addr + 1
	CALL	VLDIR		;move characters
	STO	' ',[hl]	;last chr becomes blank

	DI
	ENADIM		;enable 9th bit memory
	DEC	HL		;HL = last chr on this line
	STO	BRTBIT,[hl]		;set chr BRIGHT
	DISDIM
	EI			;main memory

	POP	HL		;restore cursor_addr
	JR	VOUT90		;next
	PAGE

EINSRT:
;Insert Character

	CALL	UN_CUR
	PUSH	HL		;save cursor_addr
	CALL	CALC		;calculate BC
	LDK	A,7Fh
	OR	L
	MOV	L,A		;HL = last_chr on this line
	PUSH	HL
	POP	IX
	DEC	HL
	CALL	VLDDR		;do move
	POP	HL		;restore cursor
	LD	A,[hl]		;get underline bit of this chr.
	RAL			;into CY
	LDK	A,' ' shl 1	;change this chr to ' '
	JR	VOUT96		;exit
	PAGE

CALC:
;Subroutine for use with EDELC and EINSRT:
;Calculate #chrs to move; if move zero chrs, never return.

	LDK	A,VLL-1		;A= max #chrs to be moved
	MOV	C,L
	CBIT	7,C		;C = col(cursor)
	SUB	C		;A = #chrs to move
	JRZ	:end		;if move zero characters

	MOV	C,A
	LDK	B,0		;BC = #chrs to move
	RET

:end:	POP	HL		;trash return_addr
	POP	HL		;cursor_addr
	JR	VOUT90
	PAGE

ESCSGR:
;ESC-Sequence processing.

	PROC

	LDK	A,EF_GR		;ESC-g
	JR	:125		;set graphics mode.

ESCSHA:	LDK	A,EF_HA		;ESC-) set half intensity
	JR	:125		;go set flag bit

ESCSUN:	LDK	A,EF_UN		;ESC-l set underline

:125:	OR	B		;Reg B is ESCH Byte value

:130:	STO	A,ESCH		;store desired value.
	JR	VOUT97		;Exit

ESCCGR:	LDK	A,NOT EF_GR	;ESC-G Clear graphics mode
	JR	:140		;go clear ESCH bit

ESCCHA:	LDK	A,NOT EF_HA	;ESC-( Clear half intensity
	JR	:140

ESCCUN:	LDK	A,NOT EF_UN	;ESC-m Clear underline

:140:	AND	B		;Clear bit
	JR	:130		;Go store ESCH byte

ESCZZ:	=	VC_CLRS		;ESC-Z Clear screen -same as
				;Control-Z routine.
	PAGE

ESCRR:
;Delete Line

ESCEE:
;Insert Line
;ENTRY
;HL	=	cursor
;C	=	chr

;EXIT
;screen updated
;HL	=	new cursor ...to VOUT90

	PROC

	CALL	UN_CUR
	LDK	A,1000_0000b
	AND	L
	MOV	L,A		;do CR
	PUSH	HL		;save new cursor
	ADD	HL,HL
	LD	A,PIABD
	ADD	A,24		;A = addr(25th line)
	SUB	H		;A = lines_to_move + 1
	AND	0001_1111b	;mod 32
	MOV	B,A
	LDK	A,VDELL
	CMP	C
	MOV	A,B		;recall #lines to move
	JRZ	:delt		;if deleting a line

;Insert a line

:insrt:	ADD	H		;A = addr(25th line)
	MOV	D,A
	LDK	E,0
	RR D
	RR E			;shift right DE
	DEC	DE		;DE = addr(lst_chr_on_lst_line)
	MOV	A,B		;A = #lines to move
	LDK	HL,-VLL
	ADD	HL,DE		;HL = addr(line above DE)
				;DE := DE or F000h; HL := HL or F000h
	JR	:istrt

:icont:	PUSH	DE
	POP	IX
	CALL	VLDDR		;move 1 line down

:istrt:	CALL	:vmod
	JRNZ	:icont		;if must move more lines

	INC	HL		;HL => 1st chr of new line
	PAGE

:exit:
	CALL	CLRLN
	POP	HL		;recover cursor
	JMP	VOUT90		;Main Exit

:delt:	POP	DE		;recover new cursor
	PUSH	DE
	LDK	HL,VLL
	ADD	HL,DE		;HL = line_below_cursor
	JR	:dstrt

:dcont:	PUSH	DE
	POP	IX
	CALL	VLDIR		;move 1 line up

:dstrt:	CALL	:vmod
	JRNZ	:dcont

	EX	HL,DE		;get addr of line to clear
	JR	:exit
	PAGE

:vmod:
;HL = HL or F000h; DE = DE or F000h
;simple mod-4096 arithmetic to keep pointers INSIDE video memory

	PUSH	AF		;save A = #lines to move
	LDK	A,0F0h
	OR	H
	MOV	H,A		;set upper nybl of H
	LDK	A,0F0h
	OR	D
	MOV	D,A		;modulo 4096
	LDK	BC,VLL
	POP	AF
	DEC	A		;decrement line_count
	RET
	PAGE

CLRLN:
;Clear to end of line
;ENTRY
;HL	=	Cursor

;EXIT
;clear to EOL
;	Uses	All.

	PROC

	STO	' ',[hl]	;clear cursor...
	DI
	ENADIM
	STO	BRTBIT,[hl]	;set cursor BRIGHT
	DISDIM
	EI
	LD	A,LLIMIT
	DEC	A		;max_#cols => maximum_col_#
	MOV	E,L
	CBIT	7,E
	SUB	E		;A = col(EOL) - col(cursor)
	RZ			;if @EOL, done

	JRNC	:2		;if inside logical_video_line

	LDK	A,VLL
	SUB	E		;...else clr to end of 128-chr line
	RZ			;if cursor @ column #127

:2:	MOV	C,A
	LDK	B,0		;BC = chrs to move
	PUSH	HL
	POP	IX
	INC	IX
	JR	VLDIR
	PAGE

DO_LF:
;Do Line Feed processing
;ENTRY
;HL	=	cursor_addr

;EXIT
;Cursor cleared
;HL updated for current cursor pos
;window moved if necessary

	PROC

	CALL	UN_CUR		;clear cursor

DO_LF2:	PUSH	HL		;save original cursor
	LDK	BC,VLL		;line length
	ADD	HL,BC
	JRNC	:nowap		;if not wrapping from LWAVM to FWAVM

	LDK	BC,FWAVM
	ADD	HL,BC		;HL = new cursor @ top of VM

:nowap:	XTHL			;save new cursor, get old
	ADD	HL,HL		;shift HL left
	LD	A,PIABD
	ADD	A,23		;start + 23 = last_video_line
	SUB	H		;A = l_line - curr_line
	AND	0001_1111b	;modulo 32
	JRZ	:vmov		;if cursor is on 24th line of screen

:end:	POP	HL		;get new cursor
	RET

:vmov:	LD	A,LLIMIT
	SRL	L		;unshift L register
	SUB	L		;A = LLIMIT - col(cursor)
	JRC	:end		;if cursor is outside logical line

;cursor is on last line of screen, inside of logical line.
;must move screen to follow cursor down through video memory.

	POP	HL
	PUSH	HL
	LDK	A,80h
	AND	L
	MOV	L,A		;HL = beginning of line
	CALL	CLRLN		;erase to EOL
	LD	A,PIABD
	MOV	B,A
	AND	not 31		;A = line zero
	MOV	C,A		;C = housekeeping bits 5..7
	LDK	A,31
	INC	B		;increment line#
	AND	B		;A = line#
	STO	A,VRTOFF	;SET VERTICAL OFFSET FOR COUT
	OR	C		;A = new line# OR housekeeping_bits
	MOV	C,A		;C = new value for OPBD
	CALL	OPBD		;move video screen down 1 line in memory
	POP	HL
	RET
	PAGE

STODIM:
;STORE THE CONTENTS OF THE B REG IN THE ADDR POINTED TO BY THE HL PAIR
;ENTRY
;B	=	VALUE
;HL	=	ADDRESS

;EXIT
;NONE

	PROC

	DI
	ENADIM			;ENABLE DIM
	STO	B,[HL]		;STORE
	DISDIM			;DISABLE DIM
	EI
	RET
	PAGE

VLDDR:
;Video Block Move
;ENTRY
;BC, IX, HL set

;EXIT
;LDDR on main & 9th bit memory
;	Uses	BC, DE, HL,IX

	PUSH	IX
	POP	DE

	PUSH	BC
	PUSH	DE
	PUSH	HL

	LDDR			;main memory

	POP	HL
	POP	DE
	POP	BC

	DI
	ENADIM
	LDDR			;9th bit memory
	DISDIM
	EI
	RET
	PAGE

VLDIR:
;Video Block Move
;ENTRY
;BC, IX, HL set

;EXIT
;LDIR on main & 9th bit memory
;	Uses	BC, DE, HL,IX

	PUSH	IX
	POP	DE

	PUSH	BC
	PUSH	DE
	PUSH	HL

	LDIR			;main memory

	POP	HL
	POP	DE
	POP	BC

	DI
	ENADIM
	LDIR			;9th bit memory
	DISDIM
	EI
	RET
	PAGE

UN_CUR:
;Undo/Invert Cursor
;ENTRY
;HL	=	cursor_addr

;EXIT
;cursor inverted
;	Uses	A, CY.

	LD	A,[hl]		;get the chr
	RAL			;cursor_bit => CY
	CMC			;invert it
	RAR
	STO	A,[hl]		;...
	RET
	TITLE	'KEYBOARD SCANNING & DECODE'
*[ ]

GKEY:
;KEYBOARD INTERRUPT PROCESSOR
;ENTRY
;NONE

;EXIT
;KEYBOARD PROCESSING DONE, RESULT IN LDKEY.

	PROC

	DI
	STO	SP,IESTK	;SAVE INTERRUPTED PROCESS STK
	LDK	SP,ISTK		;SET TO RAM INT STK

	PUSH	AF		;SAVE ALL REGESTERS
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY

;Routine checks to see if the disk drive motor should be turned off by updating DACTIVE...Routine ALSO
;checks to see if bell is currently ringing: if so, decrement counter. If counter turns zero,
;shut off bell.

	;CHECK BELL

	LDK	HL,BELCNT
	XOR	A
	OR	[hl]		;check BELCNT
	JRZ	:0		;if BELCNT = 0

	DEC	[hl]		;...bell is on. decrement counter
	JRNZ	:1		;if bell should stay on awhile yet

:0:	LD	A,PIABD		;
	BIT	5,A		;check bell bit
	JRZ	:1		;if bell bit off

	;TURN BELL OFF

	AND	1101_1111b	;clear bell bit
	MOV	C,A
	CALL	OPBD

:1:	DEC	HL		;HL = HL - 1 DACTVE
	LD	A,[hl]
	OR	A
	JRZ	:2		;RETURN if inactive

	;TURN DRIVE OFF IF DACTVE = 1

	DEC	[hl]		;reset delay
	CZ	DDRV		;if deselect drive

;UPDATE COUNTER

:2:	LD	HL,SEQ		;GET LOW TWO BYTES
	INC	HL		;+1
	STO	HL,SEQ		;STORE

;READ KEYBOARD

	LD	A,KEYLCK
	OR	A
	CNZ	KBDRVR		;READ KEYBOARD IF KEYLOCK NOT ACTIVE

;Exit interrupt code via exiting to RAM and then enable or disable ROM code depending on the value
	;contained in ROMRAM cell.

	LD	A,H.VIO		;clear interrupt

	LD	A,ROMRAM	;IS ROM IN OR OUT?
	OR	A
	JNZ	ROMJP1		;if return to RAM

	POP	IY		;RESTORE REGESTERS
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	POP	AF

	LD	SP,IESTK	;get users stack back
	EI
	RET
	PAGE

;	This file contains the 2-key roll over keyboard driver for
;	the OSBORNE 1 comuter.

;	Author:
;	Microcode Corporation.
;	Fremont, CA.
;	Y. N. Sahae
;	September 1981

;	Revisions:

;	2-Key roll over keyboard driver.

;	DESCRIPTION:
;	The keyboard driver gets control via the 60hz interrupt, i.e. once
;	every 16 ms. It scans the keyboard to detect any struck keys. If a
;	key is found, it is entered into the keylist if there is space
;	in the keylist and the key is not already in the list.  At the end of
;	the scan, the keys in the list are proecessed. If the key is still
;	on, it is placed in lkey (or special action taken) after translating
;	the keynumber. A count is also stored in the list and the key will
;	be serviced again at the end of this count if it is still on. Thus
;	the key will repeat if it is held down. If a key which is in the
;	list is not on it is removed from the list.

;	The keyboard driver consists of the following routines:

;	KBDRVR - Examines the keylist, calls CHKEY to determine if key
;	is still on. Removes the key from the list if it is not on. If
;	key is on, it decrements the count associated with the key. when
;	the count goes to zero, it calls KBSERV to service the key. Calls
;	KBSCAN to enter any new keys into the list.

;	KBSCAN - This routine scans the keyboard, detects a struck
;	key and enters it into the keylist. The key is entered
;	into the keylist if the key is not already present in the keylist
;	and there is an empty slot in the keylist.

;	KBSERV - It calls the routine CHKEY to check if shift/ctl or alphlock
;	keys are on. It then translates the keynumber into the ASCII
;	code and places it in the LKEY for the CBIOS to read. For some
;	special cases, it calls	ROM resident routines to process the key.

;	CHKEY - It checks if a given key is on.


;	Data structure:
;	The main structure used is the keylist. The format of each entry is:

;	Byte 0:
;		bit 7 : Set indicates entry is in use.
;		bit 6 : Set indicates key has been serviced once.
;		bits 5..3 : contain the row number of struck key.
;		bits 2..0 : contain the column number of struck key.
;	Byte 1:
;		bits 7..0 : contain the repeat count for the key.
	PAGE

KBDRVR:
;DETECTS AND PROCESSES KEYSTROKES.
;ENTRY
;NONE

;EXIT
	;LKEY	=	KEYSTROKE

	PROC

	CALL	KBSCAN		;SCAN KEYBOARD AND ENTER KEYS INTO KEYLIST

;EXAMINE KEYLIST. IF KEY FOUND IN KEYLIST, CALL CHKEY TO SEE IF KEY IS STILL ON. REMOVE FROM LIST WHEN NOT ON.

	LDK	HL,KEYLST	;POINT TO FIRST ENTRY OF KEYLIST
	LDK	B,KL_LEN

:1:	LD	A,LKEY
	OR	A
	RNZ			;RETURN WHEN A KEY IS WAITING IN LKEY

	LD	A,[HL]		;GET BYTE 0 OF ENTRY
	BIT	KL_USED,A
	JRZ	:5		;IF ENTRY IS IN USE THEN

	CALL	CHKEY		;CHECK IF STILL ON
	JRNZ	:2		;IF KEY IS NOW OFF THEN

	STO	0,[HL]		;REMOVE KEY FROM LIST
	JR	:5

;KEY IS ON. DECREMENT ITS REPEAT COUNT. IF COUNT GOES TO ZERO THEN IT IS TIME TO SERVICE THE KEY.

:2:	PUSH	HL		;SAVE PTR TO FIRST BYTE OF ENTRY
	INC	HL		;POINT TO REPEAT COUNT
	DEC	[HL]
	JRNZ	:4		;EXIT WHEN NOT TIME TO SERVICE THE KEY.

;IT IS TIME TO SERVICE THE KEY. SET THE NEXT REPEAT COUNT

	EX	[SP],HL		;POINT BACK TO THE FIRST BYTE OF ENTRY
	LD	A,[HL]
	BIT	KY_SRVD,A	;CHECK IF IT IS SERVICED BEFORE
	SBIT	KY_SRVD,[HL]	;SET THE SERVICED ONCE FLAG
	EX	[SP],HL		;POINT BACK TO THE REPEAT COUNT
	STO	IRPTCT,[HL]	;AND STORE RPT COUNT AS PER SERVICED FLAG
	JRZ	:3

	STO	SRPTCT,[HL]

:3:	AND	KROW_M+KCOL_M
	CALL	KBSERV		;CALL TO SERVICE THE KEY

:4:	POP	HL		;GET PTR TO FIRST BYTE OF ENTRY AGAIN

:5:
	ECHO	KLE_LEN
	INC	HL		;POINT TO NEXT ENTRY
	ENDM
	DJNZ	:1		;UNTIL	COMPLETE LIST SCANNED

	RET			;RETURN
	PAGE

KBSCAN:
;SCAN KEYBOARD AND ENTER DETECTED KEYS IN THE KEYLIST.
;ENTRY
;NONE

;EXIT
	;KEYLST	=	CONTAINS ANY KEYS DETECTED.

	PROC

	LDK	L,0FFH		;SEE IF ANY KEY PRESSED
	CALL	RDROW
	RZ			;RETURN WHEN NONE

	LDK	L,ROW0_M	;GET ROW 0
	CALL	RDROW

	AND	11100011B	;REMOVE CTL/SHIFT AND ALPHA LOCK
	LDK	B,TOT_ROW

;IN THIS LOOP, REG B CONTAINS TOTROW CURRENT ROW BEING SCANNED

:1:	JRZ	:8		;IF ANY KEY IS PRESSED THEN

	PUSH	BC		;SAVE LOOP COUNT
	MOV	E,A		;E = COLUMNS
	LDK	A,TOT_ROW
	SUB	B
	RAL
	RAL
	RAL
	MOV	D,A		;D = ROW NUMBER * 8
	LDK	C,0		;INITIALIZE COLUMN COUNTER

;SCAN THIS ROW FROM RIGHT TO LEFT TO GET THE COLUMN NUMBER

:2:	SRL	E		;SHIFT COLUMN BIT INTO CARRY
	JRNC	:7		;IF A KEY IS FOUND THEN

;ENTER THE KEY WHOSE COLUMN NUMBER IS IN C AND ROW*8 IS IN D INTO THE KEYLST PROVIDED THE KEY IS NOT
;ALREADY IN LIST AND THERE IS AN EMPTY SLOT IN THE LIST.

	MOV	A,D
	ADD	A,C
	PUSH	BC
	MOV	C,A		;C = KEY NUMBER
	PUSH	DE		;SAVE DE
	PUSH	HL		;SAVE HL
	LDK	B,KL_LEN	;LENGTH OF KEYLIST
	LDK	HL,KEYLST
	LDK	DE,0

:3:	LD	A,[HL]
	BIT	KL_USED,A
	JRZ	:4		;IF ENTRY IS USED THEN

	AND	KROW_M+KCOL_M
	CMP	C		;CHECK WITH CURRENT KEY
	JRZ	:6		;EXIT IF THIS KEY IS IN LIST

	JR	:5

:4:	MOV	E,L		;ELSE (AN EMPTY ENTRY IS FOUND)
	MOV	D,H		;SAVE ADRS OF EMPTY ENTRY IN DE

:5:
	ECHO	KLE_LEN
	INC	HL
	ENDM			;NEXT ENTRY

	DJNZ	:3		;TILL LIST SCANNED

;CHECK IF AN EMPTY ENTRY WAS FOUND.

	MOV	A,D
	OR	A
	JRZ	:6		;IF EMPTY ENTRY WAS FOUND THEN

	EX	DE,HL		;HL = EMPTY ENTRY
	STO	C,[HL]		;STORE THE KEY IN THE LIST
	SBIT	KL_USED,[HL]	;SET USED FLAG
	INC	HL
	STO	DB_CT,[HL]	;STORE DEBOUNCE DELAY

:6:	POP	HL		;RESTORE ALL REGSTERS
	POP	DE
	POP	BC

:7:	INC	C		;INCREMENT COLUMN NUMBER
	XOR	A
	CMP	E
	JRNZ	:2		;UNTIL ALL COLUMNS SCANNED

	POP	BC		;RSTORE BC

:8:	SLA	L		;MOVE TO NEXT ROW
	CALL	RDROW
	DJNZ	:1

	RET
	PAGE

CHKEY:
;CHECKS IF KEY NUMBER IS ON.
;ENTRY
;A	=	KEYNUMBER
;EXIT
;Z CLR	=	KEY IS OFF.
;Z SET	=	KEY IS ON.

	PROC

	PUSH	HL		;SAVE CALLERS HL
	PUSH	AF		;SAVE KEYNUMBER
	RAR
	RAR
	RAR			;RIGHT JUSTIFY ROW NUMBER
	CALL	GTMASK
	POP	AF		;GET KEY NUMBER

	PUSH	DE		;SAVE ROW MASK
	CALL	GTMASK		;GET COL MASK (COL NUM IS IN BITS 0..2)
	POP	HL		;MOVE ROW MASK TO L

	CALL	RDROW		;GET ROW OF KEYS ADRSED BY L
	AND	E		;Z IND	=	VALUE OF KEY
	POP	HL

	RET
	PAGE

GTMASK:
;GENERATES MASK WITH ONE BIT SET.
;ENTRY
;A	=	BIT NUMBER (0..7)

;EXIT
;E	=	MASK

	PROC

	LDK	E,1
	AND	7

:1:	RZ
	SLA	E
	DEC	A
	JR	:1
	PAGE

RDROW:
;READS A ROW OF KEYS
;ENTRY
;L	=	LOWER 8 BITS OF ADRS TO READ THE ROW

;EXIT
;A	=	ROW VALUE

	PROC

	LDK	H,HIGH(H.KEY)		;HL = PRT ADRS FOR GIVEN ROW
	MOV	A,L
	MOV	R,A
	LD	A,[HL]
	XOR	0FFH			;INVERT VALUES
	RET
	PAGE

LFT_ARW	=	8DH
RT_ARW	=	8BH
UP_ARW	=	8AH
DN_ARW	=	8CH
HM_SCRN	=	'['


KBSERV:
;SERVICES THE KEY
;ENTRY
;A	=	KEYNUMBER
;[SP]-4	=	POINTER TO KEYLST ENTRY (USED FOR SLIDE FNC ONLY)

;EXIT
;NONE

;PRESERVES REG B

	PROC

;SETUP HL TO POINT TO KEYCODE TABLE ENTRY FOR THIS KEY

	MOV	E,A
	LDK	D,0		;USED HERE AND LATER
	LDK	HL,KYCDTB
	ADD	HL,DE
	LD	A,[HL]
	CMP	' '+1
	JRC	KEYE		;IGNORE SHIFT/CTL ETC FOR CHARS LESS THAN 21H

	PUSH	AF

	LDK	L,1		;ROW 0 ADRS
	CALL	RDROW		;GET ROW CONTAINING CTL,SHIFT AND ALPHA KEY

	PUSH	AF

	LDK	L,80H
	CALL	RDROW
	ANI	8
	MOV	E,A
	POP	AF

	OR	E
	MOV	E,A
	POP	AF		;RESTORE KEYCODE

	BIT	CTL_KY,E
	JRNZ	KEY4		;GO PROCESS CTL KEY

	BIT	SHFT_KY,E
	JRNZ	KEY2		;GO PROCESS SHIFT KEY

	BIT	ALPH_KY,E
	JRNZ	KEY1		;GO PROCESS ALPHA KEY

;FALL THROUGH TO "KEYE"
	PAGE

KEYE:
;STORE KEY CODE INTO "LKEY" AND RETURN

	STO	A,LKEY
	RET
	PAGE

KEY1:
	CMP	'a'		;PROCESS ALPHA KEY
	JRC	KEYE		;EXIT WHEN LESS THAN 'a'. ALPHA HAS NO EFFECT

:27:	CMP	80H
	JRNC	KEYE		;OR WHEN >= 80H

:28:	XOR	20H		;FOLD CHAR TO UPPER CASE
	JR	KEYE
	PAGE

KEY2:
	CMP	'a'		;PROCESS SHIFT KEY
	JRNC	:27		;GOTO ALPHA WHEN CHAR > 'a'

	CMP	'['
	JRC	KEY3		;GOTO PROCESS SHIFT NUMERICS ETC

	JRNZ	:28		;INVERT SHIFT BIT FOR '\'

	LDK	A,']'
	JR	KEYE		;CONVERT [ TO ]
	PAGE

KEY3:
;CHARS ' TO > (ASCII CODES 27H TO 3EH) ARE CONVERTED USING
;THE SHFT_TB. D=0 FROM BEFORE

	MOV	E,A
	LDK	HL,SHFT_TB - ''''
	ADD	HL,DE

KEY3A:	LD	A,[HL]
	JR	KEYE
	PAGE

KEY4:
;PROCESS CONTROL KEY
;IF CHAR IS BETWEEN A..Z THEN TURN OFF THE 3 HIGH ORDER
;BITS.
;IF CHAR IS BETWEEN ','..'?' IT IS TRANSLATED AS PER TABLE CTL_TB'
;IF CHAR IS THE ARROW KEYS OR THE ']'/'[' KEY THE SLIDE FUNCTIONS
;ARE CALLED.

	CMP	LFT_ARW
	JRZ	SLIDEL

	CMP	RT_ARW
	JRZ	SLIDER

	CMP	UP_ARW
	JRZ	SLIDEU

	CMP	DN_ARW
	JRZ	SLIDED

	CMP	HM_SCRN
	JRZ	DOHOME

	BIT	SHFT_KY,E	;TEST FOR CNTL SHIFT
	JRZ	KEY5		;IF NOT

	CMP	'/'		;IS IT ?
	JRNZ	KEY5		;IF NOT '?'

	LDK	A,07FH		;DELEAT KEY
	JR	KEYE
	PAGE

KEY5:
	CMP	'@'
	JRC	KEY6		;GOTO TRANSLATE CHARS FROM TABLE

	CMP	'z'+1
	JRNC	KEYE

	AND	1FH
	JR	KEYE
	PAGE

KEY6:
	CMP	','
	JRC	KEYE		;NO TRANSLATION IF CHAR BELOW ','

	LDK	HL,CTL_TB-','
	MOV	E,A
				;D=0 FROM ABOVE
	ADD	HL,DE
	JR	KEY3A
	PAGE

;SLIDE FUNCTIONS.

SLIDEL:
	LDK	C,2
	JR	SLR1


SLIDER:
	LDK	C,-2

SLR1:	LD	A,PIAAD		;GET HORIZONTAL COORD.
	ADD	A,C
	MOV	C,A

	CALL	OPAD		;FUNCTION PIA

;SET REPEAT COUNT FOR THESE KEYS (OVERRIDE COUNT SET BY THE KBDRVR)

SLR2:	POP	DE		;GET RETURN ADRS
	POP	HL		;POINTER TO REPEAT ENTRY

	STO	SLD_RCT,[HL]	;REPEAT COUNT FOR SLIDE KEYS

	PUSH	HL
	PUSH	DE		;RESTORE STACK

	RET
	PAGE

SLIDEU:	LDK	C,1
	JR	SLD1

SLIDED:	LDK	C,-1

SLD1:	LDK	HL,PIABD	;MERGE NEW VERTOFFSET TO LOWER 5 BITS OF PIAB
	LD	A,[HL]
	ADD	A,C
	AND	1FH		;MODIFY CURRENT WITH +1/OR-1
	MOV	C,A
	LD	A,[HL]
	AND	0E0H

SLD2:	OR	C
	MOV	C,A
	CALL	OPBD
	JR	SLR2
	PAGE

DOHOME:

;SET DENSITY BIT

	LD	A,PIAAD		;GET OLD VALUE
	ANI	0000_0001B	;SAVE DENSITY BIT
	ORI	VFLO		;OR IN HORIZONTAL OFFSET
	MOV	C,A
	CALL	OPAD		;FUNCTION PIA

	LD	A,PIABD
	AND	0E0H		;HOUSE KEEPING BITS
	MOV	C,A
	LD	A,VRTOFF	;GET LAST VERTICAL OFFSET
	JR	SLD2		;AND THE VERT TO 0 ALSO
	PAGE

;KEY CODE TRANSLATION TABLES

KYCDTB:
	DB	esc, tab, erc, erc

	DB	erc, cr, '''', '['

	DB	'1', '2', '3', '4'

	DB	'5', '6', '7', '8'

	DB	'q', 'w', 'e', 'r'

	DB	't', 'y', 'u', 'i'

	DB	'a', 's', 'd', 'f'

	DB	'g', 'h', 'j', 'k'

	DB	'z', 'x', 'c', 'v'

	DB	'b', 'n', 'm', ','

	DB	8ah, 8dh, '0', ' '

	DB	'.', 'p', 'o', '9'

	DB	8bh, 8ch, '-', '/'

	DB	';', '\', 'l', '='


SHFT_TB:
	DB	'"', 00h, 00h, 00h, 00h

	DB	'<', '_', '>', '?', ')'

	DB	'!', '@', '#', '$', '%'

	DB	'^', '&', '*', '(', 00h

	DB	':', 00h, '+', 00h


CTL_TB:	DB	'{', '_'-40h, '}', '~'

	DB	80h, 81h, 82h, 83h, 84h

	DB	85h, 86h, 87h, 88h, 89h

	DB	00h, 00h, 00H, 60H
	TITLE	'IEEE-488 INTERFACE.'

*[ ]

;	+---------------------------------------+
;	| ENTERED 05/01/81 FROM TNW XEROX, SEH. |
;	+---------------------------------------+


;LAST EDITED AT 09:29 ON 11 NOV 80

;THERE ARE FOUR COMMANDS TO THE 6821

;	00	PERIPHERAL/DIRECTION REGISTER A		CPDRA
;	01	CONTROL REGISTER A			CCRA
;	10	PERIPHERAL/DIRECTION REGISTER B		CPDRB
;	11	CONTROL REGISTER B			CCRB

;BIT 2 OF THE CONTROL REGISTER (A AND B) ALLOWS SELECTION OF EITHER
;A PERIPHERAL INTERFACE REGISTER OR A DATA DIRECTION REGISTER.
;A "1" IN BIT 2 SELECTS THE PERIPHERAL REGISTER.

;THE TWO DATA DIRECTION REGISTERS ALLOW CONTROL OF THE DIRECTION
;OF DATA THROUGH EACH CORRESPONDING PERIPHERAL DATA LINE.
;A DATA DIRECTION REGISTER BIT SET AT "0" CONFIGURES
;THE CORRESPONDING PERIPHERAL DATA LINE AS AN INPUT.

;A RESET AT POWER UP HAS THE EFFECT OF ZEROING ALL PIA REGISTERS.
;THIS WILL SET PA0-PA7, PB0-PB7, CA2, AND CB2 AS INPUTS,
;AND ALL INTERRUPTS DISABLED.
;SIGNALS ATN, REN, AND IFC WILL BE DRIVEN LOW
;UNTIL INITIALIZED BY SOFTWARE.

;DATA DIRECTION IS ALWAYS SET FOR OUTPUT FOR THE DATA REGISTER.
;DATA MUST BE SET TO ALL ONES WHEN INPUTTING.
;THE INTERFACE IS IN SOURCE HANDSHAKE MODE IF DATA ENABLE (PB0)
;IS SET TO "0", AND IN ACCEPTOR HANDSHAKE MODE IF SET TO "1".
;WHEN SWITCHING FROM SOURCE TO ACCEPTOR HANDSHAKE,
;ATN WILL ALWAYS BE LOW.
;TAKE CONTROL CAN ONLY BE CALLED FOLLOWING A GO TO STANDBY.
;AFTER A FATAL ERROR, PERFORM AN IFC RESET.

;STANDARD VALUES USED:

;CCRA	0011(IFC)(DIR)10

;CCRB	0011(REN)(DIR)00

;CPDRA	SOURCE		DIRECTION	1111_1111
;			DATA		DATA

;CPDRA	ACCEPTOR	DIRECTION	1111_1111
;			DATA		1111_1111

;CPDRB	SOURCE		DIRECTION	0011_1111
;			DATA		000A_0010	;A = ATN

;CPDRB	ACCEPTOR	DIRECTION	1101_0111
;			DATA		0100_0101
	PAGE

;PIA SIGNAL DEFINITIONS:
;ALL SIGNALS ARE LOW ON THE IEEE BUS WHEN PIA REGISTER CONTAINS "1".

;	PA0	DIO 1
;	PA1	DIO 2
;	PA2	DIO 3
;	PA3	DIO 4
;	PA4	DIO 5
;	PA5	DIO 6
;	PA6	DIO 7
;	PA7	DIO 8

;	CA1	SRQ
;	CA2	IFC

;	PB0	ENABLE DATA OUT		(ENABLED WHEN "0")
;	PB1	ENABLE NDAC/NRFD	(ENABLED WHEN "0")
;	PB2	ENABLE EOI/DAV		(ENABLED WHEN "0")
;	PB3	EOI
;	PB4	ATN
;	PB5	DAV
;	PB6	NDAC
;	PB7	NRFD

;	CB1	NOT USED
;	CB2	REN

;CONTROL WORD FORMAT

;[  7  ][  6  ][  5  ][  4  ][  3  ][  2  ][  1  ][  0  ]

;[IRQA1][IRQA2][    CA2 CONTROL    ][ DDRA][ CA1 CONTROL]
;[IRQB1][IRQB2][    CB2 CONTROL    ][ DDRB][ CB1 CONTROL]

;	IRQA1	0	INTERRUPT FLAG SET BY FALL OF SRQ
;	IRQA2	0	NOT USED
;	CA2	110	SET IFC HIGH
;		111	SET IFC LOW
;	DDRA	0	R/W DATA DIRECTION REGISTER A
;		1	R/W PERIPHERAL REGISTER A
;	CA1	10	SET IRQA1 HIGH ON RISE OF SRQ

;	IRQB1	0	NOT USED
;	IRQB2	0	NOT USED
;	CB2	110	SET REN HIGH
;		111	SET REN LOW
;	DDRB	0	R/W DATA DIRECTION REGISTER B
;		1	R/W PERIPHERAL REGISTER B
;	CB1	00	NOT USED
	PAGE

;BIOS CALL 1:	CONTROL OUT

;	CAN BE CALLED WHILE IN ANY STATE.

;	EXITS IN THE CONTROLLER STANDBY STATE (ATN HIGH),
;	SOURCE HANDSHAKE MODE

;PARAMETER PASSED IN REGISTER C:

;	BIT 0	IF "1", THE IFC SIGNAL IS SET LOW FOR 100 MICRO-SEC
;		AND ALL PIA SIGNALS ARE INITIALIZED

;	BIT 2 1
;	0 X	NO ACTION
;	1 0 SETS REN HIGH
;	1 1 SETS REN LOW
	PAGE

IE.CO:
	PROC

	PUSH	AF
	PUSH	HL

	BIT	0,C		;CHECK IFC SUB-COMMAND
	JRZ	:B1C20

;INITIALIZE ALL IEEE-488 SIGNALS

	LK	HL,CCRA
	STO	0011_1010B,[HL]	;ENABLE SRQ AND SET IFC-OUT LOW

	LK	A,1111_1111B	;DIRECT DATA OUT
	STO	A,CPDRA
	STO	0011_1110B,[HL]

	XRA	A
	STO	A,CPDRA
	LK	HL,CCRB
	STO	0011_0000B,[HL]	;SET REN-OUT HIGH

	LK	A,0011_1111B	;DIRECTION FOR SOURCE HANDSHAKE
	STO	A,CPDRB
	STO	0011_0100B,[HL]

	LK	A,0000_0010B	;VALUES FOR SOURCE HANDSHAKE
	STO	A,CPDRB

;LEAVE IFC LOW FOR 100 MICRO-SEC

	LK	A,25		;DELAY 100 MICRO-SEC

:B1C10:	DEC	A
	JRNZ	:B1C10

	LK	A,0011_0110B	;SET IFC HIGH
	STO	A,CCRA

:B1C20:	BIT	2,C		;CHECK REN SUB-COMMAND
	JRZ	:B1C40

;SET/CLEAR REN

	LK	A,0011_0100B
	BIT	1,C
	JRZ	:B1C30

	LK	A,0011_1100B

:B1C30:	STO	A,CCRB

:B1C40:	POP	HL
	POP	AF
	RET
	PAGE

IE.SI:
;BIOS CALL 2. STATUS IN
;CAN BE CALLED ONLY WHILE IN SOURCE HANDSHAKE MODE.
;BIT 0 OF REGISTER A SET IF SRQ IS LOW

	PROC

	PUSH	HL

	LD	A,CPDRA		;CLEAR IRQA1
	LK	HL,CPDRB	;PULSE ENABLE ndac/nrfd
	CBIT	1,[HL]
	SBIT	1,[HL]
	LD	A,CCRA		;SET SRQ VALUE IN A
	AND	1000_0000B
	RLC	A

	POP	HL
	RET
	PAGE

IE.GTS:
;BIOS CALL 3 GO TO STANDBY
;CAN BE CALLED ONLY WHILE IN SOURCE HANDSHAKE MODE
;ENTRY
;NONE

	PROC

	PUSH	AF

	LK	A,0000_0010B	;SET ATN HIGH
	STO	A,CPDRB
	XOR	A		;FLOAT DATA BUS
	STO	A,CPDRA

	POP	AF
	RET
	PAGE

IE.TC:
;BIOS CALL 4 TAKE CONTROL
;CAN BE CALLED ONLY WHILE IN THE CONTROLLER STANDBY STATE (ATN HIGH).
;EXITS IN THE CONTROLLER ACTIVE STATE (ATN LOW), SOURCE HANDSHAKE MODE.
;BIT 0 OF REGISTER C SET TO TAKE CONTROL ASYNCHRONOUS

;EXIT
	;A	=	;ERROR CODE

	PROC

	PUSH	HL

	LK	HL,CPDRB
	BIT	0,C
	JRNZ	:B4C30

;TAKE CONTROL SYNCHRONOUSLY

	STO	0000_0111B,[HL]	;DISABLE DRIVERS
	LD	A,CCRB
	CBIT	2,A
	STO	A,CCRB
	STO	1101_0111B,[HL]	;DIRECTION REGISTER

	SBIT	2,A
	STO	A,CCRB

	STO	1000_0101B,[HL]	;SET NRFD LOW
	LK	A,25

:B4C10:	BIT	5,[HL]
	JRZ	:B4C20		;DATA VALID HAS DROPPED

	DEC	A
	JRNZ	:B4C10		;WAIT 100 MICRO-SEC

	LK	A,1000_0001B	;SET DATA VALID TIMEOUT ERROR
	JR	:B4C40

:B4C20:	STO	1100_0101B,[HL]	;SET NDAC LOW

:B4C30:	SBIT	4,[HL]		;SET ATN LOW

;SET-UP FOR SOURCE HANDSHAKE

	LD	A,CCRB
	CBIT	2,A
	STO	A,CCRB
	STO	0011_1111B,[HL]	;DIRECTION REGISTER

	SBIT	2,A
	STO	A,CCRB
	STO	0001_0010B,[HL]	;CONTROL SIGNAL INITIAL VALUE

	XOR	A		;CLEAR ERROR CODE

:B4C40:	POP	HL
	RET
	PAGE

IE.OIM:
;BIOS CALL 5 OUTPUT INTERFACE MESSAGE
;CAN BE CALLED WHILE IN ANY MODE OR STATE
;EXITS IN THE SOURCE HANDSHAKE MODE WITH ATN LOW.

;EXIT
	;A	=	ERROR CODE
	;C	=	MULTI-LINE MESSAGE

	PROC

	PUSH	HL

	LK	HL,CPDRB
	SBIT	4,[HL]		;SET ATN LOW
	BIT	0,[HL]
	JRZ	IE.SHK

;SET-UP FOR SOURCE HANDSHAKE

	STO	0001_0111B,[HL]	;DISABLE DRIVERS
	LD	A,CCRB
	CBIT	2,A
	STO	A,CCRB
	STO	0011_1111B,[HL]	;DIRECTION REGISTER

	SBIT	2,A
	STO	A,CCRB

;FLOAT EXTERNAL DATA BUS

	XOR	A
	STO	A,CPDRA
	STO	0001_0010B,[HL]	;CONTROL SIGNAL INITIAL VALUE

	JR	IE.SHK
	PAGE

IE.ODM:
;BIOS CALL 6 OUTPUT DEVICE MESSAGE
;CAN BE CALLED ONLY WHILE IN THE SOURCE HANDSHAKE MODE WITH ATN HIGH OR LOW.
;EXITS IN THE SOURCE HANDSHAKE MODE WITH ATN HIGH.

;EXIT
	;C	=	MULTI-LINE MESSAGE
	;B	=	EOI REQUEST
	;A	=	ERROR CODE

	PROC

	PUSH	HL

	LK	HL,CPDRB
	CBIT	4,[HL]		;SET ATN HIGH
	BIT	0,B		;CHECK IF EOI REQUESTED
	JRZ	IE.SHK

	SBIT	3,[HL]

;PERFORM SOURCE HANDSHAKE

IE.SHK:	BIT	5,[HL]		;
	JRNZ	:B6C50		;DAC TIMEOUT RE-ENTRY

	MOV	A,C		;PLACE DATA ON BUS
	STO	A,CPDRA
	LK	A,10

:B6C20:	BIT	7,[HL]
	JRZ	:B6C30		;READY FOR DATA

	DEC	A
	JRNZ	:B6C20		;WAIT FOR 100 MICRO-SEC

	LK	A,1000_0010B	;SET RFD TIMEOUT ERROR
	JR	:B6C80

:B6C30:	BIT	6,[HL]
	JRNZ	:B6C40		;DATA ACCEPTED LOW

	LK	A,1000_0001B	;SET DEVICE NOT PRESENT ERROR
	JR	:B6C80

:B6C40:	SBIT	5,[HL]		;SET DAV LOW

:B6C50:	LK	A,255

:B6C60:	BIT	6,[HL]
	JRZ	:B6C70		;DATA ACCEPTED

	DEC	A
	JRNZ	:B6C60		;WAIT 1000 MICRO-SEC

	LK	A,1000_0100B	;SET DAC TIMEOUT ERROR
	JR	:B6C80

:B6C70:	CBIT	5,[HL]		;SET DAV HIGH
	CBIT	3,[HL]		;SET EOI HIGH
	XOR	A		;REMOVE DATA FROM BUS
	STO	A,CPDRA

:B6C80:	POP	HL
	RET
	PAGE

IE.IDM:
;BIOS CALL 7 INPUT DEVICE MESSAGE
;CAN BE CALLED WHILE IN ANY MODE OR STATE
;EXITS IN THE ACCEPTOR HANDSHAKE MODE WITH ATN HIGH.
;EXIT
	;L	=	ERROR CODE
	;A	=	DEVICE MESSAGE
	;H	=	DEVICE MESSAGE

	PROC

	PUSH	DE

	EX	DE,HL		;SAVE RE-ENTRY DATA
	LK	HL,CPDRB
	BIT	0,[HL]
	JRNZ	:B7C10

;SET-UP FOR ACCEPTOR HANDSHAKE

	STO	0001_0111B,[HL]	;DISABLE DRIVERS

	LD	A,CCRB
	CBIT	2,A
	STO	A,CCRB
	STO	1101_0111B,[HL]	;DIRECTION REGISTER

	SBIT	2,A
	STO	A,CCRB

	LK	A,1111_1111B	;FLOAT INTERNAL DATA BUS
	STO	A,CPDRA
	STO	0101_0101B,[HL]	;CONTROL SIGNALS INITIAL VALUE
	STO	0100_0101B,[HL]	;SET ATN HIGH

;PERFORM ACCEPTOR HANDSHAKE

:B7C10:	BIT	6,[HL]
	JRZ	:B7C50		;DATA INVALID TIMEOUT ERROR RE-ENTRY

	CBIT	7,[HL]		;SET NRFD HIGH
	LK	A,10

:B7C20:	BIT	5,[HL]
	JRNZ	:B7C30		;DATA VALID

	DEC	A
	JRNZ	:B7C20		;WAIT 100 MICRO-SEC

	LK	DE,1000_0010B	;SET DATA VALID TIMEOUT ERROR
	JR	:B7C80

:B7C30:	SBIT	7,[HL]		;SET NRFD LOW
	LD	A,CPDRA		;READ DATA
	MOV	D,A
	LK	E,0		;READ EOI
	BIT	3,[HL]
	JRZ	:B7C40

	LK	E,1

:B7C40:	CBIT	6,[HL]		;SET NDAC HIGH

:B7C50:	LK	A,255

:B7C60:	BIT	5,[HL]
	JRZ	:B7C70		;DATA VALID DROPPED

	DEC	A
	JRNZ	:B7C60		;WAIT 1000 MICRO-SEC

	SBIT	2,E		;SET DATA INVALID TIMEOUT ERROR
	SBIT	7,E
	JR	:B7C80

:B7C70:	SBIT	6,[HL]		;SET NDAC LOW

:B7C80:	EX	DE,HL		;MOVE RESULTS TO REGISTERS A AND HL
	MOV	A,H

	POP	DE
	RET
	PAGE

IE.PP:
;BIOS CALL 8 PARALLEL POLL
;CAN BE CALLED ONLY WHILE IN THE SOURCE HANDSHAKE MODE WITH ATN HIGH OR LOW.
;EXITS IN THE SOURCE HANDSHAKE MODE WITH ATN LOW.

;EXIT
	;A	=	PARALLEL POLL VALUE

	PROC

	PUSH	HL

	LK	HL,CPDRA
	LK	A,0001_1011B	;FORM PARALLEL POLL
	STO	A,CPDRB
	STO	1111_1111B,[HL]	;FLOAT INTERNAL DATA BUS

	LD	A,[HL]		;READ PARALLEL POLL DATA
	STO	0,[HL]		;RE-STORE SOURCE HANDSHAKE MODE

	LK	HL,CPDRB
	STO	0001_0010B,[HL]

	POP	HL
	RET
	PAGE

*[ ]

;IEEE drivers:

;The routines IEINSTAT, IEINP and IEOUT are used to
;transfer characters to and from an IEEE device attached to the
;OSBORNE IEEE port.  The address of the device is specified in
;the cell IE_ADRS.
;The function IEINSTAT returns the status of the input device.
;Unfortunately there is no standard way by which an IEEE device
;indicates that it has a character.  In order to determine this, one
;has to read the character device.  As a CP/M transient can call
;IEINSTAT many times before calling IEINP to read a char, and IEINSTAT
;has to read the char to determine the status, the character read has to
;be buffered until call to IEINP is made.  IEINSTAT reads the device
;only when the buffer is empty.  As zeros are used to indicate
;that the bfr is empty, a null character can not be read from the
;IEEE device.
	PAGE

IEOSTAT:
;returns status of IEEE
;IEEE always appears to be ready

	PROC

	ORI	0FFh
	RET
	PAGE

IEINSTAT:
;gets status of the input device attached to IEEE port
;if a char is present in IE_char then return with 0FFH status
;else
;make device talker
;Read the device
;if char read then
; store in bfr
;make untalk
;return with status of buffer

	PROC

	LDA	IE_CHAR
	ORA	A
	JRZ	IEI10			;if char present then

	ORI	0FFh			;return with 0FFH status
	RET
	PAGE

IEI10:
;make talker

	LDA	IE_ADRS
	ADI	IE_TALK			;get primary address
	MOV	C,A
	CALL	IE.OIM			;output interface message
	ORA	A
	JRNZ	IEI10			;try again if error

IEI20:
;read a char.

	CALL	IE.IDM
	BIT	7,L
	JRZ	IEI30			;if error then

	XRA	A			;inicate no char recvd

IEI30:	STA	IE_CHAR			;stor the char

IEI40:
;make untalk

	LDK	C,IE_UTLK
	CALL	IE.OIM
	ORA	A
	JRNZ	IEI40

;return with status of the char

	LDA	IE_CHAR
	ORA	A
	RZ

	ORI	0FFh
	RET	PAGE

IEINP:
;Reads a character from IEEE port

	PROC

	CALL	IEINSTAT
	JRZ	IEINP		;wait till char avail

	LDK	HL,IE_CHAR
	LD	A,[HL]
	STO	0,[HL]		;clear the buffer
	RET
	PAGE

IEOUT:
;Outputs the character in reg C to IEEE port
;Uses ROM resident primitives.

	PROC

	PUSH	BC		;save the char
				;make listener
IEO05:	LDA	IE_ADRS
	ADI	IE_LSTN		;get primary address
	MOV	C,A
	CALL	IE.OIM		;output interface message
	ORA	A
	JRNZ	IEO05		;try again if error

	POP	B
	LDK	B,0		;do not send eoi

IEO22:	PUSH	B		;save char again in case of retry
	CALL	IE.ODM
	POP	B
	ORA	A
	JRNZ	IEO22		;try again if error

IEO40:
;make unlisten

	LDK	C,IE_ULST
	CALL	IE.OIM
	ORA	A
	JRNZ	IEO40

	RET
	PAGE

;The Parallel port is actually the IEEE port driven with the centronix
;protocol.  The bit assignements of the PIA and PIB are as follows:
;PIA0-7 = data bus
;PIB0 = 0, data bus is output. 1, data bus is input
;PIB1 = set to 1.
;PIB2 = set to 0.
;PIB3 = 0 output, 1 Input
;PIB4 = not used
;PIB5 = output strobe. Active = 1.
;PIB6 = 0, printer busy. 1, printer is ready.
;PIB7 = not used.

;CA2 = going low indicates to device that we are busy.
;CA1 = low to high transition gates input data to port a.

;The port is bidirectional but only one direction
;can be active at any time. The direction of port is determined
;by which routines are called.  If postat or parout are
;called, it is made an output port and an input port if
;pistat or parinp are called.
	PAGE

CV2OP:
;initializes the port to a PArallel output port.

	PROC

	LDA	PP.MODE
	CPI	PP.OUT
	RZ			;return when in output mode

;set port a to output on all lines

	LDK	A,PA.CDR
	STA	PA.CTL		;select direction reg
	LDK	A,PA.DRO
	STA	PA.DIR		;output constant to dir. reg to put a port in output mode

	LK	A,PA.CDT
	STA	PA.CTL		;select port a data reg.

	LK	A,PB.CDR
	STA	PB.CTL		;selecô porô b direction
	LK	A,PB.DR
	STA	PB.DIR		;all lines are output except the output busy signal on bit  6

	LK	A,PB.CDT
	STA	PB.CTL		;select data register 
	LK	A,PB.DTO
	STA	PB.DTA		;initialize port b data

	LK	A,PP.OUT
	STA	PP.MODE
	RET
	PAGE

CV2IP:
;initializes the port to a parallel input port.

	PROC

	LDA	PP.MODE
	CPI	PP.IN
	RZ			;return when in input mode

;set port a to input on all lines

	LK	A,PA.CDR
	STA	PA.CTL		;select direction reg
	LK	A,PA.DRI
	STA	PA.DIR		;output constant to dir. reg to put a port in input mode

	LK	A,PA.CDT
	STA	PA.CTL		;select port a data reg.

	LK	A,PB.CDR
	STA	PB.CTL		;selecô porô b direction
	LK	A,PB.DR
	STA	PB.DIR		;all lines are output except the output busy signal on bit  6

	LK	A,PB.CDT
	STA	PB.CTL		;select data register 
	LK	A,PB.DTI
	STA	PB.DTA		;initialize port b data

	LK	A,PP.IN	STA	PP.MODE
	RET
	PAGE

POSTAT:
;gets status of the parallel (centronix) printer attached to the IEEE port

	PROC

	CALL	CV2OP		;convert to output
	LDA	PB.DTA		;get port b data
	ANI	PP.ORDY
	RZ

	ORI	0FFH

POS10:	RET
	PAGE

PISTAT:
;gets status of the input device attached to the parallel port

	PROC

	CALL	CV2IP
	LDA	PIACTL
	ANI	PP.IRDY
	JRNZ	PIS20		;if saved status indicates there is a char in the PIA

	LDA	PA.CTL
	STA	PIACTL		;this is saved as reading the
				;pia clears the status
	ANI	PP.IRDY
	RZ

PIS20:	ORI	0FFH
	RET
	PAGE

PARINP:
;inputs a character from PArallel port.

	PROC

	CALL	PISTAT
	JRZ	PARINP		;wait till char in pia

	XRA	A
	STA	PIACTL		;clear saved status
	LDA	PA.DTA	CMA			;invert data
	MOV	C,A		;also in c
	RET
	PAGE

PAROUT:
;outputs the character in c to the IEEE port treating the port as a parallel port.

	PROC

	CALL	POSTAT
	JRZ	PAROUT

	MOV	A,C
	CMA			;invert data
	STA	PA.DTA
	LK	A,PB.DTO+STRB
	STA	PB.DTA		;set strobe
	LK	A,PB.DTO
	STA	PB.DTA		;clear strobe
	RET
	TITLE	'SIO - Serial I/O Processors.'
*[5]
SIRST:
;Master reset SIO
;ENTRY
;C	=	SI.S16 or SI.S64 for 1200/300 baud

;EXIT
;NONE
	PROC

	LDK	A,SI.MRST
	STO	A,H.SCTRL	;master reset

	MOV	A,C
	STO	A,ACIAD		;last-command cell
	STO	A,H.SCTRL	;select SIO

	RET
	PAGE

READER:
;Input one byte from reader port
;ENTRY
;None

;EXIT
;C	=	character read

	PROC

	CALL	ACISTAT
	ANI	SI.RRDY
	JRZ	READER		;if not ready

	LDK	HL,SERFLG
	CBIT	0,[HL]

	LD	A,H.SREC	;get data
	MOV	C,A		;C=A
	RET

	PAGE

SLST:
;Get list device status
;ENTRY
;NONE

;EXIT
;A	=	0, IF NOT READY
;A	=	0FFh IF READY
;ZBIT	=	SET IF NOT READY FOR OUTPUT

	PROC

	CALL	ACISTAT
	ANI	SI.TRDY
	RZ			;RETURN

	ORI	0FFH
	RET
	PAGE

LIST:
;Output one byte to list port
;ENTRY
;C	=	character to output

;EXIT
;NONE
	PROC

	CALL	SLST		;GET STATUS
	JRZ	LIST		;LOOP

	MOV	A,C
	STO	A,H.SXMT	;send chr

	LDK	HL,SERFLG
	CBIT	1,[HL]

	RET
	PAGE

ACISTAT:
;RETURN STATUS OF THE SERIAL PORT
;ENTRY
;NONE

;EXIT
;A	=	STATUS REG

	PROC

	PUSH	BC

	LD	A,H.VIO+1
	RRC	A
	ANI	20h
	MOV	C,A

	LD	A,H.SSTS
	ANI	0DFh
	ORA	C
	MOV	C,A

	LD	A,SERFLG
	ANI	03
	ORA	C
	STO	A,SERFLG

	POP	BC

	RET
	TITLE	'NEW DISK DRIVERS'

*[6]

RDRV:
;RESET DRIVE
;ENTRY
;NONE

;EXIT
;ZBIT	=	RESET IF ERROR

	PROC

	LDK	A,NRETRY
:LOOP:	STO	A,RTRY
	CALL	SELDRV		;SELECT DRIVE
	JRC	:1

	CALL	HOME		;HOME DRIVE
	JRNC	:END		;IF GOOD

:1:	LD	A,RTRY
	DEC	A
	JRNZ	:LOOP

	INC	A		;MAKE NOT ZERO
	STC			;INDICATE ERROR
	RET

:END:	XRA	A
	RET
	PAGE

RSEC:
;READ SECTOR
;*NOTE*
;	No retries are performed at this level
;ENTRY
;B	=	NUMBER OF SECTORS

;EXIT
;HL	=	LAST DMA ADDRESS PLUS ONE IF GOOD TRANSFER
;ZBIT	=	RESET IF ERROR
;A	=	NONZERO IF ERROR
	;RTRY	=	1 IF ERROR(SO OLD CBIOS DOESN'T DO RETRYS)

	PROC

	LDK	A,D.RDS
	STO	A,R_WCOM

	JR	R_WSEC
	PAGE

WSEC:
;WRITE A SECTOR
;*NOTE*
;	No retries are performed at this level
;ENTRY
;B	=	NUMBER OF SECTORS

;EXIT
;HL	=	LAST DMA ADDRESS PLUS ONE IF GOOD TRANSFER
;ZBIT	=	RESET IF ERROR
;A	=	NONZERO IF ERROR
	;RTRY	=	1 IF ERROR(SO OLD CBIOS DOESN'T DO RETRYS)

	PROC

	LDK	A,D.WRTS
	STO	A,R_WCOM


;FALLS THROUGH TO "R_WSEC"
	PAGE

R_WSEC:
;READ OR WRITE SEGMENT
;ENTRY
;B	=	NUMBER OF SECTORS TO READ OR WRITE
	;R_WCOM	=	D.RDS OR D.WRTS

;EXIT
;HL	=	LAST DMA ADDRESS PLUS ONE IF GOOD TRANSFER
;ZBIT	=	RESET IF ERROR
	;RTRY	=	0 IF GOOD, 1 IF ERROR

	PROC

	STO	BC,NUMSEC	;SAVE BC

	LDK	A,NRETRY
	STO	A,RTRY		;SET RETRY NUMBER

;SELECT DRIVE

:RLOOP:	CALL	SELDRV		;TURN DRIVE ON
	JRZ	:1		;IF DRIVE ON DON'T READ ADDRESS

;SET "D.TRKR" TO HEAD POSITION

	CALL	RADR		;READ ADDRESS AND SET CONTROLLER
	JRC	:ERR		;STOP

;SEEK

:1:	CALL	SEEK		;SEEK TO TRACK
	JRC	:ERR		;STOP

;READ OR WRITE

	LD	BC,NUMSEC	;B = NUMBER OF SECTORS TO R/W
	CALL	RD_WRT		;READ/WRITE PER R_WCOM
	JRNC	:END		;IF GOOD

;RETRY?

	LDK	HL,RTRY		;GET RETRYS
	DEC	[HL]
	JRZ	:ERR		;NO MORE RETRYS

	LD	A,[HL]		;GET NUMBER OF RETRY
	CMP	NRETRY-1
	JRNZ	:RLOOP		;LOOP IF NOT FIRST RETRY

	CALL	RADR		;CHECK TRACK ON THE FIRST RETRY
	JRC	:ERR		;STOP IF ERROR

	JR	:RLOOP		;LOOP

:ERR:	LDK	A,1		;INDICATE ERROR
	ORA	A
	JR	:2		;EXIT

:END:	XRA	A		;INDICATE GOOD

;SET "RTRY" AND REGESTER B

:2:	STO	A,RTRY		;SET RETRY TO 1 FOR ERROR AND 0 FOR GOOD

	LD	BC,NUMSEC	;BC = RESTORE BC

	RET
	PAGE

SENDEN:
;DETERMINE THE DENSITY AND NUMBER OF SECTORS PER TRACK OF THIS DISK DRIVE
;ENTRY
;NONE

;EXIT
;B	=	NUMBER OF SECTORS ON ONE TRACK
;ZBIT	=	RESET IF ERROR
	;SAVTYP IS SET WITH DENSITY AND SECTOR SIZE

	PROC

*CHECK DENSITY

	;HOME LOOP

	LDK	A,NRETRY
	STO	A,RTRY

	;DENSITY LOOP(CHECK PRESENT DENSITY FIRST)

:RL1:	LDK	B,2		;CHECK BOTH DENSITYS

:RL2:	PUSH	BC		;SAVE COUNT

	;CHECK THIS DENSTIY

	CALL	SELDRV		;SELECT DRIVE
;	JRC	?		;NO ERROR CHECKING FOR SELDRV BECAUSE NO ERRORS ARE RETURNED AT THIS TIME

	CALL	RADR		;READ ADDRESS
	POP	BC		;RESTORE DENSITY RETRY
	JRNC	:1		;IF GOOD

*IF DENSITY ERROR CHANGE DENSITY AND LOOP TO :RL2:

	LD	A,SAVTYP	;PRESENT DENSITY
	XRI	1		;CHANGE DENSITY BIT
	STO	A,SAVTYP	;NEW DENSITY

	DJNZ	:RL2		;DENSITY LOOP

*IF BOTH DENSITYS FAIL HOME DRIVE AND TRY AGAIN

	LDK	HL,RTRY
	DEC	[HL]
	JRZ	:ERET		;END IF SECOND TIME THROUGH

	CALL	HOME		;HOME DRIVE
	JRC	:ERET		;END IF ERROR IN HOME

	JR	:RL1		;TRY AGAIN

*SET "SAVTYP"

:1:	LD	A,DSTSB+3	;SECTOR LENTH STATUS BYTE
	ANI	0000_0011B	;0-3
	SLA	A
	SLA	A		;NOW IS 0000_XX00B WAS 0000_00XXB
	MOV	B,A		;SAVE

	LD	A,SAVTYP
	ANI	1111_0011B	;CLEAR BITS
	ORA	B		;OR IN SECTOR LENTH
	STO	A,SAVTYP

*READ ADDRESS AND SET NUMBER OF SECTORS AND RETURN

	LD	A,DSTSB+2	;SECTOR JUST READ
	MOV	D,A

	;RETRY LOOP

	LDK	A,3
:RL3:	STO	A,RTRY		;SET RETRYS

	;READ HEADER LOOP

:LOOP:	PUSH	DE		;SAVE LAST SECTOR ADDR
	CALL	RADR		;READ ADDRESS
	POP	DE
	JRC	:ERR		;IF ERROR IN RADR

	;CHECK FOR LAST HEADER

	LD	A,DSTSB+2
	MOV	B,A		;B=PRESENT SECTOR
	MOV	A,D		;A=LAST SECTOR
	SUB	B		;LAST SECTOR - PRESENT SECTOR
	JRZ	:LOOP		;IF THE LAST SECTOR = THE PRESENT SECTOR(THIS SHOULD HAPPEN ONLY ON ERROR RETRY)

	JRNC	:2		;IF THE VALUE IN A WAS THE LAST SECTOR OF THE TRACK

	MOV	D,B		;D=LAST SECTOR READ
	JR	:LOOP		;LOOP TILL YOU FIND THE LAST TRACK

	;SET NUMBER OF SECTORS PER TRACK

:2:	INC	A		;A=NUMBER OF SECTORS PER TRACK
	MOV	B,A
	XRA	A		;RESET FLAGS
	RET			;GOOD RETURN


*IF NUMB. SEC. ERROR MAKE LAST SECTOR READ ZERO AND RETRY TO :LOOP1

:ERR:	LDK	D,0
	LD	A,RTRY
	DEC	A
	JRNZ	:RL3		;RETRY

:ERET:	LDK	A,1
	ORA	A		;FLAGS TO NONZERO
	RET			;ERROR RETURN
	PAGE

SCTRKR:
;SET CONTROLER TRACK REGESTER
;D.TRKR <= SAVTRK
;USED IN FORMATING WHEN YOU DON'T KNOW WHERE THE HEAD IS
;ENTRY
;SAVTRK	=	TRACK

;EXIT
;D.TRKR	=	SAVTRK

	PROC

	LD	A,SAVTRK
	STO	A,D.TRKR
	RET
	PAGE

HOME:
;HOME DISK DRIVE
;DRIVE IS ALREADY SELECTED AND READY
;If "SEKDEL" has the verify bit set this proc will check for seek and crc errors
;ENTRY
;SDISK	=	DRIVE

;EXIT
;CBIT	=	SET IF ERROR

	PROC

	LD	A,SEKDEL	;GET SEEK DELAY
	ANI	0000_0111B	;SPEAD & VERIFY BITS ONLY

	CALL	FDSK		;FUNCTION DISK
	RC			;IF ERROR

	CALL	WBUSY		;WAIT FOR BUSY TO DROP
	RC

	LD	A,D.STSR
	BIT	2,A
	JRZ	:1		;IF NOT ON TRACK ZERO

	LD	A,SEKDEL
	ANI	0000_0100B	;VERIFY?
	RZ			;NO VERIFY GOOD RETURN

	LD	A,D.STSR
	ANI	0001_1000B	;TEST SEEK AND CRC
	RZ			;GOOD RETURN

:1:	STC			;IF ERROR
	RET
	PAGE

SEEK:
;SEEK TO TRACK DEFINED BY SAVTRK
;TRACK REG UPDATED AND VERIFIED
;ENTRY
;SAVTRK SET TO DESIRED TRACK

;EXIT
;CBIT	=	SET IF ERROR
;	IF NO ERROR CONTROLER TRACK = SAVTRK

	PROC

	LDK	HL,D.TRKR
	LD	A,SAVTRK
	CMP	[HL]
	RZ			;RETURN

	STO	A,D.DATR	;SET TRACK WANTED

	LDK	B,D.SEK
	JR	PSEKC		;PERFORM SEEK COMMAND
	PAGE

STEP:
;STEP ONE TRACK
;SAVTRK IS NOT USED IN THIS PROC
;CONTROLER TRK REG IS UPDATED
;VERIFY IS PERFORMED
;ENTRY
;NONE

;EXIT
;CBIT	=	SET IF ERROR
;	IF NO ERROR CONTROLER TRACK = TRACK +/- 1

	PROC

	LDK	B,D.STP
	JR	PSEKC		;PERFORM STEP COMMAND
	PAGE

STEPIN:
;STEP IN ONE TRACK
;SAVTRK IS NOT USED IN THIS PROC
;CONTROLER URK REG IS UPDATED
;ENTRY
;NONE

;EXIT
;CBIT	=	SET IF ERROR
;	IF NO ERROR CONTROLER TRACK = TRACK + 1

	PROC

	LDK	B,D.STPI
	JR	PSEKC		;PERFORM STEP-IN COMMAND
	PAGE

STEPOUT:
;STEP OUT ONE TRACK
;SAVTRK IS NOT USED IN THIS PROC
;CONTROLER TRK REG IS UPDATED
;VERIFY IS PERFORMED
;ENTRY
;NONE

;EXIT
;CBIT	=	SET IF ERROR
;	IF NO ERROR CONTROLER TRACK = TRACK - 1

	PROC

	LDK	B,D.STPO
	JR	PSEKC		;PERFORM STEP-OUT COMMAND
	PAGE

PSEKC:
;OR IN SEKDEL AND PERFORM SEEK TYPE COMMAND
;ENTRY
;B	=	SEEK TYPE COMMAND

;EXIT
;CBIT	=	SET IF ERROR

	PROC

	LD	A,SEKDEL
	ANI	0001_0111B	;ONLY UPDATE,VERIFY, & SPEAD
	ORA	B		;OR IN COMMAND

	CALL	FDSK		;FUNCTION DISK
	RC			;IF ERROR

	CALL	WBUSY		;WAIT FOR BUSY TO DROP
	RC			;If time-out error

;HEAD SETTLE DELAY

	LDK	A,20
	CALL	DELAY

;CHECK FOR ERRORS

	LD	A,SEKDEL
	ANI	0000_0100B	;VERIFY?
	RZ			;NO VERIFY GOOD RETURN

	LD	A,D.STSR
	ANI	0001_1000B	;TEST SEEK AND CRC
	RZ			;GOOD RETURN

	STC			;IF ERROR
	RET
	PAGE

READ:
;ENTRY
;B	=	NUMB OF SECTORS TO READ

;EXIT
;HL	=	LAST DMA ADDRESS PLUS ONE IF GOOD TRANSFER
;CBIT	=	SET IF ERROR

	PROC

	LDK	A,D.RDS
	STO	A,R_WCOM

	JR	RD_WRT		;JMP AND RETURN TO CALLING PROC
	PAGE

WRITE:
;ENTRY
;B	=	NUMB OF SECTORS TO WRITE

;EXIT
;HL	=	LAST DMA ADDRESS PLUS ONE IF GOOD TRANSFER
;CBIT	=	SET IF ERROR

	PROC

	LDK	A,D.WRTS
	STO	A,R_WCOM


;FALLS THROUGH TO RD_WRT
	PAGE

RD_WRT:
;READ OR WRITE A SECTOR

;ENTRY
;B	=	NUMB OF SECTORS TO READ OR WRITE
	;R_WCOM	=	D.RDS OR D.WRTS

;EXIT
;HL	=	LAST DMA ADDRESS PLUS ONE IF GOOD TRANSFER
;CBIT	=	SET IF ERROR

	PROC

;SET SECTOR REG

	LD	A,SAVSEC
	STO	A,D.SECR

	PUSH	BC		;SAVE NUMBER OF SECTORS TO R/W

;SET DE TO NUMBER OF BYTES IN ONE SECTOR

	LDK	HL,128
	LD	A,SAVTYP	;DISK TYPE
	SRL	A		;DUMP TWO BITS
	SRL	A
	ANI	0000_0011B	;SIZE ONLY
	ORA	A		;SET FLAGS
	JRZ	:1		;IF 128

	MOV	B,A
:BLOOP:	ADD	HL,HL		;SHIFT LEFT ONE BIT
	DJNZ	:BLOOP

:1:	EX	DE,HL		;DE=NUMBER OF BYTES IN ONE SECTOR

	POP	BC		;RESTORE
	PUSH	BC		;SAVE NUMBER OF SECTORS TO R/W

;GET COMMAND AND CHECK FOR MULTI-SECTOR

	MOV	A,B		;GET NUMBER OF SECTORS
	LDK	C,0		;MAKE NONMULTI-SECTOR
	CMP	2
	JRC	:2		;IF LESS THAN TWO SECTORS

	LDK	C,10H		;MAKE MULTI-SECTOR

:2:	LD	A,R_WCOM	;GET D.RDS OR D.WRTS
	OR	C		;MAKE MULTI-SECTOR OR NONMULTI-SECTOR

;SEÔ HÌ TÏ NUMBEÒ OÆ BYTEÓ TÏ TRANSFER

	LDK	HL,0
:LOOP1:	ADD	HL,DE
	DJNZ	:LOOP1

	PUSH	HL		;SAVE LENTH

;GIVE COMMAND

	DI
	CALL	FDSK
	JRNC	:3		;IF GOOD

;IF ABORT BEFORE DMA

	POP	DE		;RESTORE STACK
	POP	DE
	EI
	RET			;RETURN IF ERROR IN FDSK

;SET RETURN FROM DMA, DMA ADDR AND NUMBER OF BYTES TO TRANSFER

:3:	POP	BC		;RESTORE LENTH
	LD	HL,DMADR	;HL = DMA ADDRESS

	LDK	DE,:RET
	PUSH	DE		;FOR RETURN

;DO DMA

	LD	A,R_WCOM	;(13) GET COMMAND
	CMP	D.RDS		;(7)

	JZ	DMARD		;(10) READ DMA RETURNS TO :RET

	JMP	DMAWRT		;(10) WRITE DMA RETURNS TO :RET

;RETURN FROM DMA AND CHECK FOR BUSY AND RESET

:RET:	POP	BC		;RESTORE NUMBER OF SECTORS

	LD	A,[DE]		;GET STATUS
	BIT	0,A
	JRZ	:4		;IF NOT BUSY

	LDK	DE,:RET1
	PUSH	DE		;FOR RETURN

	DEC	B		;SUBTRACK ONE FROM THE NUMBER OF SECTORS AND SET THE ZERO FLAG

	JZ	WBUSY		;IF NON MULTI-SECTOR R/W WAIT FOR BUSY TO DROP

	JMP	FORINT		;CLEAR BUSY

:RET1:	LD	A,D.STSR	;RETURN AND GET STATUS

;CHECK FOR ERRORS

:4:	ANI	0101_1100B	;TEST write protect, rnf, crc, and lost data
	JRZ	:5		;IF GOOD

	STC			;IF ERROR RECORD CONTROLER REGESTERS

:5:	EI
	RET			;RETURN
	PAGE

RADR:
;Read Address info.
;READS SIX BYTES INTO "DSTSB"

;ENTRY
;NONE

;EXIT
;A	=	0FFH IF TIME OUT ERROR
;CBIT	=	SET IF ERROR
;D.TRKR	=	HEAD POSITION
*NOTE*
;	SETS TRACK REG IN CONTROLER IF GOOD

	PROC

	LDK	A,D.RDA
	DI
	CALL	FDSK		;function disk
	JRC	:1

;WAIT FOR FIRST DRQ OR TIME OUT

	;SET REGESTERS FOR DMA TRANSFER

	LDK	BC,5		;SIX BYTES TO READ
	LDK	HL,DSTSB	;FBA FOR DMA

	;WAIT FOR 1/4 OF A TRACK(60MS) OR DRQ

	LDK	DE,4363
:LOOP:	LD	A,D.STSR	;(13) GET STATUS
	RAR			;(4)
	RAR			;(4)
	JC	:3		;(10) GOT DRQ

	DEC	DE		;(6)
	MOV	A,D		;(4)
	ORA	E		;(4)
	JNZ	:LOOP		;(10)

	;INDICATE TIME OUT ERROR

	CALL	FORINT		;CLEAR BUSY
	LDK	A,0FFH		;A=0FFH
	JR	:2		;INDICATE A TIME OUT ERROR

	;TRANSFER FIRST BYTE AND CALL DMARD FOR LAST FIVE BYTES

:3:	LD	A,D.DATR	;(13) GET BYTE
	STO	A,[HL]		;(7) STORE BYTE
	INC	HL		;(6)
				;BC = 5
	CALL	DMARD		;(17) CALL DMARD

;RETURN FROM DMARD AND WAIT FOR BUSY TO BE RESET

	CALL	WBUSY
	JRC	:1		;IF TIME OUT ERROR

	LD	A,D.STSR	;GET STATUS

;CHECK FOR ERRORS

	ANI	0001_1100B	;TEST RNF, CRC AND DATA LOST
	JRNZ	:2		;IF ERROR

;SET TRACK REGESTER

	LD	A,D.SECR	;GET TRACK
	STO	A,D.TRKR	;SET TRACK
	XRA	A		;RESET CARRY
	JR	:1

:2:	STC			;SET CBIT

:1:	EI
	RET
	PAGE

READTRK:
;READ ONE TRACK FROM THE DRIVE
;ENTRY
;DMADR	=	FWA OF BUFFER

;EXIT
;CBIT	=	SET IF ERROR

	PROC

	LDK	A,D.RDT
	DI
	CALL	FDSK
	JRC	:1		;IF ERROR

;DO DMA

	LDK	BC,0FFFFH	;FOR ROM 1.2
	LD	HL,DMADR
	CALL	DMARD		;IN ROM
	EI
	XRA	A
	RET

:1:	EI
	RET
	PAGE

FMTTRK:
;FORMAT ONE TRACK
;ENTRY
	;BC	=	LENTH
	;DMADR	=	FWA OF BUFFER

;EXIT
;CBIT	=	SET IF ERROR

	PROC

;TEST DENSITY AND SET REG D TO 04EH OR 0FFH

	LD	A,SAVTYP
	LDK	D,04EH		;DOUBLE
	RRC	A
	JRNC	:1		;IF DOUBLE

	LDK	D,0FFH		;SINGLE

;GIVE COMMAND

:1:	LDK	A,D.WRTT
	DI
	PUSH	DE		;FILL BYTE
	PUSH	BC		;LENTH

	CALL	FDSK
	POP	BC		;LENTH
	POP	DE		;FILL BYTE
	JRC	:3		;IF ERROR

;DO DMA

	PUSH	DE		;FILL BYTE

	LD	HL,DMADR
	CALL	DMAWRT

;PAD REST OF TRACK

	POP	BC		;B = FILL BYTE
	LDK	HL,02103H	;DATA REGESTER

:LOOP:	LD	A,[DE]		;GET STATUS
	RAR
	JRNC	:2		;FINISHED IF NO BUSY
	RAR
	JRNC	:LOOP		;IF NO DRQ

	STO	B,[HL]		;STORE BYTE
	JR	:LOOP

;CHECK FOR ERROR

:2:	LD	A,D.STSR	;GET STATUS
	ANI	0100_0100B	;TEST write protect, and data lost
	JRZ	:4		;IF GOOD

:3:	STC

:4:	EI
	RET
	PAGE

FORINT:
;INTERRUPT DISK CONTROLLER
;ENTRY
;NONE

;EXIT
;BUSY CLEARED.
	PROC

	PUSH	AF
	PUSH	BC

	LDK	A,D.FINT
	STO	A,D.CMDR

;WAIT FOR AT LEAST 28 MICROSECONDS

	ORA	A		;(4)
	LDK	B,7		;(7)
:WLOOP:	DJNZ	:WLOOP		;(91) = (13*7) WAIT

;CHECK FOR BUSY DROP

	CALL	WBUSY

	POP	BC
	POP	AF
	RET
	PAGE

FDSK:
;FUNCTION DISK ROUTINE
;THIS IS THE ONLY ROUTINE THAT WRITES TO THE COMMAND REGESTER OF THE CONTROLER CHIP
;THIS ROUTINE HAS A BUILT IN DELAY OF AT LEAST 28 MICRO SEC. BEFORE READING THE STATUS ON THE CHIP
;ENTRY
;A	=	FUNCTION CODE

;EXIT
;A	=	0FFH IS TIME OUT ERROR
;CBIT	=	SET IF ERROR

	PROC

	LDK	HL,D.STSR	;STATUS AND COMMAND REGESTER
	BIT	0,[HL]
	JRZ	:1		;IF NOT BUSY

	CALL	FORINT		;RESET BUSY

:1:	STO	A,[HL]		;FUNCTION DRIVE(WRITE COMMAND TO CONTROLER)

;WAIT FOR 56 SINGLE AND 28 DOUBLE

	LD	A,SAVTYP	;(13) DISK TYPE
	LDK	B,5		;(7)
	RRC	A		;(4)
	JNC	:WLOOP		;(10) IF DOUBLE DENSITY

	XRA	A		;(4) RESET CARRY FLAG
	LDK	B,13		;(7)

:WLOOP:	DJNZ	:WLOOP		;(13) WAIT

;WAIT FOR BUSY TO BE SET

	LDK	A,0FFH		;(7)
	MOV	B,A		;(4) 256 LOOPS

:LOOP:	BIT	0,[HL]		;TEST BUSY BIT
	JRNZ	:3		;IF CHIP WENT BUSY

	DJNZ	:LOOP		;IF NOT TIME-OUT

	STC			;IF ERROR A=FF AND CBIT = SET
	RET

:3:	STO	A,DACTVE	;SET DRIVE ACTIVE COUNTER
	XRA	A		;RESET CARRY FLAG
	RET
	PAGE

SELDRV:
;SELECT DRIVE
;ENTRY
;SDISK	=	DRIVE TO SELECT

;EXIT
;ZBIT	=	SET IF PIABD WAS THE SAME AS SDISK
;ZBIT	=	RESET IF PIABD WAS DIFFERENT THAN SDISK
;*CBIT	=	SET IF THERE ARE NO INDEX PULSES (Not Implemented)

	PROC

	CALL	SELDEN		;SELECT DENSITY

	DI
	LD	A,SDISK
	LDK	HL,DSKSWP	;DISK DRIVE SWAP CELL
	XOR	[HL]		;SWAP A FOR B IF DSKSWP=1
	AND	1		;CAN ONLY BE 0 OR 1
	CMP	1
	JRNZ	:1		;IF NOT DRIVE 1

	LDK	A,40H

:1:	ADI	40H
	MOV	C,A
	LD	A,PIABD
	MOV	B,A
	ANI	1100_0000B	;GET DRIVE BITS ONLY
	CMP	C
	JRZ	:2		;IF DRIVE ALREADY SELECTED

;SELECT DRIVE

	CALL	RDSKD		;TURN DRIVE ON
	LDK	A,250
	CALL	DELAY		;WAIT FOR MOTOR SPIN UP
	LDK	A,250
	CALL	DELAY		;2ND DELAY

	LDK	A,1		;INDICATED DRIVE WAS NOT SELECTED
	ORA	A		;SET FLAGS

:2:	LDK	HL,DACTVE
	STO	0FFH,[HL]
	EI
	RET
	PAGE

SELDEN:
;SELECT SINGLE OR DOUBLE DENSITY
;ENTRY
;SAVTYP	=	BIT 0:
;		1 = SINGLE, 0 = DOUBLE

;EXIT
;NONE
*NOTE	Bit 0 of "PIAAD" :
;	set	=	single density
;	reset	=	double density

	PROC

	LD	A,PIAAD		;PRESENT VALUE OF PIA REG
	ANI	1111_1110B	;CLEAR BIT 0
	MOV	C,A

;SET DENSITY BIT

	LD	A,SAVTYP	;GET DISK TYPE INFO
	RRC			;CBIT <= BIT 0
	JRNC	:1		;IF "SAVTYP" BIT0 IS 0

	SBIT	0,C		;SET BIT 0 OF REG C

:1:	CALL	OPAD		;FUNCTION PIA
	RET
	PAGE

WBUSY:
;WAIT FOR BUSY TO CLEAR
;This routine must wait for 2 seconds
;2 seconds is the time it takes for the chip to seek 39 tracks and have five index holes go by.
;ENTRY
;NONE

;EXIT
;A	=	0FFH IF TIME OUT OCCURRED
;CBIT	=	SET "  "  "   "

	PROC

	LDK	BC,0

:LOOP:	LD	A,D.STSR	;(13)
	BIT	0,A		;(8) DS.BSY
	JRZ	:1		;(7) GOOD RETURN

	EX	[SP],HL		;(23) DELAY
	EX	[SP],HL		;(23) DELAY
	EX	[SP],HL		;(23) DELAY
	EX	[SP],HL		;(23) DELAY
	DEC	BC		;(6)
	MOV	A,B		;(4)
	OR	C		;(4)
	JRNZ	:LOOP		;(12) IF NOT TIME-OUT

	LDK	A,0FFH		;TIME OUT ERROR
;	CALL	FORINT		;RESET BUSY
	STC			;SET ERROR

:1:	RET
	PAGE

RDSKD:
;SELECT DRIVE BY SETING THE "PIA" WITH THE VALUE SPECIFIED BY C
;ENTRY
;C	=	DRIVE

;EXIT
;NONE
	PROC

	LD	A,PIABD
	ANI	0011_1111B	;GET VIO OFFSET AND BELL
	OR	C
	MOV	C,A
	CALL	OPBD		;FUNCTION PIO-B
	RET
	PAGE

DMARD:
;TRANSFER DATA FROM CONTROLER TO MEMORY
;ENTRY
;BC	=	BYTES TO TRANSFER
;HL	=	FWA OF BUFFER

;EXIT
;HL	=	NEXT ADDRESS
;DE	=	D.STSR

	PROC

	LDK	DE,D.STSR	;(10)

:LOOP:	LD	A,[DE]		;(7) GET STATUS
	RAR			;(4)
	RNC			;(5) RETURN IF NO BUSY
	RAR			;(4)
	JNC	:LOOP		;(10) IF NO DRQ

	LD	A,D.DATR	;(13) GET BYTE
	STO	A,[HL]		;(7) STORE BYTE
	INC	HL		;(6)
	DEC	BC		;(6)
	MOV	A,B		;(4)
	ORA	C		;(4)
	JNZ	:LOOP		;(10)

	RET
	PAGE

DMAWRT:
;Xfer data from memory to disk
;ENTRY
;BC	=	BYTES TO TRANSFER
;HL	=	FWA OF BUFFER

;EXIT
;HL	=	NEXT ADDRESS

	PROC

	LDK	DE,D.STSR

:LOOP:	LD	A,[DE]		;GET STATUS
	RAR
	RNC			;RETURN IF NO BUSY
	RAR
	JNC	:LOOP		;IF NO DRQ

	LD	A,[HL]		;GET BYTE
	STO	A,D.DATR	;STORE BYTE
	INC	HL
	DEC	BC
	MOV	A,B
	ORA	C
	JNZ	:LOOP

	RET
	PAGE

DDRV:
;Deselect drive
;Entry
;SDISK	=	current disk drive
	PROC

	LD	A,PIABD
	AND	1_1111b
	MOV	C,A
	JMP	OPBD		;deselect last drive
	TITLE	'FORMAT'
*[7]

FORMAT:
;	This proc will format the next track in IBM 3740 format consisting of 40 tracks, with each
;track containing 10 sectors.

;Entry
;BC	=	FWA of buffer
	;BUF+0	=	DW length
	;BUF+2	=	beginning of data
	;SAVTRK	=	THE TRACK TO BE FORMATED

;EXIT
;NONE

	PROC

	STO	BC,DMADR	;SAVE BC

;SELECT DRIVE

	CALL	SELDRV
	JRC	:ERROR

;TEST FOR STEP OR NO-STEP

	LDK	HL,SAVTRK
	LD	A,D.TRKR	;TRACK REG
	CMP	[HL]
	JRZ	:1		;IF SAVTRK AND TRACK REG ARE THE SAME SKIP THE STEP

;STEP IN ONE TRACK

	LD	A,SEKDEL
	ORI	0001_0000B	;UPDATE
	STO	A,SEKDEL	;SET UP SEKDEL

	CALL	STEPIN

	PUSH	AF		;SAVE FLAGS
	LD	A,SEKDEL
	ANI	0000_0011B	;ONLY SPEAD LEFT
	STO	A,SEKDEL	;RESET SEKDEL
	POP	AF		;RESTORE

	JRC	:ERROR

;SET "DMADR"

:1:	LD	HL,DMADR	;GET ADDRESS

	LD	C,[HL]
	INC	HL
	LD	B,[HL]		;BC = LENTH OF FORMAT DATA

	INC	HL
	STO	HL,DMADR	;SET DMA

;FORMAT TRACK

	CALL	FMTTRK
	JRC	:ERROR

	XRA	A
	RET

:ERROR:	LDK	A,0FFH
	ORA	A
	RET



HCBOOT:
;IF "ESC" IS PRESSED IN RESPONCE TO THE FIRST PROMPT THIS IS THE PLACE TO PUT A COLD BOOT LOADER OTHER
;THAN THE FLOPPY ONE SUPPLIED.
;ENTRY
;NONE

;EXIT
;NONE

	PROC

	JMP	START


RLWA	=	*		;LWA OF ROM RESIDENT CODE

	MSG	'LENGTH OF THIS ROM IS = ',RLWA-1
	IF	RLWA > 0FFBH
.9	ERROR	CODE TOO LARGE..
	ENDIF

	ECHO	0FFFH-RLWA  !	DB   0FFH
	ENDM

;	END
 