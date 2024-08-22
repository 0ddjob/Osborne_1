	page

HOME:
;
;	Returns disk to home.  This routine sets the track number
;	to zero.  The current host disk buffer is flushed to the
;	disk.

	CALL	FLUSH			;Flush host buffer
	XRA	A
	STO	A,HSTACT		;Clear host active flag
	STO	A,UNACNT		;Clear sector count
	STO	A,SEKTRK
	STO	A,SEKTRK+1
	RET
	PAGE

SELDSK:
;	Selects disk drive for next transfer.
;
;	ENTRY	C  = disk selection value (0..15).
;		DE and 1 = 0, first call for this disk.
;
;	EXIT	HL = 0, if drive not selectable.
;		HL = DPH address if drive is selected.

	PROC
	PUSH	IX		;Save user IX
	MOV	A,C
	CPI	NDSK
	JNC	SELD		;If invalid drive number
	STO	A,SEKDSK
	MOV	L,C
	MVI	H,0
	ADD	HL,HL		;*2
	ADD	HL,HL		;*4
	ADD	HL,HL		;*8
	ADD	HL,HL		;*16
	MOV	A,E		;get initial bit
	LDK	DE,DPBASE
	ADD	HL,DE		;HL = DPH address
	STO	HL,SAVDPH

	MOV	E,A		;Restore initial bit
	CALL	CHKSEL		;Check to see if density needs to be determined
	JNZ	SELER		;Unable to determine density, error return

	LDK	DE,10		;form dpb address
	ADD	HL,DE		;to get type
	LD	E,[HL]
	INC	HL
	LD	D,[HL]		;dpb address in DE
	DEC	DE
	LD	A,[DE]		;get disk type
	STO	A,SEKTYP	;and store value

	LD	HL,SEQ		;Get current sequence count
	STO	L,[IX+0]
	STO	H,[IX+1]	;Store seq # in LASTA or LASTB

	LD	HL,SAVDPH
	POP	IX		;Restore user IX
	RET
	PAGE

;	Select disk error handling

SELER:	LDK	DE,FORERR
	ANI	1		;Is diskette unformatted?
	JRNZ	SELER1		;Yes
	LDK	DE,DENERR	;No, get density error message

SELER1:	LD	A,SEKDSK
	ADD	A,'A'
	STO	A,DRV		;Indicate drive in message
	STO	A,DRV1
	CALL	PRINT		;Print appropriate message on console

SELD:	POP	IX		;Restore user IX
	LDK	HL,0
	LDA	CDISK
	SUB	C
	RNZ			;If default drive not in error
	STO	A,CDISK
	RET

DENERR:	DB	DENL
	DB	CR,LF,'Can''t recognize disk on drive '
DRV:	DS	1
DENL:	=	*-DENERR-1

FORERR:	DB	FORL
	DB	CR,LF,'Unformatted disk on drive '
DRV1:	DS	1
FORL:	=	*-FORERR-1
	PAGE

CHKSEL:
;	Determines if new DPB should be established
;	
;	ENTRY	C = disk selection value (0..15)
;		E & 01 = 0, first call for this disk
;
;	EXIT	IX = address of drive sequence number
;		Z status bit set, good return
;		Z status bit clear, error return

	PROC
	PUSH	HL		;Save user HL
	PUSH	BC
	LDK	IX,LASTA	;Get last count for selected drive
	MOV	A,C		;Current drive to A - reg
	ORA	A		;Is this drive A?
	JRZ	CHKSEQ		;Yes, check sequence number
	INC	IX		;No, form address for B
	INC	IX

CHKSEQ:	LD	C,[IX+0]	;Get last sequence number for this drive
	LD	B,[IX+1]
	LD	HL,SEQ		;Get current sequence number
	SBC	HL,BC		;Compare seq #'s
	POP	BC
	PUSH	IX

	BIT	0,E		;First call for this disk?
	JRZ	:10		;Yes, fill in DPB

	MOV	A,H		;No, check elasped time
	ORA	A		;Elasped time < 4 sec
	JRZ	GRET		;Yes, good return
	CPI	02
	JRNC	:10
	MOV	A,L
	CPI	0A0H		;Elasped time > 6 sec
	JRC	GRET		;No, indicate good return

:10:	CALL	GDEN
	JR	RETURN

GRET:	XRA	A

RETURN:	POP	IX
	POP	HL
	RET
	PAGE
	
GDEN:
;	Fills in DPH with appropriate values after determining type and # of sectors
;
;	ENTRY	SEKDSK = DISK TO SELECT
;
;	EXIT	A =  0, ZERO FLAG SET .... GOOD RETURN
;		A = -1, ZERO FLAG CLEAR .. ERROR RETURN
;
;	USES ALL REGISTERS

	PROC
 	CALL	GETDEN
	JRNZ	SELD1		;Error, unformatted disk

	MOV	A,B		;# of physical sectors into A
	BIT	2,C		;bits 2 & 3 of reg C indicate sector size
	JRZ	:10		;convert # psectors into # 128 byte sectors
	SLA	A		;A=A*2

:10:	BIT	3,C		
	JRZ	:20		
	SLA	A		
	SLA	A		;A=A*4 or A=A*8

