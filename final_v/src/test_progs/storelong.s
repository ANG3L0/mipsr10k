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
	lda $r9, 0x08
	lda $r10, 0x08
	lda $r29, 1
	lda $r30, 3

loop:   subq $r30, $r29, $r30
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
        stq $r9, 0x1050($r10)
     	stq $r10, 0x1058($r9)
     	stq $r9, 0x1068($r10)
     	stq $r10, 0x1048($r9)
     	stq $r9, 0x1038($r10)
     	stq $r10, 0x1028($r9)
     	stq $r9, 0x1018($r10)
     	stq $r10, 0x1008($r9)
     	stq $r9, 0x1258($r10)
     	stq $r10, 0x1258($r9)
     	stq $r9, 0x1258($r10)
     	stq $r10, 0x1258($r9)
     	stq $r9, 0x1258($r10)
     	stq $r10, 0x1258($r9)
     	stq $r9, 0x1258($r10)
     	stq $r10, 0x1258($r9)
     	stq $r9, 0x1258($r10)
     	stq $r10, 0x1258($r9)
     	stq $r9, 0x1050($r10)
	mulq $r1, $r2, $r3
     	stq $r7, 0x1200($r3)
     	stq $r7, 0x1350($r2)
	mulq $r3, $r1, $r3
     	stq $r7, 0x1450($r3)
	mulq $r7, $r8, $r8
	mulq $r7, $r8, $r8
     	stq $r7, 0x1480($r1)
     	stq $r7, 0x1590($r4)
	mulq $r4, $r1, $r2
     	stq $r7, 0x1690($r1)
	addq  $r1, $r2, $r3
	addq  $r1, $r2, $r3
	addq  $r1, $r2, $r3
     	stq $r7, 0x1690($r3)
     	stq $r7, 0x1690($r3)
     	stq $r7, 0x1690($r3)
     	stq $r5, 0x1690($r3)
     	stq $r7, 0x1690($r3)
     	stq $r7, 0x1690($r3)
     	stq $r7, 0x1690($r3)
     	stq $r7, 0x1690($r3)
     	stq $r7, 0x1690($r3)
	addq $r1, $r2, $r3
	bne $r30, loop
	call_pal 0x555
