;.Date: 11/17/82
;.Author: Roger W. Chapman
;.Title: Osborne CP/M 2.2 CBIOS Rev 1.41
;.Comments:

	TITLE	'Osborne CP/M 2.2 CBIOS Rev 1.4'

*NOTE*	FOR USE WITH OCCTXT6.AST ONLY

*	4D2007-00	MASTER	.ASM
*	2D2007-00	ASSY	.ASM
*	1D2007-00	LISTING	.PRN
*	4D1007-00	MASTER	.COM
*	2D1007-00	ASSY	.COM

;	+-----------------------+
;	|			|
;	|	  O C C		|
;	|			|
;	|	C B I O S 	|
;	|			|
;	|  by Roger W. Chapman	|
;	|			|
;	+-----------------------+ 

;	Copyright 1982, Osborne.

;	This product is a copyright program product of
;	Osborne and is supplied for use with the Osborne.

;	MODIFIED 11/17/82 TO ACCOMODATE 80 PLUS OPTION
;	by Chris M. Mayer

VERS:	=	22
	space	4,10

	LINK	OCCBIO15.ASM	;Jump Table
	LINK	OCCBIO25.ASM	;Key translation & initialization values
	LINK	OCCBIO95.ASM	;CP/M disk tables
	LINK	OCCBIO35.ASM	;ROM call interface
	LINK	OCCBIO45.ASM	;Non data transfer disk
	LINK	OCCBIO55.ASM	;cold and warm boot
	LINK	OCCBIO65.ASM	;Disk data transfer I/O
	LINK	OCCBIO75.ASM	;Utility routines
	LINK	OCCBIO85.ASM	;Iobyte dispatch table
	LINK	OCCRAM15.ASM	;Bios ram definitions
	LINK	OCCRAM25.ASM	;Commom ram definitions
