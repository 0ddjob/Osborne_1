	PAGE

XXX:	=	*
	IF	XXX > CCP + 1E00H
.9	ERROR	SYSTEM SIZE TOO LARGE
	ENDIF

	MSG	'SYSTEM SPACE AVAILABLE = ',1E00H - (XXX - CCP)
	space	4,12
	ORG	CCP + 1E00H

LASTA:	DS	4		;used by occbio4?, # drives * 2
DPB:	DS	2
SAVDPH:	DS	2
TEMDSK:	DS	1
TEMTYP:	DS	1

SAVADR:	DS	2

ALV:	DS	ALVSZ
CSV:	DS	CSVSZ

SEKTYP:	DS	1
HSTTYP:	DS	1

XLTKEY:	DS	2
	SPACE	6,4
YYY:	=	*
	IF	YYY > MRAM
.9	ERROR	CODE HIT BMRAM
	ENDIF
