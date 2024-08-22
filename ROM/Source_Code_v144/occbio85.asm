 	page


; The following routines will use the IOBYTE to transfer 
; control to the appropriate device driver

CONST:
;	Returns console status

	proc
	LDK	HL,PTR_CSTAT	;Status table
	JR	GODISPCH	;Call appropriate rtn
	space 4,7
CONIN:
;	Reads input character from device

	proc
	LDK	HL,PTR_CINP	;Table of input rtns
	JR	GODISPCH
	space 4,8
CONOUT:
;	Puts output character to device
;	C contains output character

	proc
	LDK	HL,PTR_COUT	;Table of output rtns
	space 4,7
GODISPCH:
	LDK	B,1		;number of shifts required to align
				;CONSOLE field
	JR	DISPCH
	space 4,20
LIST:
;	List device character output

	proc
	LDK	HL,PINTFG	;Get printer initialiation flag
	LD	A,[HL]
	ORA	A
	JRNZ	LIST1		;Printer previously initialized

	DEC	[HL]		;Non-zero value to PINTFG
	PUSH	BC		;Save character
	INC	HL
	EX	HL,DE		;Get initialization string
	CALL	PSTR		;and print it
	POP	BC		;Restore character

LIST1: 	LDK	B,4Š	LDK	HL,PTR_LIST	;table of list routines
	JR	DISPCH
	space	4,8
PUNCH:
;	Output to punch

	proc
	LDK	B,6
	LDK	HL,PTR_PNCH	;Punch routines
	JR	DISPCH
	space	4,8
READER:
;	Reader input

	proc
    	LDK	B,8
	LDK	HL,PTR_RDR	; reader routines
	JR	DISPCH
	space	4,14
LISTST:
;	Return the ready status for the list device.
;
;	EXIT	A = 0 (zero), list device is not ready to
;		accept another character.
;		A = FFh (255), list device is ready to accept
;		a character.

	proc
	LDK	B,4		;number of left shifts thru carry
				;to align LIST field of IOBYTE
	LDK	HL,PTR_LST	;list status routines
;	JR	DISPCH
	page

DISPCH:
;	on entry here reg B contains the left shift count
;	required to align the iobyte field to bit 1 position.
;	and reg HL contains address of select table

	proc
	LD	A,IOBYTE

DSPCH1:
	RAL
	DJNZ	DSPCH1
	ANI	6		;get select field*2
	MOV	E,A
	LDK	D,0		;DE = iobyte field * 2
	DAD	DE
	MOV	E,[HL]Š	INC	HL
	MOV	H,[HL]		;get the routine address
	MOV	L,E		;into hl and xchange with pc
	JMP	[HL]
	PAGE

;	Dispatch Table

PTR_CSTAT:
	DW	CNST		; keyboard status
	DW	SISTAT		; serial port input status
	DW	PISTAT		; parallel input status
	DW	IEINSTAT	; status of input device on IEEE port

PTR_RDR:
PTR_CINP:
	DW	KEYINP		; get input from keyboard
	DW	SPINP		; serial port input
	DW	PARINP		; parallel input
	DW	IEINP		; ieee port input

PTR_PNCH:
PTR_COUT:
	DW	CRTOUT		; output character to crt
	DW	SPOUT 		; serial port output
	DW	PAROUT		; parallel output
	DW	IEOUT		; ieee port output

PTR_LST:
	DW	CRSTAT
	DW	SOSTAT		; serial output status
	DW	POSTAT		; parallel output status
	DW	IEOSTAT		; ieee output status

PTR_LIST:
	DW	CRTOUT
	DW	PRTOUT
	DW	PAROUT
	DW	IEOUT
	page

CNST:
;	C O N S O L   S T A T U S
;
;	This routine samples the Console status and returns the
;	following values in the A register.
;
;	EXIT	A = 0 (zero), means no character
;		currently ready to read.
;
;		A = FFh (255), means character
;		currently ready to read.

