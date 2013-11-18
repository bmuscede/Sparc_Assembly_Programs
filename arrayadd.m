	include(macro_defs.m)

	define(WORD,4)
	define(SIZE,4)
	define(ARRAY_SIZE, 16)
	define(INPUT,'>')

	define(count_r, l0)
	define(pos_r, l1)
	define(product_r, l2)

	local_var
	var(array_s,WORD,WORD * SIZE)

	begin_main
	
	clr 	%count_r			!Sets the counter to 0.
	clr	%product_r			!Clears the product register.
	add 	%fp, array_s, %pos_r		!Moves to the first position in the array.

loop:	cmp	%count_r, ARRAY_SIZE		!Sees if the counter has reached the top of the array. 
	bge	aftLoop
	nop
	
	call	writeChar
	mov	INPUT, %o0
	
	call	readInt
	nop

	st	%o0, [%pos_r]			!Stores the user input in the current position of the array.
	nop
	
	inc	WORD, %count_r			!Increases the counter by 4. One position up in the array.
	add	%pos_r, %count_r, %pos_r	!Moves the frame up by 4.
	ba	loop
	nop

aftLoop:add	%fp, array_s, %pos_r		!Now resets the pointer so its pointing at A[0]
	clr	%count_r			!Clears the counter yet again.

loop1:	cmp	%count_r, ARRAY_SIZE		!Determines whether the array has fully been traversed.
	bge	afLoop1
	nop
	
	ld	[%pos_r], %l3
	nop
	
	add	%product_r, %l3, %product_r	!Adds the stored value to the total.	
	
	inc	4, %count_r			!Increments the counter.
	add	%pos_r, %count_r, %pos_r	!Moves the frame up by 4.
	ba	loop1
	nop

afLoop1:call	writeInt			!Writes the result of the adds.
	mov	%product_r, %o0

	call	writeChar			!Writes a new line to the terminal.
	mov	10, %o0

	ret
	restore
	
	
