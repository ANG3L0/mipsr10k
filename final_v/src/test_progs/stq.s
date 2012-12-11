

   data1 = 0x1000
   data2 = 0x1008
   lda   $r2, 2
   lda   $r3, data1
   lda	 $r29, data2
   lda   $r4, data1
   stq   $r2,0($r3)
   stq   $r2,0($r29)
   stq   $r3,0($r3)
   lda   $r5, 5
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r7, 0
   #lda   $r8, 0
   call_pal 0x555