;	check if any translated keys are pending

	proc
	LD	A,COUNT
	ORA	A
	JRNZ	CNST5

;	if no xlated keys pending, check keyhit flagŠ
	LD	A,LKEY		;Get Key hit flag
	ORA	A
	RZ			;If data not available

CNST5:
	ORI	0FFh
	RET
	page

KEYINP:
; 	Gets keystroke from ROM keyboard driver.
;	Translates the codes 80h to 8fh as per table. 
;
; 	EXIT	 A = translated code in ASCII

BASVL0:	=	80h			;lowest value of translatable keys
	proc
	PUSH	IX			;Save user IX

KIN0:	CALL	AHSCRL
	LDK	HL,COUNT
	LD	A,[HL]			;get number of xlated keys
	ORA	A
	JRZ	KIN10			;if keys pending then
	LD	IX,XLTKEY		;get base address in IX reg

	LD	A,[IX+0]		;simulate LD  A,(IX+COUNT)
COUNT:	=	*-1			;to get next key from table

	INC	[HL]			;increment count

KRET:	POP	IX			;Restore user IX
	RET

KIN10:
	LDK	E,09
	CALL	ROMCD1

;	When console has returned this code will check
;	for function key and preform some translation

	CPI	80h		;function keys have value
	JRC	KRET		;80h-8dh
	CPI	8Eh		;do a shift to make pointer 
	JRNC	KRET		;into table and return if not function key
	SLA	A
	MOV	E,A
	LDK	D,0
	LDK	IX,XLTBL
	ADD	IX,DE
 	LD	L,[IX+0]
	LD	H,[IX+1]
	LD	E,[IX+2]
	LD	D,[IX+3]
	STO	DE,XLTKEYŠ	SBC	HL,DE
	MOV	A,L
	STO	A,COUNT
	JR	KIN0
        page

AHSCRL:
;	ahscrl - does auto horizontal scroll if required.

	proc
	LD	A,AHSENB
	OR	A
	RZ

	LD	HL,CURS		;get cursor
	ADD	HL,HL

;	check for cursor in home window

	LDK	A,100
	CMP	L
	JRC	RHC		;jump if cursor not in home window
	LD	A,PIAAD		;check for screen at home
	SUB	VFLO
	RZ			;screen at home
	XRA	A		;home screen
	JR	SCRL

RHC:
;	check right-hand margin

	LD	A,PIAAD		;a=horizontal screen position
	SUB	VFLO
	ADD	A,100		;window size*2 (50)
	CMP	L
	JC	:30		;move screen when cursor about to go off
				;the right hand margin
;	check left hand margin

	SUB	90
	CMP	L		;check left margin
	RC			;cursor in window return
	MOV	A,L
	SUB	10
	RZ			;return if cusor at column 2
	JR	SCRL

:30:	MOV	A,L
	SUB	100

SCRL:	RAR
	ADD	A,' '
	LK	HL,ESCSQ+3
	STO	A,[HL]
	LD	A,PIABD
	AND	1Fh
	ADD	A,' '
	DEC	HL
	STO	A,[HL]			;escsq+2 = vert. coords
	DEC	HL
	DEC	HL			;point to start of esc seq
	LK	B,4

:50:	PUSH	BCŠ	PUSH	HL
	LD	C,[HL]
	CALL	CRT10
	POP	HL
	POP	BC
	INC	HL
	DJNZ	:50	
	RET	

ESCSQ:	DB	ESC			;set screen coord escape sequence
	DB	'S'
	DB	0			;** y coord
	DB	0			;** x coord
	page

CRSTAT:
;	Returns status of crt.
;	crt is always ready

	proc
	ORI	0FFh
	RET
	space	4,10
CRTOUT:
;	ENTRY	 C = output character

EF_ESC:	=	8		;escape flag bit definitions
EF_GR:	=	1

	proc
	LD	A,ESCH
	AND	EF_ESC+EF_GR
	JRNZ	CRT10
	MOV	A,C
	CPI	14h
	JRNZ	CRT10
	LD	A,AHSENB
	CMA
	STO	A,AHSENB
	RET

