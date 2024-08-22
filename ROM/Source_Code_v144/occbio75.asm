	page

MVINFO:
;	Move information necessary for transfer.

	XRA	A
	STO	A,ERFLAG		;Clear error flag
	LD	A,TEMSEC
	STO	A,SEKSEC
	RET
	page

PRINT:
;	Print message string to CONSOLE device

	LDK	HL,CONOUT
	JR	STROUT
	space	4,8
PSTR:
;	Print message string to LIST device

	LDK	HL,LIST
;	JR	STROUT
	space 4,40
STROUT:
;	Print message terminated by zero byte.
;
;	ENTRY	DE -> message buffer, first byte = length
;
;	EXIT	DE -> DE + length
;		A = 0.
;		Z bit set.
;
;	USES A, BC, DE, HL

	PROC
	LD	A,[DE]		;Get a length of print string
	ORA	A
	RZ			;If zero then terminate

	MOV	B,A		;Length to B reg
NEXTC:	INC	DE
	LD	A,[DE]		;Get character
	MOV	C,A

	PUSH	DE		;Save print string address
	PUSH	BC		;Save loop counter
	PUSH	HL		;Save output routine address

	LDK	DE,NEXT
	PUSH	DE		;Return address to stack
	JMP	[HL]		;Output

NEXT:	POP	HL
	POP	BC
	POP	DE

	DJNZ	NEXTC		;Print next character if not done

	RET
