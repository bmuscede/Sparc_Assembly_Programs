define(a_s,-4)
define(b_s,-8)
define(APRINT,'=')
define(BPRINT,'-')

	.global	main
main:	save	%sp, -104, %sp
	
	call	readInt
	nop

	st	%o0, [%fp + a_s]
	nop
	
	call	readInt
	nop

	st	%o0, [%fp + b_s]
	nop

	call	writeChar
	mov	APRINT, %o0

	ld	[%fp + a_s], %o0
	nop
	
	call	writeInt
	nop

	call	writeChar
	mov	10, %o0

	call	writeChar
	mov	BPRINT, %o0
	
	ld	[%fp + b_s], %o0
	nop
	
	call	writeInt
	nop
	
	call 	writeChar
	mov	10, %o0

	ret
	restore	
