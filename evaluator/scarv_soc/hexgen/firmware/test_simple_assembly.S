
.text
.global _start
_start:

    li x1 , 0
    li x2 , 0
    li x3 , 0
    li x4 , 0
    li x5 , 0
    li x6 , 0
    li x7 , 0
    li x8 , 0
    li x9 , 0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    li x16, 0
    li x17, 0
    li x18, 0
    li x19, 0
    li x20, 0
    li x21, 0
    li x22, 0
    li x23, 0
    li x24, 0
    li x25, 0
    li x26, 0
    li x27, 0
    li x28, 0
    li x29, 0
    li x30, 0
    li x31, 0

    li sp, 0x2000FFF0

    j       main                    // Jump to the first stage boot loader.

.global __fsbl_goto_main
__fsbl_goto_main:
    jalr    zero, a0                // Jump to pointer value passed in a0.


main:

#
# ------------------------------------------------------------

    xc.ldr.b    a0,a1(a2)
    xc.ldr.h    a0,a1(a2)
    xc.ldr.w    a0,a1(a2)
    xc.ldr.bu    a0,a1(a2)
    xc.ldr.hu    a0,a1(a2)
    
    xc.str.b    a0,a1(a2)
    xc.str.h    a0,a1(a2)
    xc.str.w    a0,a1(a2)

    xc.mmul.3   (a1,a0),a2,a3,a4
    xc.macc.1   (a1,a0),a2,a3,a4
    xc.madd.3   (a1,a0),a2,a3,a4
    xc.msub.3   (a1,a0),a2,a3,a4

    xc.mror    (a1,a0), a2,a3,a4

    xc.rngtest a0
    xc.rngsamp a0
    xc.rngseed a0

    xc.lut  a0,a1,a2
    xc.bop  a0,a1,a2,1

    xc.padd     h,a0,a1,a2
    xc.psub     h,a0,a1,a2
    xc.pror     h,a0,a1,a2
    xc.psll     h,a0,a1,a2
    xc.psrl     h,a0,a1,a2
    xc.pror.i   h,a0,a2,1
    xc.psll.i   h,a0,a2,1
    xc.psrl.i   h,a0,a2,1

    xc.pmul.l   h,a0,a1,a2
    xc.pmul.h   h,a0,a1,a2

    xc.pclmul.l h,a0,a1,a2
    xc.pclmul.h h,a0,a1,a2

    xc.scatter.b a0,a1,a2
    xc.scatter.h a0,a1,a2

    xc.gather.b a0,a1,a2
    xc.gather.h a0,a1,a2

    xc.aessub.enc       a0,a1,a2
    xc.aessub.encrot    a0,a1,a2
    xc.aessub.dec       a0,a1,a2
    xc.aessub.decrot    a0,a1,a2
    xc.aesmix.enc       a0,a1,a2
    xc.aesmix.dec       a0,a1,a2

    xc.sha256.s0  a0, a1
    xc.sha256.s1  a0, a1
    xc.sha256.s2  a0, a1
    xc.sha256.s3  a0, a1

    xc.sha3.xy    a0, a1, a2, 0
    xc.sha3.x1    a0, a1, a2, 0
    xc.sha3.x2    a0, a1, a2, 0
    xc.sha3.x4    a0, a1, a2, 0
    xc.sha3.yx    a0, a1, a2, 0

