
        data1 = 0x0001   
        data2 = 0x000a
        data3 = 0x0002
        data4 = 0x0008

        lda  $r1, data1   /* $r1 = 1 */
        lda  $r2, data2   /* $r2 = 2 */
        lda  $r3, data3   /* $r3 = 6 */
        lda  $r4, data4   /* $r4 = 8 */
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
        mulq $r3, $r3, $r3
#       mult $r, $r1, $r2
        call_pal 0x555
