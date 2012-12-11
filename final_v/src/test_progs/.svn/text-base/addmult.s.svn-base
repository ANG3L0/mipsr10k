

   data1 = 0x0000
   data2 = 0x0004
   data3 = 0x0006
   data4 = 0x0008
   data5 = 0x000a
   data6 = 0x000c
   data7 = 0x000e
   lda   $r1, 2
   lda   $r2, data1 /* 0 */
   lda   $r3, data2 /* 4 */
   lda   $r4, data3 /* 6 */
   lda   $r5, data4 /* 8 */
   lda   $r31,data7 /* nothing should happen */
   addq  $r1,$r2,$r6 /* 2+0000 = 0002 -> r6 */
   addq	 $r2,$r3,$r7 /* r7 = 4 */
   mulq  $r4,$r7,$r8 /* r8 = 48 */
   addq  $r4,$r31,$r9 /*r9 = 6 */
   addq  $r5,$r3,$r11 /*r11 = 12 */
   mulq  $r4,$r5,$r8
   mulq  $r1,$r2,$r3
   mulq  $r3,$r4,$r5
   addq  $r3,$r5,$r6
   addq  $r6,$r7,$r8
   mulq  $r6,$r8,$r7
   addq  $r1,$r3,$r2
   addq  $r3,$r7,$r3
   mulq  $r2,$r2,$r2
   addq  $r2,$r2,$r2
   mulq  $r2,$r2,$r2
   addq  $r2,$r2,$r2
   mulq  $r2,$r2,$r2
   addq  $r2,$r2,$r2
   mulq  $r31,$r31,$r31
   addq  $r31,$r31,$r31
   addq  $r1,$r2,$r3
   call_pal 0x555
