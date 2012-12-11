

        lda  $r1, 0xa 
        lda  $r2, 0x1 
        lda  $r3, 0x3f7
        lda  $r4, 0x4
        lda  $r10, 0x2
loop2:  subq $r1, $r2, $r1  
        lda  $r5, 5
loop1:  subq $r5, $r2, $r5
	mulq $r1, $r5, $r6
	addq $r6, $r3, $r3
	addq $r1, $r5, $r7
	addq $r7, $r4, $r4
        addq $r10, $r10, $r10 
        bne  $r5, loop1
        bne  $r1, loop2
	addq $r1, $r2, $r8
	addq $r5, $r2, $r9
        call_pal 0x555
