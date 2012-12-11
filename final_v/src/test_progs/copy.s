/*
	TEST PROGRAM #1: copy memory contents of 16 elements starting at
			 address 0x1000 over to starting address 0x1100. 
	

	long output[16];

	void
	main(void)
	{
	  long i;
	  *a = 0x1000;
          *b = 0x1100;
	 
	  for (i=0; i < 16; i++)
	    {
	      a[i] = i*10; 
	      b[i] = a[i]; 
	    }
	}
*/
	data = 0x1000 #
	lda	$r5,0 #0
	lda	$r1,data #4
loop:	mulq	$r5,0x0a,$r2 #8
	stq	$r2,0($r1) #c
	ldq	$r3,0($r1) #10
	stq     $r3,0x100($r1) #14
	addq    $r1,0x8,$r1 #18
	addq	$r5,0x1,$r5 #1c
	cmple   $r5,0xf,$r4 #20
	bne     $r4,loop #24
	call_pal        0x555 #2c

