	include(macro_defs.m)

	define(SIZE,50)
	define(WORD,4)
	define(INPUT,'>')

	define(input_r,l0)
	define(count_r,l1)
	define(current_r,l2)
	define(stack_r, l7)
	
	local_var
	var(stack_s,WORD,SIZE * WORD)
	
	begin_main
	
	clr	%count_r

	call	writeChar			!Writes prompt to screen.	
	mov	INPUT, %o0

	call	readInt				!Reads the integer entered by the user.
	nop

	add	%fp, stack_s, %stack_r		!Goes to the top of the stack.
	add	%stack_r, WORD*SIZE, %stack_r	!Now moves to the bottom of the empty stack.
	
	mov	%o0, %current_r			!Moves the current input into the current register.

loop:	cmp	%current_r, 0			!Sees if the register is equal to 0.
	be	afLoop
	nop
	
	mov	4, %o1
	call	.rem				!Gets the remainder of the current number.
	mov	%current_r, %o0
	
	dec	WORD, %stack_r			!Pushes a new item onto the stack.
	st	%o0, [%stack_r]
	nop
	
	mov	4, %o0
	call	.div				!Divides the current number.
	mov	%current_r, %o0

	mov	%o0, %current_r			!Sets the new number as the divided product.
	inc	%count_r			!Keeps track of the elements in the stack.

	ba	loop
	nop

afLoop:	

print:	cmp	%count_r, 0			!Sees if the bottom of the array has been reached.
	be	end
	nop
 
	ld	[%stack_r], %o0			!Pops item off the top of the stack.
	inc	WORD, %stack_r
	
	dec	%count_r

	call	writeInt
	nop
	
	ba	print
	nop

end:	call	writeChar
	mov	10, %o0
	
	ret
	restore