:20:	LDK	B,NUMDPB	;Number of DPB's to check for
	LDK	HL,DPBSTART+1	;get dpb address of # logical sectors
	LDK	DE,16		;next address
	LDK	IX,XTAB		;first translation table address

:LOOP:	CMP	[HL]		;compare # of logical sectors
	JRZ	:30		;match  check for same type
:LP1:	INC	IX		;no match increment translation table address
	INC	IX
	ADD	HL,DE		;also get next dpb
	DJNZ	:LOOP		;have we checked all dbp's no go to loop
	JR	SELD2		;Yes, no match error return

:30:	PUSH	AF		;here on match of # of logical sectors
	SHLD	DPB		;save current dpb address
	DEC	HL		;now check type
	MOV	A,C		;value of type returned from getden
	CMP	[HL]		;compare to dpb type
	JRZ	:40		;type is ok 
	POP	AF		;number of physical sectors into A reg
	INC	HL		;type does not match
	JR	:LP1		;check next dpb

:40:	POP	AF		;Restore stack

	LD	HL,SAVDPH	;Get header address
	LD	A,[IX+0]	;Get translation table address
	STO	A,[HL]		;Store address in header
	INC	HL
	LD	A,[IX+1]
	STO	A,[HL]

	LDK	DE,9		;Form address in header for DPB
	ADD	HL,DE
	LDK	IX,DPB		;Store DPB address in header
	LD	A,[IX+0]
	STO	A,[HL]
	INX	HL
	LD	A,[IX+1]
	STO	A,[HL]

	XRA	A		;Indicate good return
	RET
	space 3,8
;	Error return section

SELD1:	MVI	A,1		;Indicate unformatted disk Z-flag = clear, A = 1
	RET

SELD2:	ORI	02		;Indicate unrecognizable disk Z-flag = clear, A = 2
	RET
	PAGE

GETDEN:
;	Gets density of selected disk
;
;	ENTRY	SEKDSK = Current drive
;
;	EXIT	C = TYPE    	    7   6   5   4   3   2   1   0
;				    |   |   |   |   |   |   |   |
;		Undef = 0 <---------+---+---+---+   |   |   |   |
;		Bytes/sector <----------------------+---+   |   |
;		Sides <-------------------------------------+   |
;		Density <---------------------------------------+
;
;		B = # of physical sectors per track
;		A = 0, good return
;		A <> 0, error return
;		Z-bit set, good return
;		Z-bit clear, error return

SENDEN:	=	130H

	PROC
	LD	A,SDISK		;Save current value
	STO	A,TEMDSK	;of SDISK
	LD	A,SAVTYP	;and SAVTYP
	STO	A,TEMTYP	;(SDISK & SAVTYP are used by SENDEN)

	LD	A,SEKDSK	;Disk to be select
	STO	A,SDISK		;in SDISK (parameter to SENDEN)

	LDK	DE,SENDEN	;Call SENDEN
	CALL	ROMJMP

	LD	A,TEMDSK	;Restore caller's value of SDISK
	STO	A,SDISK

	LD	A,SAVTYP	;Exit TYPE parameter
	MOV	C,A		;into C - Reg

	LD	A,TEMTYP	;Restore caller's SAVTYP
	STO	A,SAVTYP

	RNZ	ERRET		;Error return, flag set by SENDEN

	XRA	A		;Indicate good return
	RET
	PAGE

SETTRK:
;	Sets track number.  The track number is saved for later
;	use during a disk transfer operation.
;
;	ENTRY	BC = track number.

	STO	BC,SEKTRK	;Set track
	LHLD	UNATRK
	MOV	A,L
	XRA	C
	MOV	C,A
	MOV	A,H
	XRA	B
	ORA	C
	RZ			;If same track
;	JMP	CUNACT
	space	4,6
CUNACT:
;	Clear Unallocated block count (force pre-reads).

	XRA	A		;A = 0
	STO	A,UNACNT		;Clear unallocated block count
	RET
	space	4,10
SETSEC:
;	Set the sector for later use in the disk transfer.  No
;	actual disk operations are perfomed.
;
;	Entry	BC = sector number.

	MOV	A,C
	STO	A,TEMSEC	;sector to seek
	RET
	space	4,12
SETDMA:
;	Sets Disk memory address for subsequent disk read or
;	write routines.  This address is saved in DMAADR until
;	the disk transfer is performed.
;
;	ENTRY	BC = Disk memory address.
;
;	EXIT	DMAADR = BC.

	STO	BC,DMAADR
	RET
	space	4,30
SECTRN:
;	Translates sector number from logical to physical.
;
;	ENTRY	DE = 0, no translation required.
;		DE = translation table address.
;		BC = sector number to translate.
;
;	EXIT	HL = translated sector.

	LDA	UNASEC
	CMP	C
	CNZ	CUNACT		;If sectors do not match
	MOV	A,C
	STO	A,LOGSEC
	MOV	L,C
	MOV	H,B

	MOV	A,E		;Check if translation is required
	ORA	D
	RZ			;None required, return

TRAN:	ADD	HL,DE		;Translation required
	MOV	L,M
	MVI	H,0
	RET
