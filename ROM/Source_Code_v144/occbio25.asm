	PAGE

;;;;;;;;;;;;;;;;;;;;;;;
;
;	This area is reserved data storage area for 
;	the set-up program to install printer drivers,
;	function keys, auto boot command, iobyte value,
;	and auto horizontal scroll flag
;						RWC
;;;;;;;;;;;;;;;;;;;;;;;

IOBITE:	DB	40h		;default to serial printer=40h
				;	  parallel printer=80h
				;	      IEEE printer=c0h
PRNTER:	DB	00h		;default to standard serial=0
				;Qume 		ETX/ACK    =1
				;Diablo		XON/XOFF   =2

AHSENB:	DB	TRUE		;auto horizontal scroll enable

BRATE:	DB	SI.120		;default baud rate = 1200

SCRSZE:	DB	128		;default screen size = 128



XLTBL:	DW	CNTRL0		;Fixed length table
	DW	CNTRL1		;contains pointers
	DW	CNTRL2		;to strings 
	DW	CNTRL3		;to decode
	DW	CNTRL4		;function keys
	DW	CNTRL5
	DW	CNTRL6
	DW	CNTRL7
	DW 	CNTRL8
	DW	CNTRL9
	DW	UP
	DW	RIGHT
	DW	DOWN
	DW	LEFT
	DW	EOTBL		;end of table address

IEEEAD:	DB	4		;IEEE device address

PINTFG:	DB	0		;Flag indicates if printer has been initialized

PINIT:	DB	0		;Length of string
	DS	16		;Printer initialization string

ACMD:	DB	1		;auto command = 0 ignore auto boot
				;	      = 1 auto on cold boot
				;	      = 2 auto on warm boot
				;	      = 3 auto on both
CAUTO:	DB	CAUTOL		;length of auto command here
	DB	'AUTOST '	;auto command goes here
CAUTOL:	=	*-CAUTO-1
PLUGH:	DB	0		;0 = 52 column, 1 = 100 column, 3 = 80 column

	SPACE 4,14
CNTRL0:	DB	'0'		;Variable length table 
CNTRL1:	DB	'1'		;is placed here by set-up
CNTRL2:	DB	'2'		;program, with xlttbl
CNTRL3:	DB	'3'		;pointing to the entries
CNTRL4:	DB	'4'
CNTRL5:	DB	'5'		;Default values for the
CNTRL6:	DB	'6'		;control numerics
CNTRL7:	DB	'7'		;are the numbers on the keys
CNTRL8:	DB	'8'
CNTRL9:	DB	'9'
UP:	DB	'K'-40h		;Default values 
RIGHT:	DB	'L'-40h		;for the cusor
DOWN:	DB	'J'-40h		;keys are standard
LEFT:	DB	'H'-40h		;values for CP/M


EOTBL:	=	*
	SPACE 4,2
	ORG	BIOS+256	;space reseverd for full function
				;key decoding and 16 byte auto
				;boot command
