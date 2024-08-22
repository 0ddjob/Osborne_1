	page

ROMRI:
;	Exits ROM resident Interrupt routine.

	LD	A,ROMRAM
	MOV	C,A		;port
	OT,C	A		;set ROM or RAM enabled
	POP	IY
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	POP	AF
	LD	SP,IESTK	;reset to interrupt entry stk
	EI
	RET
	page

ROMCDE:
;	Calls ROM resident processor
;
;	Entry	DE = resident processor to call biased
;		by CBIOS jump vector.
;	NOTE: ROM jump vector must match CBIOS vector
;
;	Entry at ROMCD1 with low digit of CBIOS vector in reg E

	POP	DE		;Get calling address
	MOV	A,E
	SUI	3
	MOV	E,A

ROMCD1:	LDK	D,high (ROMVEC)

ROMJMP:
;	Entry here to jump to ROM function code directly
;
;	Entry	DE = ROM jump address
;		BC, HL, IX = any parameters

	PUSH	IY		;Save user Index registers
	PUSH	IX

	DI			;Set up local stack for ROM
	EXX
	LDK	HL,0
	ADD	HL,SP		;Old stack to HL
	LDK	SP,BIOSTK
	PUSH	HL		;Save old stack pointer
	EXX

	CALL	SW2ROM
	CALL	GOROM		;Go to ROM address (DE) and return to next instruction
	CALL	SW2RAM

	POP	IY		;Restore old stack pointer
	MOV	SP,IY

	POP	IX		;Restore user Index registers
	POP	IY

	RET
	space	4,6
GOROM:
;	This routine is used to simulate a CALL  (DE) instruction

	PUSH	DE		;ROM jump address to IY
	POP	IY
	JMP	[IY]		;Go to ROM, ROM will RET to next instruction
