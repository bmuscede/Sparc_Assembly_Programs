	include(macro_defs.m)
	
	define(multiplier_r,l0)
	define(multiplicand_r,l1)
	define(product_r,l2)
	define(count_r,l3)
	define(temp_r,l4)
	define(omultiplier_r,l5)

	local_var
	
	.data
mplier:	.asciz	"The multiplier> "
mcand:	.asciz	"The multiplicand> "

	.text
	begin_main
	
	set	mplier, %o0				
	call	writeString				!Prompts the user to input a multiplier.
	nop

	call	readInt					!Reads the user's input.
	nop
	
	mov	%o0, %multiplier_r			!Sets it as the multiplier.
	mov	%o0, %omultiplier_r		!Stores the original multiplier.

	set	mcand, %o0				!Prompts the user to enter a multiplicand.
	call	writeString				
	nop
	
	call	readInt					!Reads the user's input.
	nop
	
	mov	%o0, %multiplicand_r			!Sets it as the multiplicand.
	clr	%product_r				!Clears the product register.
	mov	0, %count_r				!Sets the counter to 0.

shiftLp:cmp	%count_r, 32				!Sees if the counter has reached 32.
	bge	afterLp
	nop

	btst	1, %multiplier_r			!Looks at whether the multiplier has a 1 as its lsb.
	ble	noAdd
	nop
	
	add	%multiplicand_r, %product_r, %product_r	!Adds the multiplicand to the product register if 1 is in the multiplier lsb.

noAdd:	srl	%multiplier_r, 1, %multiplier_r		!Shifts the multiplier over by 1. Logically.
	and	%product_r, 1, %temp_r			!Gets the lsb of the product register.
	sll	%temp_r, 31, %temp_r			!Takes that bit and makes it the largest.
	add	%temp_r, %multiplier_r, %multiplier_r	!Adds it to the msb of the multiplier.
	sra	%product_r, 1, %product_r		!Now arithmetically shifts the product register.

	inc	%count_r				!Increases the counter.
	
	ba	shiftLp					!Goes to the beginning of the loop.
	nop

afterLp:mov	%omultiplier_r, %o0
	mov	%multiplier_r, %o2
	call	eqWrite					!Writes the equation to the screen.
	mov	%multiplicand_r, %o1
	
	ret
	restore 

	.global	eqWrite
eqWrite:save	%sp, -96, %sp

	call	writeInt
	mov	%i0, %o0

	call	writeChar
	mov	32, %o0

	call	writeChar
	mov	120, %o0
	
	call	writeChar
	mov	32, %o0

	call	writeInt
	mov	%i1, %o0

	call	writeChar
	mov	32, %o0

	call	writeChar
	mov	61, %o0

	call	writeChar
	mov	32, %o0
	
	call	writeInt
	mov	%i2, %o0

	call	writeChar
	mov	10, %o0

	ret
	restore