CRT10:
	LDK	E,0Ch		  ;output to crt
	JMP	ROMCD1
	page

SOSTAT:
;	Gets status of output device attached to serial port

	proc
	LDK	E,2Dh
	JR	JMPROM		;Call rom driver
	space 4,8
SISTAT:
;	Gets status of input device attached to serial port

	proc
	CALL	ACISTAT
	ANI	SI.RRDY
	RZ			;return with not ready status
	ORI	TRUE
	RET
	space 4,8
SPINP:
;	Inputs a character from the serial port 

	proc
	LDK	E,15h
	JR	JMPROM
	space 4,8
SPOUT:
;	Outputs character in reg c to the serial port (list device)

	proc
	LDK	E,0Fh
	JR	JMPROM
	page

PRTOUT:
;	routine does LIST output and printer protocols

XON:	=	11h
XOFF:	=	13h
ETX:	=	3
ACK:	=	6

	proc
	CALL	SPOUT
	LD	A,PRNTER
	ORA	A
	RZ
	ANI	2
	JRNZ	XONXOF
	LDK	A,0Dh
	CMP	C
	RNZ

	LDK	C,ETX
	CALL	SPOUT

PRT10:
	CALL	SPINP
	ANI	7Fh		;mask out parity bit
	CPI	ACK
	JRNZ	PRT10
	RET

XONXOF:
	CALL	SISTAT
	ORA	A
	RZ
	CALL	SPINP
	ANI	7Fh		;mask out parity bit
	CPI	XOFF
	RNZ

PRT20:
	CALL	SPINP
	ANI	7Fh		;mask out parity bit
	CPI	XON
	JRNZ	PRT20
	RET
	PAGE

JMPROM:	JMP	ROMCD1
	space	4,10
ACICTL:	=	SBAUD
;	Outputs character in c to the ACIA CTL port.
	space	4,10
ACISTAT:
;	Returns usart status in A
	
	PROC
	LDK	E,81H		;Low order byte of ACISTAT routine in ROM
	JR	JMPROM	
	page

IEINSTAT:
;	Returns status of IEEE input port
;
;	EXIT	A = 0   character not available
;		A = FFH	character available

	proc
	LDK	E,87H
	JR	JMPROM
	space	4,10
IEOSTAT:
;	Returns	status of IEEE output port	
;
;	EXIT	A = 0   transmitter not ready
;		A = FFH	transmitter ready

	proc
	LDK	E,8AH
	JR	JMPROM
	space	4,10
IEINP:
;	Reads a character from IEEE port 

	LDK	E,8DH
	JR	JMPROM
	space	4,10
IEOUT:
;	Outputs the character in reg C to IEEE port

	proc
	LDK	E,90H
	JR	JMPROM
	page

POSTAT:
;	Gets status of the parallel (centronix) printer
;	attached to the ieee port

	proc
	LDK	E,96H
	JR	JMPROM
	space	4,10
PISTAT:
;	Gets status of the input device attached to the
;	parallel port

	proc
	LDK	E,93H
	JR	JMPROM
	space	4,10
PARINP:
;	Inputs a character from parallel port.

	proc
	LDK	E,99H
	JR	JMPROM
	space	4,10
PAROUT:
;	Outputs the character in c to the IEEE port treating the
;	port as a parallel port.

	proc
	LDK	E,9CH
	JR	JMPROM		
	page

SW2ROM:
;	Switches to rom
;	saves all registers

	PROC
	DI
	PUSH	AF
	XRA	A
	OUT	0
SWMEM:	STO	A,ROMRAM
	POP	AFŠ	EI
	RET
	space	4,10
SW2RAM:
;	Switches to ram
;	preserves all registers

	PROC
	DI
	PUSH	AF
	LDK	A,1
	OUT	1
	JR	SWMEM

;	STO	A,ROMRAM
;	POP	AFŠ;	EI
;	RET
