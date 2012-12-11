/*
	TEST PROGRAM #4: compute nth fibonacci number recursively

	int output;
	
	void
	main(void)
	{
	   output = fib(14); 
	}

	int
	fib(int arg)
	{
	    if (arg == 0 || arg == 1)
		return 1;

	    return fib(arg-1) + fib(arg-2);
	}
*/
	
	data = 0x400
	stack = 0x1000

	lda	$r30,stack	# initialize stack pointer #0
	
	lda	$r16,4		# call fib(14)		 #4
	bsr	$r26,fib				 #8

	lda	$r1,data 				#c
	stq	$r0,0($r1)	# save to mem		 #10
	call_pal 0x555 					#14
	
fib:	beq	$r16,fib_ret_1	# arg is 0: return 1 #18

	cmpeq	$r16,1,$r1	# arg is 1: return 1 #1c
	bne	$r1,fib_ret_1 				#20

	subq	$r30,32,$r30	# allocate stack frame #24
	stq	$r26,24($r30)	# save off return address #28

	stq	$r16,0($r30)	# save off arg 		#2c

	subq	$r16,1,$r16	# arg = arg-1 		#30
	bsr	$r26,fib	# call fib 		#34
	stq	$r0,8($r30)	# save return value (fib(arg-1)) #38

	ldq	$r16,0($r30)	# restore arg		 #3c
	subq	$r16,2,$r16	# arg = arg-2 		#40
	bsr	$r26,fib	# call fib 		#44

	ldq	$r1,8($r30)	# restore fib(arg-1)	 #48
	addq	$r1,$r0,$r0	# fib(arg-1)+fib(arg-2) #4c

	ldq	$r26,24($r30)	# restore return address #50
	addq	$r30,32,$r30	# deallocate stack frame #54
	ret			# return 		#58
	
fib_ret_1:
	mov	1,$r0		# set return value to 1 #5c
	ret			# return		 #60
	
