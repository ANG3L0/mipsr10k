


   
     lda  $r1, 2
     lda  $r2, 2
     lda  $r3, 3
     lda  $r4, 4
     mulq $r1,$r1,$r1
     mulq $r1,$r1,$r5
     mulq $r5,$r1,$r6
     mulq $r5,$r6,$r5
     call_pal    0x555
