
        data1 = 0x0001   
        data2 = 0x0005
        data3 = 0x0002
        data4 = 0x0008

        lda  $r1, data1   /* $r1 = 1 */
        lda  $r2, data2   /* $r2 = 2 */
        lda  $r3, data3   /* $r3 = 6 */
        lda  $r4, data4   /* $r4 = 8 */
        addq $r4, $r3, $r4   /* $r4 = 14 */
        subq $r4, $r3, $r6   /* $r6 = 8  */  
loop:   subq $r2, $r1, $r2   /* $r2 = 1  */  /* $r2 = 0 */ 
        addq $r6, $r4, $r6   /* $r6 = 22 */  /* $r6 = 30*/ 
	mulq $r3, $r3, $r4
	addq $r1, $r6, $r7
	mulq $r3, $r4, $r20
        bne  $r2, loop       /* $r2 = 1 */   /* $r2 = 0 */ 
        addq $r2, $r1, $r9                   /* $r9 = 1 */ 
        call_pal 0x555
