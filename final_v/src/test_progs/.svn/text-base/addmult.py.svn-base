

if __name__ == '__main__':
   r1=2
   print "r1=2" # lda   $r1, 2
   r2=0
   print "r2=0"# lda   $r2, data1 /* 0 */
   r3=4
   print "r3=4"# lda   $r3, data2 /* 4 */
   r4=6
   print "r4=6"# lda   $r4, data3 /* 6 */
   r5=8
   print "r5=8"# lda   $r5, data4 /* 8 */
   # lda   $r31,data7 /* nothing should happen */
   r6=r1+r2
   print "r6 = " + str(r1+r2)# addq  $r1,$r2,$r6 /* 2+0000 = 0002 -> r6 */
   r7=r2+r3
   print "r7 = " + str(r2+r3)# addq	 $r2,$r3,$r7 /* r7 = 4 */
   r8=r4*r7
   print "r8 = " + str(r4*r7)# mulq  $r4,$r7,$r8 /* r8 = 48 */
   r9=r4
   print "r9 = " + str(r4)# addq  $r4,$r31,$r9 /*r9 = 6 */
   r11=r5+r3
   print "r11 = " + str(r5+r3)# addq  $r5,$r3,$r11
   r8=r4*r5
   print "r8 = " + str(r4*r5)# mulq  $r4,$r5,$r8
   r3 = r2*r1
   print "r3 = " + str(r2*r1)# mulq  $r1,$r2,$r3
   r5 = r3*r4
   print "r5 = " + str(r3*r4)# mulq  $r3,$r4,$r5
   r6 = r3+r5
   print "r6 = " + str(r3+r5)# addq  $r3,$r5,$r6
   r8 = r6+r7
   print "r8 = " + str(r6+r7)# addq  $r6,$r7,$r8
   r7 = r6*r8
   print "r7 = " + str(r6*r8)# mulq  $r6,$r8,$r7
   r2 = r1+r3
   print "r2 = " + str(r1+r3)# addq  $r1,$r3,$r2
   r3 = r7+r3
   print "r3 = " + str(r7+r3)# addq  $r3,$r7,$r3
   r2 = r2*r2
   print "r2 = " + str(r2)# mulq  $r2,$r2,$r2
   r2 = r2+r2
   print "r2 = " + str(r2)# addq  $r2,$r2,$r2
   r2 = r2*r2
   print "r2 = " + str(r2)# mulq  $r2,$r2,$r2
   r2 = r2+r2
   print "r2 = " + str(r2)# addq  $r2,$r2,$r2
   r2 = r2*r2
   print "r2 = " + str(r2)# mulq  $r2,$r2,$r2
   r2 = r2+r2
   print "r2 = " + str(r2)# addq  $r2,$r2,$r2
   print "r31=0"# mulq  $r31,$r31,$r31
   print "r31=0"# addq  $r31,$r31,$r31
   r3=r1+r2
   print "r3 = " + str(r1+r2)# addq  $r1,$r2,$r3
   # call_pal 0x555
