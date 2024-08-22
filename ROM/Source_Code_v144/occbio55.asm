	page

;	B o o t   C P / M   f r o m   d i s k.
;
;	The CBOOT entry point gets control from the cold start
;	loader and is responsible for the basic system initial-
;	ization.  This includes outputting a sign-on message and
;	initializing the following page zero locations:
;
;	   0,1,2: Set to the warmstart jump vector.
;	       3: Set to the initial IOBYTE value.
;	       4: Default and logged on drive.
;	   5,6,7: Set to a jump to BDOS.
;
;	The WBOOT entry point gets control when a warm start
;	occurs, a ^C from the console, a jump to BDOS (function
;	0), or a jump to location zero.  The WBOOT routine reads
;	the CCP and BDOS from the appropriate disk sectors.
;	WBOOT must also re-initialize locations 0,1,2 and 5,6,7.
;	The WBOOT routines exits with the C register set to the
;	appropriate drive selection value.  The exit address
;	is to the CCP routine.

MAGIC:	;THIS SUBROUTINE IS HERE SO THE 80 PLUS OPTION
	;CAN BE CALLED FROM A BASIC PROGRAM. FIRST POKE
	;THE VALUE (0=52,1=100,3=80 columns) IN
	;LOCATION PLUGH, THEN CALL PSINIT

	PUSH	AF			;SAVE ALL REGESTERS
	LD	A,ROMRAM		;SAVE CURRENT BANK STATUS
	CALL	SW2ROM			;ENABLE I/O BANK
	PUSH	AF
	LD	A,PLUGH			;SET THE PHYSICAL SCREEN SIZE
	STO	A,02400h
	POP	AF
	CMP	1			;RESTORE BANK STATUS AT ENTRY
	CZ	SW2RAM
	POP	AF			;RESTORE THE REGESTERS AND FLAGS
	RET

CBOOT:
	LDK	SP,CCP

	CALL	MAGIC

;	LD	A,PLUGH
;	STO	A,02400h

	CALL	SW2RAM

	LD	A,IOBITE	;get iobyte value
	STO	A,IOBYTE	;Set I/O byte to default

	LD	A,BRATE
	MOV	C,A
	CALL	SBAUD		;set baud rate

	LDA	SCRSZE
	STA	LLIMIT		;set screen size

	LD	A,IEEEAD	;Get IEEE device address
	STO	A,IEADR		;and save it in BMRAM

	XRA	A
	STO	A,CDISK		;Set current drive to A
	INC	A

	JR	BCCP		;Do CP/M

WBOOT:				;Warm boot
	LDK	SP,CCP
	CALL	HOME		;flush any buffer

BCPM:	LDK	DE,ROMVEC+3*1	;Set ROM vector address
	CALL	ROMJMP

	MVI	A,2		;indicate warm boot

BCCP:	;Entry	A = 01, if cold boot
;		A = 02, if warm boot

	PUSH	AF		;Save entry
	LDK	BC,DBUF		;Set default data transfer address
	CALL	SETDMA
	LDK	HL,HSTBUF
	STO	HL,DMADR	;set ROM DMA address

;	Clear console control ESC cell
	XRA	A
	STO	A,ESCH		;clear ESC

;	Set-up low core pointer cells
	LDK	A,0C3h		;Store jumps in low memory
	STO	A,0
	STO	A,5
	LDK	HL,BIOS+3
	STO	HL,1
	LDK	HL,BDOS
	STO	HL,6

	LDK	HL,CAUTO
	POP	BC		;cold/warm indicator in b
	LD	A,ACMD
	AND	B
	JRZ	DONE

	LD	A,[HL]
	ORA	A
	JRZ	DONE

	LDK	DE,CCP+7
	LDK	B,0
	MOV	C,A
	LDIR			;Move command line to buffer

	LDK	DE,0
	JR	DONE1

SIGNON:	DB	SIGNL		;Length of signon message
	DB	'Z'-40h
	DB	'Osborne Computer System'
	DB	CR,LF
	DB	MSIZE/10+'0',MSIZE mod 10 + '0'
	DB	'k CP/M vers ',VERS/10+'0','.',VERS mod 10 + '0'
	DB	CR,LF,'CBIOS 1.4',CR,LF
SIGNL:	=	*-SIGNON-1

DONE:	LDK	A,2
	CMP	B
	JRZ	DONE0

	LDK	DE,SIGNON
	CALL	PRINT

DONE0:	LDK	DE,3

DONE1:	LDK	HL,CCP
	ADD	HL,DE
	LD	A,CDISK
	MOV	C,A
	JMP	[HL]
