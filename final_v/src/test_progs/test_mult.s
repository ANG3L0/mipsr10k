


   
     lda  $r1, 4
     lda  $r2, 2
     mulq $r1,0x8,$r3
     mulq $r2,0x8,$r4
     call_pal    0x555
