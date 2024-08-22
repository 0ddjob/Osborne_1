;OCCRAM2.ASM
	TITLE	'Monitor RAM Storage.'
;	Used to assembly ROM resident and CBIOS

	ORG	MRAM

;	Host disk xfer buffer and...
;	Format track template holding buffer
HSTBUF:
	DS	1024+128

;	Directory Buffer
DIRBUF:	=	HSTBUF+1024


TEM	DS	6
RNDV	=	TEM+1	;random number seed
ERCNT	=	RNDV+1	;DW ERCNT
RTRC	=	ERCNT+2	;retry count
RTRY	=	RTRC+1
MPCHR	DS	1	;prompt character
ECHOP	DS	1	;=0, list ehco off
ROMRAM	DS	1	;0= RAM, 1= ROM
DSTSB	DS	6	;Disk status bytes

;	Disk operation temps and control
DMADR	DS	2	;Address for read/write Disk
DMAADR	DS	2	;CBIOS, users DMA

;	Note order of xxxSEC,xxxTRK,xxxDSK must be maintained
;	along with length (1,2,1).
SEKDEL:	DS	1	;Set for seek-restore command in ROM
			;depends on disk type. Siemens = 3h, MPI = 0h
SAVSEC	DS	1	;last sector requested
SAVTRK	DS	2	;last track requested
SDISK	DS	1	;Selected disk drive (0,1)
;SAVTYP	=	0EFD0H	;SELECTED TYPE (sector size)

ACTSEC	=	SAVSEC
ACTTRK	=	SAVTRK
ACTDSK	=	SDISK

SEKSEC	DS	1
SEKTRK	DS	2
SEKDSK	DS	1

HSTSEC	DS	1
HSTTRK	DS	2
HSTDSK	DS	1

TEMSEC	DS	1	;Used in bios only
RDFLAG	DS	1	;Read flag
ERFLAG	DS	1	;Error reporting
WRTYPE	DS	1	;Write operation type

;ALV:	DS	ALVS
;CSV:	DS	CSVS

	DS	ALVS
	DS	CSVS

;	BIOS blocking-deblocking flags
HSTACT:	DS	1	;host active flag
HSTWRT:	DS	1	;Host written flag
UNACNT:	DS	1	;Unalloc rec count
UNATRK:	DS	2	;Track
UNASEC:	DS	1	;Sector
LOGSEC:	DS	1	;Logical sector


LDADR	DS	2
KEYLCK	DS	1	;Zero if locked keyboard
CURS	DS	2	;current cursor position

;	Keyboard scan temporaries
TKEY	DS	1	;Tem holding key
HKCNT	DS	1	;Debounce key
LKEY	DS	1	;Last valid keystroke
CKEY	DS	1	;Last control key
ESCH	DS	1	;ESC holding flag

;PIAAD and PIABD must be kept sequential, PIAAD first
;dependency in VC_HOME of BMKEY.asm
PIAAD:	DS	1	;Holds last PIA-A data
PIABD:	DS	1	;Holds last PIA-B data

;	Calendar month, day year
IDAY	DS	3
IMONTH	=	IDAY+1
IYR	=	IDAY+2

;	Wall clock time cells and disk active
;	see UPTIM: in BMKEY.asm
HOURS:	DS	6
MINS:	=	HOURS+1
SECS:	=	HOURS+2
SEC6:	=	HOURS+3

;	Used to deselect drive when there is NO activity
;	on drive for n seconds.  See FDSK routine
DACTVE:	=	HOURS+4	;=0 by FDSK, Used by UPTIM

BELCNT:	=	HOURS+5	;^G bell timer cell


LLIMIT	DS	1	;max #columns in a logical line
;	MSG	'LLIMIT = ',LLIMIT,'h.'

;	Disk drive current positions
LDSEL:	DS	2	;Last selected drive
LDTRK	=	LDSEL+1	;Last track used for non-selected drive

IESTK:	DS	2	;save current stk ptr


;	Interrupt stack
	DS	20*2
ISTK:	DS	0

;	Stack entry
	DS	20*2	
BIOSTK:
ROMSTK:	DS	0

ACIAD:	DS	1	;last command byte written to ACIA

R179x:	DS	4	;179x register save area
KBDLY:	DS	1	;keyboard debounce-delay cell

;since CP/M CANNOT boot off B:, this cell is used
;to invert the names of the 2 drives:
;	=0, all normal, A=A:, B=B:
;	=1, all inverted, A=B:, B=A:
DSKSWP	DS	1

	ALIGN	10h

SEQ:	=	*-4
ACTTYP:
SAVTYP:	DS	1
RDT_WRTS: DS	1
CCPADR:	DS	2
KEYLST:	DS	6

SERFLG:	DS	1
IE_ADR:	DS	1
IE_CHAR: DS	1

PIACTL:	DS	1
PP.MODE: DS	1



;	8080 Register Save Area.
	ALIGN	10h
REGS:
ESAVE:  DS	1	;E Register save location
DSAVE:  DS	1	;D Register save location
CSAVE:  DS	1	;C Register save location
BSAVE:  DS	1	;B Register save location
FSAVE:  DS	1	;FLAGS save location
ASAVE:  DS	1	;A Register save location
LSAVE:  DS	1	;L Register save location
HSAVE:  DS	1	;H Register save location
PSAVE:  DS	2	;PGM COUNTER save location
SSAVE:  DS	2	;USER STACK pointer save location

BKPA:	DS	2	;last breakpoint address
BKPC:	DS	1	;Contents of bkp

VRTOFF	DS	1	;LAST VERTICAL OFFSET TAKEN FROM COUT
;
;
;	Interrupt Jump Vector is between EFF8, EFFF.
;	Endx	MRAM
