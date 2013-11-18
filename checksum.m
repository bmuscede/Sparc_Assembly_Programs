!*********************************************************************************
! File: checksum.m
! Author: Bryan J Muscedere
! Sparc Assembly Language
!
! Description:
! 	This file contains a program that determines whether or a calculated internet
!	checksum is valid. The program uses 1's complement addition on hexadecimal
!	values to make this determination. The program will the output either a 'V'
!	or 'I' depending on whether the checksum calculated was valid or invalid.
!
! Register Legend:
!	%sum_r  	The sum of all the 16 bit values together	%l0
!	%current_r	The register where the current value is stored	%l1
!	%temp_r   	The register where the current digit is stored	%l2
!	%count_r	Counter that keeps track of the digit its on	%l3
!	%mask_r 	Register that holds any masks before use	%l4
!*********************************************************************************

define(NEWLINE,10)	!Defines the new line character to add new lines between prompts.
define(VALID,'V')	!Defines the 'V' character to print when checksum is valid.
define(INVALID,'I')	!Defines the 'I' character to print when checksum is invalid.
define(SHIFT,4) 	!Defines the amount the bits have to  to the left or right.
define(CHR_DETERMINE,60)!Defines the amount to subtract to determine if a character or integer.
define(CHR_ADD,5)	!Defines the amount to add to characters.		
define(INT_ADD,12)	!Defines the amount to add to integers.
define(SUM_LENGTH,16)	!Defines the length of the sum (16 bit). Useful to determine "carry over" value.
define(COUNT_MAX,4)	!The total number of digits before they get added to the sum.

define(sum_r, %l0)	!The register where the sum of the checksum is stored.
define(current_r, %l1)	!The register where the current value is stored.
define(temp_r, %l2)	!The register that holds the temp char.
define(count_r, %l3)	!The register which counts the number of loops
define(mask_r, %l4)	!The register which holds the masks needed.
	
	.global main
main:	save	%sp, -96, %sp
	
	clr	sum_r	 	!Clears the sum register before use.
	clr	current_r	!Clears the current number register before use.
	clr	temp_r	 	!Clears the temporary register before use.
	clr	count_r		!Clears the counter before use.

getChr: call	getchar		!Gets the next character inputted.
	nop	
	
	cmp	%o0, 0	!Sees if the end of input is reached (if %o0 is -1).
	bl	afLp	!If it is at the end, goes to afLp
	nop

	sll	current_r, SHIFT, current_r	!Shifts the bits left by 4 to make way for new digit.
	
	subcc	%o0, CHR_DETERMINE, temp_r	!Subtracts the current digit by 60.
	bl	intFlag	!If the character is less than 0, its an integer.
	nop
	
chrFlag:add	temp_r, CHR_ADD, temp_r	!Adds the appropriate value to make it a proper hex digit.
	ba	aftAdd	!Moves to aftAdd.
	nop

intFlag:add	temp_r, INT_ADD, temp_r	!Adds the appropriate value to make it a proper dec digit.

aftAdd:	add	current_r, temp_r, current_r	!Now adds the current digit to the 16 bit number.
	
	inc	count_r	!Increments the counter.

	cmp	count_r, COUNT_MAX	!Sees if the counter is equal to 4.
	be	addChr	!If it is, moves to addChr.
	nop

	ba	getChr	!If not, it moves to getChr.
	nop

addChr:	clr	count_r	!Resets the counter.
	add	sum_r, current_r, sum_r	!Adds the current 16 bit number to the sum.
	srl	sum_r, SUM_LENGTH, temp_r	!Shifts all the bits over by 16 to get the "carry-over" value.
	add	sum_r, temp_r, sum_r	!Adds the "carry-over" value to the total.
	
	set	0xFFFF, mask_r	!Sets FFFF to a mask.
	and	sum_r, mask_r, sum_r	!Makes the sum a 16 bit number. Removes everything beyond 16 bit.
	
	clr	current_r	!Clears the current number.
	clr	temp_r		!Clears the temp number.

	ba 	getChr	!Branches back to getChr.
	nop

afLp:	set	0xFFFF, mask_r	!Sets FFFF as a mask.
	cmp	sum_r, mask_r	!Compares to see if the sum is equal to FFFF.
	be	valid	!If it is, its a valid checksum.
	nop
	
	ba	ival	!It isn't a valid checksum.
	nop

valid:	mov	VALID, %o0	!Moves the valid chr to %o0 and writes it to screen.
	call	writeChar
	nop
	
	ba	proEnd	!Moves to the end of the program.
	nop

ival:	mov	INVALID, %o0	!Moves the invalid chr to %o0 and writes it to the screen.
	call	writeChar
	nop

proEnd:	mov	NEWLINE, %o0	!Moves the newline chr to %o0 and writes it to the screen.
	call	writeChar
	nop

	ret	!Exits the program.
	restore
