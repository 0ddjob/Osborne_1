	page
READ:
;	a CP/M 128 byte sector.
;
;	EXIT	A = 0, successful read operation.
;		A = 1, unsucessful read operation.
;		Z bit = 1, successful read operation.
;		Z bit = 0, unsuccessful read operation.

	PROC
	CALL	MVINFO		;Move information for transfer
	XRA	A		;Set flag to force a read
	STO	A,UNACNT		;Clear sector counter
	CALL	FILL		;Fill buffer with data
	POP	HL
	POP	DE
	LDK	BC,128		;Move 128 bytes
	LDIR
	LD	A,ERFLAG
	ORA	A
	RZ			;If no error

	XRA	A
	STO	A,HSTACT	;Clear host active (A = 0)
	ORI	1		;Indicate error
	RET
	PAGE

WRITE:
;	the selected 128 byte CP/M sector.
;
;	ENTRY	C = 0, write to a previously allocated block.
;		C = 1, write to the directory.
;		C = 2, write to the first sector of unallocated
;		data block.
;
;	EXIT	A = 0, write was successful.
;		A = 1, write was unsucessful.
;		Z bit = 1, write was successful.
;		Z bit = 0, write was unsucessful.

	PROC
	CALL	MVINFO		;Move information for transfer
	MOV	A,C		;Write type in c
	STO	A,WRTYPE
	CPI	WRUAL
	JRNZ	WRIT2		;If write to allocated
	LD	A,SEKTYP
	CPI	5		;Check for 2K block size
	LDK	A,2048/128
	JRZ	WRIT1		;Type = Osborne single density (2K block size)
	LDK	A,1024/128	;Otherwise 1K block size

WRIT1:	STO	A,UNACNT
	LD	HL,SEKTRK
	STO	HL,UNATRK	;UNATRK = SEKTRK
	LD	A,LOGSEC
	INC	A
	JR	WRIT3

WRIT2:	LDK	HL,UNACNT
	LD	A,[hl]
	ORA	A
	JZ	WRIT4		;If no unallocated records
	DEC	[hl]		;dec unalloc record count

	LDK	HL,DPBASE-16+10	;Get number of sectors per track
	LDK	DE,16		;To point to next DPB
	LD	A,SEKDSK
	MOV	B,A
	INC	B

WRIT25:	ADD	HL,DE
	DJNZ	WRIT25

	LD	E,[HL]
	INC	HL
	LD	D,[HL]
	LD	A,[DE]		;Number of sectors per track in A reg
	MOV	B,A
	LD	A,UNASEC	;Increment logical sector
	INC	A
	CMP	B
	JRNZ	WRIT3		;If not end of track
	LD	HL,UNATRK
	INC	HL
	STO	HL,UNATRK
	XRA	A

WRIT3:	STO	A,UNASEC
	LDK	A,0FFh

WRIT4:	CALL	FILL
	POP	DE
	POP	HL
	LDK	BC,128
	LDIR

	LDK	A,1
	STO	A,HSTWRT	;HSTWRT = 1
	LD	A,ERFLAG
	ORA	A
	RNZ			;If any errors occurred

	LD	A,WRTYPE	;write type
	CPI	WRDIR		;to directory?
	CZ	FLUSH		;Force write of directory
	LD	A,ERFLAG
	ORA	A
	RET
	page

FILL:
;	Fills host buffer with approprite host sector.
;
;	ENTRY	A = 0, Read required if not in buffer.
;		0therwise read not required.
;
;	EXIT	On exit the stack will contain the following
;		values:
;	      POP     x         ;x = host record address.
;	      POP     y		;y = caller's buffer address.

	proc
	STO	A,RDFLAG	;Save read flag

	LD	A,SEKTYP
	RRC
	RRC
	ANI	03
	MOV	B,A
	LDK	DE,HSTBUF	;initial offset
	LD	A,SEKSEC	;Get logical sector
	LDK	HL,128		;128 byte records
	JRZ	FILL35		;Jump when sector size <> 128, no deblocking necessary

FILL2:	EX	DE,HL
	RRC
	JRNC	FILL3		;If low bit not set
	ADD	HL,DE		;Add bias to offset

FILL3:	EX	DE,HL
	ADD	HL,HL
	ANI	07Fh		;Mask sector
	DJNZ	FILL2

FILL35:	STO	A,SEKSEC	;SEKSEC = physical sector - 1
	LD	HL,DMAADR
	XTHL			;Set return parameters
	PUSH	DE
	PUSH	HL		;Set return address

	LDK	HL,HSTACT	;host active flag
	LD	A,[HL]
	STO	1,[HL]		;always becomes 1
	ORA	A
	JRZ	FILL6		;If host buffer inactive
	LDK	HL,HSTTYP
	LD	A,SEKTYP
	CMP	[HL]
	JRNZ	FILL5
	LDK	HL,HSTSEC
	LDK	DE,SEKSEC
	LDK	B,SEKDSK-SEKSEC+1

FILL4:	LD	A,[DE]
	CMP	[HL]
	JRNZ	FILL5		;If mis-match
	INC	HL
	INC	DE
	DJNZ	FILL4		;If all bytes not checked
	RET

FILL5:	CALL	FLUSH		;Flush host buffer

FILL6:	LD	A,SEKDSK	;Move disk 
	STO	A,HSTDSK
	STO	A,ACTDSK
	LD	HL,SEKTRK
	STO	HL,HSTTRK
	STO	HL,ACTTRK
	LD	A,SEKSEC
	STO	A,HSTSEC
	STO	A,ACTSEC
	LD	A,SEKTYP
	STO	A,HSTTYP
	STO	A,ACTTYP
	LD	A,RDFLAG
	ORA	A
	RNZ			;If no read required

	LDK	A,0		;Read
	JR	FINAL
	page

FLUSH:
;	Writes out active host buffer onto disk.

	proc
	LDK	HL,HSTWRT
	LD	A,[hl]
	ORA	A
	RZ			;If host buffer already on disk
	STO	0,[hl]
	LD	A,HSTDSK	;Move disk 
	STO	A,ACTDSK
	LD	HL,HSTTRK
	STO	HL,ACTTRK
	LD	A,HSTSEC
	STO	A,ACTSEC
	LD	A,HSTTYP
	STO	A,ACTTYP
	LDK	A,3		;Write flag
;	JMP	FINAL
	PAGE

FINAL:
;	Preforms final transfer processing.
;
;	ENTRY	A = 0 .. read disk.
;		  = 3 .. write disk.
;	Calls: Rom resident routine to read/write ONE
;		sector only.


	MOV	E,A
	LDK	D,0
	LDK	HL,ROMVEC+3*13
	ADD	HL,DE
	STO	HL,SAVADR

	LDK	HL,ACTSEC
	INC	[hl]		;update sector+1

	LD	HL,SAVADR
	EX	DE,HL
	LDK	B,1		;indicate one sector xfer
	CALL	ROMJMP		;process read or write
	STO	A,ERFLAG	;set possible error flag
	RZ			;If no errors

	LDK	HL,ERFLAG
	LD	A,[HL]
	ORI	01h
	STO	A,[HL]	;Set error flag
	RET
