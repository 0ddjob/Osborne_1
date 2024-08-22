	page
MSIZE:	=	59
CCP:	=	0CB00H		;location of ccp
BIOS:	=	ccp+1600h
BDOS:	=	ccp+806h

	MSG	'DDT R (relocation value) = ',1F80H-BIOS
	MSG	'Assemblying BIOS for LWA of ', LWAMEM,'h.'

;	CP/M to host disk constants

HSTSIZ:	=	1024		;Blocking/Deblocking buffer size
FPYSIB:	=	2048/128	;Sectors in floppy disk block (Osborne single density block size = 2K)
FPYDIB:	=	1024/128	;Sectors in floppy disk block (Osborne double density block size = 1K)

;	CP/M disk control block equates which define the
;	disk types and maximum storage capability of each
;	disk type.

DSKS1:	=	5	;Single density ( 256), single sided.
DSKD1:	=	0Ch	;Double density (1024), single sided.
XEROX:	=	1	;Single density ( 128), single sided.
IBM:	=	8	;Double density ( 512), single sided.
DEC:	=	8

S1DSM:	=	((40-3)*2*10)/FPYSIB
D1DSM:	=	((40-3)*8*5 )/FPYDIB
XXDSM:	=	((40-3)*1*18)/FPYDIB
IBMDSM:	=	((40-1)*4*8 )/FPYDIB
DECDSM:	=	((40-2)*4*9 )/FPYDIB

;	BDOS constants on entry to write

WRALL:	=	0		;write to allocated
WRDIR:	=	1		;write to directory
WRUAL:	=	2		;write to unallocated
	space	4,10
;	ROM equates.

ENROM:	=	0		;Port to enable ROM
DIROM:	=	1		;Port to disable ROM
	page

;	Macro for generating Control Blocks for disk drives
;	The format of these disk control blocks are as follows:
;	16 bits = -> translation table.
;	48 bits = Work area for CP/M.
;	16 bits = -> DIRBUF.
;	16 bits = -> Parameter block.
;	16 bits = -> check vector.
;	16 bits = -> allocation vector.

NDSK:	SET	0		;Number of disk drives
NOFDD:	SET	0		;Number of floppy disk drives
ALVSZ:	SET	0		;Allocation vector size
CSVSZ:	SET	0		;Check vector size

	LIST	M
DPHGEN	MACRO	TYPE,XLATE,DIRBUF,DPBADR
NDSK:	SET	NDSK+1
	DW	%2
	DW	0,0,0
	DW	%3
	DW	%4
	DW	CSV+CSVSZ
	DW	ALV+ALVSZ
NOFDD:	SET	NOFDD+1
CSVSZ:	SET	CSVSZ+(64/4)
ALVSZ:	SET	ALVSZ+((D1DSM+7)/8)
	ENDM
	space	4,10
;	Macro for generating the Disk Parameter Blocks.
;
;	Disk type definition blocks for each particular mode.
;	The format of these areas are as follow:
;	8 bit = disk type code
;	16 bit = Sectors per track
;	8 bit  = Block shift
;	8 bit  = BS mask
;	8 bit  = Extent mask
;	16 bit = Disk size/1024 - 1.
;	16 bit = Directory size.
;	16 bit = Allocation for directory.
;	16 bit = check area size.
;	16 bit = offset to first track.

DPBGEN	MACRO	TYPE,SPT,BSH,BSM,EXM,DSM,DIRSIZ,ALVMSK,OFFSET
	DB	%1
	DW	%2
	DB	%3,%4,%5
	DW	%6-1,%7-1,REV (%8)
	DW	(%7+3)/4
	DW	%9
	ENDM
	page

;	The following jump table defines the entry points
;	into the CBIOS for use by CP/M and other external
;	routines; therfore the order of these jump cannot
;	be modified.  The location of these jumps can only
;	be modified by 400h locations, which is a restriction
;	of MOVCPM.

	ORG	BIOS

	JMP	CBOOT		;Cold boot
	JMP	WBOOT		;Warm boot
	JMP	CONST		;Console status (input)
	JMP	CONIN		;Console input
	JMP 	CONOUT		;Console output
	JMP	LIST		;List output
	JMP	PUNCH		;Punch output
	JMP	READER		;Reader input
	JMP	HOME		;Set track to zero
	JMP	SELDSK		;Select disk unit
	JMP	SETTRK		;Set track
	JMP	SETSEC		;Set sector
	JMP	SETDMA		;Set Disk Memory Address
	JMP	READ		;Read from disk
	JMP	WRITE		;Write onto disk
	JMP	LISTST		;Return LST: device status
	JMP	SECTRN		;Sector translation routine

;	Extensions
RRI:	JMP	ROMRI
	JMP	ROMJMP
FMTJ:	CALL	ROMCDE		;Rom resident call
SBAUD:	CALL	ROMCDE

;	IEEE-488 vectors
IEB1C:	CALL	ROMCDE		;Control Out
IEB2C:	CALL	ROMCDE		;Status In
IEB3C:	CALL	ROMCDE		;Go To Standby
IEB4C:	CALL	ROMCDE		;Take Control
IEB5C:	CALL	ROMCDE		;Output Interface Message
IEB6C:	CALL	ROMCDE		;Output Device Message
IEB7C:	CALL	ROMCDE		;Input Device Message
IEB8C:	CALL	ROMCDE		;Parallel Poll

	CALL	ROMCDE		;extensions
	CALL	ROMCDE		;  for
	CALL	ROMCDE		;    memory-mapped video

	JMP	ACICTL		;hook for serial command port write
	JMP	ACISTAT		;hook for serial status port read
	