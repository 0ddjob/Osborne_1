	PAGE

;	Control Blocks for disk drives

DPBASE:
	DPHGEN	DSKD1,DDXLTS,DIRBUF,DPBD1+1	;Drive A:

	DPHGEN	DSKD1,DDXLTS,DIRBUF,DPBD1+1	;Drive B:
	PAGE

XTAB:	;Translation table addresses

	DW	DDXLTS		;Double density Osborne tranlation table address
	DW	XLTS		;Single density Osborne
	DW	XXXLTS		;Xerox translation table address
	DW	IBMXLT		;IBM translation table address
	DW	DECXLT		;DEC translation table address
	DW	XTRXLT		;User defined translation table address

DDXLTS:	=	0		;Translation table for DOUBLE DENSITY OSBORNE  2 to 1

XLTS:	;Translation table 2 to 1

	DB	0, 1,	    4, 5,	8, 9,	    12,13,	16,17
	DB	2, 3,	    6, 7,	10,11,	    14,15,	18,19

XXXLTS:	;XEROX TRANSLATION TABLE  5 to 1

	DB	0,	5,	10,	15
	DB	2,	7,	12,	17
	DB	4,	9,	14
	DB	1,	6,	11,	16
	DB	3,	8,	13

IBMXLT:	=	0		;IBM TRANSLATION TABLE, No translation  1 to 1

DECXLT:	;DEC TRANSLATION TABLE  2 to 1
	DB	0, 1, 2, 3,	 8, 9,10,11,	16,17,18,19,	24,25,26,27,	32,33,34,35
	DB	4, 5, 6, 7,	12,13,14,15,	20,21,22,23,	28,29,30,31

XTRXLT:	DS	40		;Space for user defined expansion
	page

;	Disk type definition blocks for each particular mode.

DPBSTART:			;Start of Disk parameter blocks, used by select disk routine

DPBD1:				;Osborne Double density, single sided
	DPBGEN	DSKD1,8*5 ,3, 7,0,D1DSM ,64,1100000000000000B,3
	SPACE 1,10
DPBS1:				;Osborne Single density, single sided.
	DPBGEN	DSKS1,2*10,4,15,1,S1DSM ,64,1000000000000000B,3
	SPACE 1,10
DPBX0:
	DPBGEN	XEROX,1*18,3, 7,0,XXDSM ,32,1000000000000000B,3
	SPACE 1,10
DPBIBM:
 	DPBGEN	IBM  ,4*8 ,3, 7,0,IBMDSM,64,1100000000000000B,1
	SPACE 1,10
DPBDEC:
	DPBGEN	DEC  ,4*9 ,3, 7,0,DECDSM,64,1100000000000000B,2
	SPACE 1,3
DPBXTR:
	DS	16
	SPACE 3,2
NUMDPB:	=	(*-DPBSTART)/10H
