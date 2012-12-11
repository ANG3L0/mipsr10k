/*
   btest2.s: Hammer on the branch prediction logic somewhat.
             This test is a series of 128 code-blocks that check a register
             and update a bit-vector by or'ing with 2^block#.  The resulting
             bit-vector sequence is 0xbeefbeefbaadbaad, 0xdeadbeefdeadbeef
             stored in mem lines 2000 & 2001
	     
             Do not expect a decent prediction rate on this test.  No branches
             are re-visited (though a global predictor _may_ do reasonably well)
             The intent of this benchmark is to test control flow.
	     
             Note: 'call_pal 0x000' is an instruction that is not decoded by
                   simplescalar3.  It is being used in this instance as a way
                   to pad the space between (almost) basic blocks with invalid
                   opcodes.									
 */
	lda $r0, 0x0 
	lda $r1, 0x8
	lda $r2, 0x10
	lda $r3, 0x18
	lda $r4, 0x20
	lda $r5, 0x28
	lda $r6, 0x30
	lda $r7, 0x38
	lda $r8, 0x40
	mulq $r0, $r0, $r0
	stq $r0, 0x1020($r0)
	mulq $r0, $r1, $r1
	stq $r1, 0x1008($r1)
	mulq $r1, $r2, $r2
    	stq $r2, 0x1008($r2)
	mulq $r2, $r3, $r3
     	stq $r3, 0x1008($r3)
	mulq $r3, $r4, $r4
     	stq $r4, 0x1018($r4)
	mulq $r4, $r5, $r5
     	stq $r5, 0x1028($r5)
	mulq $r5, $r6, $r6
     	stq $r6, 0x1038($r6)
	mulq $r6, $r1, $r1
     	stq $r7, 0x1048($r7)
	mulq $r7, $r8, $r8
     	stq $r8, 0x1050($r2)
     	stq $r7, 0x1058($r1)
     	stq $r6, 0x1068($r6)
     	stq $r5, 0x1048($r7)
     	stq $r4, 0x1038($r5)
     	stq $r3, 0x1028($r6)
     	stq $r2, 0x1018($r4)
     	stq $r1, 0x1008($r1)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
     	stq $r8, 0x1258($r8)
	call_pal 0x555
