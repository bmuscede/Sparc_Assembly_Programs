	include(macro_defs.m)

	local_var
	var(a_s, 4)

	define(a_r, l0)

	begin_main
	
	call	writeChar
	mov	'>', %o0
	
	call	readChar
	nop

	st	%o0, [%fp + a_s]
	nop
	
	ld	[%fp + a_s], %o0
	call	writeChar
	nop
	
	call	writeChar
	mov	10, %o0

	ret
	restore
