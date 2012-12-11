/*
	TEST PROGRAM #3: compute first 16 fibonacci numbers
			 with forwarding and stall conditions in the loop


	long output[16];
	
	void
	main(void)
	{
	  long i, fib;
	
	  output[0] = 1;
	  output[1] = 2;
	  for (i=2; i < 16; i++)
	    output[i] = output[i-1] + output[i-2];
	}
*/
	
	data = 0x1000
	lda     $r3,data
	lda     $r4,data+8
	lda     $r5,data+16
	lda     $r9,2
	lda     $r1,1
	stq     $r1,0($r3)
	call_pal        0x555
