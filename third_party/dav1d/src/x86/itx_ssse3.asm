; Copyright © 2018, VideoLAN and dav1d authors
; Copyright © 2018, Two Orioles, LLC
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice, this
;    list of conditions and the following disclaimer.
;
; 2. Redistributions in binary form must reproduce the above copyright notice,
;    this list of conditions and the following disclaimer in the documentation
;    and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
; ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%include "ext/x86/x86inc.asm"


SECTION_RODATA 16

deint_shuf:  db  0,  1,  4,  5,  8,  9, 12, 13,  2,  3,  6,  7, 10, 11, 14, 15

deint_shuf1: db  0,  1,  8,  9,  2,  3, 10, 11,  4,  5, 12, 13,  6,  7, 14, 15
deint_shuf2: db  8,  9,  0,  1, 10, 11,  2,  3, 12, 13,  4,  5, 14, 15,  6,  7

%macro COEF_PAIR 2
pw_%1_m%2:  times 4 dw   %1, -%2
pw_%2_%1:   times 4 dw   %2,  %1
%endmacro

;adst4
pw_1321_3803:   times 4 dw  1321,  3803
pw_2482_m1321:  times 4 dw  2482, -1321
pw_3344_2482:   times 4 dw  3344,  2482
pw_3344_m3803:  times 4 dw  3344, -3803
pw_3344_m3344:  times 4 dw  3344, -3344
pw_0_3344       times 4 dw     0,  3344
pw_m6688_m3803: times 4 dw -6688, -3803

COEF_PAIR 2896, 2896
COEF_PAIR 1567, 3784
COEF_PAIR  799, 4017
COEF_PAIR 3406, 2276
COEF_PAIR  401, 4076
COEF_PAIR 1931, 3612
COEF_PAIR 3166, 2598
COEF_PAIR 3920, 1189
COEF_PAIR 3784, 1567
COEF_PAIR  995, 3973
COEF_PAIR 1751, 3703
COEF_PAIR 3513, 2106
COEF_PAIR 3857, 1380
COEF_PAIR 4017,  799
COEF_PAIR  201, 4091
COEF_PAIR 2440, 3290
COEF_PAIR 3035, 2751
COEF_PAIR 4052,  601
COEF_PAIR 2276, 3406

pd_2048:        times 4 dd  2048
pw_2048:        times 8 dw  2048
pw_m2048:       times 8 dw -2048
pw_4096:        times 8 dw  4096
pw_16384:       times 8 dw  16384
pw_m16384:      times 8 dw  -16384
pw_2896x8:      times 8 dw  2896*8
pw_3344x8:      times 8 dw  3344*8
pw_5793x4:      times 8 dw  5793*4
pw_8192:        times 8 dw  8192
pw_m8192:       times 8 dw -8192
pw_5:           times 8 dw  5
pw_201x8:       times 8 dw   201*8
pw_4091x8:      times 8 dw  4091*8
pw_m2751x8:     times 8 dw -2751*8
pw_3035x8:      times 8 dw  3035*8
pw_1751x8:      times 8 dw  1751*8
pw_3703x8:      times 8 dw  3703*8
pw_m1380x8:     times 8 dw -1380*8
pw_3857x8:      times 8 dw  3857*8
pw_995x8:       times 8 dw   995*8
pw_3973x8:      times 8 dw  3973*8
pw_m2106x8:     times 8 dw -2106*8
pw_3513x8:      times 8 dw  3513*8
pw_2440x8:      times 8 dw  2440*8
pw_3290x8:      times 8 dw  3290*8
pw_m601x8:      times 8 dw  -601*8
pw_4052x8:      times 8 dw  4052*8

pw_4095x8:      times 8 dw  4095*8
pw_101x8:       times 8 dw   101*8
pw_2967x8:      times 8 dw  2967*8
pw_m2824x8:     times 8 dw -2824*8
pw_3745x8:      times 8 dw  3745*8
pw_1660x8:      times 8 dw  1660*8
pw_3822x8:      times 8 dw  3822*8
pw_m1474x8:     times 8 dw -1474*8
pw_3996x8:      times 8 dw  3996*8
pw_897x8:       times 8 dw   897*8
pw_3461x8:      times 8 dw  3461*8
pw_m2191x8:     times 8 dw -2191*8
pw_3349x8:      times 8 dw  3349*8
pw_2359x8:      times 8 dw  2359*8
pw_4036x8:      times 8 dw  4036*8
pw_m700x8:      times 8 dw  -700*8
pw_4065x8:      times 8 dw  4065*8
pw_501x8:       times 8 dw   501*8
pw_3229x8:      times 8 dw  3229*8
pw_m2520x8:     times 8 dw -2520*8
pw_3564x8:      times 8 dw  3564*8
pw_2019x8:      times 8 dw  2019*8
pw_3948x8:      times 8 dw  3948*8
pw_m1092x8:     times 8 dw -1092*8
pw_3889x8:      times 8 dw  3889*8
pw_1285x8:      times 8 dw  1285*8
pw_3659x8:      times 8 dw  3659*8
pw_m1842x8:     times 8 dw -1842*8
pw_3102x8:      times 8 dw  3102*8
pw_2675x8:      times 8 dw  2675*8
pw_4085x8:      times 8 dw  4085*8
pw_m301x8:      times 8 dw  -301*8

iadst4_dconly1a: times 2 dw 10568, 19856, 26752, 30424
iadst4_dconly1b: times 2 dw 30424, 26752, 19856, 10568
iadst4_dconly2a: dw 10568, 10568, 10568, 10568, 19856, 19856, 19856, 19856
iadst4_dconly2b: dw 26752, 26752, 26752, 26752, 30424, 30424, 30424, 30424

SECTION .text

%macro REPX 2-*
    %xdefine %%f(x) %1
%rep %0 - 1
    %rotate 1
    %%f(%1)
%endrep
%endmacro

%define m(x) mangle(private_prefix %+ _ %+ x %+ SUFFIX)

%if ARCH_X86_64
%define o(x) x
%else
%define o(x) r5-$$+x ; PIC
%endif

%macro WRITE_4X4 9  ;src[1-2], tmp[1-3], row[1-4]
    lea                  r2, [dstq+strideq*2]
%assign %%i 1
%rotate 5
%rep 4
    %if %1 & 2
        CAT_XDEFINE %%row_adr, %%i, r2   + strideq*(%1&1)
    %else
        CAT_XDEFINE %%row_adr, %%i, dstq + strideq*(%1&1)
    %endif
    %assign %%i %%i + 1
    %rotate 1
%endrep

    movd                 m%3, [%%row_adr1]        ;dst0
    movd                 m%5, [%%row_adr2]        ;dst1
    punpckldq            m%3, m%5                 ;high: dst1 :low: dst0
    movd                 m%4, [%%row_adr3]        ;dst2
    movd                 m%5, [%%row_adr4]        ;dst3
    punpckldq            m%4, m%5                 ;high: dst3 :low: dst2

    pxor                 m%5, m%5
    punpcklbw            m%3, m%5                 ;extend byte to word
    punpcklbw            m%4, m%5                 ;extend byte to word

    paddw                m%3, m%1                 ;high: dst1 + out1 ;low: dst0 + out0
    paddw                m%4, m%2                 ;high: dst3 + out3 ;low: dst2 + out2

    packuswb             m%3, m%4                 ;high->low: dst3 + out3, dst2 + out2, dst1 + out1, dst0 + out0

    movd        [%%row_adr1], m%3                  ;store dst0 + out0
    pshuflw              m%4, m%3, q1032
    movd        [%%row_adr2], m%4                  ;store dst1 + out1
    punpckhqdq           m%3, m%3
    movd        [%%row_adr3], m%3                  ;store dst2 + out2
    psrlq                m%3, 32
    movd        [%%row_adr4], m%3                  ;store dst3 + out3
%endmacro

%macro ITX4_END 4-5 2048 ; row[1-4], rnd
%if %5
    mova                 m2, [o(pw_%5)]
    pmulhrsw             m0, m2
    pmulhrsw             m1, m2
%endif

    WRITE_4X4            0, 1, 2, 3, 4, %1, %2, %3, %4
    ret
%endmacro

; flags: 1 = swap, 2: coef_regs
%macro ITX_MUL2X_PACK 5-6 0 ; dst/src, tmp[1], rnd, coef[1-2], flags
%if %6 & 2
    pmaddwd              m%2, m%4, m%1
    pmaddwd              m%1, m%5
%elif %6 & 1
    pmaddwd              m%2, m%1, [o(pw_%5_%4)]
    pmaddwd              m%1, [o(pw_%4_m%5)]
%else
    pmaddwd              m%2, m%1, [o(pw_%4_m%5)]
    pmaddwd              m%1, [o(pw_%5_%4)]
%endif
    paddd                m%2, m%3
    paddd                m%1, m%3
    psrad                m%2, 12
    psrad                m%1, 12
    packssdw             m%1, m%2
%endmacro

%macro IDCT4_1D_PACKED 0-1   ;pw_2896x8
    punpckhwd            m2, m0, m1            ;unpacked in1 in3
    psubw                m3, m0, m1
    paddw                m0, m1
    punpcklqdq           m0, m3                ;high: in0-in2 ;low: in0+in2

    mova                 m3, [o(pd_2048)]
    ITX_MUL2X_PACK        2, 1, 3, 1567, 3784

%if %0 == 1
    pmulhrsw             m0, m%1
%else
    pmulhrsw             m0, [o(pw_2896x8)]    ;high: t1 ;low: t0
%endif

    psubsw               m1, m0, m2            ;high: out2 ;low: out3
    paddsw               m0, m2                ;high: out1 ;low: out0
%endmacro

%macro INV_TXFM_FN 5+ ; type1, type2, fast_thresh, size, xmm/stack
cglobal inv_txfm_add_%1_%2_%4, 4, 6, %5, dst, stride, coeff, eob, tx2
    %undef cmp
    %define %%p1 m(i%1_%4_internal)
%if ARCH_X86_32
    LEA                    r5, $$
%endif
%if has_epilogue
%if %3 > 0
    cmp                  eobd, %3
    jle %%end
%elif %3 == 0
    test                 eobd, eobd
    jz %%end
%endif
    lea                  tx2q, [o(m(i%2_%4_internal).pass2)]
    call %%p1
    RET
%%end:
%else
    lea                  tx2q, [o(m(i%2_%4_internal).pass2)]
%if %3 > 0
    cmp                  eobd, %3
    jg %%p1
%elif %3 == 0
    test                 eobd, eobd
    jnz %%p1
%else
    times ((%%end - %%p1) >> 31) & 1 jmp %%p1
ALIGN function_align
%%end:
%endif
%endif
%endmacro

%macro INV_TXFM_4X4_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 4x4, 6
%ifidn %1_%2, dct_identity
    mova                 m0, [o(pw_2896x8)]
    pmulhrsw             m0, [coeffq]
    paddw                m0, m0
    pmulhrsw             m0, [o(pw_5793x4)]
    punpcklwd            m0, m0
    punpckhdq            m1, m0, m0
    punpckldq            m0, m0
    TAIL_CALL m(iadst_4x4_internal).end
%elifidn %1_%2, identity_dct
    mova                 m1, [coeffq+16*0]
    mova                 m2, [coeffq+16*1]
    punpcklwd            m0, m1, m2
    punpckhwd            m1, m2
    punpcklwd            m0, m1
    punpcklqdq           m0, m0
    paddw                m0, m0
    pmulhrsw             m0, [o(pw_5793x4)]
    pmulhrsw             m0, [o(pw_2896x8)]
    mova                 m1, m0
    TAIL_CALL m(iadst_4x4_internal).end
%elif %3 >= 0
    pshuflw              m0, [coeffq], q0000
    punpcklqdq           m0, m0
%ifidn %1, dct
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1
%elifidn %1, adst
    pmulhrsw             m0, [o(iadst4_dconly1a)]
%elifidn %1, flipadst
    pmulhrsw             m0, [o(iadst4_dconly1b)]
%endif
    mov            [coeffq], eobd                ;0
%ifidn %2, dct
%ifnidn %1, dct
    pmulhrsw             m0, [o(pw_2896x8)]
%else
    pmulhrsw             m0, m1
%endif
    mova                 m1, m0
    TAIL_CALL m(iadst_4x4_internal).end2
%else ; adst / flipadst
    pmulhrsw             m1, m0, [o(iadst4_dconly2b)]
    pmulhrsw             m0, [o(iadst4_dconly2a)]
    TAIL_CALL m(i%2_4x4_internal).end2
%endif
%endif
%endmacro

INIT_XMM ssse3

INV_TXFM_4X4_FN dct, dct,      0
INV_TXFM_4X4_FN dct, adst,     0
INV_TXFM_4X4_FN dct, flipadst, 0
INV_TXFM_4X4_FN dct, identity, 3

cglobal idct_4x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m0, [coeffq+16*0]      ;high: in1 ;low: in0
    mova                 m1, [coeffq+16*1]      ;high: in3 ;low in2

    IDCT4_1D_PACKED

    mova                 m2, [o(deint_shuf)]
    shufps               m3, m0, m1, q1331
    shufps               m0, m1, q0220
    pshufb               m0, m2                 ;high: in1 ;low: in0
    pshufb               m1, m3, m2             ;high: in3 ;low :in2
    jmp                tx2q

.pass2:
    IDCT4_1D_PACKED

    pxor                 m2, m2
    mova      [coeffq+16*0], m2
    mova      [coeffq+16*1], m2                 ;memset(coeff, 0, sizeof(*coeff) * sh * sw);

    ITX4_END     0, 1, 3, 2

INV_TXFM_4X4_FN adst, dct,      0
INV_TXFM_4X4_FN adst, adst,     0
INV_TXFM_4X4_FN adst, flipadst, 0
INV_TXFM_4X4_FN adst, identity

cglobal iadst_4x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    call .main
    punpckhwd            m2, m0, m1
    punpcklwd            m0, m1
    punpckhwd            m1, m0, m2       ;high: in3 ;low :in2
    punpcklwd            m0, m2           ;high: in1 ;low: in0
    jmp                tx2q

.pass2:
    call .main

.end:
    pxor                 m2, m2
    mova      [coeffq+16*0], m2
    mova      [coeffq+16*1], m2

.end2:
    ITX4_END              0, 1, 2, 3

ALIGN function_align
.main:
    punpcklwd            m2, m0, m1                ;unpacked in0 in2
    punpckhwd            m0, m1                    ;unpacked in1 in3
    mova                 m3, m0
    pmaddwd              m1, m2, [o(pw_3344_m3344)];3344 * in0 - 3344 * in2
    pmaddwd              m0, [o(pw_0_3344)]        ;3344 * in3
    paddd                m1, m0                    ;t2
    pmaddwd              m0, m2, [o(pw_1321_3803)] ;1321 * in0 + 3803 * in2
    pmaddwd              m2, [o(pw_2482_m1321)]    ;2482 * in0 - 1321 * in2
    pmaddwd              m4, m3, [o(pw_3344_2482)] ;3344 * in1 + 2482 * in3
    pmaddwd              m5, m3, [o(pw_3344_m3803)];3344 * in1 - 3803 * in3
    paddd                m4, m0                    ;t0 + t3
    pmaddwd              m3, [o(pw_m6688_m3803)]   ;-2 * 3344 * in1 - 3803 * in3
    mova                 m0, [o(pd_2048)]
    paddd                m1, m0                    ;t2 + 2048
    paddd                m2, m0
    paddd                m0, m4                    ;t0 + t3 + 2048
    paddd                m5, m2                    ;t1 + t3 + 2048
    paddd                m2, m4
    paddd                m2, m3                    ;t0 + t1 - t3 + 2048
    REPX      {psrad x, 12}, m1, m0, m5, m2
    packssdw             m0, m5                    ;high: out1 ;low: out0
    packssdw             m1, m2                    ;high: out3 ;low: out3
    ret

INV_TXFM_4X4_FN flipadst, dct,      0
INV_TXFM_4X4_FN flipadst, adst,     0
INV_TXFM_4X4_FN flipadst, flipadst, 0
INV_TXFM_4X4_FN flipadst, identity

cglobal iflipadst_4x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    call m(iadst_4x4_internal).main
    punpcklwd            m2, m1, m0
    punpckhwd            m1, m0
    punpcklwd            m0, m1, m2            ;high: in3 ;low :in2
    punpckhwd            m1, m2                ;high: in1 ;low: in0
    jmp                tx2q

.pass2:
    call m(iadst_4x4_internal).main

.end:
    pxor                 m2, m2
    mova      [coeffq+16*0], m2
    mova      [coeffq+16*1], m2

.end2:
    ITX4_END              3, 2, 1, 0

INV_TXFM_4X4_FN identity, dct,      3
INV_TXFM_4X4_FN identity, adst
INV_TXFM_4X4_FN identity, flipadst
INV_TXFM_4X4_FN identity, identity

cglobal iidentity_4x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    mova                 m2, [o(pw_5793x4)]
    paddw                m0, m0
    paddw                m1, m1
    pmulhrsw             m0, m2
    pmulhrsw             m1, m2

    punpckhwd            m2, m0, m1
    punpcklwd            m0, m1
    punpckhwd            m1, m0, m2            ;high: in3 ;low :in2
    punpcklwd            m0, m2                ;high: in1 ;low: in0
    jmp                tx2q

.pass2:
    mova                 m2, [o(pw_5793x4)]
    paddw                m0, m0
    paddw                m1, m1
    pmulhrsw             m0, m2
    pmulhrsw             m1, m2
    jmp m(iadst_4x4_internal).end

%macro IWHT4_1D_PACKED 0
    punpckhqdq           m3, m0, m1            ;low: in1 high: in3
    punpcklqdq           m0, m1                ;low: in0 high: in2
    psubw                m2, m0, m3            ;low: in0 - in1 high: in2 - in3
    paddw                m0, m3                ;low: in0 + in1 high: in2 + in3
    punpckhqdq           m2, m2                ;t2 t2
    punpcklqdq           m0, m0                ;t0 t0
    psubw                m1, m0, m2
    psraw                m1, 1                 ;t4 t4
    psubw                m1, m3                ;low: t1/out2 high: t3/out1
    psubw                m0, m1                ;high: out0
    paddw                m2, m1                ;low: out3
%endmacro

cglobal inv_txfm_add_wht_wht_4x4, 3, 3, 4, dst, stride, coeff
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    pxor                 m2, m2
    mova      [coeffq+16*0], m2
    mova      [coeffq+16*1], m2
    psraw                m0, 2
    psraw                m1, 2

    IWHT4_1D_PACKED

    punpckhwd            m0, m1
    punpcklwd            m3, m1, m2
    punpckhdq            m1, m0, m3
    punpckldq            m0, m3

    IWHT4_1D_PACKED

    shufpd               m0, m2, 0x01
    ITX4_END              0, 3, 2, 1, 0


%macro IDCT8_1D_PACKED 0
    mova                 m6, [o(pd_2048)]
    punpckhwd            m5, m0, m3                 ;unpacked in1 in7
    punpckhwd            m4, m2, m1                 ;unpacked in5 in3
    punpcklwd            m1, m3                     ;unpacked in2 in6
    psubw                m3, m0, m2
    paddw                m0, m2
    punpcklqdq           m0, m3                     ;low: in0+in4 high: in0-in4
    ITX_MUL2X_PACK        5, 2, 6,  799, 4017, 1    ;low: t4a high: t7a
    ITX_MUL2X_PACK        4, 2, 6, 3406, 2276, 1    ;low: t5a high: t6a
    ITX_MUL2X_PACK        1, 2, 6, 1567, 3784       ;low: t3  high: t2
    mova                 m6, [o(pw_2896x8)]
    psubsw               m2, m5, m4                 ;low: t5a high: t6a
    paddsw               m5, m4                     ;low: t4  high: t7
    punpckhqdq           m4, m2, m2                 ;low: t6a high: t6a
    psubw                m3, m4, m2                 ;low: t6a - t5a
    paddw                m4, m2                     ;low: t6a + t5a
    punpcklqdq           m4, m3                     ;low: t6a + t5a high: t6a - t5a
    pmulhrsw             m0, m6                     ;low: t0   high: t1
    pmulhrsw             m4, m6                     ;low: t6   high: t5
    shufps               m2, m5, m4, q1032          ;low: t7   high: t6
    shufps               m5, m4, q3210              ;low: t4   high: t5
    psubsw               m4, m0, m1                 ;low: tmp3 high: tmp2
    paddsw               m0, m1                     ;low: tmp0 high: tmp1
    psubsw               m3, m0, m2                 ;low: out7 high: out6
    paddsw               m0, m2                     ;low: out0 high: out1
    psubsw               m2, m4, m5                 ;low: out4 high: out5
    paddsw               m1, m4, m5                 ;low: out3 high: out2
%endmacro

;dst1 = (src1 * coef1 - src2 * coef2 + rnd) >> 12
;dst2 = (src1 * coef2 + src2 * coef1 + rnd) >> 12
%macro ITX_MULSUB_2W 7 ; dst/src[1-2], tmp[1-2], rnd, coef[1-2]
    punpckhwd           m%3, m%1, m%2
    punpcklwd           m%1, m%2
%if %7 < 8
    pmaddwd             m%2, m%7, m%1
    pmaddwd             m%4, m%7, m%3
%else
    mova                m%2, [o(pw_%7_%6)]
    pmaddwd             m%4, m%3, m%2
    pmaddwd             m%2, m%1
%endif
    paddd               m%4, m%5
    paddd               m%2, m%5
    psrad               m%4, 12
    psrad               m%2, 12
    packssdw            m%2, m%4                 ;dst2
%if %7 < 8
    pmaddwd             m%3, m%6
    pmaddwd             m%1, m%6
%else
    mova                m%4, [o(pw_%6_m%7)]
    pmaddwd             m%3, m%4
    pmaddwd             m%1, m%4
%endif
    paddd               m%3, m%5
    paddd               m%1, m%5
    psrad               m%3, 12
    psrad               m%1, 12
    packssdw            m%1, m%3                 ;dst1
%endmacro

%macro IDCT4_1D 7 ; src[1-4], tmp[1-2], pd_2048
    ITX_MULSUB_2W        %2, %4, %5, %6, %7, 1567, 3784   ;t2, t3
    mova                m%6, [o(pw_2896x8)]
    paddw               m%5, m%1, m%3
    psubw               m%1, m%3
    pmulhrsw            m%1, m%6                          ;t1
    pmulhrsw            m%5, m%6                          ;t0
    psubsw              m%3, m%1, m%2                     ;out2
    paddsw              m%2, m%1                          ;out1
    paddsw              m%1, m%5, m%4                     ;out0
    psubsw              m%5, m%4                          ;out3
    mova                m%4, m%5
%endmacro

%macro WRITE_4X8 4 ;row[1-4]
    WRITE_4X4             0, 1, 4, 5, 6, %1, %2, %3, %4
    lea                dstq, [dstq+strideq*4]
    WRITE_4X4             2, 3, 4, 5, 6, %1, %2, %3, %4
%endmacro

%macro INV_4X8 0
    punpckhwd            m4, m2, m3
    punpcklwd            m2, m3
    punpckhwd            m3, m0, m1
    punpcklwd            m0, m1
    punpckhdq            m1, m0, m2                  ;low: in2 high: in3
    punpckldq            m0, m2                      ;low: in0 high: in1
    punpckldq            m2, m3, m4                  ;low: in4 high: in5
    punpckhdq            m3, m4                      ;low: in6 high: in7
%endmacro

%macro INV_TXFM_4X8_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 4x8, 8
%if %3 >= 0
%ifidn %1_%2, dct_identity
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1, [coeffq]
    pmulhrsw             m0, m1
    pmulhrsw             m0, [o(pw_4096)]
    punpckhwd            m2, m0, m0
    punpcklwd            m0, m0
    punpckhdq            m1, m0, m0
    punpckldq            m0, m0
    punpckhdq            m3, m2, m2
    punpckldq            m2, m2
    TAIL_CALL m(iadst_4x8_internal).end3
%elifidn %1_%2, identity_dct
    movd                 m0, [coeffq+16*0]
    punpcklwd            m0, [coeffq+16*1]
    movd                 m1, [coeffq+16*2]
    punpcklwd            m1, [coeffq+16*3]
    mova                 m2, [o(pw_2896x8)]
    punpckldq            m0, m1
    pmulhrsw             m0, m2
    paddw                m0, m0
    pmulhrsw             m0, [o(pw_5793x4)]
    pmulhrsw             m0, m2
    pmulhrsw             m0, [o(pw_2048)]
    punpcklqdq           m0, m0
    mova                 m1, m0
    mova                 m2, m0
    mova                 m3, m0
    TAIL_CALL m(iadst_4x8_internal).end3
%elifidn %1_%2, dct_dct
    pshuflw              m0, [coeffq], q0000
    punpcklqdq           m0, m0
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1
    mov           [coeffq], eobd
    pmulhrsw             m0, m1
    pmulhrsw             m0, m1
    pmulhrsw             m0, [o(pw_2048)]
    mova                 m1, m0
    mova                 m2, m0
    mova                 m3, m0
    TAIL_CALL m(iadst_4x8_internal).end4
%else ; adst_dct / flipadst_dct
    pshuflw              m0, [coeffq], q0000
    punpcklqdq           m0, m0
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1
%ifidn %1, adst
    pmulhrsw             m0, [o(iadst4_dconly1a)]
%else ; flipadst
    pmulhrsw             m0, [o(iadst4_dconly1b)]
%endif
    mov            [coeffq], eobd
    pmulhrsw             m0, m1
    pmulhrsw             m0, [o(pw_2048)]
    mova                 m1, m0
    mova                 m2, m0
    mova                 m3, m0
    TAIL_CALL m(iadst_4x8_internal).end4
%endif
%endif
%endmacro

INV_TXFM_4X8_FN dct, dct,      0
INV_TXFM_4X8_FN dct, identity, 7
INV_TXFM_4X8_FN dct, adst
INV_TXFM_4X8_FN dct, flipadst

cglobal idct_4x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

.pass1:
    call m(idct_8x4_internal).main
    jmp m(iadst_4x8_internal).pass1_end

.pass2:
    call .main
    shufps               m1, m1, q1032
    shufps               m3, m3, q1032
    mova                 m4, [o(pw_2048)]
    jmp m(iadst_4x8_internal).end2

ALIGN function_align
.main:
    IDCT8_1D_PACKED
    ret


INV_TXFM_4X8_FN adst, dct,      0
INV_TXFM_4X8_FN adst, adst
INV_TXFM_4X8_FN adst, flipadst
INV_TXFM_4X8_FN adst, identity

cglobal iadst_4x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

.pass1:
    call m(iadst_8x4_internal).main

.pass1_end:
    INV_4X8
    jmp                tx2q

.pass2:
    shufps               m0, m0, q1032
    shufps               m1, m1, q1032
    call .main
    mova                 m4, [o(pw_2048)]
    pxor                 m5, m5
    psubw                m5, m4

.end:
    punpcklqdq           m4, m5

.end2:
    pmulhrsw             m0, m4
    pmulhrsw             m1, m4
    pmulhrsw             m2, m4
    pmulhrsw             m3, m4

.end3:
    pxor                 m5, m5
    mova      [coeffq+16*0], m5
    mova      [coeffq+16*1], m5
    mova      [coeffq+16*2], m5
    mova      [coeffq+16*3], m5

.end4:
    WRITE_4X8             0, 1, 2, 3
    RET

ALIGN function_align
.main:
    mova                 m6, [o(pd_2048)]
    punpckhwd            m4, m3, m0                ;unpacked in7 in0
    punpckhwd            m5, m2, m1                ;unpacked in5 in2
    punpcklwd            m1, m2                    ;unpacked in3 in4
    punpcklwd            m0, m3                    ;unpacked in1 in6
    ITX_MUL2X_PACK        4, 2, 6,  401, 4076      ;low:  t0a   high:  t1a
    ITX_MUL2X_PACK        5, 2, 6, 1931, 3612      ;low:  t2a   high:  t3a
    ITX_MUL2X_PACK        1, 2, 6, 3166, 2598      ;low:  t4a   high:  t5a
    ITX_MUL2X_PACK        0, 2, 6, 3920, 1189      ;low:  t6a   high:  t7a

    psubsw               m3, m4, m1                ;low:  t4    high:  t5
    paddsw               m4, m1                    ;low:  t0    high:  t1
    psubsw               m2, m5, m0                ;low:  t6    high:  t7
    paddsw               m5, m0                    ;low:  t2    high:  t3

    shufps               m1, m3, m2, q1032
    punpckhwd            m2, m1
    punpcklwd            m3, m1
    ITX_MUL2X_PACK        3, 0, 6, 1567, 3784, 1   ;low:  t5a   high:  t4a
    ITX_MUL2X_PACK        2, 0, 6, 3784, 1567      ;low:  t7a   high:  t6a

    psubsw               m1, m4, m5                ;low:  t2    high:  t3
    paddsw               m4, m5                    ;low:  out0  high: -out7
    psubsw               m5, m3, m2                ;low:  t7    high:  t6
    paddsw               m3, m2                    ;low:  out6  high: -out1
    shufps               m0, m4, m3, q3210         ;low:  out0  high: -out1
    shufps               m3, m4, q3210             ;low:  out6  high: -out7

    mova                 m2, [o(pw_2896_m2896)]
    mova                 m7, [o(pw_2896_2896)]
    shufps               m4, m1, m5, q1032         ;low:  t3    high:  t7
    shufps               m1, m5, q3210             ;low:  t2    high:  t6
    punpcklwd            m5, m1, m4
    punpckhwd            m1, m4
    pmaddwd              m4, m2, m1                ;-out5
    pmaddwd              m2, m5                    ; out4
    pmaddwd              m1, m7                    ; out2
    pmaddwd              m5, m7                    ;-out3
    REPX      {paddd x, m6}, m4, m2, m1, m5
    REPX      {psrad x, 12}, m4, m2, m1, m5
    packssdw             m1, m5                    ;low:  out2  high: -out3
    packssdw             m2, m4                    ;low:  out4  high: -out5
    ret

INV_TXFM_4X8_FN flipadst, dct,      0
INV_TXFM_4X8_FN flipadst, adst
INV_TXFM_4X8_FN flipadst, flipadst
INV_TXFM_4X8_FN flipadst, identity

cglobal iflipadst_4x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

.pass1:
    call m(iadst_8x4_internal).main

    punpcklwd            m4, m3, m2
    punpckhwd            m3, m2
    punpcklwd            m5, m1, m0
    punpckhwd            m1, m0
    punpckldq            m2, m3, m1                  ;low: in4 high: in5
    punpckhdq            m3, m1                      ;low: in6 high: in7
    punpckldq            m0, m4, m5                  ;low: in0 high: in1
    punpckhdq            m1, m4, m5                  ;low: in2 high: in3
    jmp                tx2q

.pass2:
    shufps               m0, m0, q1032
    shufps               m1, m1, q1032
    call m(iadst_4x8_internal).main

    mova                 m4, m0
    mova                 m5, m1
    pshufd               m0, m3, q1032
    pshufd               m1, m2, q1032
    pshufd               m2, m5, q1032
    pshufd               m3, m4, q1032
    mova                 m5, [o(pw_2048)]
    pxor                 m4, m4
    psubw                m4, m5
    jmp m(iadst_4x8_internal).end

INV_TXFM_4X8_FN identity, dct,      3
INV_TXFM_4X8_FN identity, adst
INV_TXFM_4X8_FN identity, flipadst
INV_TXFM_4X8_FN identity, identity

cglobal iidentity_4x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

.pass1:
    mova                 m5, [o(pw_5793x4)]
    paddw                m0, m0
    paddw                m1, m1
    paddw                m2, m2
    paddw                m3, m3
    pmulhrsw             m0, m5
    pmulhrsw             m1, m5
    pmulhrsw             m2, m5
    pmulhrsw             m3, m5

    jmp m(iadst_4x8_internal).pass1_end

.pass2:
    mova                 m4, [o(pw_4096)]
    jmp m(iadst_4x8_internal).end2


%macro WRITE_8X2 5       ;coefs[1-2], tmp[1-3]
    movq                 m%3, [dstq        ]
    movq                 m%4, [dstq+strideq]
    pxor                 m%5, m%5
    punpcklbw            m%3, m%5                 ;extend byte to word
    punpcklbw            m%4, m%5                 ;extend byte to word
%ifnum %1
    paddw                m%3, m%1
%else
    paddw                m%3, %1
%endif
%ifnum %2
    paddw                m%4, m%2
%else
    paddw                m%4, %2
%endif
    packuswb             m%3, m%4
    movq      [dstq        ], m%3
    punpckhqdq           m%3, m%3
    movq      [dstq+strideq], m%3
%endmacro

%macro WRITE_8X4 7      ;coefs[1-4], tmp[1-3]
    WRITE_8X2             %1, %2, %5, %6, %7
    lea                dstq, [dstq+strideq*2]
    WRITE_8X2             %3, %4, %5, %6, %7
%endmacro

%macro INV_TXFM_8X4_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 8x4, 8
%if %3 >= 0
%ifidn %1_%2, dct_identity
    mova                 m0, [o(pw_2896x8)]
    pmulhrsw             m1, m0, [coeffq]
    pmulhrsw             m1, m0
    paddw                m1, m1
    pmulhrsw             m1, [o(pw_5793x4)]
    pmulhrsw             m1, [o(pw_2048)]
    punpcklwd            m1, m1
    punpckhdq            m2, m1, m1
    punpckldq            m1, m1
    punpckhdq            m3, m2, m2
    punpckldq            m2, m2
    punpckldq            m0, m1, m1
    punpckhdq            m1, m1
%elifidn %1_%2, identity_dct
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    mova                 m2, [coeffq+16*2]
    mova                 m3, [coeffq+16*3]
    punpckhwd            m4, m0, m1
    punpcklwd            m0, m1
    punpckhwd            m5, m2, m3
    punpcklwd            m2, m3
    punpcklwd            m0, m4
    punpcklwd            m2, m5
    punpcklqdq           m0, m2
    mova                 m4, [o(pw_2896x8)]
    pmulhrsw             m0, m4
    paddw                m0, m0
    pmulhrsw             m0, m4
    pmulhrsw             m0, [o(pw_2048)]
    mova                 m1, m0
    mova                 m2, m0
    mova                 m3, m0
%else
    pshuflw              m0, [coeffq], q0000
    punpcklqdq           m0, m0
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1
    pmulhrsw             m0, m1
%ifidn %2, dct
    mova                 m2, [o(pw_2048)]
    pmulhrsw             m0, m1
    pmulhrsw             m0, m2
    mova                 m1, m0
    mova                 m2, m0
    mova                 m3, m0
%else ; adst / flipadst
    pmulhrsw             m2, m0, [o(iadst4_dconly2b)]
    pmulhrsw             m0, [o(iadst4_dconly2a)]
    mova                 m1, [o(pw_2048)]
    pmulhrsw             m0, m1
    pmulhrsw             m2, m1
%ifidn %2, adst
    punpckhqdq           m1, m0, m0
    punpcklqdq           m0, m0
    punpckhqdq           m3, m2, m2
    punpcklqdq           m2, m2
%else ; flipadst
    mova                 m3, m0
    punpckhqdq           m0, m2, m2
    punpcklqdq           m1, m2, m2
    punpckhqdq           m2, m3, m3
    punpcklqdq           m3, m3
%endif
%endif
%endif
    TAIL_CALL m(iadst_8x4_internal).end2
%endif
%endmacro

INV_TXFM_8X4_FN dct, dct,      0
INV_TXFM_8X4_FN dct, adst,     0
INV_TXFM_8X4_FN dct, flipadst, 0
INV_TXFM_8X4_FN dct, identity, 3

cglobal idct_8x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

    call m(idct_4x8_internal).main

    mova                 m4, [o(deint_shuf1)]
    mova                 m5, [o(deint_shuf2)]
    pshufb               m0, m4
    pshufb               m1, m5
    pshufb               m2, m4
    pshufb               m3, m5
    punpckhdq            m4, m0, m1
    punpckldq            m0, m1
    punpckhdq            m5, m2, m3
    punpckldq            m2, m3
    punpckhqdq           m1, m0, m2                      ;in1
    punpcklqdq           m0, m2                          ;in0
    punpckhqdq           m3, m4, m5                      ;in3
    punpcklqdq           m2 ,m4, m5                      ;in2
    jmp                tx2q

.pass2:
    call .main
    jmp m(iadst_8x4_internal).end

ALIGN function_align
.main:
    mova                 m6, [o(pd_2048)]
    IDCT4_1D             0, 1, 2, 3, 4, 5, 6
    ret

INV_TXFM_8X4_FN adst, dct
INV_TXFM_8X4_FN adst, adst
INV_TXFM_8X4_FN adst, flipadst
INV_TXFM_8X4_FN adst, identity

cglobal iadst_8x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

    shufps               m0, m0, q1032
    shufps               m1, m1, q1032
    call m(iadst_4x8_internal).main

    punpckhwd            m4, m0, m1
    punpcklwd            m0, m1
    punpckhwd            m1, m2, m3
    punpcklwd            m2, m3
    pxor                 m5, m5
    psubw                m3, m5, m1
    psubw                m5, m4
    punpckhdq            m4, m5, m3
    punpckldq            m5, m3
    punpckhdq            m3, m0, m2
    punpckldq            m0, m2
    punpckhwd            m1, m0, m5      ;in1
    punpcklwd            m0, m5          ;in0
    punpcklwd            m2, m3, m4      ;in2
    punpckhwd            m3, m4          ;in3
    jmp              tx2q

.pass2:
    call .main

.end:
    mova                 m4, [o(pw_2048)]
    pmulhrsw             m0, m4
    pmulhrsw             m1, m4
    pmulhrsw             m2, m4
    pmulhrsw             m3, m4

.end2:
    pxor                 m6, m6
    mova      [coeffq+16*0], m6
    mova      [coeffq+16*1], m6
    mova      [coeffq+16*2], m6
    mova      [coeffq+16*3], m6
.end3:
    WRITE_8X4             0, 1, 2, 3, 4, 5, 6
    RET

ALIGN function_align
.main:
    punpckhwd            m6, m0, m2                    ;unpacked in0 in2
    punpcklwd            m0, m2                        ;unpacked in0 in2
    punpckhwd            m7, m1, m3                    ;unpacked in1 in3
    punpcklwd            m1, m3                        ;unpacked in1 in3

    mova                 m2, [o(pw_3344_m3344)]
    mova                 m4, [o(pw_0_3344)]
    pmaddwd              m3, m2, m6                    ;3344 * in0 - 3344 * in2
    pmaddwd              m5, m4, m7                    ;3344 * in3
    pmaddwd              m2, m0
    pmaddwd              m4, m1
    paddd                m3, m5
    paddd                m2, m4
    mova                 m4, [o(pd_2048)]
    paddd                m3, m4                        ;t2 + 2048
    paddd                m2, m4
    psrad                m3, 12
    psrad                m2, 12
    packssdw             m2, m3                        ;out2

    pmaddwd              m4, m0, [o(pw_1321_3803)]     ;1321 * in0 + 3803 * in2
    pmaddwd              m0, [o(pw_2482_m1321)]        ;2482 * in0 - 1321 * in2
    pmaddwd              m3, m1, [o(pw_3344_2482)]     ;3344 * in1 + 2482 * in3
    pmaddwd              m5, m1, [o(pw_3344_m3803)]    ;3344 * in1 - 3803 * in3
    paddd                m3, m4                        ;t0 + t3

    pmaddwd              m1, [o(pw_m6688_m3803)]       ;-2 * 3344 * in1 - 3803 * in3
    mova                 m4, [o(pd_2048)]
    paddd                m0, m4
    paddd                m4, m3                        ;t0 + t3 + 2048
    paddd                m5, m0                        ;t1 + t3 + 2048
    paddd                m3, m0
    paddd                m3, m1                        ;t0 + t1 - t3 + 2048

    psrad                m4, 12                        ;out0
    psrad                m5, 12                        ;out1
    psrad                m3, 12                        ;out3
    packssdw             m0, m4, m5                    ;low: out0  high: out1

    pmaddwd              m4, m6, [o(pw_1321_3803)]     ;1321 * in0 + 3803 * in2
    pmaddwd              m6, [o(pw_2482_m1321)]        ;2482 * in0 - 1321 * in2
    pmaddwd              m1, m7, [o(pw_3344_2482)]     ;3344 * in1 + 2482 * in3
    pmaddwd              m5, m7, [o(pw_3344_m3803)]    ;3344 * in1 - 3803 * in3
    paddd                m1, m4                        ;t0 + t3
    pmaddwd              m7, [o(pw_m6688_m3803)]       ;-2 * 3344 * in1 - 3803 * in3

    mova                 m4, [o(pd_2048)]
    paddd                m6, m4
    paddd                m4, m1                        ;t0 + t3 + 2048
    paddd                m5, m6                        ;t1 + t3 + 2048
    paddd                m1, m6
    paddd                m1, m7                        ;t0 + t1 - t3 + 2048

    psrad                m4, 12                        ;out0
    psrad                m5, 12                        ;out1
    psrad                m1, 12                        ;out3
    packssdw             m3, m1                        ;out3
    packssdw             m4, m5                        ;low: out0  high: out1

    punpckhqdq           m1, m0, m4                    ;out1
    punpcklqdq           m0, m4                        ;out0
    ret

INV_TXFM_8X4_FN flipadst, dct
INV_TXFM_8X4_FN flipadst, adst
INV_TXFM_8X4_FN flipadst, flipadst
INV_TXFM_8X4_FN flipadst, identity

cglobal iflipadst_8x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]

    shufps               m0, m0, q1032
    shufps               m1, m1, q1032
    call m(iadst_4x8_internal).main

    punpckhwd            m5, m3, m2
    punpcklwd            m3, m2
    punpckhwd            m2, m1, m0
    punpcklwd            m1, m0

    pxor                 m0, m0
    psubw                m4, m0, m2
    psubw                m0, m5
    punpckhdq            m2, m0, m4
    punpckldq            m0, m4
    punpckhdq            m4, m3, m1
    punpckldq            m3, m1
    punpckhwd            m1, m0, m3      ;in1
    punpcklwd            m0, m3          ;in0
    punpckhwd            m3, m2, m4      ;in3
    punpcklwd            m2, m4          ;in2
    jmp                  tx2q

.pass2:
    call m(iadst_8x4_internal).main
    mova                 m4, m0
    mova                 m5, m1
    mova                 m0, m3
    mova                 m1, m2
    mova                 m2, m5
    mova                 m3, m4
    jmp m(iadst_8x4_internal).end

INV_TXFM_8X4_FN identity, dct,      7
INV_TXFM_8X4_FN identity, adst
INV_TXFM_8X4_FN identity, flipadst
INV_TXFM_8X4_FN identity, identity

cglobal iidentity_8x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [coeffq+16*0]
    pmulhrsw             m1, m3, [coeffq+16*1]
    pmulhrsw             m2, m3, [coeffq+16*2]
    pmulhrsw             m3,     [coeffq+16*3]
    paddw                m0, m0
    paddw                m1, m1
    paddw                m2, m2
    paddw                m3, m3

    punpckhwd            m4, m0, m1
    punpcklwd            m0, m1
    punpckhwd            m1, m2, m3
    punpcklwd            m2, m3
    punpckhdq            m5, m4, m1
    punpckldq            m4, m1
    punpckhdq            m3, m0, m2
    punpckldq            m0, m2
    punpckhwd            m1, m0, m4      ;in1
    punpcklwd            m0, m4          ;in0
    punpcklwd            m2, m3, m5      ;in2
    punpckhwd            m3, m5          ;in3
    jmp                tx2q

.pass2:
    mova                 m4, [o(pw_5793x4)]
    paddw                m0, m0
    paddw                m1, m1
    paddw                m2, m2
    paddw                m3, m3
    pmulhrsw             m0, m4
    pmulhrsw             m1, m4
    pmulhrsw             m2, m4
    pmulhrsw             m3, m4
    jmp m(iadst_8x4_internal).end

%macro INV_TXFM_8X8_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 8x8, 8, 16*4
%ifidn %1_%2, dct_identity
    mova                 m0, [o(pw_2896x8)]
    pmulhrsw             m0, [coeffq]
    mova                 m1, [o(pw_16384)]
    pmulhrsw             m0, m1
    psrlw                m1, 2
    pmulhrsw             m0, m1
    punpckhwd            m7, m0, m0
    punpcklwd            m0, m0
    pshufd               m3, m0, q3333
    pshufd               m2, m0, q2222
    pshufd               m1, m0, q1111
    pshufd               m0, m0, q0000
    call m(iadst_8x4_internal).end2
    pshufd               m3, m7, q3333
    pshufd               m2, m7, q2222
    pshufd               m1, m7, q1111
    pshufd               m0, m7, q0000
    lea                dstq, [dstq+strideq*2]
    TAIL_CALL m(iadst_8x4_internal).end3
%elif %3 >= 0
%ifidn %1, dct
    pshuflw              m0, [coeffq], q0000
    punpcklwd            m0, m0
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1
    mova                 m2, [o(pw_16384)]
    mov            [coeffq], eobd
    pmulhrsw             m0, m2
    psrlw                m2, 3
    pmulhrsw             m0, m1
    pmulhrsw             m0, m2
.end:
    mov                 r3d, 2
    lea                tx2q, [o(m(inv_txfm_add_dct_dct_8x8).end3)]
.loop:
    WRITE_8X4             0, 0, 0, 0, 1, 2, 3
    lea                dstq, [dstq+strideq*2]
    dec                 r3d
    jg .loop
    jmp                tx2q
.end3:
    RET
%else ; identity
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    mova                 m2, [coeffq+16*2]
    mova                 m3, [coeffq+16*3]
    punpcklwd            m0, [coeffq+16*4]
    punpcklwd            m1, [coeffq+16*5]
    punpcklwd            m2, [coeffq+16*6]
    punpcklwd            m3, [coeffq+16*7]
    punpcklwd            m0, m2
    punpcklwd            m1, m3
    punpcklwd            m0, m1
    pmulhrsw             m0, [o(pw_2896x8)]
    pmulhrsw             m0, [o(pw_2048)]
    pxor                 m4, m4
    REPX {mova [coeffq+16*x], m4}, 0,  1,  2,  3,  4,  5,  6,  7
    jmp m(inv_txfm_add_dct_dct_8x8).end
%endif
%endif
%endmacro

%macro LOAD_8ROWS 2-3 0 ; src, stride, is_rect2
%if %3
    mova                 m7, [o(pw_2896x8)]
    pmulhrsw             m0, m7, [%1+%2*0]
    pmulhrsw             m1, m7, [%1+%2*1]
    pmulhrsw             m2, m7, [%1+%2*2]
    pmulhrsw             m3, m7, [%1+%2*3]
    pmulhrsw             m4, m7, [%1+%2*4]
    pmulhrsw             m5, m7, [%1+%2*5]
    pmulhrsw             m6, m7, [%1+%2*6]
    pmulhrsw             m7, [%1+%2*7]
%else
    mova                 m0, [%1+%2*0]
    mova                 m1, [%1+%2*1]
    mova                 m2, [%1+%2*2]
    mova                 m3, [%1+%2*3]
    mova                 m4, [%1+%2*4]
    mova                 m5, [%1+%2*5]
    mova                 m6, [%1+%2*6]
    mova                 m7, [%1+%2*7]
%endif
%endmacro

%macro IDCT8_1D_ODDHALF 7 ; src[1-4], tmp[1-2], pd_2048
    ITX_MULSUB_2W        %1, %4, %5, %6, %7,  799, 4017   ;t4a, t7a
    ITX_MULSUB_2W        %3, %2, %5, %6, %7, 3406, 2276   ;t5a, t6a
    psubsw               m%5, m%1, m%3                    ;t5a
    paddsw               m%1, m%3                         ;t4
    psubsw               m%6, m%4, m%2                    ;t6a
    paddsw               m%4, m%2                         ;t7
    mova                 m%3, [o(pw_2896x8)]
    psubw                m%2, m%6, m%5                    ;t6a - t5a
    paddw                m%6, m%5                         ;t6a + t5a
    pmulhrsw             m%2, m%3                         ;t5
    pmulhrsw             m%3, m%6                         ;t6
%endmacro

INV_TXFM_8X8_FN dct, dct,      0
INV_TXFM_8X8_FN dct, identity, 7
INV_TXFM_8X8_FN dct, adst
INV_TXFM_8X8_FN dct, flipadst

cglobal idct_8x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS          coeffq, 16

.pass1:
    call .main

.pass1_end:
    mova                    m7, [o(pw_16384)]

.pass1_end1:
    REPX      {pmulhrsw x, m7}, m0, m2, m4, m6
    mova    [rsp+gprsize+16*1], m6

.pass1_end2:
    REPX      {pmulhrsw x, m7}, m1, m3, m5
    pmulhrsw                m7, [rsp+gprsize+16*0]

.pass1_end3:
    punpcklwd               m6, m1, m5             ;10 50 11 51 12 52 13 53
    punpckhwd               m1, m5                 ;14 54 15 55 16 56 17 57
    punpckhwd               m5, m0, m4             ;04 44 05 45 06 46 07 47
    punpcklwd               m0, m4                 ;00 40 01 41 02 42 03 43
    punpckhwd               m4, m3, m7             ;34 74 35 75 36 76 37 77
    punpcklwd               m3, m7                 ;30 70 31 71 32 72 33 73
    punpckhwd               m7, m1, m4             ;16 36 56 76 17 37 57 77
    punpcklwd               m1, m4                 ;14 34 54 74 15 35 55 75
    punpckhwd               m4, m6, m3             ;12 32 52 72 13 33 53 73
    punpcklwd               m6, m3                 ;10 30 50 70 11 31 51 71
    mova    [rsp+gprsize+16*2], m6
    mova                    m6, [rsp+gprsize+16*1]
    punpckhwd               m3, m2, m6             ;24 64 25 65 26 66 27 67
    punpcklwd               m2, m6                 ;20 60 21 61 22 62 23 63
    punpckhwd               m6, m5, m3             ;06 26 46 66 07 27 47 67
    punpcklwd               m5, m3                 ;04 24 44 64 05 25 45 65
    punpckhwd               m3, m0, m2             ;02 22 42 62 03 23 43 63
    punpcklwd               m0, m2                 ;00 20 40 60 01 21 41 61

    punpckhwd               m2, m6, m7             ;07 17 27 37 47 57 67 77
    punpcklwd               m6, m7                 ;06 16 26 36 46 56 66 76
    mova    [rsp+gprsize+16*0], m2
    punpcklwd               m2, m3, m4             ;02 12 22 32 42 52 62 72
    punpckhwd               m3, m4                 ;03 13 23 33 43 53 63 73
    punpcklwd               m4, m5, m1             ;04 14 24 34 44 54 64 74
    punpckhwd               m5, m1                 ;05 15 25 35 45 55 65 75
    mova                    m7, [rsp+gprsize+16*2]
    punpckhwd               m1, m0, m7             ;01 11 21 31 41 51 61 71
    punpcklwd               m0, m7                 ;00 10 20 30 40 50 60 70
    mova                    m7, [rsp+gprsize+16*0]
    jmp                   tx2q

.pass2:
    lea                   tx2q, [o(m(idct_8x8_internal).end4)]

.pass2_main:
    call .main

.end:
    mova                    m7, [o(pw_2048)]
    REPX      {pmulhrsw x, m7}, m0, m2, m4, m6
    mova    [rsp+gprsize+16*1], m6

.end2:
    REPX      {pmulhrsw x, m7}, m1, m3, m5
    pmulhrsw                m7, [rsp+gprsize+16*0]
    mova    [rsp+gprsize+16*2], m5
    mova    [rsp+gprsize+16*0], m7

.end3:
    WRITE_8X4                0, 1, 2, 3, 5, 6, 7
    lea                   dstq, [dstq+strideq*2]
    WRITE_8X4                4, [rsp+gprsize+16*2], [rsp+gprsize+16*1], [rsp+gprsize+16*0], 5, 6, 7
    jmp                   tx2q

.end4:
    pxor                    m7, m7
    REPX   {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7
    ret

ALIGN function_align
.main:
    mova  [rsp+gprsize*2+16*0], m7
    mova  [rsp+gprsize*2+16*1], m3
    mova  [rsp+gprsize*2+16*2], m1
    mova                    m7, [o(pd_2048)]
    IDCT4_1D                 0, 2, 4, 6, 1, 3, 7
    mova                    m3, [rsp+gprsize*2+16*2]
    mova  [rsp+gprsize*2+16*2], m2
    mova                    m2, [rsp+gprsize*2+16*1]
    mova  [rsp+gprsize*2+16*1], m4
    mova                    m4, [rsp+gprsize*2+16*0]
    mova  [rsp+gprsize*2+16*0], m6
    IDCT8_1D_ODDHALF         3, 2, 5, 4, 1, 6, 7
    mova                    m6, [rsp+gprsize*2+16*0]
    psubsw                  m7, m0, m4                    ;out7
    paddsw                  m0, m4                        ;out0
    mova  [rsp+gprsize*2+16*0], m7
    mova                    m1, [rsp+gprsize*2+16*2]
    psubsw                  m4, m6, m3                    ;out4
    paddsw                  m3, m6                        ;out3
    mova                    m7, [rsp+gprsize*2+16*1]
    psubsw                  m6, m1, m5                    ;out6
    paddsw                  m1, m5                        ;out1
    psubsw                  m5, m7, m2                    ;out5
    paddsw                  m2, m7                        ;out2
    ret


INV_TXFM_8X8_FN adst, dct
INV_TXFM_8X8_FN adst, adst
INV_TXFM_8X8_FN adst, flipadst
INV_TXFM_8X8_FN adst, identity

cglobal iadst_8x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS          coeffq, 16

.pass1:
    call .main
    call .main_pass1_end

.pass1_end:
    mova                    m7, [o(pw_16384)]

.pass1_end1:
    REPX      {pmulhrsw x, m7}, m0, m2, m4, m6
    mova    [rsp+gprsize+16*1], m6
    pxor                    m6, m6
    psubw                   m6, m7
    mova                    m7, m6
    jmp m(idct_8x8_internal).pass1_end2

ALIGN function_align
.pass2:
    lea                   tx2q, [o(m(idct_8x8_internal).end4)]

.pass2_main:
    call .main
    call .main_pass2_end

.end:
    mova                    m7, [o(pw_2048)]
    REPX      {pmulhrsw x, m7}, m0, m2, m4, m6
    mova    [rsp+gprsize+16*1], m6
    pxor                    m6, m6
    psubw                   m6, m7
    mova                    m7, m6
    jmp m(idct_8x8_internal).end2

ALIGN function_align
.main:
    mova  [rsp+gprsize*2+16*0], m7
    mova  [rsp+gprsize*2+16*1], m3
    mova  [rsp+gprsize*2+16*2], m4
    mova                    m7, [o(pd_2048)]
    ITX_MULSUB_2W            5, 2, 3, 4, 7, 1931, 3612    ;t3a, t2a
    ITX_MULSUB_2W            1, 6, 3, 4, 7, 3920, 1189    ;t7a, t6a
    paddsw                  m3, m2, m6                    ;t2
    psubsw                  m2, m6                        ;t6
    paddsw                  m4, m5, m1                    ;t3
    psubsw                  m5, m1                        ;t7
    ITX_MULSUB_2W            5, 2, 1, 6, 7, 3784, 1567    ;t6a, t7a

    mova                    m6, [rsp+gprsize*2+16*2]
    mova  [rsp+gprsize*2+16*2], m5
    mova                    m1, [rsp+gprsize*2+16*1]
    mova  [rsp+gprsize*2+16*1], m2
    mova                    m5, [rsp+gprsize*2+16*0]
    mova  [rsp+gprsize*2+16*0], m3
    ITX_MULSUB_2W            5, 0, 2, 3, 7,  401, 4076    ;t1a, t0a
    ITX_MULSUB_2W            1, 6, 2, 3, 7, 3166, 2598    ;t5a, t4a
    psubsw                  m2, m0, m6                    ;t4
    paddsw                  m0, m6                        ;t0
    paddsw                  m3, m5, m1                    ;t1
    psubsw                  m5, m1                        ;t5
    ITX_MULSUB_2W            2, 5, 1, 6, 7, 1567, 3784    ;t5a, t4a

    mova                    m7, [rsp+gprsize*2+16*0]
    paddsw                  m1, m3, m4                    ;-out7
    psubsw                  m3, m4                        ;t3
    mova  [rsp+gprsize*2+16*0], m1
    psubsw                  m4, m0, m7                    ;t2
    paddsw                  m0, m7                        ;out0
    mova                    m6, [rsp+gprsize*2+16*2]
    mova                    m7, [rsp+gprsize*2+16*1]
    paddsw                  m1, m5, m6                    ;-out1
    psubsw                  m5, m6                        ;t6
    paddsw                  m6, m2, m7                    ;out6
    psubsw                  m2, m7                        ;t7
    ret
ALIGN function_align
.main_pass1_end:
    mova  [rsp+gprsize*2+16*1], m1
    mova  [rsp+gprsize*2+16*2], m6
    punpckhwd               m1, m4, m3
    punpcklwd               m4, m3
    punpckhwd               m7, m5, m2
    punpcklwd               m5, m2
    mova                    m2, [o(pw_2896_2896)]
    mova                    m6, [o(pd_2048)]
    pmaddwd                 m3, m2, m7
    pmaddwd                 m2, m5
    paddd                   m3, m6
    paddd                   m2, m6
    psrad                   m3, 12
    psrad                   m2, 12
    packssdw                m2, m3                        ;out2
    mova                    m3, [o(pw_2896_m2896)]
    pmaddwd                 m7, m3
    pmaddwd                 m5, m3
    paddd                   m7, m6
    paddd                   m5, m6
    psrad                   m7, 12
    psrad                   m5, 12
    packssdw                m5, m7                        ;-out5
    mova                    m3, [o(pw_2896_2896)]
    pmaddwd                 m7, m3, m1
    pmaddwd                 m3, m4
    paddd                   m7, m6
    paddd                   m3, m6
    psrad                   m7, 12
    psrad                   m3, 12
    packssdw                m3, m7                        ;-out3
    mova                    m7, [o(pw_2896_m2896)]
    pmaddwd                 m1, m7
    pmaddwd                 m4, m7
    paddd                   m1, m6
    paddd                   m4, m6
    psrad                   m1, 12
    psrad                   m4, 12
    packssdw                m4, m1                        ;-out5
    mova                    m1, [rsp+gprsize*2+16*1]
    mova                    m6, [rsp+gprsize*2+16*2]
    ret
ALIGN function_align
.main_pass2_end:
    paddsw                  m7, m4, m3                    ;t2 + t3
    psubsw                  m4, m3                        ;t2 - t3
    paddsw                  m3, m5, m2                    ;t6 + t7
    psubsw                  m5, m2                        ;t6 - t7
    mova                    m2, [o(pw_2896x8)]
    pmulhrsw                m4, m2                        ;out4
    pmulhrsw                m5, m2                        ;-out5
    pmulhrsw                m7, m2                        ;-out3
    pmulhrsw                m2, m3                        ;out2
    mova                    m3, m7
    ret

INV_TXFM_8X8_FN flipadst, dct
INV_TXFM_8X8_FN flipadst, adst
INV_TXFM_8X8_FN flipadst, flipadst
INV_TXFM_8X8_FN flipadst, identity

cglobal iflipadst_8x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS          coeffq, 16

.pass1:
    call m(iadst_8x8_internal).main
    call m(iadst_8x8_internal).main_pass1_end

.pass1_end:
    mova                    m7, [o(pw_m16384)]

.pass1_end1:
    pmulhrsw                m1, m7
    mova    [rsp+gprsize+16*1], m1
    mova                    m1, m6
    mova                    m6, m2
    pmulhrsw                m2, m5, m7
    mova                    m5, m6
    mova                    m6, m4
    pmulhrsw                m4, m3, m7
    mova                    m3, m6
    mova                    m6, m0
    mova                    m0, m7
    pxor                    m7, m7
    psubw                   m7, m0
    pmulhrsw                m0, [rsp+gprsize+16*0]
    REPX      {pmulhrsw x, m7}, m1, m3, m5
    pmulhrsw                m7, m6
    jmp m(idct_8x8_internal).pass1_end3

ALIGN function_align
.pass2:
    lea                   tx2q, [o(m(idct_8x8_internal).end4)]

.pass2_main:
    call m(iadst_8x8_internal).main
    call m(iadst_8x8_internal).main_pass2_end

.end:
    mova                    m7, [o(pw_2048)]
    REPX      {pmulhrsw x, m7}, m0, m2, m4, m6
    mova    [rsp+gprsize+16*2], m2
    mova                    m2, m0
    pxor                    m0, m0
    psubw                   m0, m7
    mova                    m7, m2
    pmulhrsw                m1, m0
    pmulhrsw                m2, m5, m0
    mova    [rsp+gprsize+16*1], m1
    mova                    m5, m4
    mova                    m1, m6
    pmulhrsw                m4, m3, m0
    pmulhrsw                m0, [rsp+gprsize+16*0]
    mova                    m3, m5
    mova    [rsp+gprsize+16*0], m7
    jmp m(idct_8x8_internal).end3

INV_TXFM_8X8_FN identity, dct,      7
INV_TXFM_8X8_FN identity, adst
INV_TXFM_8X8_FN identity, flipadst
INV_TXFM_8X8_FN identity, identity

cglobal iidentity_8x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS          coeffq, 16
    mova    [rsp+gprsize+16*1], m6
    jmp   m(idct_8x8_internal).pass1_end3

ALIGN function_align
.pass2:
    lea                   tx2q, [o(m(idct_8x8_internal).end4)]

.end:
    pmulhrsw                m7, [o(pw_4096)]
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_4096)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova    [rsp+gprsize+16*2], m5
    mova    [rsp+gprsize+16*1], m6
    jmp m(idct_8x8_internal).end3


%macro INV_TXFM_4X16_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 4x16, 8
%if %3 >= 0
%ifidn %1_%2, dct_identity
    mova                 m0, [o(pw_2896x8)]
    mova                 m1, m0
    pmulhrsw             m0, [coeffq+16*0]
    pmulhrsw             m1, [coeffq+16*1]
    mova                 m2, [o(pw_16384)]
    mova                 m3, [o(pw_5793x4)]
    mova                 m4, [o(pw_2048)]
    pmulhrsw             m0, m2
    pmulhrsw             m1, m2
    psllw                m0, 2
    psllw                m1, 2
    pmulhrsw             m0, m3
    pmulhrsw             m1, m3
    pmulhrsw             m0, m4
    pmulhrsw             m4, m1
    punpckhwd            m2, m0, m0
    punpcklwd            m0, m0
    punpckhwd            m6, m4, m4
    punpcklwd            m4, m4
    punpckhdq            m1, m0, m0
    punpckldq            m0, m0
    punpckhdq            m3, m2, m2
    punpckldq            m2, m2
    punpckhdq            m5, m4, m4
    punpckldq            m4, m4
    punpckhdq            m7, m6, m6
    punpckldq            m6, m6
    mova      [coeffq+16*4], m4
    TAIL_CALL m(iadst_4x16_internal).end2
%elifidn %1_%2, identity_dct
    movd                  m0, [coeffq+32*0]
    punpcklwd             m0, [coeffq+32*1]
    movd                  m1, [coeffq+32*2]
    punpcklwd             m1, [coeffq+32*3]
    mova                  m2, [o(pw_5793x4)]
    mova                  m3, [o(pw_16384)]
    mova                  m4, [o(pw_2896x8)]
    punpckldq             m0, m1
    paddw                 m0, m0
    pmulhrsw              m0, m2
    pmulhrsw              m0, m3
    psrlw                 m3, 3                ; pw_2048
    pmulhrsw              m0, m4
    pmulhrsw              m0, m3
    punpcklqdq            m0, m0
    pxor                  m7, m7
    REPX     {mova [coeffq+32*x], m7}, 0,  1,  2,  3
%elifidn %1_%2, dct_dct
    pshuflw               m0, [coeffq], q0000
    punpcklwd             m0, m0
    mova                  m1, [o(pw_2896x8)]
    pmulhrsw              m0, m1
    mov             [coeffq], eobd
    pmulhrsw              m0, [o(pw_16384)]
    pmulhrsw              m0, m1
    pmulhrsw              m0, [o(pw_2048)]
%else ; adst_dct / flipadst_dct
    pshuflw               m0, [coeffq], q0000
    punpcklwd             m0, m0
%ifidn %1, adst
    pmulhrsw              m0, [o(iadst4_dconly1a)]
%else ; flipadst
    pmulhrsw              m0, [o(iadst4_dconly1b)]
%endif
    mova                  m1, [o(pw_16384)]
    mov             [coeffq], eobd
    pmulhrsw              m0, m1
    psrlw                 m1, 3                ; pw_2048
    pmulhrsw              m0, [o(pw_2896x8)]
    pmulhrsw              m0, m1
%endif
.end:
    WRITE_4X4             0, 0, 1, 2, 3, 0, 1, 2, 3
    lea                dstq, [dstq+strideq*4]
    WRITE_4X4             0, 0, 1, 2, 3, 0, 1, 2, 3
    lea                dstq, [dstq+strideq*4]
    WRITE_4X4             0, 0, 1, 2, 3, 0, 1, 2, 3
    lea                dstq, [dstq+strideq*4]
    WRITE_4X4             0, 0, 1, 2, 3, 0, 1, 2, 3
    RET
%endif
%endmacro

INV_TXFM_4X16_FN dct, dct,      0
INV_TXFM_4X16_FN dct, identity, 15
INV_TXFM_4X16_FN dct, adst
INV_TXFM_4X16_FN dct, flipadst

cglobal idct_4x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                  r3, [o(m(idct_4x8_internal).pass1)]

.pass1:
    mova                 m0, [coeffq+16*1]
    mova                 m1, [coeffq+16*3]
    mova                 m2, [coeffq+16*5]
    mova                 m3, [coeffq+16*7]
    push               tx2q
    lea                tx2q, [o(m(idct_4x16_internal).pass1_2)]
    jmp                  r3

.pass1_2:
    mova      [coeffq+16*1], m0
    mova      [coeffq+16*3], m1
    mova      [coeffq+16*5], m2
    mova      [coeffq+16*7], m3
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*2]
    mova                 m2, [coeffq+16*4]
    mova                 m3, [coeffq+16*6]
    lea                tx2q, [o(m(idct_4x16_internal).pass1_end)]
    jmp                  r3

.pass1_end:
    pop                tx2q

    mova                 m4, [coeffq+16*1]
    mova                 m5, [coeffq+16*3]
    mova                 m6, [coeffq+16*5]
    mova                 m7, [o(pw_16384)]
    REPX   {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6

    pmulhrsw             m7, [coeffq+16*7]
    mova       [coeffq+16*7], m7
    jmp                tx2q

.pass2:
    call m(idct_16x4_internal).main

.end:
    mova                  m7, [o(pw_2048)]
    REPX    {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    pmulhrsw              m7, [coeffq+16*7]
    mova       [coeffq+16*4], m4

.end1:
    mova       [coeffq+16*5], m5
    mova       [coeffq+16*6], m6
    mov                   r3, coeffq
    WRITE_4X8              0, 1, 3, 2

    mova                  m0, [r3+16*4]
    mova                  m1, [r3+16*5]
    mova                  m2, [r3+16*6]
    mova                  m3, m7
    lea                 dstq, [dstq+strideq*4]
    WRITE_4X8              0, 1, 3, 2

.end2:
    pxor                  m7, m7
    REPX     {mova [r3+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7
    ret

INV_TXFM_4X16_FN adst, dct,      0
INV_TXFM_4X16_FN adst, adst
INV_TXFM_4X16_FN adst, flipadst
INV_TXFM_4X16_FN adst, identity

cglobal iadst_4x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                   r3, [o(m(iadst_4x8_internal).pass1)]
    jmp   m(idct_4x16_internal).pass1

.pass2:
    call m(iadst_16x4_internal).main
    call m(iadst_16x4_internal).main_pass2_end

    punpcklqdq            m6, m5, m4                ;low: -out5  high: -out7
    punpckhqdq            m4, m5                    ;low:  out8  high:  out10
    punpcklqdq            m5, m7, m2                ;low:  out4  high:  out6
    punpckhqdq            m2, m7                    ;low: -out9  high: -out11
    mova       [coeffq+16*4], m2
    mova       [coeffq+16*5], m6
    mova                  m2, [coeffq+16*6]
    mova                  m6, [coeffq+16*7]
    punpckhqdq            m1, m6, m0                ;low: -out13 high: -out15
    punpcklqdq            m0, m6                    ;low:  out0  high:  out2
    punpckhqdq            m6, m3, m2                ;low:  out12 high:  out14
    punpcklqdq            m2, m3                    ;low: -out1  high: -out3

    mova                  m7, [o(pw_2048)]

.end1:
    REPX    {pmulhrsw x, m7}, m0, m5, m4, m6
    pxor                  m3, m3
    psubw                 m3, m7
    mova                  m7, [coeffq+16*4]
    REPX    {pmulhrsw x, m3}, m2, m7, m1
    pmulhrsw              m3, [coeffq+16*5]
    mova       [coeffq+16*7], m5

    punpckhqdq            m5, m4, m7                ;low:  out10 high:  out11
    punpcklqdq            m4, m7                    ;low:  out8  high:  out9
    punpckhqdq            m7, m6, m1                ;low:  out14 high:  out15
    punpcklqdq            m6, m1                    ;low:  out12 high:  out13
    punpckhqdq            m1, m0, m2                ;low:  out2  high:  out3
    punpcklqdq            m0, m2                    ;low:  out0  high:  out1
    mova       [coeffq+16*4], m4
    mova                  m4, [coeffq+16*7]
    punpcklqdq            m2, m4, m3                ;low:  out4  high:  out5
    punpckhqdq            m4, m3                    ;low:  out6  high:  out7
    mova                  m3, m4

.end2:
    mova       [coeffq+16*5], m5
    mova       [coeffq+16*6], m6
    mov                   r3, coeffq
    WRITE_4X8              0, 1, 2, 3

    mova                  m0, [r3+16*4]
    mova                  m1, [r3+16*5]
    mova                  m2, [r3+16*6]
    mova                  m3, m7
    lea                 dstq, [dstq+strideq*4]
    WRITE_4X8              0, 1, 2, 3

.end3:
    pxor                  m7, m7
    REPX     {mova [r3+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7
    ret


INV_TXFM_4X16_FN flipadst, dct,      0
INV_TXFM_4X16_FN flipadst, adst
INV_TXFM_4X16_FN flipadst, flipadst
INV_TXFM_4X16_FN flipadst, identity

cglobal iflipadst_4x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                   r3, [o(m(iflipadst_4x8_internal).pass1)]
    jmp   m(idct_4x16_internal).pass1

.pass2:
    call m(iadst_16x4_internal).main
    call m(iadst_16x4_internal).main_pass2_end

    punpckhqdq            m6, m5, m4                ;low:  out5  high:  out7
    punpcklqdq            m4, m5                    ;low: -out8  high: -out10
    punpckhqdq            m5, m7, m2                ;low: -out4  high: -out6
    punpcklqdq            m2, m7                    ;low:  out9  high:  out11
    mova       [coeffq+16*4], m2
    mova       [coeffq+16*5], m6
    mova                  m2, [coeffq+16*6]
    mova                  m6, [coeffq+16*7]
    punpcklqdq            m1, m6, m0                ;low:  out13 high:  out15
    punpckhqdq            m0, m6                    ;low: -out0  high: -out2
    punpcklqdq            m6, m3, m2                ;low: -out12 high: -out14
    punpckhqdq            m2, m3                    ;low:  out1  high:  out3

    mova                  m7, [o(pw_m2048)]
    jmp   m(iadst_4x16_internal).end1


INV_TXFM_4X16_FN identity, dct,      3
INV_TXFM_4X16_FN identity, adst
INV_TXFM_4X16_FN identity, flipadst
INV_TXFM_4X16_FN identity, identity

cglobal iidentity_4x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                   r3, [o(m(iidentity_4x8_internal).pass1)]
    jmp   m(idct_4x16_internal).pass1

.pass2:
    mova                  m7, [o(pw_5793x4)]
    REPX    {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6
    REPX    {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    psllw                 m7, [coeffq+16*7], 2
    pmulhrsw              m7, [o(pw_5793x4)]
    mova       [coeffq+16*7], m7

    mova                  m7, [o(pw_2048)]
    REPX    {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    pmulhrsw              m7, [coeffq+16*7]
    mova       [coeffq+16*4], m4
    jmp   m(iadst_4x16_internal).end2


%macro INV_TXFM_16X4_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 16x4, 8
%if %3 >= 0
%ifidn %1_%2, dct_identity
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m3, [coeffq]
    mova                 m0, [o(pw_16384)]
    pmulhrsw             m3, m0
    psrlw                m0, 3                ; pw_2048
    paddw                m3, m3
    pmulhrsw             m3, [o(pw_5793x4)]
    pmulhrsw             m3, m0
    punpcklwd            m3, m3
    pshufd               m0, m3, q0000
    pshufd               m1, m3, q1111
    pshufd               m2, m3, q2222
    pshufd               m3, m3, q3333
    lea                tx2q, [dstq+8]
    call m(iadst_8x4_internal).end2
    add              coeffq, 16*4
    mov                dstq, tx2q
    TAIL_CALL m(iadst_8x4_internal).end2
%elifidn %1_%2, identity_dct
    mova                 m5, [o(pw_16384)]
    mova                 m6, [o(pw_5793x4)]
    mova                 m7, [o(pw_2896x8)]
    mov                 r3d, 2
.main_loop:
    mova                 m0, [coeffq+16*0]
    mova                 m1, [coeffq+16*1]
    mova                 m2, [coeffq+16*2]
    mova                 m3, [coeffq+16*3]
    punpckhwd            m4, m0, m1
    punpcklwd            m0, m1
    punpckhwd            m1, m2, m3
    punpcklwd            m2, m3
    punpcklwd            m0, m4
    punpcklwd            m2, m1
    punpcklqdq           m0, m2
    psllw                m0, 2
    pmulhrsw             m0, m6
    pmulhrsw             m0, m5
    psrlw                m1, m5, 3               ; pw_2048
    pmulhrsw             m0, m7
    pmulhrsw             m0, m1
.end:
    pxor                 m3, m3
    mova      [coeffq+16*0], m3
    mova      [coeffq+16*1], m3
    mova      [coeffq+16*2], m3
    mova      [coeffq+16*3], m3
    add              coeffq, 16*4
    lea                tx2q, [dstq+8]
    WRITE_8X4            0, 0, 0, 0, 1, 2, 3
    mov                dstq, tx2q
    dec                 r3d
    jg .main_loop
    RET
%else
    movd                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1, [coeffq]
%ifidn %2, dct
    movd                m2, [o(pw_16384)]
    mov            [coeffq], eobd
    mov                 r2d, 2
    lea                tx2q, [o(m(inv_txfm_add_dct_dct_16x4).end)]
.dconly:
    pmulhrsw             m0, m2
    movd                 m2, [o(pw_2048)]              ;intentionally rip-relative
    pmulhrsw             m0, m1
    pmulhrsw             m0, m2
    pshuflw              m0, m0, q0000
    punpcklwd            m0, m0
    pxor                 m5, m5
.dconly_loop:
    mova                 m1, [dstq]
    mova                 m3, [dstq+strideq]
    punpckhbw            m2, m1, m5
    punpcklbw            m1, m5
    punpckhbw            m4, m3, m5
    punpcklbw            m3, m5
    paddw                m2, m0
    paddw                m1, m0
    paddw                m4, m0
    paddw                m3, m0
    packuswb             m1, m2
    packuswb             m3, m4
    mova             [dstq], m1
    mova     [dstq+strideq], m3
    lea                dstq, [dstq+strideq*2]
    dec                 r2d
    jg .dconly_loop
    jmp                tx2q
.end:
    RET
%else ; adst / flipadst
    movd                 m2, [o(pw_16384)]
    pmulhrsw             m0, m2
    pshuflw              m0, m0, q0000
    punpcklwd            m0, m0
    mov            [coeffq], eobd
    pmulhrsw             m2, m0, [o(iadst4_dconly2b)]
    pmulhrsw             m0, [o(iadst4_dconly2a)]
    mova                 m1, [o(pw_2048)]
    pmulhrsw             m0, m1
    pmulhrsw             m2, m1
%ifidn %2, adst
    punpckhqdq           m1, m0, m0
    punpcklqdq           m0, m0
    punpckhqdq           m3, m2, m2
    punpcklqdq           m2, m2
%else ; flipadst
    mova                 m3, m0
    punpckhqdq           m0, m2, m2
    punpcklqdq           m1, m2, m2
    punpckhqdq           m2, m3, m3
    punpcklqdq           m3, m3
%endif
    lea                tx2q, [dstq+8]
    call m(iadst_8x4_internal).end3
    mov                dstq, tx2q
    TAIL_CALL m(iadst_8x4_internal).end3
%endif
%endif
%endif
%endmacro

%macro LOAD_7ROWS 2 ;src, stride
    mova                 m0, [%1+%2*0]
    mova                 m1, [%1+%2*1]
    mova                 m2, [%1+%2*2]
    mova                 m3, [%1+%2*3]
    mova                 m4, [%1+%2*4]
    mova                 m5, [%1+%2*5]
    mova                 m6, [%1+%2*6]
%endmacro

%macro SAVE_7ROWS 2 ;src, stride
    mova          [%1+%2*0], m0
    mova          [%1+%2*1], m1
    mova          [%1+%2*2], m2
    mova          [%1+%2*3], m3
    mova          [%1+%2*4], m4
    mova          [%1+%2*5], m5
    mova          [%1+%2*6], m6
%endmacro

%macro IDCT16_1D_PACKED_ODDHALF 7  ;src[1-4], tmp[1-3]
    punpckhwd            m%5, m%4, m%1                ;packed in13 in3
    punpcklwd            m%1, m%4                     ;packed in1  in15
    punpcklwd            m%6, m%3, m%2                ;packed in9  in7
    punpckhwd            m%2, m%3                     ;packed in5  in11

    mova                 m%7, [o(pd_2048)]
    ITX_MUL2X_PACK        %1, %4, %7,  401, 4076, 1    ;low: t8a   high: t15a
    ITX_MUL2X_PACK        %6, %4, %7, 3166, 2598, 1    ;low: t9a   high: t14a
    ITX_MUL2X_PACK        %2, %4, %7, 1931, 3612, 1    ;low: t10a  high: t13a
    ITX_MUL2X_PACK        %5, %4, %7, 3920, 1189, 1    ;low: t11a  high: t12a
    psubsw               m%4, m%1, m%6                 ;low: t9    high: t14
    paddsw               m%1, m%6                      ;low: t8    high: t15
    psubsw               m%3, m%5, m%2                 ;low: t10   high: t13
    paddsw               m%2, m%5                      ;low: t11   high: t12
    punpcklqdq           m%5, m%4, m%3                 ;low: t9    high: t10
    punpckhqdq           m%4, m%3                      ;low: t14   high: t13
    punpcklwd            m%6, m%4, m%5                 ;packed t14 t9
    punpckhwd            m%5, m%4                      ;packed t10 t13
    pxor                 m%4, m%4
    psubw                m%4, m%5                      ;packed -t10 -t13
    ITX_MUL2X_PACK        %6, %3, %7, 1567, 3784, 1    ;low: t9a   high: t14a
    ITX_MUL2X_PACK        %4, %3, %7, 3784, 1567       ;low: t10a  high: t13a
    psubsw               m%3, m%1, m%2                 ;low: t11a  high: t12a
    paddsw               m%1, m%2                      ;low: t8a   high: t15a
    psubsw               m%5, m%6, m%4                 ;low: t10   high: t13
    paddsw               m%6, m%4                      ;low: t9    high: t14
    mova                 m%7, [o(pw_2896x8)]
    punpckhqdq           m%4, m%3, m%5                 ;low: t12a  high: t13
    punpcklqdq           m%3, m%5                      ;low: t11a  high: t10
    psubw                m%2, m%4, m%3
    paddw                m%3, m%4
    pmulhrsw             m%2, m%7                      ;low: t11   high: t10a
    pmulhrsw             m%3, m%7                      ;low: t12   high: t13a
    punpckhqdq           m%4, m%1, m%6                 ;low: t15a  high: t14
    punpcklqdq           m%1, m%6                      ;low: t8a   high: t9
%endmacro

INV_TXFM_16X4_FN dct, dct,      0
INV_TXFM_16X4_FN dct, adst,     0
INV_TXFM_16X4_FN dct, flipadst, 0
INV_TXFM_16X4_FN dct, identity, 3

cglobal idct_16x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_7ROWS        coeffq, 16
    call .main

.pass1_end:
    punpckhwd             m7, m0, m2                 ;packed out1,  out5
    punpcklwd             m0, m2                     ;packed out0,  out4
    punpcklwd             m2, m1, m3                 ;packed out3,  out7
    punpckhwd             m1, m3                     ;packed out2,  out6
    mova       [coeffq+16*6], m7
    mova                  m7, [coeffq+16*7]
    punpckhwd             m3, m4, m6                 ;packed out9,  out13
    punpcklwd             m4, m6                     ;packed out8,  out12
    punpcklwd             m6, m5, m7                 ;packed out11, out15
    punpckhwd             m5, m7                     ;packed out10, out14

.pass1_end2:
    mova                  m7, [o(pw_16384)]
    REPX    {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    pmulhrsw              m7, [coeffq+16*6]
    mova       [coeffq+16*6], m7

.pass1_end3:
    punpckhwd             m7, m3, m6                 ;packed 9, 11, 13, 15 high
    punpcklwd             m3, m6                     ;packed 9, 10, 13, 15 low
    punpckhwd             m6, m4, m5                 ;packed 8, 10, 12, 14 high
    punpcklwd             m4, m5                     ;packed 8, 10, 12, 14 low
    punpckhwd             m5, m4, m3                 ;8, 9, 10, 11, 12, 13, 14, 15(1)
    punpcklwd             m4, m3                     ;8, 9, 10, 11, 12, 13, 14, 15(0)
    punpckhwd             m3, m6, m7                 ;8, 9, 10, 11, 12, 13, 14, 15(3)
    punpcklwd             m6, m7                     ;8, 9, 10, 11, 12, 13, 14, 15(2)
    mova       [coeffq+16*7], m3
    mova                  m3, [coeffq+16*6]
    punpckhwd             m7, m3, m2                 ;packed 1, 3, 5, 7 high
    punpcklwd             m3, m2                     ;packed 1, 3, 5, 7 low
    punpckhwd             m2, m0, m1                 ;packed 0, 2, 4, 6 high
    punpcklwd             m0, m1                     ;packed 0, 2, 4, 6 low
    punpckhwd             m1, m0, m3                 ;0, 1, 2, 3, 4, 5, 6, 7(1)
    punpcklwd             m0, m3                     ;0, 1, 2, 3, 4, 5, 6, 7(0)
    punpckhwd             m3, m2, m7                 ;0, 1, 2, 3, 4, 5, 6, 7(3)
    punpcklwd             m2, m7                     ;0, 1, 2, 3, 4, 5, 6, 7(2)
    jmp                 tx2q

.pass2:
    lea                 tx2q, [o(m(idct_8x4_internal).pass2)]

.pass2_end:
    mova       [coeffq+16*4], m4
    mova       [coeffq+16*5], m5
    mova       [coeffq+16*6], m6
    lea                   r3, [dstq+8]
    call                tx2q

    add               coeffq, 16*4
    mova                  m0, [coeffq+16*0]
    mova                  m1, [coeffq+16*1]
    mova                  m2, [coeffq+16*2]
    mova                  m3, [coeffq+16*3]
    mov                 dstq, r3
    jmp                 tx2q

ALIGN function_align
.main:
    punpckhqdq            m7, m0, m1                 ;low:in1  high:in3
    punpcklqdq            m0, m1
    punpcklqdq            m1, m2, m3
    punpckhqdq            m3, m2                     ;low:in7  high:in5
    mova       [coeffq+16*4], m7
    mova       [coeffq+16*5], m3
    mova                  m7, [coeffq+16*7]
    punpcklqdq            m2, m4, m5
    punpckhqdq            m4, m5                     ;low:in9  high:in11
    punpcklqdq            m3, m6, m7
    punpckhqdq            m7, m6                     ;low:in15 high:in13
    mova       [coeffq+16*6], m4
    IDCT8_1D_PACKED
    mova                  m6, [coeffq+16*4]
    mova                  m4, [coeffq+16*5]
    mova                  m5, [coeffq+16*6]
    mova       [coeffq+16*4], m1
    mova       [coeffq+16*5], m2
    mova       [coeffq+16*6], m3

    IDCT16_1D_PACKED_ODDHALF 6, 4, 5, 7, 1, 2, 3

    mova                  m1, [coeffq+16*4]
    psubsw                m3, m0, m7                 ;low:out15 high:out14
    paddsw                m0, m7                     ;low:out0  high:out1
    psubsw                m7, m1, m5                 ;low:out12 high:out13
    paddsw                m1, m5                     ;low:out3  high:out2
    mova       [coeffq+16*7], m3
    mova                  m2, [coeffq+16*5]
    mova                  m3, [coeffq+16*6]
    psubsw                m5, m2, m4                 ;low:out11 high:out10
    paddsw                m2, m4                     ;low:out4  high:out5
    psubsw                m4, m3, m6                 ;low:out8  high:out9
    paddsw                m3, m6                     ;low:out7  high:out6
    mova                  m6, m7
    ret

INV_TXFM_16X4_FN adst, dct
INV_TXFM_16X4_FN adst, adst
INV_TXFM_16X4_FN adst, flipadst
INV_TXFM_16X4_FN adst, identity

cglobal iadst_16x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_7ROWS        coeffq, 16
    call .main
    call .main_pass1_end

    punpckhwd             m6, m7, m0                 ;packed -out11, -out15
    punpcklwd             m0, m7                     ;packed   out0,   out4
    punpcklwd             m7, m3, m4                 ;packed  -out3,  -out7
    punpckhwd             m4, m3                     ;packed   out8,  out12
    mova                  m1, [coeffq+16*6]
    punpcklwd             m3, m1, m5                 ;packed  -out1,  -out5
    punpckhwd             m5, m1                     ;packed  out10,  out14
    mova                  m1, [coeffq+16*7]
    mova       [coeffq+16*6], m3
    mova       [coeffq+16*7], m7
    punpckhwd             m3, m2, m1                 ;packed  -out9,  -out13
    punpcklwd             m1, m2                     ;packed   out2,   out6

    mova                  m7, [o(pw_16384)]

.pass1_end:
    REPX    {pmulhrsw x, m7}, m0, m1, m4, m5
    pxor                  m2, m2
    psubw                 m2, m7
    mova                  m7, [coeffq+16*6]
    REPX    {pmulhrsw x, m2}, m7, m3, m6
    pmulhrsw              m2, [coeffq+16*7]
    mova       [coeffq+16*6], m7
    jmp   m(idct_16x4_internal).pass1_end3

.pass2:
    lea                 tx2q, [o(m(iadst_8x4_internal).pass2)]
    jmp   m(idct_16x4_internal).pass2_end

ALIGN function_align
.main:
    mova       [coeffq+16*6], m0
    pshufd                m0, m1, q1032
    pshufd                m2, m2, q1032
    punpckhwd             m1, m6, m0                 ;packed in13,  in2
    punpcklwd             m0, m6                     ;packed  in3, in12
    punpckhwd             m7, m5, m2                 ;packed in11,  in4
    punpcklwd             m2, m5                     ;packed  in5, in10
    mova                  m6, [o(pd_2048)]
    ITX_MUL2X_PACK         1, 5, 6,  995, 3973       ;low:t2   high:t3
    ITX_MUL2X_PACK         7, 5, 6, 1751, 3703       ;low:t4   high:t5
    ITX_MUL2X_PACK         2, 5, 6, 3513, 2106       ;low:t10  high:t11
    ITX_MUL2X_PACK         0, 5, 6, 3857, 1380       ;low:t12  high:t13
    psubsw                m5, m1, m2                 ;low:t10a high:t11a
    paddsw                m1, m2                     ;low:t2a  high:t3a
    psubsw                m2, m7, m0                 ;low:t12a high:t13a
    paddsw                m7, m0                     ;low:t4a  high:t5a
    punpcklqdq            m0, m5
    punpckhwd             m0, m5                     ;packed t10a, t11a
    punpcklqdq            m5, m2
    punpckhwd             m2, m5                     ;packed t13a, t12a
    ITX_MUL2X_PACK         0, 5, 6, 3406, 2276       ;low:t10  high:t11
    ITX_MUL2X_PACK         2, 5, 6, 4017,  799, 1    ;low:t12  high:t13
    mova       [coeffq+16*4], m1
    mova       [coeffq+16*5], m7
    mova                  m1, [coeffq+16*6]
    mova                  m7, [coeffq+16*7]
    pshufd                m1, m1, q1032
    pshufd                m3, m3, q1032
    punpckhwd             m5, m7, m1                 ;packed in15,  in0
    punpcklwd             m1, m7                     ;packed  in1, in14
    punpckhwd             m7, m4, m3                 ;packed  in9,  in6
    punpcklwd             m3, m4                     ;packed  in7,  in8
    ITX_MUL2X_PACK         5, 4, 6,  201, 4091       ;low:t0    high:t1
    ITX_MUL2X_PACK         7, 4, 6, 2440, 3290       ;low:t6    high:t7
    ITX_MUL2X_PACK         3, 4, 6, 3035, 2751       ;low:t8    high:t9
    ITX_MUL2X_PACK         1, 4, 6, 4052,  601       ;low:t14   high:t15
    psubsw                m4, m5, m3                 ;low:t8a   high:t9a
    paddsw                m5, m3                     ;low:t0a   high:t1a
    psubsw                m3, m7, m1                 ;low:t14a  high:t15a
    paddsw                m7, m1                     ;low:t6a   high:t7a
    punpcklqdq            m1, m4
    punpckhwd             m1, m4                     ;packed  t8a,  t9a
    punpcklqdq            m4, m3
    punpckhwd             m3, m4                     ;packed t15a, t14a
    ITX_MUL2X_PACK         1, 4, 6,  799, 4017       ;low:t8    high:t9
    ITX_MUL2X_PACK         3, 4, 6, 2276, 3406, 1    ;low:t14   high:t15
    paddsw                m4, m1, m2                 ;low:t12a  high:t13a
    psubsw                m1, m2                     ;low:t8a   high:t9a
    psubsw                m2, m0, m3                 ;low:t14a  high:t15a
    paddsw                m0, m3                     ;low:t10a  high:t11a
    punpcklqdq            m3, m1
    punpckhwd             m3, m1                     ;packed t12a, t13a
    punpcklqdq            m1, m2
    punpckhwd             m2, m1                     ;packed t15a, t14a
    ITX_MUL2X_PACK         3, 1, 6, 1567, 3784       ;low:t12   high:t13
    ITX_MUL2X_PACK         2, 1, 6, 3784, 1567, 1    ;low:t14   high:t15
    psubsw                m1, m3, m2                 ;low:t14a  high:t15a
    paddsw                m3, m2                     ;low:out2  high:-out13
    psubsw                m2, m4, m0                 ;low:t10   high:t11
    paddsw                m0, m4                     ;low:-out1 high:out14
    mova       [coeffq+16*6], m0
    mova       [coeffq+16*7], m3
    mova                  m0, [coeffq+16*4]
    mova                  m3, [coeffq+16*5]
    psubsw                m4, m5, m3                 ;low:t4    high:t5
    paddsw                m5, m3                     ;low:t0    high:t1
    psubsw                m3, m0, m7                 ;low:t6    high:t7
    paddsw                m0, m7                     ;low:t2    high:t3
    punpcklqdq            m7, m4
    punpckhwd             m7, m4                     ;packed t4, t5
    punpcklqdq            m4, m3
    punpckhwd             m3, m4                     ;packed t7, t6
    ITX_MUL2X_PACK         7, 4, 6, 1567, 3784       ;low:t4a   high:t5a
    ITX_MUL2X_PACK         3, 4, 6, 3784, 1567, 1    ;low:t6a   high:t7a
    psubsw                m4, m5, m0                 ;low:t2a   high:t3a
    paddsw                m0, m5                     ;low:out0  high:-out15
    psubsw                m5, m7, m3                 ;low:t6    high:t7
    paddsw                m3, m7                     ;low:-out3 high:out12
    ret
ALIGN function_align
.main_pass1_end:
    mova                  m7, [o(deint_shuf1)]
    mova       [coeffq+16*4], m0
    mova       [coeffq+16*5], m3
    mova                  m0, [o(pw_2896_m2896)]
    mova                  m3, [o(pw_2896_2896)]
    pshufb                m1, m7                     ;t14a t15a
    pshufb                m2, m7                     ;t10  t11
    pshufb                m4, m7                     ;t2a  t3a
    pshufb                m5, m7                     ;t6   t7
    pmaddwd               m7, m0, m2
    pmaddwd               m2, m3
    paddd                 m7, m6
    paddd                 m2, m6
    psrad                 m7, 12
    psrad                 m2, 12
    packssdw              m2, m7                     ;low:out6  high:-out9
    pmaddwd               m7, m0, m4
    pmaddwd               m4, m3
    paddd                 m7, m6
    paddd                 m4, m6
    psrad                 m7, 12
    psrad                 m4, 12
    packssdw              m4, m7                     ;low:-out7 high:out8
    pmaddwd               m7, m3, m5
    pmaddwd               m5, m0
    paddd                 m7, m6
    paddd                 m5, m6
    psrad                 m7, 12
    psrad                 m5, 12
    packssdw              m7, m5                     ;low:out4  high:-out11
    pmaddwd               m5, m3, m1
    pmaddwd               m1, m0
    paddd                 m5, m6
    paddd                 m1, m6
    psrad                 m5, 12
    psrad                 m1, 12
    packssdw              m5, m1                     ;low:-out5 high:out10
    mova                  m0, [coeffq+16*4]
    mova                  m3, [coeffq+16*5]
    ret
ALIGN function_align
.main_pass2_end:
    mova                  m7, [o(pw_2896x8)]
    punpckhqdq            m6, m2, m1                 ;low:t11   high:t15a
    punpcklqdq            m2, m1                     ;low:t10   high:t14a
    psubsw                m1, m2, m6
    paddsw                m2, m6
    punpckhqdq            m6, m4, m5                 ;low:t3a   high:t7
    punpcklqdq            m4, m5                     ;low:t2a   high:t6
    psubsw                m5, m4, m6
    paddsw                m4, m6
    pmulhrsw              m1, m7                     ;low:-out9 high:out10
    pmulhrsw              m2, m7                     ;low:out6  high:-out5
    pmulhrsw              m5, m7                     ;low:out8  high:-out11
    pmulhrsw              m4, m7                     ;low:-out7 high:out4
    punpckhqdq            m7, m4, m5                 ;low:out4  high:-out11
    punpcklqdq            m4, m5                     ;low:-out7 high:out8
    punpckhqdq            m5, m2, m1                 ;low:-out5 high:out10
    punpcklqdq            m2, m1                     ;low:out6  high:-out9
    ret


INV_TXFM_16X4_FN flipadst, dct
INV_TXFM_16X4_FN flipadst, adst
INV_TXFM_16X4_FN flipadst, flipadst
INV_TXFM_16X4_FN flipadst, identity

cglobal iflipadst_16x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_7ROWS        coeffq, 16
    call m(iadst_16x4_internal).main
    call m(iadst_16x4_internal).main_pass1_end

    punpcklwd             m6, m7, m0                 ;packed  out11,  out15
    punpckhwd             m0, m7                     ;packed  -out0,  -out4
    punpckhwd             m7, m3, m4                 ;packed   out3,   out7
    punpcklwd             m4, m3                     ;packed  -out8, -out12
    mova                  m1, [coeffq+16*6]
    punpckhwd             m3, m1, m5                 ;packed   out1,   out5
    punpcklwd             m5, m1                     ;packed -out10, -out14
    mova                  m1, [coeffq+16*7]
    mova       [coeffq+16*6], m3
    mova       [coeffq+16*7], m7
    punpcklwd             m3, m2, m1                 ;packed   out9,  out13
    punpckhwd             m1, m2                     ;packed  -out2,  -out6

    mova                  m7, [o(pw_m16384)]
    jmp   m(iadst_16x4_internal).pass1_end

.pass2:
    lea                 tx2q, [o(m(iflipadst_8x4_internal).pass2)]
    jmp   m(idct_16x4_internal).pass2_end


INV_TXFM_16X4_FN identity, dct,      15
INV_TXFM_16X4_FN identity, adst
INV_TXFM_16X4_FN identity, flipadst
INV_TXFM_16X4_FN identity, identity

cglobal iidentity_16x4_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_7ROWS        coeffq, 16
    mova                  m7, [o(pw_5793x4)]
    REPX    {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6
    REPX    {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    punpckhwd             m7, m0, m2                 ;packed out1,  out5
    punpcklwd             m0, m2                     ;packed out0,  out4
    punpckhwd             m2, m1, m3                 ;packed out3,  out7
    punpcklwd             m1, m3                     ;packed out2,  out6
    mova       [coeffq+16*6], m7
    psllw                 m7, [coeffq+16*7], 2
    pmulhrsw              m7, [o(pw_5793x4)]
    punpckhwd             m3, m4, m6                 ;packed out9,  out13
    punpcklwd             m4, m6                     ;packed out8,  out12
    punpckhwd             m6, m5, m7                 ;packed out11, out15
    punpcklwd             m5, m7                     ;packed out10, out14
    jmp   m(idct_16x4_internal).pass1_end2

.pass2:
    lea                 tx2q, [o(m(iidentity_8x4_internal).pass2)]
    jmp   m(idct_16x4_internal).pass2_end


%macro SAVE_8ROWS 2  ;src, stride
    mova                 [%1+%2*0], m0
    mova                 [%1+%2*1], m1
    mova                 [%1+%2*2], m2
    mova                 [%1+%2*3], m3
    mova                 [%1+%2*4], m4
    mova                 [%1+%2*5], m5
    mova                 [%1+%2*6], m6
    mova                 [%1+%2*7], m7
%endmacro

%macro INV_TXFM_8X16_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 8x16, 8, 16*16
%ifidn %1_%2, dct_dct
    pshuflw              m0, [coeffq], q0000
    punpcklwd            m0, m0
    mova                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1
    mova                 m2, [o(pw_16384)]
    mov            [coeffq], eobd
    pmulhrsw             m0, m1
    pmulhrsw             m0, m2
    psrlw                m2, 3              ; pw_2048
    pmulhrsw             m0, m1
    pmulhrsw             m0, m2
    mov                 r3d, 4
    lea                tx2q, [o(m(inv_txfm_add_dct_dct_8x16).end)]
    jmp m(inv_txfm_add_dct_dct_8x8).loop
.end:
    RET
%elifidn %1_%2, dct_identity
    mov                 r3d, 2
.loop:
    mova                 m0, [o(pw_2896x8)]
    pmulhrsw             m7, m0, [coeffq]
    mova                 m1, [o(pw_16384)]
    pxor                 m2, m2
    mova           [coeffq], m2
    pmulhrsw             m7, m0
    pmulhrsw             m7, m1
    psrlw                m1, 3          ; pw_2048
    psllw                m7, 2
    pmulhrsw             m7, [o(pw_5793x4)]
    pmulhrsw             m7, m1
    punpcklwd            m0, m7, m7
    punpckhwd            m7, m7
    pshufd               m3, m0, q3333
    pshufd               m2, m0, q2222
    pshufd               m1, m0, q1111
    pshufd               m0, m0, q0000
    call m(iadst_8x4_internal).end3
    pshufd               m3, m7, q3333
    pshufd               m2, m7, q2222
    pshufd               m1, m7, q1111
    pshufd               m0, m7, q0000
    lea                dstq, [dstq+strideq*2]
    call m(iadst_8x4_internal).end3

    add              coeffq, 16
    lea                dstq, [dstq+strideq*2]
    dec                 r3d
    jg .loop
    RET
%elifidn %1_%2, identity_dct
    movd                 m0, [coeffq+32*0]
    punpcklwd            m0, [coeffq+32*1]
    movd                 m2, [coeffq+32*2]
    punpcklwd            m2, [coeffq+32*3]
    add              coeffq, 32*4
    movd                 m1, [coeffq+32*0]
    punpcklwd            m1, [coeffq+32*1]
    movd                 m3, [coeffq+32*2]
    punpcklwd            m3, [coeffq+32*3]
    mova                 m4, [o(pw_2896x8)]
    xor                eobd, eobd
    mov       [coeffq-32*4], eobd
    mov       [coeffq-32*3], eobd
    mov       [coeffq-32*2], eobd
    mov       [coeffq-32*1], eobd
    punpckldq            m0, m2
    punpckldq            m1, m3
    punpcklqdq           m0, m1
    pmulhrsw             m0, m4
    pmulhrsw             m0, m4
    pmulhrsw             m0, [o(pw_2048)]
    mov       [coeffq+32*0], eobd
    mov       [coeffq+32*1], eobd
    mov       [coeffq+32*2], eobd
    mov       [coeffq+32*3], eobd
    mov                 r3d, 4
    lea                tx2q, [o(m(inv_txfm_add_identity_dct_8x16).end)]
    jmp m(inv_txfm_add_dct_dct_8x8).loop
.end:
    RET
%endif
%endmacro

INV_TXFM_8X16_FN dct, dct,      0
INV_TXFM_8X16_FN dct, identity, 15
INV_TXFM_8X16_FN dct, adst
INV_TXFM_8X16_FN dct, flipadst

cglobal idct_8x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                    r3, [o(m(idct_8x8_internal).pass1)]

.pass1:
    LOAD_8ROWS    coeffq+16*1, 32, 1
    mov   [rsp+gprsize+16*11], tx2q
    lea                  tx2q, [o(m(idct_8x16_internal).pass1_end)]
    jmp                    r3

.pass1_end:
    SAVE_8ROWS    coeffq+16*1, 32
    LOAD_8ROWS    coeffq+16*0, 32, 1
    mov                  tx2q, [rsp+gprsize+16*11]
    jmp                    r3

.pass2:
    lea                  tx2q, [o(m(idct_8x16_internal).end)]

.pass2_pre:
    mova       [coeffq+16*2 ], m1
    mova       [coeffq+16*6 ], m3
    mova       [coeffq+16*10], m5
    mova       [coeffq+16*14], m7
    mova                   m1, m2
    mova                   m2, m4
    mova                   m3, m6
    mova                   m4, [coeffq+16*1 ]
    mova                   m5, [coeffq+16*5 ]
    mova                   m6, [coeffq+16*9 ]
    mova                   m7, [coeffq+16*13]

.pass2_main:
    call m(idct_8x8_internal).main

    SAVE_7ROWS   rsp+gprsize+16*3, 16
    mova                   m0, [coeffq+16*2 ]
    mova                   m1, [coeffq+16*6 ]
    mova                   m2, [coeffq+16*10]
    mova                   m3, [coeffq+16*14]
    mova                   m4, [coeffq+16*3 ]
    mova                   m5, [coeffq+16*7 ]
    mova                   m6, [coeffq+16*11]
    mova                   m7, [coeffq+16*15]
    call m(idct_16x8_internal).main

    mov                    r3, dstq
    lea                  dstq, [dstq+strideq*8]
    jmp  m(idct_8x8_internal).end

.end:
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova   [rsp+gprsize+16*0], m7
    lea                  tx2q, [o(m(idct_8x16_internal).end1)]
    mov                  dstq, r3
    jmp  m(idct_8x8_internal).end

.end1:
    pxor                   m7, m7
    REPX  {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15
    ret

INV_TXFM_8X16_FN adst, dct
INV_TXFM_8X16_FN adst, adst
INV_TXFM_8X16_FN adst, flipadst
INV_TXFM_8X16_FN adst, identity

cglobal iadst_8x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                    r3, [o(m(iadst_8x8_internal).pass1)]
    jmp  m(idct_8x16_internal).pass1

.pass2:
    lea                  tx2q, [o(m(iadst_8x16_internal).end)]

.pass2_pre:
    mova    [rsp+gprsize+16*7], m0
    mova    [rsp+gprsize+16*8], m1
    mova    [rsp+gprsize+16*5], m6
    mova    [rsp+gprsize+16*6], m7
    mova                    m0, m2
    mova                    m1, m3
    mova                    m2, m4
    mova                    m3, m5

.pass2_main:
    mova                    m4, [coeffq+16*1 ]
    mova                    m5, [coeffq+16*3 ]
    mova                    m6, [coeffq+16*13]
    mova                    m7, [coeffq+16*15]
    mova    [rsp+gprsize+16*3], m4
    mova    [rsp+gprsize+16*4], m5
    mova    [rsp+gprsize+16*9], m6
    mova    [rsp+gprsize+32*5], m7
    mova                    m4, [coeffq+16*5 ]
    mova                    m5, [coeffq+16*7 ]
    mova                    m6, [coeffq+16*9 ]
    mova                    m7, [coeffq+16*11]

    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass2_end

    mov                    r3, dstq
    lea                  dstq, [dstq+strideq*8]
    jmp m(iadst_8x8_internal).end

.end:
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova   [rsp+gprsize+16*0], m7
    lea                  tx2q, [o(m(idct_8x16_internal).end1)]
    mov                  dstq, r3
    jmp  m(iadst_8x8_internal).end


INV_TXFM_8X16_FN flipadst, dct
INV_TXFM_8X16_FN flipadst, adst
INV_TXFM_8X16_FN flipadst, flipadst
INV_TXFM_8X16_FN flipadst, identity

cglobal iflipadst_8x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    lea                    r3, [o(m(iflipadst_8x8_internal).pass1)]
    jmp  m(idct_8x16_internal).pass1

.pass2:
    lea                   tx2q, [o(m(iflipadst_8x16_internal).end)]
    lea                     r3, [dstq+strideq*8]

.pass2_pre:
    mova    [rsp+gprsize+16*7], m0
    mova    [rsp+gprsize+16*8], m1
    mova    [rsp+gprsize+16*5], m6
    mova    [rsp+gprsize+16*6], m7
    mova                    m0, m2
    mova                    m1, m3
    mova                    m2, m4
    mova                    m3, m5

.pass2_main:
    mova                    m4, [coeffq+16*1 ]
    mova                    m5, [coeffq+16*3 ]
    mova                    m6, [coeffq+16*13]
    mova                    m7, [coeffq+16*15]
    mova    [rsp+gprsize+16*3], m4
    mova    [rsp+gprsize+16*4], m5
    mova    [rsp+gprsize+16*9], m6
    mova    [rsp+gprsize+32*5], m7
    mova                    m4, [coeffq+16*5 ]
    mova                    m5, [coeffq+16*7 ]
    mova                    m6, [coeffq+16*9 ]
    mova                    m7, [coeffq+16*11]

    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass2_end
    jmp  m(iflipadst_8x8_internal).end

.end:
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_8x16_internal).end1)]
    mov                   dstq, r3
    jmp  m(iflipadst_8x8_internal).end


INV_TXFM_8X16_FN identity, dct,      7
INV_TXFM_8X16_FN identity, adst
INV_TXFM_8X16_FN identity, flipadst
INV_TXFM_8X16_FN identity, identity

cglobal iidentity_8x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS    coeffq+16*1, 32, 1
    mov                    r3, tx2q
    lea                  tx2q, [o(m(iidentity_8x16_internal).pass1_end)]
    mova   [rsp+gprsize+16*1], m6
    jmp  m(idct_8x8_internal).pass1_end3

.pass1_end:
    SAVE_8ROWS    coeffq+16*1, 32
    LOAD_8ROWS    coeffq+16*0, 32, 1
    mov                  tx2q, r3
    mova   [rsp+gprsize+16*1], m6
    jmp  m(idct_8x8_internal).pass1_end3

.pass2:
    lea                  tx2q, [o(m(iidentity_8x16_internal).end1)]

.end:
    REPX     {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6, m7
    pmulhrsw               m7, [o(pw_5793x4)]
    pmulhrsw               m7, [o(pw_2048)]
    mova   [rsp+gprsize+16*0], m7
    mova                   m7, [o(pw_5793x4)]
    REPX     {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova                   m7, [o(pw_2048)]
    REPX     {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova   [rsp+gprsize+16*1], m6
    mova   [rsp+gprsize+16*2], m5
    jmp  m(idct_8x8_internal).end3

.end1:
    LOAD_8ROWS    coeffq+16*1, 32
    lea                  tx2q, [o(m(idct_8x16_internal).end1)]
    lea                  dstq, [dstq+strideq*2]
    jmp .end


%macro INV_TXFM_16X8_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 16x8, 8, 16*16
%ifidn %1_%2, dct_dct
    movd                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1, [coeffq]
    movd                 m2, [o(pw_16384)]
    mov            [coeffq], eobd
    pmulhrsw             m0, m1
    mov                 r2d, 4
    lea                tx2q, [o(m(inv_txfm_add_dct_dct_16x8).end)]
    jmp m(inv_txfm_add_dct_dct_16x4).dconly
.end:
    RET
%elifidn %1_%2, dct_identity
    mova                 m7, [coeffq]
    mova                 m0, [o(pw_2896x8)]
    mova                 m1, [o(pw_16384)]
    pxor                 m2, m2
    mova           [coeffq], m2
    pmulhrsw             m7, m0
    pmulhrsw             m7, m0
    pmulhrsw             m7, m1
    psrlw                m1, 2               ; pw_4096
    pmulhrsw             m7, m1
    punpcklwd            m3, m7, m7
    punpckhwd            m7, m7
    pshufd               m0, m3, q0000
    pshufd               m1, m3, q1111
    pshufd               m2, m3, q2222
    pshufd               m3, m3, q3333
    lea                  r3, [dstq+strideq*4]
    lea                tx2q, [dstq+8]
    call m(iadst_8x4_internal).end2
    add              coeffq, 16*4
    mov                dstq, tx2q
    call m(iadst_8x4_internal).end2
    mov                dstq, r3
    add              coeffq, 16*4
    pshufd               m0, m7, q0000
    pshufd               m1, m7, q1111
    pshufd               m2, m7, q2222
    pshufd               m3, m7, q3333
    lea                tx2q, [dstq+8]
    call m(iadst_8x4_internal).end2
    add              coeffq, 16*4
    mov                dstq, tx2q
    TAIL_CALL m(iadst_8x4_internal).end2
%elifidn %1_%2, identity_dct
    mova                 m5, [o(pw_16384)]
    mova                 m6, [o(pw_5793x4)]
    mova                 m7, [o(pw_2896x8)]
    pxor                 m4, m4
    mov                 r3d, 2
.main_loop:
    mova                 m0, [coeffq+16*0]
    punpcklwd            m0, [coeffq+16*1]
    mova                 m1, [coeffq+16*2]
    punpcklwd            m1, [coeffq+16*3]
    mova                 m2, [coeffq+16*4]
    punpcklwd            m2, [coeffq+16*5]
    mova                 m3, [coeffq+16*6]
    punpcklwd            m3, [coeffq+16*7]
    punpckldq            m0, m1
    punpckldq            m2, m3
    punpcklqdq           m0, m2
    pmulhrsw             m0, m7
    psllw                m0, 2
    pmulhrsw             m0, m6
    pmulhrsw             m0, m5
    psrlw                m1, m5, 3               ; pw_2048
    pmulhrsw             m0, m7
    pmulhrsw             m0, m1
.end:
    REPX  {mova [coeffq+16*x], m4},  0,  1,  2,  3,  4,  5,  6,  7
    add              coeffq, 16*8
    lea                tx2q, [dstq+8]
    WRITE_8X4             0, 0, 0, 0, 1, 2, 3
    lea                dstq, [dstq+strideq*2]
    WRITE_8X4             0, 0, 0, 0, 1, 2, 3
    mov                dstq, tx2q
    dec                 r3d
    jg .main_loop
    RET
%endif
%endmacro

INV_TXFM_16X8_FN dct, dct,      0
INV_TXFM_16X8_FN dct, identity, 7
INV_TXFM_16X8_FN dct, adst
INV_TXFM_16X8_FN dct, flipadst

cglobal idct_16x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS    coeffq+16*0, 32, 1
    call m(idct_8x8_internal).main
    SAVE_7ROWS   rsp+gprsize+16*3, 16

    LOAD_8ROWS    coeffq+16*1, 32, 1
    call  .main
    mov                    r3, tx2q
    lea                  tx2q, [o(m(idct_16x8_internal).pass1_end)]
    jmp  m(idct_8x8_internal).pass1_end

.pass1_end:
    SAVE_8ROWS    coeffq+16*1, 32
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova   [rsp+gprsize+16*0], m7
    mov                  tx2q, r3
    jmp  m(idct_8x8_internal).pass1_end

.pass2:
    lea                  tx2q, [o(m(idct_16x8_internal).end)]
    lea                    r3, [dstq+8]
    jmp  m(idct_8x8_internal).pass2_main

.end:
    LOAD_8ROWS    coeffq+16*1, 32
    lea                  tx2q, [o(m(idct_8x16_internal).end1)]
    mov                  dstq, r3
    jmp  m(idct_8x8_internal).pass2_main


ALIGN function_align
.main:
    mova [rsp+gprsize*2+16*1], m2
    mova [rsp+gprsize*2+16*2], m6
    mova [rsp+gprsize*2+32*5], m5

    mova                   m6, [o(pd_2048)]
    ITX_MULSUB_2W           0, 7, 2, 5, 6,  401, 4076   ;t8a, t15a
    ITX_MULSUB_2W           4, 3, 2, 5, 6, 3166, 2598   ;t9a, t14a
    psubsw                 m2, m0, m4                   ;t9
    paddsw                 m0, m4                       ;t8
    psubsw                 m4, m7, m3                   ;t14
    paddsw                 m7, m3                       ;t15
    ITX_MULSUB_2W           4, 2, 3, 5, 6, 1567, 3784   ;t9a, t14a
    mova                   m3, [rsp+gprsize*2+16*1]
    mova                   m5, [rsp+gprsize*2+32*5]
    mova [rsp+gprsize*2+16*1], m2
    mova [rsp+gprsize*2+32*5], m4
    mova                   m2, [rsp+gprsize*2+16*2]
    mova [rsp+gprsize*2+16*2], m7
    ITX_MULSUB_2W           3, 5, 7, 4, 6, 1931, 3612   ;t10a, t13a
    ITX_MULSUB_2W           2, 1, 7, 4, 6, 3920, 1189   ;t11a, t12a
    pxor                   m4, m4
    psubsw                 m7, m2, m3                   ;t10
    paddsw                 m2, m3                       ;t11
    psubsw                 m3, m1, m5                   ;t13
    paddsw                 m1, m5                       ;t12
    psubw                  m4, m7
    ITX_MULSUB_2W           4, 3, 7, 5, 6, 1567, 3784   ;t10a, t13a
    mova                   m7, [rsp+gprsize*2+32*5]
    psubsw                 m6, m0, m2                   ;t11a
    paddsw                 m0, m2                       ;t8a
    paddsw                 m2, m7, m4                   ;t9
    psubsw                 m7, m4                       ;t10
    mova                   m5, [rsp+gprsize*2+16*0]
    psubsw                 m4, m5, m0                   ;out8
    paddsw                 m0, m5                       ;out7
    mova [rsp+gprsize*2+32*5], m0
    mova                   m5, [rsp+gprsize*2+16*9]
    psubsw                 m0, m5, m2                   ;out9
    paddsw                 m2, m5                       ;out6
    mova [rsp+gprsize*2+16*0], m0
    mova [rsp+gprsize*2+16*9], m2
    mova                   m0, [rsp+gprsize*2+16*1]
    mova                   m2, [rsp+gprsize*2+16*2]
    mova [rsp+gprsize*2+16*1], m4
    psubsw                 m4, m0, m3                   ;t13
    paddsw                 m0, m3                       ;t14
    psubsw                 m3, m2, m1                   ;t12a
    paddsw                 m1, m2                       ;t15a
    mova                   m5, [o(pw_2896x8)]
    psubw                  m2, m4, m7                   ;t13-t10
    paddw                  m7, m4                       ;t13+t10
    psubw                  m4, m3, m6                   ;t12a-t11a
    paddw                  m6, m3                       ;t12a+t11a
    pmulhrsw               m7, m5                       ;t13a
    pmulhrsw               m4, m5                       ;t11
    pmulhrsw               m6, m5                       ;t12
    pmulhrsw               m5, m2                       ;t10a
    mova                   m3, [rsp+gprsize*2+16*8]
    psubsw                 m2, m3, m5                   ;out10
    paddsw                 m3, m5                       ;out5
    mova                   m5, [rsp+gprsize*2+16*7]
    mova [rsp+gprsize*2+16*8], m3
    psubsw                 m3, m5, m4                   ;out11
    paddsw                 m5, m4                       ;out4
    mova                   m4, [rsp+gprsize*2+16*6]
    mova [rsp+gprsize*2+16*7], m5
    paddsw                 m5, m4, m6                   ;out3
    psubsw                 m4, m6                       ;out12
    mova                   m6, [rsp+gprsize*2+16*5]
    mova [rsp+gprsize*2+16*6], m5
    psubsw                 m5, m6, m7                   ;out13
    paddsw                 m6, m7                       ;out2
    mova                   m7, [rsp+gprsize*2+16*4]
    mova [rsp+gprsize*2+16*5], m6
    psubsw                 m6, m7, m0                   ;out14
    paddsw                 m7, m0                       ;out1
    mova                   m0, [rsp+gprsize*2+16*3]
    mova [rsp+gprsize*2+16*4], m7
    psubsw                 m7, m0, m1                   ;out15
    paddsw                 m0, m1                       ;out0
    mova [rsp+gprsize*2+16*3], m0
    mova                   m1, [rsp+gprsize*2+16*0]
    mova                   m0, [rsp+gprsize*2+16*1]
    mova [rsp+gprsize*2+16*0], m7
    ret

INV_TXFM_16X8_FN adst, dct
INV_TXFM_16X8_FN adst, adst
INV_TXFM_16X8_FN adst, flipadst
INV_TXFM_16X8_FN adst, identity

cglobal iadst_16x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                    m7, [o(pw_2896x8)]
    pmulhrsw                m0, m7, [coeffq+16*0 ]
    pmulhrsw                m1, m7, [coeffq+16*1 ]
    pmulhrsw                m2, m7, [coeffq+16*14]
    pmulhrsw                m3, m7, [coeffq+16*15]
    mova    [rsp+gprsize+16*7], m0
    mova    [rsp+gprsize+16*8], m1
    mova    [rsp+gprsize+16*9], m2
    mova    [rsp+gprsize+32*5], m3
    pmulhrsw                m0, m7, [coeffq+16*6 ]
    pmulhrsw                m1, m7, [coeffq+16*7 ]
    pmulhrsw                m2, m7, [coeffq+16*8 ]
    pmulhrsw                m3, m7, [coeffq+16*9 ]
    mova    [rsp+gprsize+16*3], m2
    mova    [rsp+gprsize+16*4], m3
    mova    [rsp+gprsize+16*5], m0
    mova    [rsp+gprsize+16*6], m1
    pmulhrsw                m0, m7, [coeffq+16*2 ]
    pmulhrsw                m1, m7, [coeffq+16*3 ]
    pmulhrsw                m2, m7, [coeffq+16*4 ]
    pmulhrsw                m3, m7, [coeffq+16*5 ]
    pmulhrsw                m4, m7, [coeffq+16*10]
    pmulhrsw                m5, m7, [coeffq+16*11]
    pmulhrsw                m6, m7, [coeffq+16*12]
    pmulhrsw                m7,     [coeffq+16*13]

    call .main
    call .main_pass1_end
    mov                    r3, tx2q
    lea                  tx2q, [o(m(iadst_16x8_internal).pass1_end)]
    jmp m(iadst_8x8_internal).pass1_end

.pass1_end:
    SAVE_8ROWS    coeffq+16*1, 32
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova   [rsp+gprsize+16*0], m7
    mov                  tx2q, r3
    jmp m(iadst_8x8_internal).pass1_end

.pass2:
    lea                  tx2q, [o(m(iadst_16x8_internal).end)]
    lea                    r3, [dstq+8]
    jmp m(iadst_8x8_internal).pass2_main

.end:
    LOAD_8ROWS    coeffq+16*1, 32
    lea                  tx2q, [o(m(idct_8x16_internal).end1)]
    mov                  dstq, r3
    jmp m(iadst_8x8_internal).pass2_main

ALIGN function_align
.main:
    mova  [rsp+gprsize*2+16*0], m1
    mova  [rsp+gprsize*2+16*1], m2
    mova  [rsp+gprsize*2+16*2], m6

    mova                    m6, [o(pd_2048)]
    ITX_MULSUB_2W            7, 0, 1, 2, 6,  995, 3973   ;t3,  t2
    ITX_MULSUB_2W            3, 4, 1, 2, 6, 3513, 2106   ;t11, t10
    psubsw                  m1, m0, m4                   ;t10a
    paddsw                  m0, m4                       ;t2a
    psubsw                  m4, m7, m3                   ;t11a
    paddsw                  m3, m7                       ;t3a
    ITX_MULSUB_2W            1, 4, 7, 2, 6, 3406, 2276   ;t11, t10
    mova                    m2, [rsp+gprsize*2+16*0]     ;in3
    mova                    m7, [rsp+gprsize*2+16*1]     ;in4
    mova  [rsp+gprsize*2+16*0], m1                       ;t11
    mova  [rsp+gprsize*2+16*1], m4                       ;t10
    mova                    m1, [rsp+gprsize*2+16*2]     ;in12
    mova  [rsp+gprsize*2+16*2], m0                       ;t2a
    ITX_MULSUB_2W            5, 7, 0, 4, 6, 1751, 3703   ;t5,  t4
    ITX_MULSUB_2W            2, 1, 0, 4, 6, 3857, 1380   ;t13, t12
    psubsw                  m0, m7, m1                   ;t12a
    paddsw                  m1, m7                       ;t4a
    psubsw                  m4, m5, m2                   ;t13a
    paddsw                  m5, m2                       ;t5a
    ITX_MULSUB_2W            4, 0, 7, 2, 6, 4017,  799   ;t12, t13
    mova                    m2, [rsp+gprsize*2+16*8]     ;in1
    mova                    m7, [rsp+gprsize*2+16*9]     ;in14
    mova  [rsp+gprsize*2+16*8], m4                       ;t12
    mova  [rsp+gprsize*2+16*9], m0                       ;t13
    mova                    m4, [rsp+gprsize*2+16*4]     ;in9
    mova                    m0, [rsp+gprsize*2+16*5]     ;in6
    mova  [rsp+gprsize*2+16*4], m1                       ;t4a
    mova  [rsp+gprsize*2+16*5], m5                       ;t5a
    ITX_MULSUB_2W            2, 7, 1, 5, 6, 4052,  601   ;t15, t14
    ITX_MULSUB_2W            4, 0, 1, 5, 6, 2440, 3290   ;t7,  t6
    psubsw                  m1, m0, m7                   ;t14a
    paddsw                  m0, m7                       ;t6a
    psubsw                  m5, m4, m2                   ;t15a
    paddsw                  m4, m2                       ;t7a
    ITX_MULSUB_2W            5, 1, 7, 2, 6, 2276, 3406   ;t14, t15
    mova                    m2, [rsp+gprsize*2+16*2]     ;t2a
    mova  [rsp+gprsize*2+16*2], m5                       ;t14
    psubsw                  m7, m2, m0                   ;t6
    paddsw                  m2, m0                       ;t2
    psubsw                  m0, m3, m4                   ;t7
    paddsw                  m3, m4                       ;t3
    ITX_MULSUB_2W            0, 7, 4, 5, 6, 3784, 1567   ;t6a, t7a
    mova                    m4, [rsp+gprsize*2+16*7]     ;in0
    mova                    m5, [rsp+gprsize*2+32*5]     ;in15
    mova  [rsp+gprsize*2+16*7], m3                       ;t3
    mova  [rsp+gprsize*2+32*5], m1                       ;t15
    mova                    m1, [rsp+gprsize*2+16*6]     ;in7
    mova                    m3, [rsp+gprsize*2+16*3]     ;in8
    mova  [rsp+gprsize*2+16*6], m7                       ;t7a
    mova  [rsp+gprsize*2+16*3], m0                       ;t6a
    ITX_MULSUB_2W            5, 4, 0, 7, 6,  201, 4091   ;t1,  t0
    ITX_MULSUB_2W            1, 3, 0, 7, 6, 3035, 2751   ;t9,  t8
    psubsw                  m0, m4, m3                   ;t8a
    paddsw                  m4, m3                       ;t0a
    psubsw                  m3, m5, m1                   ;t9a
    paddsw                  m5, m1                       ;t1a
    ITX_MULSUB_2W            0, 3, 1, 7, 6,  799, 4017   ;t9,  t8
    mova                    m1, [rsp+gprsize*2+16*4]     ;t4a
    mova                    m7, [rsp+gprsize*2+16*5]     ;t5a
    mova  [rsp+gprsize*2+16*4], m3                       ;t8
    mova  [rsp+gprsize*2+16*5], m0                       ;t9
    psubsw                  m0, m4, m1                   ;t4
    paddsw                  m4, m1                       ;t0
    psubsw                  m3, m5, m7                   ;t5
    paddsw                  m5, m7                       ;t1
    ITX_MULSUB_2W            0, 3, 1, 7, 6, 1567, 3784   ;t5a, t4a
    mova                    m7, [rsp+gprsize*2+16*3]     ;t6a
    psubsw                  m1, m4, m2                   ;t2a
    paddsw                  m4, m2                       ;out0
    mova  [rsp+gprsize*2+16*3], m4                       ;out0
    mova                    m4, [rsp+gprsize*2+16*6]     ;t7a
    psubsw                  m2, m3, m7                   ;t6
    paddsw                  m3, m7                       ;-out3
    mova  [rsp+gprsize*2+16*6], m3                       ;-out3
    psubsw                  m3, m0, m4                   ;t7
    paddsw                  m0, m4                       ;out12
    mova [rsp+gprsize*2+16*12], m3
    mova                    m3, [rsp+gprsize*2+16*7]     ;t3
    mova [rsp+gprsize*2+16* 7], m2                       ;out4
    psubsw                  m2, m5, m3                   ;t3a
    paddsw                  m5, m3                       ;-out15
    mova [rsp+gprsize*2+16*11], m2
    mova                    m2, [rsp+gprsize*2+32*5]     ;t15
    mova [rsp+gprsize*2+16*10], m1                       ;-out7
    mova                    m1, [rsp+gprsize*2+16*0]     ;t11
    mova [rsp+gprsize*2+16*0 ], m5                       ;-out15
    mova                    m3, [rsp+gprsize*2+16*1]     ;t10
    mova [rsp+gprsize*2+16*1 ], m4                       ;-out11
    mova                    m4, [rsp+gprsize*2+16*2]     ;t14
    mova [rsp+gprsize*2+16*2 ], m0                       ;out12
    psubsw                  m0, m3, m4                   ;t14a
    paddsw                  m3, m4                       ;t10a
    psubsw                  m5, m1, m2                   ;t15a
    paddsw                  m1, m2                       ;t11a
    ITX_MULSUB_2W            5, 0, 2, 4, 6, 3784, 1567   ;t14, t15
    mova                    m2, [rsp+gprsize*2+16*4]     ;t8
    mova                    m4, [rsp+gprsize*2+16*5]     ;t9
    mova  [rsp+gprsize*2+16*4], m3                       ;t10a
    mova  [rsp+gprsize*2+16*5], m1                       ;t11a
    mova                    m3, [rsp+gprsize*2+16*8]     ;t12
    mova                    m1, [rsp+gprsize*2+16*9]     ;t13
    mova  [rsp+gprsize*2+16*8], m5                       ;t14
    mova  [rsp+gprsize*2+16*9], m0                       ;t15
    psubsw                  m5, m2, m3                   ;t12a
    paddsw                  m2, m3                       ;t8a
    psubsw                  m0, m4, m1                   ;t13a
    paddsw                  m4, m1                       ;t9a
    ITX_MULSUB_2W            5, 0, 1, 3, 6, 1567, 3784   ;t13, t12
    mova                    m6, [rsp+gprsize*2+16*4]     ;t10a
    mova                    m1, [rsp+gprsize*2+16*5]     ;t11a
    psubsw                  m3, m2, m6                   ;t10
    paddsw                  m2, m6                       ;-out1
    paddsw                  m6, m4, m1                   ;out14
    psubsw                  m4, m1                       ;t11
    mova [rsp+gprsize*2+16*14], m4
    mova [rsp+gprsize*2+16* 4], m2                       ;-out1
    mova                    m4, [rsp+gprsize*2+16*8]     ;t14
    mova                    m2, [rsp+gprsize*2+16*9]     ;t15
    mova [rsp+gprsize*2+16* 9], m3                       ;out6
    psubsw                  m3, m0, m4                   ;t14a
    paddsw                  m0, m4                       ;out2
    psubsw                  m4, m5, m2                   ;t15a
    paddsw                  m5, m2                       ;-out13
    mova [rsp+gprsize*2+16* 5], m0                       ;out2
    ret
ALIGN function_align
.main_pass1_end:
    mova                    m0, [rsp+gprsize*2+16*14]
    mova [rsp+gprsize*2+16*14], m5
    mova [rsp+gprsize*2+16*15], m6
    mova                    m5, [o(pw_2896_2896)]
    mova                    m6, [o(pw_2896_m2896)]
    mova                    m7, [o(pd_2048)]
    punpcklwd               m2, m3, m4
    punpckhwd               m3, m4
    pmaddwd                 m4, m5, m2
    pmaddwd                 m2, m6
    pmaddwd                 m1, m5, m3
    pmaddwd                 m3, m6
    REPX         {paddd x, m7}, m4, m2, m1, m3
    REPX         {psrad x, 12}, m4, m1, m2, m3
    packssdw                m4, m1                       ;-out5
    packssdw                m2, m3                       ;out10
    mova [rsp+gprsize*2+16* 8], m4
    mova                    m3, [rsp+gprsize*2+16* 9]
    punpcklwd               m1, m3, m0
    punpckhwd               m3, m0
    pmaddwd                 m0, m5, m1
    pmaddwd                 m1, m6
    pmaddwd                 m4, m5, m3
    pmaddwd                 m3, m6
    REPX         {paddd x, m7}, m0, m1, m4, m3
    REPX         {psrad x, 12}, m0, m4, m1, m3
    packssdw                m0, m4                       ;out6
    packssdw                m1, m3                       ;-out9
    mova [rsp+gprsize*2+16* 9], m0
    mova                    m0, [rsp+gprsize*2+16* 7]
    mova                    m4, [rsp+gprsize*2+16*12]
    punpcklwd               m3, m0, m4
    punpckhwd               m0, m4
    pmaddwd                 m4, m5, m3
    pmaddwd                 m3, m6
    pmaddwd                 m5, m0
    pmaddwd                 m0, m6
    REPX         {paddd x, m7}, m4, m3, m5, m0
    REPX         {psrad x, 12}, m4, m5, m3, m0
    packssdw                m4, m5                       ;out4
    packssdw                m3, m0                       ;-out11
    mova [rsp+gprsize*2+16* 7], m4
    mova                    m4, [rsp+gprsize*2+16*10]
    mova                    m5, [rsp+gprsize*2+16*11]
    punpcklwd               m0, m4, m5
    punpckhwd               m4, m5
    pmaddwd                 m5, m0, [o(pw_2896_2896)]
    pmaddwd                 m0, m6
    pmaddwd                 m6, m4
    pmaddwd                 m4, [o(pw_2896_2896)]
    REPX         {paddd x, m7}, m5, m0, m6, m4
    REPX         {psrad x, 12}, m0, m6, m5, m4
    packssdw                m0, m6                       ;out8
    packssdw                m5, m4                       ;-out7
    mova [rsp+gprsize*2+16*10], m5
    mova                    m4, [rsp+gprsize*2+16* 2]    ;out12
    mova                    m5, [rsp+gprsize*2+16*14]    ;-out13
    mova                    m6, [rsp+gprsize*2+16*15]    ;out14
    ret
ALIGN function_align
.main_pass2_end:
    mova                    m7, [o(pw_2896x8)]
    mova                    m1, [rsp+gprsize*2+16* 9]
    mova                    m2, [rsp+gprsize*2+16*14]
    paddsw                  m0, m1, m2
    psubsw                  m1, m2
    pmulhrsw                m0, m7                       ;out6
    pmulhrsw                m1, m7                       ;-out9
    mova [rsp+gprsize*2+16* 9], m0
    psubsw                  m2, m3, m4
    paddsw                  m3, m4
    pmulhrsw                m2, m7                       ;out10
    pmulhrsw                m3, m7                       ;-out5
    mova [rsp+gprsize*2+16* 8], m3
    mova                    m3, [rsp+gprsize*2+16* 7]
    mova                    m4, [rsp+gprsize*2+16*12]
    paddsw                  m0, m3, m4
    psubsw                  m3, m4
    pmulhrsw                m0, m7                       ;out4
    pmulhrsw                m3, m7                       ;-out11
    mova [rsp+gprsize*2+16* 7], m0
    mova                    m0, [rsp+gprsize*2+16*10]
    paddsw                  m4, m0, [rsp+gprsize*2+16*11]
    psubsw                  m0, [rsp+gprsize*2+16*11]
    pmulhrsw                m4, m7                       ;-out7
    pmulhrsw                m0, m7                       ;out8
    mova [rsp+gprsize*2+16*10], m4
    mova                    m4, [rsp+gprsize*2+16*2 ]    ;out12
    ret

INV_TXFM_16X8_FN flipadst, dct
INV_TXFM_16X8_FN flipadst, adst
INV_TXFM_16X8_FN flipadst, flipadst
INV_TXFM_16X8_FN flipadst, identity

cglobal iflipadst_16x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mova                    m7, [o(pw_2896x8)]
    pmulhrsw                m0, m7, [coeffq+16*0 ]
    pmulhrsw                m1, m7, [coeffq+16*1 ]
    pmulhrsw                m2, m7, [coeffq+16*14]
    pmulhrsw                m3, m7, [coeffq+16*15]
    mova    [rsp+gprsize+16*7], m0
    mova    [rsp+gprsize+16*8], m1
    mova    [rsp+gprsize+16*9], m2
    mova    [rsp+gprsize+32*5], m3
    pmulhrsw                m0, m7, [coeffq+16*6 ]
    pmulhrsw                m1, m7, [coeffq+16*7 ]
    pmulhrsw                m2, m7, [coeffq+16*8 ]
    pmulhrsw                m3, m7, [coeffq+16*9 ]
    mova    [rsp+gprsize+16*3], m2
    mova    [rsp+gprsize+16*4], m3
    mova    [rsp+gprsize+16*5], m0
    mova    [rsp+gprsize+16*6], m1
    pmulhrsw                m0, m7, [coeffq+16*2 ]
    pmulhrsw                m1, m7, [coeffq+16*3 ]
    pmulhrsw                m2, m7, [coeffq+16*4 ]
    pmulhrsw                m3, m7, [coeffq+16*5 ]
    pmulhrsw                m4, m7, [coeffq+16*10]
    pmulhrsw                m5, m7, [coeffq+16*11]
    pmulhrsw                m6, m7, [coeffq+16*12]
    pmulhrsw                m7,     [coeffq+16*13]

    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass1_end

    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS     coeffq+16*0, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mov                     r3, tx2q
    lea                   tx2q, [o(m(iflipadst_16x8_internal).pass1_end)]
    jmp m(iflipadst_8x8_internal).pass1_end

.pass1_end:
    SAVE_8ROWS     coeffq+16*1, 32
    LOAD_8ROWS     coeffq+16*0, 32
    mova    [rsp+gprsize+16*0], m7
    mov                   tx2q, r3
    jmp m(iflipadst_8x8_internal).pass1_end

.pass2:
    lea                   tx2q, [o(m(iflipadst_16x8_internal).end)]
    lea                     r3, [dstq+8]
    jmp m(iflipadst_8x8_internal).pass2_main

.end:
    LOAD_8ROWS     coeffq+16*1, 32
    lea                   tx2q, [o(m(idct_8x16_internal).end1)]
    mov                   dstq, r3
    jmp m(iflipadst_8x8_internal).pass2_main


INV_TXFM_16X8_FN identity, dct,      15
INV_TXFM_16X8_FN identity, adst
INV_TXFM_16X8_FN identity, flipadst
INV_TXFM_16X8_FN identity, identity

cglobal iidentity_16x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS    coeffq+16*8, 16, 1

    mov                    r3, tx2q
    lea                  tx2q, [o(m(iidentity_16x8_internal).pass1_end)]

.pass1:
    REPX     {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6, m7
    pmulhrsw               m7, [o(pw_5793x4)]
    mova   [rsp+gprsize+16*0], m7

    mova                   m7, [o(pw_5793x4)]
    REPX     {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6

    jmp   m(idct_8x8_internal).pass1_end

.pass1_end:
    mova       [coeffq+16*9 ], m4
    mova       [coeffq+16*11], m5
    mova       [coeffq+16*13], m6
    mova       [coeffq+16*15], m7
    mova                   m4, [o(pw_2896x8)]
    pmulhrsw               m5, m4, [coeffq+16*5]
    pmulhrsw               m6, m4, [coeffq+16*6]
    pmulhrsw               m7, m4, [coeffq+16*7]
    mova       [coeffq+16*5 ], m2
    mova       [coeffq+16*7 ], m3
    pmulhrsw               m2, m4, [coeffq+16*2]
    pmulhrsw               m3, m4, [coeffq+16*3]
    mova       [coeffq+16*3 ], m1
    pmulhrsw               m1, m4, [coeffq+16*1]
    mova       [coeffq+16*1 ], m0
    pmulhrsw               m0, m4, [coeffq+16*0]
    pmulhrsw               m4, [coeffq+16*4]

    mov                  tx2q, r3
    jmp .pass1

.pass2:
    lea                  tx2q, [o(m(iidentity_16x8_internal).end)]
    lea                    r3, [dstq+8]
    jmp  m(iidentity_8x8_internal).end

.end:
    LOAD_8ROWS    coeffq+16*1, 32
    lea                  tx2q, [o(m(idct_8x16_internal).end1)]
    mov                  dstq, r3
    jmp  m(iidentity_8x8_internal).end


%macro INV_TXFM_16X16_FN 2-3 -1 ; type1, type2, fast_thresh
    INV_TXFM_FN          %1, %2, %3, 16x16, 8, 16*16
%ifidn %1_%2, dct_dct
    movd                   m1, [o(pw_2896x8)]
    pmulhrsw               m0, m1, [coeffq]
    movd                   m2, [o(pw_8192)]
    mov              [coeffq], eobd
    mov                   r2d, 8
    lea                  tx2q, [o(m(inv_txfm_add_dct_dct_16x16).end)]
    jmp m(inv_txfm_add_dct_dct_16x4).dconly
.end:
    RET
%elifidn %1_%2, dct_identity
    mova                   m3, [o(pw_2896x8)]
    pmulhrsw               m2, m3, [coeffq+16*0]
    pmulhrsw               m3, [coeffq+16*1]
    mova                   m0, [o(pw_8192)]
    mova                   m1, [o(pw_5793x4)]
    pshuflw                m4, [o(deint_shuf)], q0000 ;pb_0_1
    punpcklwd              m4, m4
    pcmpeqb                m5, m5
    pxor                   m6, m6
    mova        [coeffq+16*0], m6
    mova        [coeffq+16*1], m6
    paddb                  m5, m5                     ;pb_m2
    pmulhrsw               m2, m0
    pmulhrsw               m3, m0
    psrlw                  m0, 2                      ;pw_2048
    psllw                  m2, 2
    psllw                  m3, 2
    pmulhrsw               m2, m1
    pmulhrsw               m3, m1
    pmulhrsw               m2, m0
    pmulhrsw               m3, m0
    mov                   r3d, 8
.loop:
    mova                   m1, [dstq]
    pshufb                 m0, m2, m4
    punpckhbw              m7, m1, m6
    punpcklbw              m1, m6
    paddw                  m7, m0
    paddw                  m1, m0
    packuswb               m1, m7
    mova               [dstq], m1
    mova                   m1, [dstq+strideq*8]
    pshufb                 m0, m3, m4
    psubb                  m4, m5 ; += 2
    punpckhbw              m7, m1, m6
    punpcklbw              m1, m6
    paddw                  m7, m0
    paddw                  m1, m0
    packuswb               m1, m7
    mova     [dstq+strideq*8], m1
    add                  dstq, strideq
    dec                   r3d
    jg .loop
    RET
%elifidn %1_%2, identity_dct
    mova                   m4, [o(pw_5793x4)]
    mova                   m5, [o(pw_8192)]
    mova                   m6, [o(pw_2896x8)]
    psrlw                  m7, m5, 2                 ;pw_2048
    xor                  eobd, eobd
    lea                  tx2q, [o(m(inv_txfm_add_identity_dct_16x16).end)]
    lea                    r3, [dstq+8]
    mov            [rsp+16*0], r3
.main:
    movd                   m0, [coeffq+32*0]
    punpcklwd              m0, [coeffq+32*1]
    movd                   m2, [coeffq+32*2]
    punpcklwd              m2, [coeffq+32*3]
    add                coeffq, 32*4
    movd                   m1, [coeffq+32*0]
    punpcklwd              m1, [coeffq+32*1]
    movd                   m3, [coeffq+32*2]
    punpcklwd              m3, [coeffq+32*3]
    xor                  eobd, eobd
    mov         [coeffq-32*4], eobd
    mov         [coeffq-32*3], eobd
    mov         [coeffq-32*2], eobd
    mov         [coeffq-32*1], eobd
    punpckldq              m0, m2
    punpckldq              m1, m3
    punpcklqdq             m0, m1
    psllw                  m0, 2
    pmulhrsw               m0, m4
    pmulhrsw               m0, m5
    pmulhrsw               m0, m6
    pmulhrsw               m0, m7
    mov         [coeffq+32*0], eobd
    mov         [coeffq+32*1], eobd
    mov         [coeffq+32*2], eobd
    mov         [coeffq+32*3], eobd
    mov                   r3d, 4
    jmp m(inv_txfm_add_dct_dct_8x8).loop
.end:
    lea                  tx2q, [o(m(inv_txfm_add_identity_dct_16x16).end1)]
    add                coeffq, 32*4
    mov                  dstq, [rsp+16*0]
    jmp .main
.end1:
    RET
%endif
%endmacro

INV_TXFM_16X16_FN dct, dct,      0
INV_TXFM_16X16_FN dct, identity, 15
INV_TXFM_16X16_FN dct, adst
INV_TXFM_16X16_FN dct, flipadst

cglobal idct_16x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS     coeffq+16*1, 64
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+16*3, 64
    call m(idct_16x8_internal).main
    mov                     r3, tx2q
    lea                   tx2q, [o(m(idct_16x16_internal).pass1_end)]
    mova                    m7, [o(pw_8192)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS    coeffq+16*17, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_16x16_internal).pass1_end1)]
    mova                    m7, [o(pw_8192)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS     coeffq+16*1, 32
    LOAD_8ROWS     coeffq+16*0, 64
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+16*2, 64
    call m(idct_16x8_internal).main
    lea                   tx2q, [o(m(idct_16x16_internal).pass1_end2)]
    mova                    m7, [o(pw_8192)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end2:
    SAVE_8ROWS    coeffq+16*16, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mov                   tx2q, r3
    mova                    m7, [o(pw_8192)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass2:
    lea                   tx2q, [o(m(idct_16x16_internal).end)]
    jmp  m(idct_8x16_internal).pass2_pre

.end:
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_16x16_internal).end1)]
    mov                   dstq, r3
    lea                     r3, [dstq+8]
    jmp   m(idct_8x8_internal).end

.end1:
    pxor                    m7, m7
    REPX   {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15

    add                 coeffq, 32*8
    mov                   dstq, r3

    mova                    m0, [coeffq+16*0 ]
    mova                    m1, [coeffq+16*4 ]
    mova                    m2, [coeffq+16*8 ]
    mova                    m3, [coeffq+16*12]
    mova                    m4, [coeffq+16*1 ]
    mova                    m5, [coeffq+16*5 ]
    mova                    m6, [coeffq+16*9 ]
    mova                    m7, [coeffq+16*13]
    lea                   tx2q, [o(m(idct_8x16_internal).end)]
    jmp  m(idct_8x16_internal).pass2_main


%macro ITX_16X16_ADST_LOAD_ODD_COEFS 0
    mova                    m0, [coeffq+16*1 ]
    mova                    m1, [coeffq+16*3 ]
    mova                    m2, [coeffq+16*29]
    mova                    m3, [coeffq+16*31]
    mova    [rsp+gprsize+16*7], m0
    mova    [rsp+gprsize+16*8], m1
    mova    [rsp+gprsize+16*9], m2
    mova    [rsp+gprsize+32*5], m3
    mova                    m0, [coeffq+16*13]
    mova                    m1, [coeffq+16*15]
    mova                    m2, [coeffq+16*17]
    mova                    m3, [coeffq+16*19]
    mova    [rsp+gprsize+16*3], m2
    mova    [rsp+gprsize+16*4], m3
    mova    [rsp+gprsize+16*5], m0
    mova    [rsp+gprsize+16*6], m1
    mova                    m0, [coeffq+16*5 ]
    mova                    m1, [coeffq+16*7 ]
    mova                    m2, [coeffq+16*9 ]
    mova                    m3, [coeffq+16*11]
    mova                    m4, [coeffq+16*21]
    mova                    m5, [coeffq+16*23]
    mova                    m6, [coeffq+16*25]
    mova                    m7, [coeffq+16*27]
%endmacro

%macro ITX_16X16_ADST_LOAD_EVEN_COEFS 0
    mova                    m0, [coeffq+16*0 ]
    mova                    m1, [coeffq+16*2 ]
    mova                    m2, [coeffq+16*28]
    mova                    m3, [coeffq+16*30]
    mova    [rsp+gprsize+16*7], m0
    mova    [rsp+gprsize+16*8], m1
    mova    [rsp+gprsize+16*9], m2
    mova    [rsp+gprsize+32*5], m3
    mova                    m0, [coeffq+16*12]
    mova                    m1, [coeffq+16*14]
    mova                    m2, [coeffq+16*16]
    mova                    m3, [coeffq+16*18]
    mova    [rsp+gprsize+16*3], m2
    mova    [rsp+gprsize+16*4], m3
    mova    [rsp+gprsize+16*5], m0
    mova    [rsp+gprsize+16*6], m1
    mova                    m0, [coeffq+16*4 ]
    mova                    m1, [coeffq+16*6 ]
    mova                    m2, [coeffq+16*8 ]
    mova                    m3, [coeffq+16*10]
    mova                    m4, [coeffq+16*20]
    mova                    m5, [coeffq+16*22]
    mova                    m6, [coeffq+16*24]
    mova                    m7, [coeffq+16*26]
%endmacro

INV_TXFM_16X16_FN adst, dct
INV_TXFM_16X16_FN adst, adst
INV_TXFM_16X16_FN adst, flipadst

cglobal iadst_16x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    ITX_16X16_ADST_LOAD_ODD_COEFS
    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass1_end

    mov                     r3, tx2q
    lea                   tx2q, [o(m(iadst_16x16_internal).pass1_end)]
    mova                    m7, [o(pw_8192)]
    jmp  m(iadst_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS    coeffq+16*17, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(iadst_16x16_internal).pass1_end1)]
    mova                    m7, [o(pw_8192)]
    jmp  m(iadst_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS     coeffq+16*1, 32
    ITX_16X16_ADST_LOAD_EVEN_COEFS
    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass1_end

    lea                   tx2q, [o(m(iadst_16x16_internal).pass1_end2)]
    mova                    m7, [o(pw_8192)]
    jmp  m(iadst_8x8_internal).pass1_end1

.pass1_end2:
    SAVE_8ROWS    coeffq+16*16, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mov                   tx2q, r3
    mova                    m7, [o(pw_8192)]
    jmp  m(iadst_8x8_internal).pass1_end1

.pass2:
    lea                   tx2q, [o(m(iadst_16x16_internal).end)]
    jmp m(iadst_8x16_internal).pass2_pre

.end:
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(iadst_16x16_internal).end1)]
    mov                   dstq, r3
    lea                     r3, [dstq+8]
    jmp  m(iadst_8x8_internal).end

.end1:
    pxor                    m7, m7
    REPX   {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15

    add                 coeffq, 32*8
    mov                   dstq, r3

    mova                    m4, [coeffq+16*0 ]
    mova                    m5, [coeffq+16*2 ]
    mova                    m0, [coeffq+16*4 ]
    mova                    m1, [coeffq+16*6 ]
    mova                    m2, [coeffq+16*8 ]
    mova                    m3, [coeffq+16*10]
    mova                    m6, [coeffq+16*12]
    mova                    m7, [coeffq+16*14]
    mova    [rsp+gprsize+16*7], m4
    mova    [rsp+gprsize+16*8], m5
    mova    [rsp+gprsize+16*5], m6
    mova    [rsp+gprsize+16*6], m7
    lea                   tx2q, [o(m(iadst_8x16_internal).end)]
    jmp m(iadst_8x16_internal).pass2_main


INV_TXFM_16X16_FN flipadst, dct
INV_TXFM_16X16_FN flipadst, adst
INV_TXFM_16X16_FN flipadst, flipadst

cglobal iflipadst_16x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    ITX_16X16_ADST_LOAD_ODD_COEFS
    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass1_end

    mov                     r3, tx2q
    lea                   tx2q, [o(m(iflipadst_16x16_internal).pass1_end)]
    mova                    m7, [o(pw_m8192)]
    jmp  m(iflipadst_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS     coeffq+16*1, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(iflipadst_16x16_internal).pass1_end1)]
    mova                    m7, [o(pw_m8192)]
    jmp  m(iflipadst_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS    coeffq+16*17, 32
    ITX_16X16_ADST_LOAD_EVEN_COEFS
    call m(iadst_16x8_internal).main
    call m(iadst_16x8_internal).main_pass1_end

    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS     coeffq+16*0, 32
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(iflipadst_16x16_internal).pass1_end2)]
    mova                    m7, [o(pw_m8192)]
    jmp  m(iflipadst_8x8_internal).pass1_end1

.pass1_end2:
    SAVE_8ROWS    coeffq+16*16, 32
    LOAD_8ROWS    coeffq+16* 0, 32
    mova    [rsp+gprsize+16*0], m7
    mov                   tx2q, r3
    mova                    m7, [o(pw_m8192)]
    jmp m(iflipadst_8x8_internal).pass1_end1

.pass2:
    lea                   tx2q, [o(m(iflipadst_16x16_internal).end)]
    lea                     r3, [dstq+8]
    jmp m(iflipadst_8x16_internal).pass2_pre

.end:
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(iflipadst_16x16_internal).end1)]
    lea                   dstq, [dstq+strideq*2]
    jmp  m(iflipadst_8x8_internal).end

.end1:
    pxor                    m7, m7
    REPX   {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15

    add                 coeffq, 32*8

    mova                    m4, [coeffq+16*0 ]
    mova                    m5, [coeffq+16*2 ]
    mova                    m0, [coeffq+16*4 ]
    mova                    m1, [coeffq+16*6 ]
    mova                    m2, [coeffq+16*8 ]
    mova                    m3, [coeffq+16*10]
    mova                    m6, [coeffq+16*12]
    mova                    m7, [coeffq+16*14]
    mova    [rsp+gprsize+16*7], m4
    mova    [rsp+gprsize+16*8], m5
    mova    [rsp+gprsize+16*5], m6
    mova    [rsp+gprsize+16*6], m7

    lea                   tx2q, [o(m(iflipadst_16x16_internal).end2)]
    mov                   dstq, r3
    jmp m(iflipadst_8x16_internal).pass2_main

.end2:
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_8x16_internal).end1)]
    lea                   dstq, [dstq+strideq*2]
    jmp  m(iflipadst_8x8_internal).end


INV_TXFM_16X16_FN identity, dct,      15
INV_TXFM_16X16_FN identity, identity

cglobal iidentity_16x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    LOAD_8ROWS    coeffq+16*17, 32
    mov                     r3, tx2q
    lea                   tx2q, [o(m(iidentity_16x16_internal).pass1_end)]

.pass1:
    REPX      {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6, m7
    pmulhrsw                m7, [o(pw_5793x4)]
    mova    [rsp+gprsize+16*0], m7

    mova                    m7, [o(pw_5793x4)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6

    mova                    m7, [o(pw_8192)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS    coeffq+16*17, 32
    LOAD_8ROWS    coeffq+16* 1, 32
    lea                   tx2q, [o(m(iidentity_16x16_internal).pass1_end1)]
    jmp .pass1

.pass1_end1:
    SAVE_8ROWS    coeffq+16* 1, 32
    LOAD_8ROWS    coeffq+16*16, 32
    lea                   tx2q, [o(m(iidentity_16x16_internal).pass1_end2)]
    jmp .pass1

.pass1_end2:
    SAVE_8ROWS    coeffq+16*16, 32
    LOAD_8ROWS    coeffq+16* 0, 32
    mov                   tx2q, r3
    jmp .pass1

.pass2:
    lea                     r3, [dstq+8]
    lea                   tx2q, [o(m(iidentity_16x16_internal).end1)]

.end:
    REPX      {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6, m7
    pmulhrsw                m7, [o(pw_5793x4)]
    pmulhrsw                m7, [o(pw_2048)]
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_5793x4)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova                    m7, [o(pw_2048)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova    [rsp+gprsize+16*1], m6
    mova    [rsp+gprsize+16*2], m5
    jmp   m(idct_8x8_internal).end3

.end1:
    LOAD_8ROWS     coeffq+16*1, 32
    lea                   tx2q, [o(m(iidentity_16x16_internal).end2)]
    lea                   dstq, [dstq+strideq*2]
    jmp .end

.end2:
    pxor                    m7, m7
    REPX   {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15

    add                 coeffq, 32*8
    LOAD_8ROWS          coeffq, 32
    lea                   tx2q, [o(m(iidentity_16x16_internal).end3)]
    mov                   dstq, r3
    jmp .end

.end3:
    LOAD_8ROWS     coeffq+16*1, 32
    lea                   tx2q, [o(m(idct_8x16_internal).end1)]
    lea                   dstq, [dstq+strideq*2]
    jmp .end


cglobal inv_txfm_add_dct_dct_8x32, 4, 6, 8, 16*36, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly
    call  m(idct_8x32_internal)
    RET

.dconly:
    movd                 m1, [o(pw_2896x8)]
    pmulhrsw             m0, m1, [coeffq]
    movd                 m2, [o(pw_8192)]
    mov            [coeffq], eobd
    pmulhrsw             m0, m2
    psrlw                m2, 2            ;pw_2048
    pmulhrsw             m0, m1
    pmulhrsw             m0, m2
    pshuflw              m0, m0, q0000
    punpcklwd            m0, m0
    mov                 r3d, 8
    lea                tx2q, [o(m(inv_txfm_add_dct_dct_8x32).end)]
    jmp m(inv_txfm_add_dct_dct_8x8).loop

.end:
    RET



cglobal idct_8x32_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp
    cmp                   eobd, 106
    jle .fast

    LOAD_8ROWS     coeffq+16*3, 64
    call  m(idct_8x8_internal).main
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_8x32_internal).pass1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1:
    mova   [rsp+gprsize+16*9 ], m0                        ;in24
    mova   [rsp+gprsize+16*10], m4                        ;in28
    mova   [rsp+gprsize+16*17], m2                        ;in26
    mova   [rsp+gprsize+16*18], m6                        ;in30
    mova   [rsp+gprsize+16*31], m1                        ;in25
    mova   [rsp+gprsize+16*30], m3                        ;in27
    mova   [rsp+gprsize+16*27], m5                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31
    LOAD_8ROWS     coeffq+16*2, 64
    call  m(idct_8x8_internal).main
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_8x32_internal).pass1_1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_1:
    mova   [rsp+gprsize+16*7 ], m0                        ;in16
    mova   [rsp+gprsize+16*8 ], m4                        ;in20
    mova   [rsp+gprsize+16*15], m2                        ;in18
    mova   [rsp+gprsize+16*16], m6                        ;in22
    mova   [rsp+gprsize+16*33], m1                        ;in17
    mova   [rsp+gprsize+16*28], m3                        ;in19
    mova   [rsp+gprsize+16*29], m5                        ;in21
    mova   [rsp+gprsize+16*32], m7                        ;in23

.fast:
    LOAD_8ROWS     coeffq+16*1, 64
    call  m(idct_8x8_internal).main
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_8x32_internal).pass1_end)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end:
    mova   [rsp+gprsize+16*5 ], m0                        ;in8
    mova   [rsp+gprsize+16*6 ], m4                        ;in12
    mova   [rsp+gprsize+16*13], m2                        ;in10
    mova   [rsp+gprsize+16*14], m6                        ;in14
    mova   [rsp+gprsize+16*21], m1                        ;in9
    mova   [rsp+gprsize+16*24], m3                        ;in11
    mova   [rsp+gprsize+16*25], m5                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15
    LOAD_8ROWS     coeffq+16*0, 64
    call  m(idct_8x8_internal).main
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_8x32_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end1:
    mova   [rsp+gprsize+16*11], m2                        ;in2
    mova   [rsp+gprsize+16*12], m6                        ;in6
    mova   [rsp+gprsize+16*19], m1                        ;in1
    mova   [rsp+gprsize+16*26], m3                        ;in3
    mova   [rsp+gprsize+16*23], m5                        ;in5
    mova   [rsp+gprsize+16*22], m7                        ;in7
    mova                    m1, m4                        ;in4
    mova                    m2, [rsp+gprsize+16*5 ]       ;in8
    mova                    m3, [rsp+gprsize+16*6 ]       ;in12

    cmp                   eobd, 106
    jg .full

    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS   rsp+gprsize+16*3 , 16
    mova                    m0, [rsp+gprsize+16*11]
    mova                    m1, [rsp+gprsize+16*12]
    mova                    m2, [rsp+gprsize+16*13]
    mova                    m3, [rsp+gprsize+16*14]
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call .main_fast
    jmp  .pass2

.full:
    mova                    m4, [rsp+gprsize+16*7 ]       ;in16
    mova                    m5, [rsp+gprsize+16*8 ]       ;in20
    mova                    m6, [rsp+gprsize+16*9 ]       ;in24
    mova                    m7, [rsp+gprsize+16*10]       ;in28
    call  m(idct_8x8_internal).main
    SAVE_7ROWS   rsp+gprsize+16*3 , 16
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16
    call .main

.pass2:
    lea                     r3, [o(m(idct_8x32_internal).end6)]

.end:
    mova   [rsp+gprsize+16*0 ], m7
    lea                   tx2q, [o(m(idct_8x32_internal).end2)]

.end1:
    pxor                    m7, m7
    REPX   {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  \
                                     8,  9,  10, 11, 12, 13, 14, 15, \
                                     16, 17, 18, 19, 20, 21, 22, 23, \
                                     24, 25, 26, 27, 28, 29, 30, 31

    jmp                   tx2q

.end2:
    lea                   tx2q, [o(m(idct_8x32_internal).end3)]
    jmp   m(idct_8x8_internal).end

.end3:
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova   [rsp+gprsize+16*0 ], m7
    lea                   dstq, [dstq+strideq*2]
    lea                   tx2q, [o(m(idct_8x32_internal).end4)]
    jmp   m(idct_8x8_internal).end

.end4:
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova   [rsp+gprsize+16*0 ], m7
    lea                   dstq, [dstq+strideq*2]
    lea                   tx2q, [o(m(idct_8x32_internal).end5)]
    jmp   m(idct_8x8_internal).end

.end5:
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova   [rsp+gprsize+16*0 ], m7
    lea                   dstq, [dstq+strideq*2]
    mov                   tx2q, r3
    jmp   m(idct_8x8_internal).end

.end6:
    ret

ALIGN function_align
.main_veryfast:
    mova                    m0, [rsp+gprsize*2+16*19]     ;in1
    pmulhrsw                m3, m0, [o(pw_4091x8)]        ;t30,t31
    pmulhrsw                m0, [o(pw_201x8)]             ;t16,t17
    mova                    m7, [o(pd_2048)]
    mova [rsp+gprsize*2+16*19], m0                        ;t16
    mova [rsp+gprsize*2+16*34], m3                        ;t31
    ITX_MULSUB_2W            3, 0, 1, 2, 7,  799, 4017    ;t17a, t30a
    mova [rsp+gprsize*2+16*20], m3                        ;t17a
    mova [rsp+gprsize*2+16*33], m0                        ;t30a
    mova                    m1, [rsp+gprsize*2+16*22]     ;in7
    pmulhrsw                m2, m1, [o(pw_3857x8)]        ;t28,t29
    pmulhrsw                m1, [o(pw_m1380x8)]           ;t18,t19
    mova [rsp+gprsize*2+16*22], m1                        ;t19
    mova [rsp+gprsize*2+16*31], m2                        ;t28
    pxor                    m0, m0
    psubw                   m0, m1
    ITX_MULSUB_2W            0, 2, 1, 3, 7,  799, 4017    ;t18a, t29a
    mova [rsp+gprsize*2+16*21], m0                        ;t18a
    mova [rsp+gprsize*2+16*32], m2                        ;t29a
    mova                    m0, [rsp+gprsize*2+16*23]     ;in5
    pmulhrsw                m3, m0, [o(pw_3973x8)]        ;t26, t27
    pmulhrsw                m0, [o(pw_995x8)]             ;t20, t21
    mova [rsp+gprsize*2+16*23], m0                        ;t20
    mova [rsp+gprsize*2+16*30], m3                        ;t27
    ITX_MULSUB_2W            3, 0, 1, 2, 7, 3406, 2276    ;t21a, t26a
    mova [rsp+gprsize*2+16*24], m3                        ;t21a
    mova [rsp+gprsize*2+16*29], m0                        ;t26a
    mova                    m2, [rsp+gprsize*2+16*26]     ;in3
    pxor                    m0, m0
    mova                    m3, m0
    pmulhrsw                m1, m2, [o(pw_4052x8)]
    pmulhrsw                m2, [o(pw_m601x8)]
    jmp .main2

ALIGN function_align
.main_fast: ;bottom half is zero
    mova                    m0, [rsp+gprsize*2+16*19]     ;in1
    mova                    m1, [rsp+gprsize*2+16*20]     ;in15
    pmulhrsw                m3, m0, [o(pw_4091x8)]        ;t31a
    pmulhrsw                m0, [o(pw_201x8)]             ;t16a
    pmulhrsw                m2, m1, [o(pw_3035x8)]        ;t30a
    pmulhrsw                m1, [o(pw_m2751x8)]           ;t17a
    mova                    m7, [o(pd_2048)]
    psubsw                  m4, m0, m1                    ;t17
    paddsw                  m0, m1                        ;t16
    psubsw                  m5, m3, m2                    ;t30
    paddsw                  m3, m2                        ;t31
    ITX_MULSUB_2W            5, 4, 1, 2, 7,  799, 4017    ;t17a, t30a
    mova [rsp+gprsize*2+16*19], m0                        ;t16
    mova [rsp+gprsize*2+16*20], m5                        ;t17a
    mova [rsp+gprsize*2+16*33], m4                        ;t30a
    mova [rsp+gprsize*2+16*34], m3                        ;t31
    mova                    m0, [rsp+gprsize*2+16*21]     ;in9
    mova                    m1, [rsp+gprsize*2+16*22]     ;in7
    pmulhrsw                m3, m0, [o(pw_3703x8)]
    pmulhrsw                m0, [o(pw_1751x8)]
    pmulhrsw                m2, m1, [o(pw_3857x8)]
    pmulhrsw                m1, [o(pw_m1380x8)]
    psubsw                  m4, m1, m0                    ;t18
    paddsw                  m0, m1                        ;t19
    psubsw                  m5, m2, m3                    ;t29
    paddsw                  m3, m2                        ;t28
    pxor                    m2, m2
    psubw                   m2, m4
    ITX_MULSUB_2W            2, 5, 1, 4, 7,  799, 4017    ;t18a, t29a
    mova [rsp+gprsize*2+16*21], m2                        ;t18a
    mova [rsp+gprsize*2+16*22], m0                        ;t19
    mova [rsp+gprsize*2+16*31], m3                        ;t28
    mova [rsp+gprsize*2+16*32], m5                        ;t29a
    mova                    m0, [rsp+gprsize*2+16*23]     ;in5
    mova                    m1, [rsp+gprsize*2+16*24]     ;in11
    pmulhrsw                m3, m0, [o(pw_3973x8)]
    pmulhrsw                m0, [o(pw_995x8)]
    pmulhrsw                m2, m1, [o(pw_3513x8)]
    pmulhrsw                m1, [o(pw_m2106x8)]
    psubsw                  m4, m0, m1                    ;t21
    paddsw                  m0, m1                        ;t20
    psubsw                  m5, m3, m2                    ;t26
    paddsw                  m3, m2                        ;t27
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 3406, 2276    ;t21a, t26a
    mova [rsp+gprsize*2+16*23], m0                        ;t20
    mova [rsp+gprsize*2+16*24], m5                        ;t21a
    mova [rsp+gprsize*2+16*29], m4                        ;t26a
    mova [rsp+gprsize*2+16*30], m3                        ;t27
    mova                    m0, [rsp+gprsize*2+16*25]     ;in13
    mova                    m2, [rsp+gprsize*2+16*26]     ;in3
    pmulhrsw                m3, m0, [o(pw_3290x8)]
    pmulhrsw                m0, [o(pw_2440x8)]
    pmulhrsw                m1, m2, [o(pw_4052x8)]
    pmulhrsw                m2, [o(pw_m601x8)]
    jmp .main2

ALIGN function_align
.main:
    mova                    m7, [o(pd_2048)]
    mova                    m0, [rsp+gprsize*2+16*19]     ;in1
    mova                    m1, [rsp+gprsize*2+16*20]     ;in15
    mova                    m2, [rsp+gprsize*2+16*33]     ;in17
    mova                    m3, [rsp+gprsize*2+16*34]     ;in31
    ITX_MULSUB_2W            0, 3, 4, 5, 7,  201, 4091    ;t16a, t31a
    ITX_MULSUB_2W            2, 1, 4, 5, 7, 3035, 2751    ;t17a, t30a
    psubsw                  m4, m0, m2                    ;t17
    paddsw                  m0, m2                        ;t16
    psubsw                  m5, m3, m1                    ;t30
    paddsw                  m3, m1                        ;t31
    ITX_MULSUB_2W            5, 4, 1, 2, 7,  799, 4017    ;t17a, t30a
    mova [rsp+gprsize*2+16*19], m0                        ;t16
    mova [rsp+gprsize*2+16*20], m5                        ;t17a
    mova [rsp+gprsize*2+16*33], m4                        ;t30a
    mova [rsp+gprsize*2+16*34], m3                        ;t31
    mova                    m0, [rsp+gprsize*2+16*21]     ;in9
    mova                    m1, [rsp+gprsize*2+16*22]     ;in7
    mova                    m2, [rsp+gprsize*2+16*31]     ;in25
    mova                    m3, [rsp+gprsize*2+16*32]     ;in23
    ITX_MULSUB_2W            0, 3, 4, 5, 7, 1751, 3703    ;t18a, t29a
    ITX_MULSUB_2W            2, 1, 4, 5, 7, 3857, 1380    ;t19a, t28a
    psubsw                  m4, m2, m0                    ;t18
    paddsw                  m0, m2                        ;t19
    psubsw                  m5, m1, m3                    ;t29
    paddsw                  m3, m1                        ;t28
    pxor                    m2, m2
    psubw                   m2, m4                        ;-t18
    ITX_MULSUB_2W            2, 5, 1, 4, 7,  799, 4017    ;t18a, t29a
    mova [rsp+gprsize*2+16*21], m2                        ;t18a
    mova [rsp+gprsize*2+16*22], m0                        ;t19
    mova [rsp+gprsize*2+16*31], m3                        ;t28
    mova [rsp+gprsize*2+16*32], m5                        ;t29a
    mova                    m0, [rsp+gprsize*2+16*23]     ;in5
    mova                    m1, [rsp+gprsize*2+16*24]     ;in11
    mova                    m2, [rsp+gprsize*2+16*29]     ;in21
    mova                    m3, [rsp+gprsize*2+16*30]     ;in27
    ITX_MULSUB_2W            0, 3, 4, 5, 7,  995, 3973    ;t20a, t27a
    ITX_MULSUB_2W            2, 1, 4, 5, 7, 3513, 2106    ;t21a, t26a
    psubsw                  m4, m0, m2                    ;t21
    paddsw                  m0, m2                        ;t20
    psubsw                  m5, m3, m1                    ;t26
    paddsw                  m3, m1                        ;t27
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 3406, 2276    ;t21a, t26a
    mova [rsp+gprsize*2+16*23], m0                        ;t20
    mova [rsp+gprsize*2+16*24], m5                        ;t21a
    mova [rsp+gprsize*2+16*29], m4                        ;t26a
    mova [rsp+gprsize*2+16*30], m3                        ;t27
    mova                    m0, [rsp+gprsize*2+16*25]     ;in13
    mova                    m1, [rsp+gprsize*2+16*26]     ;in3
    mova                    m2, [rsp+gprsize*2+16*27]     ;in29
    mova                    m3, [rsp+gprsize*2+16*28]     ;in19
    ITX_MULSUB_2W            0, 3, 4, 5, 7, 2440, 3290    ;t22a, t25a
    ITX_MULSUB_2W            2, 1, 4, 5, 7, 4052,  601    ;t23a, t24a

.main2:
    psubsw                  m4, m2, m0                    ;t22
    paddsw                  m0, m2                        ;t23
    psubsw                  m5, m1, m3                    ;t25
    paddsw                  m3, m1                        ;t24
    pxor                    m6, m6
    psubw                   m2, m6, m4
    ITX_MULSUB_2W            2, 5, 1, 4, 7, 3406, 2276    ;t22a, t25a

    mova                    m4, [rsp+gprsize*2+16*24]     ;t21a
    psubsw                  m1, m2, m4                    ;t21
    paddsw                  m2, m4                        ;t22
    psubw                   m4, m6, m1                    ;-t21
    mova [rsp+gprsize*2+16*25], m2                        ;t22
    mova                    m1, [rsp+gprsize*2+16*29]     ;t26a
    psubsw                  m2, m5, m1                    ;t26
    paddsw                  m5, m1                        ;t25
    mova [rsp+gprsize*2+16*28], m5                        ;t25
    ITX_MULSUB_2W            4, 2, 1, 5, 7, 1567, 3784    ;t21a, t26a
    mova [rsp+gprsize*2+16*24], m4                        ;t21a
    mova [rsp+gprsize*2+16*29], m2                        ;t26a

    mova                    m1, [rsp+gprsize*2+16*23]     ;t20
    mova                    m5, [rsp+gprsize*2+16*30]     ;t27
    psubsw                  m2, m0, m1                    ;t20a
    paddsw                  m0, m1                        ;t23a
    psubsw                  m4, m3, m5                    ;t27a
    paddsw                  m3, m5                        ;t24a
    psubw                   m6, m2                        ;-t20a
    ITX_MULSUB_2W            6, 4, 1, 5, 7, 1567, 3784    ;t20, t27
    mova [rsp+gprsize*2+16*26], m0                        ;t23a
    mova [rsp+gprsize*2+16*27], m3                        ;t24a
    mova [rsp+gprsize*2+16*30], m4                        ;t27

    mova                    m0, [rsp+gprsize*2+16*20]     ;t17a
    mova                    m1, [rsp+gprsize*2+16*21]     ;t18a
    mova                    m2, [rsp+gprsize*2+16*32]     ;t29a
    mova                    m3, [rsp+gprsize*2+16*33]     ;t30a
    psubsw                  m4, m0, m1                    ;t18
    paddsw                  m0, m1                        ;t17
    psubsw                  m5, m3, m2                    ;t29
    paddsw                  m3, m2                        ;t30
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 1567, 3784    ;t18a, t29a
    mova [rsp+gprsize*2+16*20], m0                        ;t17
    mova [rsp+gprsize*2+16*21], m5                        ;t18a
    mova [rsp+gprsize*2+16*32], m4                        ;t29a
    mova [rsp+gprsize*2+16*33], m3                        ;t30
    mova                    m0, [rsp+gprsize*2+16*19]     ;t16
    mova                    m1, [rsp+gprsize*2+16*22]     ;t19
    mova                    m2, [rsp+gprsize*2+16*31]     ;t28
    mova                    m3, [rsp+gprsize*2+16*34]     ;t31
    psubsw                  m4, m0, m1                    ;t19a
    paddsw                  m0, m1                        ;t16a
    psubsw                  m5, m3, m2                    ;t28a
    paddsw                  m3, m2                        ;t31a
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 1567, 3784    ;t19, t28

    mova                    m2, [rsp+gprsize*2+16*15]     ;tmp12
    psubsw                  m1, m5, m6                    ;t20a
    paddsw                  m5, m6                        ;t19a
    psubsw                  m6, m2, m5                    ;out19
    paddsw                  m2, m5                        ;out12
    mova [rsp+gprsize*2+16*22], m6                        ;out19
    mova [rsp+gprsize*2+16*15], m2                        ;out12
    mova                    m5, [rsp+gprsize*2+16*30]     ;t27
    psubsw                  m6, m4, m5                    ;t27a
    paddsw                  m4, m5                        ;t28a
    mova                    m2, [rsp+gprsize*2+16*6 ]     ;tmp3
    mova                    m7, [o(pw_2896x8)]
    psubw                   m5, m6, m1                    ;t27a - t20a
    paddw                   m6, m1                        ;t27a + t20a
    psubsw                  m1, m2, m4                    ;out28
    paddsw                  m2, m4                        ;out3
    pmulhrsw                m5, m7                        ;t20
    pmulhrsw                m6, m7                        ;t27
    mova                    m4, [rsp+gprsize*2+16*14]     ;tmp11
    mova [rsp+gprsize*2+16*31], m1                        ;out28
    mova [rsp+gprsize*2+16*6 ], m2                        ;out3
    psubsw                  m1, m4, m5                    ;out20
    paddsw                  m4, m5                        ;out11
    mova                    m2, [rsp+gprsize*2+16*7 ]     ;tmp4
    mova [rsp+gprsize*2+16*23], m1                        ;out20
    mova [rsp+gprsize*2+16*14], m4                        ;out11
    psubsw                  m5, m2, m6                    ;out27
    paddsw                  m2, m6                        ;out4
    mova                    m1, [rsp+gprsize*2+16*26]     ;t23a
    mova                    m4, [rsp+gprsize*2+16*27]     ;t24a
    mova [rsp+gprsize*2+16*30], m5                        ;out27
    mova [rsp+gprsize*2+16*7 ], m2                        ;out4
    psubsw                  m5, m0, m1                    ;t23
    paddsw                  m0, m1                        ;t16
    psubsw                  m2, m3, m4                    ;t24
    paddsw                  m3, m4                        ;t31
    mova                    m6, [rsp+gprsize*2+16*18]     ;tmp15
    psubw                   m1, m2, m5                    ;t24  - t23
    paddw                   m2, m5                        ;t24  + t23
    psubsw                  m4, m6, m0                    ;out16
    paddsw                  m6, m0                        ;out15
    pmulhrsw                m1, m7                        ;t23a
    pmulhrsw                m2, m7                        ;t24a
    mova                    m0, [rsp+gprsize*2+16*3 ]     ;tmp0
    mova                    m5, [rsp+gprsize*2+16*11]     ;tmp8
    mova [rsp+gprsize*2+16*18], m6                        ;out15
    mova [rsp+gprsize*2+16*19], m4                        ;out16
    psubsw                  m6, m0, m3                    ;out31
    paddsw                  m0, m3                        ;out0
    psubsw                  m4, m5, m1                    ;out23
    paddsw                  m5, m1                        ;out8
    mova                    m3, [rsp+gprsize*2+16*10]     ;tmp7
    mova [rsp+gprsize*2+16*34], m6                        ;out31
    mova [rsp+gprsize*2+16*11], m5                        ;out8
    mova [rsp+gprsize*2+16*26], m4                        ;out23
    paddsw                  m6, m3, m2                    ;out7
    psubsw                  m3, m2                        ;out24
    mova                    m1, [rsp+gprsize*2+16*20]     ;t17
    mova                    m5, [rsp+gprsize*2+16*25]     ;t22
    mova                    m2, [rsp+gprsize*2+16*17]     ;tmp14
    mova [rsp+gprsize*2+16*27], m3                        ;out24
    psubsw                  m4, m1, m5                    ;t22a
    paddsw                  m1, m5                        ;t17a
    psubsw                  m3, m2, m1                    ;out17
    paddsw                  m2, m1                        ;out14
    mova                    m5, [rsp+gprsize*2+16*28]     ;t25
    mova                    m1, [rsp+gprsize*2+16*33]     ;t30
    mova [rsp+gprsize*2+16*17], m2                        ;out14
    mova [rsp+gprsize*2+16*20], m3                        ;out17
    psubsw                  m2, m1, m5                    ;t25a
    paddsw                  m1, m5                        ;t30a
    psubw                   m3, m2, m4                    ;t25a - t22a
    paddw                   m2, m4                        ;t25a + t22a
    mova                    m5, [rsp+gprsize*2+16*4 ]     ;tmp1
    pmulhrsw                m3, m7                        ;t22
    pmulhrsw                m2, m7                        ;t25
    psubsw                  m4, m5, m1                    ;out30
    paddsw                  m5, m1                        ;out1
    mova                    m1, [rsp+gprsize*2+16*12]     ;tmp9
    mova [rsp+gprsize*2+16*33], m4                        ;out30
    mova [rsp+gprsize*2+16*4 ], m5                        ;out1
    psubsw                  m4, m1, m3                    ;out22
    paddsw                  m1, m3                        ;out9
    mova                    m5, [rsp+gprsize*2+16*9 ]     ;tmp6
    mova [rsp+gprsize*2+16*25], m4                        ;out22
    mova [rsp+gprsize*2+16*12], m1                        ;out9
    psubsw                  m3, m5, m2                    ;out25
    paddsw                  m5, m2                        ;out6
    mova                    m4, [rsp+gprsize*2+16*21]     ;t18a
    mova                    m1, [rsp+gprsize*2+16*24]     ;t21a
    mova                    m2, [rsp+gprsize*2+16*16]     ;tmp13
    mova [rsp+gprsize*2+16*28], m3                        ;out25
    mova [rsp+gprsize*2+16*9 ], m5                        ;out6
    paddsw                  m3, m4, m1                    ;t18
    psubsw                  m4, m1                        ;t21
    psubsw                  m5, m2, m3                    ;out18
    paddsw                  m2, m3                        ;out13
    mova                    m1, [rsp+gprsize*2+16*29]     ;t26a
    mova                    m3, [rsp+gprsize*2+16*32]     ;t29a
    mova [rsp+gprsize*2+16*21], m5                        ;out18
    mova [rsp+gprsize*2+16*16], m2                        ;out13
    psubsw                  m5, m3, m1                    ;t26
    paddsw                  m3, m1                        ;t29
    mova                    m2, [rsp+gprsize*2+16*5 ]     ;tmp2
    psubw                   m1, m5, m4                    ;t26 - t21
    paddw                   m4, m5                        ;t26 + t21
    psubsw                  m5, m2, m3                    ;out29
    paddsw                  m2, m3                        ;out2
    pmulhrsw                m1, m7                        ;t21a
    pmulhrsw                m4, m7                        ;t26a
    mova                    m3, [rsp+gprsize*2+16*13]     ;tmp10
    mova [rsp+gprsize*2+16*32], m5                        ;out29
    psubsw                  m7, m3, m1                    ;out21
    paddsw                  m3, m1                        ;out10
    mova                    m5, [rsp+gprsize*2+16*8 ]     ;tmp5
    mova [rsp+gprsize*2+16*24], m7                        ;out21
    mova [rsp+gprsize*2+16*13], m3                        ;out10
    psubsw                  m1, m5, m4                    ;out26
    paddsw                  m5, m4                        ;out5
    mova                    m7, m6                        ;out7
    mova                    m3, [rsp+gprsize*2+16*6 ]     ;out3
    mova                    m4, [rsp+gprsize*2+16*7 ]     ;out4
    mova [rsp+gprsize*2+16*29], m1                        ;out26
    mova                    m6, [rsp+gprsize*2+16*9 ]     ;out6
    mova                    m1, [rsp+gprsize*2+16*4 ]     ;out1
    ret


cglobal inv_txfm_add_dct_dct_32x8, 4, 6, 8, 16*36, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly
    call  m(idct_32x8_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_8192)]
    mov               [coeffq], eobd
    mov                    r3d, 8
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_32x8).end)]

.body:
    pmulhrsw                m0, m2
    movd                    m2, [o(pw_2048)]  ;intentionally rip-relative
    pmulhrsw                m0, m1
    pmulhrsw                m0, m2
    pshuflw                 m0, m0, q0000
    punpcklwd               m0, m0
    pxor                    m5, m5

.loop:
    mova                    m1, [dstq+16*0]
    mova                    m3, [dstq+16*1]
    punpckhbw               m2, m1, m5
    punpcklbw               m1, m5
    punpckhbw               m4, m3, m5
    punpcklbw               m3, m5
    paddw                   m2, m0
    paddw                   m1, m0
    paddw                   m4, m0
    paddw                   m3, m0
    packuswb                m1, m2
    packuswb                m3, m4
    mova           [dstq+16*0], m1
    mova           [dstq+16*1], m3
    add                   dstq, strideq
    dec                    r3d
    jg .loop
    jmp                tx2q

.end:
    RET


cglobal idct_32x8_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp
    LOAD_8ROWS     coeffq+16*0, 64
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    LOAD_8ROWS     coeffq+16*2, 64
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS     coeffq+16*1, 32
    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7
    mova   [rsp+gprsize+16*21], m4                        ;in9
    mova   [rsp+gprsize+16*24], m5                        ;in11
    mova   [rsp+gprsize+16*25], m6                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15

    cmp                   eobd, 106
    jg  .full
    call m(idct_8x32_internal).main_fast
    jmp .pass2

.full:
    LOAD_8ROWS    coeffq+16*17, 32
    mova   [rsp+gprsize+16*33], m0                        ;in17
    mova   [rsp+gprsize+16*28], m1                        ;in19
    mova   [rsp+gprsize+16*29], m2                        ;in21
    mova   [rsp+gprsize+16*32], m3                        ;in23
    mova   [rsp+gprsize+16*31], m4                        ;in25
    mova   [rsp+gprsize+16*30], m5                        ;in27
    mova   [rsp+gprsize+16*27], m6                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31
    call m(idct_8x32_internal).main

.pass2:
    mova   [rsp+gprsize+16*0 ], m7
    lea                   tx2q, [o(m(idct_32x8_internal).end)]
    jmp  m(idct_8x32_internal).end1

.end:
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x8_internal).end1)]
    jmp   m(idct_8x8_internal).pass1_end1

.end1:
    lea                     r3, [dstq+8]
    lea                   tx2q, [o(m(idct_32x8_internal).end2)]
    jmp   m(idct_8x8_internal).pass2_main

.end2:
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova   [rsp+gprsize+16*0 ], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x8_internal).end3)]
    jmp   m(idct_8x8_internal).pass1_end1

.end3:
    mov                   dstq, r3
    lea                     r3, [r3+8]
    lea                   tx2q, [o(m(idct_32x8_internal).end4)]
    jmp   m(idct_8x8_internal).pass2_main

.end4:
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova   [rsp+gprsize+16*0 ], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x8_internal).end5)]
    jmp   m(idct_8x8_internal).pass1_end1

.end5:
    mov                   dstq, r3
    lea                     r3, [r3+8]
    lea                   tx2q, [o(m(idct_32x8_internal).end6)]
    jmp   m(idct_8x8_internal).pass2_main

.end6:
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova   [rsp+gprsize+16*0 ], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x8_internal).end7)]
    jmp   m(idct_8x8_internal).pass1_end1

.end7:
    mov                   dstq, r3
    lea                   tx2q, [o(m(idct_32x8_internal).end8)]
    jmp   m(idct_8x8_internal).pass2_main

.end8:
    ret


cglobal inv_txfm_add_identity_identity_8x32, 4, 6, 8, 16*4, dst, stride, coeff, eob, tx2
    mov                    r5d, 4
    mov                   tx2d, 2
    cmp                   eobd, 106
    cmovg                 tx2d, r5d
    mov                    r3d, tx2d
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    lea                   tx2q, [o(m(idct_32x8_internal).end8)]

.loop:
    LOAD_8ROWS     coeffq+16*0, 64
    paddw                   m6, [o(pw_5)]
    mova            [rsp+16*1], m6
    mova                    m6, [o(pw_5)]
    REPX         {paddw x, m6}, m0, m1, m2, m3, m4, m5, m7

    call  m(idct_8x8_internal).pass1_end3
    REPX         {psraw x, 3 }, m0, m1, m2, m3, m4, m5, m6, m7

    mova            [rsp+16*2], m5
    mova            [rsp+16*1], m6
    mova            [rsp+16*0], m7
    call  m(idct_8x8_internal).end3
    lea                   dstq, [dstq+strideq*2]

    pxor                    m7, m7
    REPX   {mova [coeffq+64*x], m7}, 0, 1, 2, 3, 4, 5, 6, 7

    add                 coeffq, 16
    dec                    r3d
    jg .loop
    RET

cglobal inv_txfm_add_identity_identity_32x8, 4, 6, 8, 16*4, dst, stride, coeff, eob, tx2
    mov                    r5d, 4
    mov                   tx2d, 2
    cmp                   eobd, 106
    cmovg                 tx2d, r5d
    mov                    r3d, tx2d
%if ARCH_X86_32
    LEA                     r5, $$
%endif

.loop:
    LOAD_8ROWS     coeffq+16*0, 16
    pmulhrsw                m6, [o(pw_4096)]
    mova            [rsp+16*1], m6
    mova                    m6, [o(pw_4096)]
    REPX      {pmulhrsw x, m6}, m0, m1, m2, m3, m4, m5, m7
    lea                   tx2q, [o(m(idct_32x8_internal).end8)]
    call  m(idct_8x8_internal).pass1_end3

    mov             [rsp+16*3], dstq
    mova            [rsp+16*2], m5
    mova            [rsp+16*1], m6
    mova            [rsp+16*0], m7
    lea                   tx2q, [o(m(idct_8x8_internal).end4)]
    call  m(idct_8x8_internal).end3

    add                 coeffq, 16*8
    mov                   dstq, [rsp+16*3]
    lea                   dstq, [dstq+8]
    dec                    r3d
    jg .loop
    jnc .loop
    RET


cglobal inv_txfm_add_dct_dct_16x32, 4, 6, 8, 16*36, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly
    call  m(idct_16x32_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_16384)]
    mov               [coeffq], eobd
    pmulhrsw                m0, m1
    mov                    r2d, 16
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_16x32).end)]
    jmp m(inv_txfm_add_dct_dct_16x4).dconly

.end:
    RET

cglobal idct_16x32_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    LOAD_8ROWS     coeffq+16*1, 128, 1
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+16*5, 128, 1
    call m(idct_16x8_internal).main
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end:
    SAVE_8ROWS    coeffq+16*33, 64               ;in8~in15
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end1:
    mova        [coeffq+16*1 ], m0                        ;in8
    mova        [coeffq+16*5 ], m4                        ;in12
    mova   [rsp+gprsize+16*13], m2                        ;in10
    mova   [rsp+gprsize+16*14], m6                        ;in14
    mova   [rsp+gprsize+16*21], m1                        ;in9
    mova   [rsp+gprsize+16*24], m3                        ;in11
    mova   [rsp+gprsize+16*25], m5                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15
    LOAD_8ROWS     coeffq+16*0, 128, 1
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+16*4, 128, 1
    call m(idct_16x8_internal).main
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end2:
    SAVE_8ROWS    coeffq+16*32, 64               ;in0~in7
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end3:
    mova   [rsp+gprsize+16*11], m2                        ;in2
    mova   [rsp+gprsize+16*12], m6                        ;in6
    mova   [rsp+gprsize+16*19], m1                        ;in1
    mova   [rsp+gprsize+16*26], m3                        ;in3
    mova   [rsp+gprsize+16*23], m5                        ;in5
    mova   [rsp+gprsize+16*22], m7                        ;in7

    cmp                eobd, 150
    jg .full

    mova                    m1, m4                        ;in4
    mova                    m2, [coeffq+16*1 ]            ;in8
    mova                    m3, [coeffq+16*5 ]            ;in12
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    mova                    m0, [rsp+gprsize+16*11]       ;in2
    mova                    m1, [rsp+gprsize+16*12]       ;in6
    mova                    m2, [rsp+gprsize+16*13]       ;in10
    mova                    m3, [rsp+gprsize+16*14]       ;in14
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call m(idct_8x32_internal).main_fast
    jmp  .pass2

.full:
    mova        [coeffq+16*0 ], m0                        ;in0
    mova        [coeffq+16*4 ], m4                        ;in4

    LOAD_8ROWS     coeffq+16*2, 128, 1
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+16*6, 128, 1
    call m(idct_16x8_internal).main
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end4:
    SAVE_8ROWS    coeffq+16*34, 64               ;in16~in23
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end5)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end5:
    mova        [coeffq+16*2 ], m0                        ;in16
    mova        [coeffq+16*6 ], m4                        ;in20
    mova   [rsp+gprsize+16*15], m2                        ;in18
    mova   [rsp+gprsize+16*16], m6                        ;in22
    mova   [rsp+gprsize+16*33], m1                        ;in17
    mova   [rsp+gprsize+16*28], m3                        ;in19
    mova   [rsp+gprsize+16*29], m5                        ;in21
    mova   [rsp+gprsize+16*32], m7                        ;in23

    LOAD_8ROWS     coeffq+16*3, 128, 1
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+16*7, 128, 1
    call m(idct_16x8_internal).main
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end6)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end6:
    SAVE_8ROWS    coeffq+16*35, 64                        ;in24~in31
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_16x32_internal).pass1_end7)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end7:
    mova   [rsp+gprsize+16*17], m2                        ;in26
    mova   [rsp+gprsize+16*18], m6                        ;in30
    mova   [rsp+gprsize+16*31], m1                        ;in25
    mova   [rsp+gprsize+16*30], m3                        ;in27
    mova   [rsp+gprsize+16*27], m5                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31

    mova                    m6, m0                        ;in24
    mova                    m7, m4                        ;in28
    mova                    m0, [coeffq+16*0 ]            ;in0
    mova                    m1, [coeffq+16*4 ]            ;in4
    mova                    m2, [coeffq+16*1 ]            ;in8
    mova                    m3, [coeffq+16*5 ]            ;in12
    mova                    m4, [coeffq+16*2 ]            ;in16
    mova                    m5, [coeffq+16*6 ]            ;in20
    call  m(idct_8x8_internal).main
    SAVE_7ROWS   rsp+gprsize+16*3 , 16
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call m(idct_8x32_internal).main

.pass2:
    mov  [rsp+gprsize*1+16*35], eobd
    lea                     r3, [dstq+8]
    mov  [rsp+gprsize*2+16*35], r3
    lea                     r3, [o(m(idct_16x32_internal).end)]
    jmp  m(idct_8x32_internal).end

.end:
    mov                   dstq, [rsp+gprsize*2+16*35]
    mov                   eobd, [rsp+gprsize*1+16*35]
    add                 coeffq, 16*32

    mova                    m0, [coeffq+16*4 ]            ;in1
    mova                    m1, [coeffq+16*12]            ;in3
    mova                    m2, [coeffq+16*20]            ;in5
    mova                    m3, [coeffq+16*28]            ;in7
    mova                    m4, [coeffq+16*5 ]            ;in9
    mova                    m5, [coeffq+16*13]            ;in11
    mova                    m6, [coeffq+16*21]            ;in13
    mova                    m7, [coeffq+16*29]            ;in15

    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7
    mova   [rsp+gprsize+16*21], m4                        ;in9
    mova   [rsp+gprsize+16*24], m5                        ;in11
    mova   [rsp+gprsize+16*25], m6                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15

    mova                    m0, [coeffq+16*0 ]            ;in0
    mova                    m1, [coeffq+16*16]            ;in4
    mova                    m2, [coeffq+16*1 ]            ;in8
    mova                    m3, [coeffq+16*17]            ;in12

    cmp                   eobd, 150
    jg .full1

    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    mova                    m0, [coeffq+16*8 ]            ;in2
    mova                    m1, [coeffq+16*24]            ;in6
    mova                    m2, [coeffq+16*9 ]            ;in10
    mova                    m3, [coeffq+16*25]            ;in14
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call m(idct_8x32_internal).main_fast
    jmp  .end1

.full1:
    mova                    m4, [coeffq+16*2 ]            ;in16
    mova                    m5, [coeffq+16*18]            ;in20
    mova                    m6, [coeffq+16*3 ]            ;in24
    mova                    m7, [coeffq+16*19]            ;in26
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    mova                    m0, [coeffq+16*8 ]            ;in2
    mova                    m1, [coeffq+16*24]            ;in6
    mova                    m2, [coeffq+16*9 ]            ;in10
    mova                    m3, [coeffq+16*25]            ;in14
    mova                    m4, [coeffq+16*10]            ;in18
    mova                    m5, [coeffq+16*26]            ;in22
    mova                    m6, [coeffq+16*11]            ;in26
    mova                    m7, [coeffq+16*27]            ;in30
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    mova                    m0, [coeffq+16*6 ]            ;in17
    mova                    m1, [coeffq+16*14]            ;in19
    mova                    m2, [coeffq+16*22]            ;in21
    mova                    m3, [coeffq+16*30]            ;in23
    mova                    m4, [coeffq+16*7 ]            ;in25
    mova                    m5, [coeffq+16*15]            ;in27
    mova                    m6, [coeffq+16*23]            ;in29
    mova                    m7, [coeffq+16*31]            ;in31

    mova   [rsp+gprsize+16*33], m0                        ;in17
    mova   [rsp+gprsize+16*28], m1                        ;in19
    mova   [rsp+gprsize+16*29], m2                        ;in21
    mova   [rsp+gprsize+16*32], m3                        ;in23
    mova   [rsp+gprsize+16*31], m4                        ;in25
    mova   [rsp+gprsize+16*30], m5                        ;in27
    mova   [rsp+gprsize+16*27], m6                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31

    call m(idct_8x32_internal).main

.end1:
    jmp m(idct_8x32_internal).pass2



cglobal inv_txfm_add_dct_dct_32x16, 4, 6, 8, 16*36, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_32x16_internal)
    call m(idct_8x16_internal).pass2

    add                 coeffq, 16*16
    lea                   dstq, [r3+8]
    LOAD_8ROWS       rsp+16*11, 16
    mova            [rsp+16*0], m7
    lea                   tx2q, [o(m(idct_32x16_internal).end)]
    call  m(idct_8x8_internal).pass1_end
    call m(idct_8x16_internal).pass2

    add                 coeffq, 16*16
    lea                   dstq, [r3+8]
    LOAD_8ROWS       rsp+16*19, 16
    mova            [rsp+16*0], m7
    lea                   tx2q, [o(m(idct_32x16_internal).end)]
    call  m(idct_8x8_internal).pass1_end
    call m(idct_8x16_internal).pass2

    add                 coeffq, 16*16
    lea                   dstq, [r3+8]
    LOAD_8ROWS       rsp+16*27, 16
    mova            [rsp+16*0], m7
    lea                   tx2q, [o(m(idct_32x16_internal).end)]
    call  m(idct_8x8_internal).pass1_end
    call m(idct_8x16_internal).pass2
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_16384)]
    mov               [coeffq], eobd
    pmulhrsw                m0, m1
    mov                    r3d, 16
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_32x8).end)]
    jmp m(inv_txfm_add_dct_dct_32x8).body


cglobal idct_32x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    add                 coeffq, 16
    lea                     r3, [o(m(idct_32x16_internal).pass1_end1)]
.pass1:
    LOAD_8ROWS     coeffq+16*0, 128, 1
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    LOAD_8ROWS     coeffq+16*4, 128, 1
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS     coeffq+16*2, 64, 1
    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7
    mova   [rsp+gprsize+16*21], m4                        ;in9
    mova   [rsp+gprsize+16*24], m5                        ;in11
    mova   [rsp+gprsize+16*25], m6                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15

    LOAD_8ROWS    coeffq+16*34, 64, 1
    mova   [rsp+gprsize+16*33], m0                        ;in17
    mova   [rsp+gprsize+16*28], m1                        ;in19
    mova   [rsp+gprsize+16*29], m2                        ;in21
    mova   [rsp+gprsize+16*32], m3                        ;in23
    mova   [rsp+gprsize+16*31], m4                        ;in25
    mova   [rsp+gprsize+16*30], m5                        ;in27
    mova   [rsp+gprsize+16*27], m6                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31
    call m(idct_8x32_internal).main

.pass1_end:
    mova   [rsp+gprsize+16*0 ], m7
    mov                   tx2q, r3
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end1:
    SAVE_8ROWS     coeffq+16*0, 32
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova   [rsp+gprsize+16*0 ], m7
    lea                   tx2q, [o(m(idct_32x16_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end2:
    SAVE_8ROWS    coeffq+16*16, 32
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova   [rsp+gprsize+16*0 ], m7
    lea                   tx2q, [o(m(idct_32x16_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end3:
    SAVE_8ROWS    coeffq+16*32, 32
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova   [rsp+gprsize+16*0 ], m7
    lea                   tx2q, [o(m(idct_32x16_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end4:
    SAVE_8ROWS    coeffq+16*48, 32

    sub                 coeffq, 16
    lea                     r3, [o(m(idct_32x16_internal).end)]
    jmp .pass1

.end:
    ret


cglobal inv_txfm_add_identity_identity_16x32, 4, 6, 8, 16*4, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r4, 1
    mov                     r5, 2
    cmp                   eobd, 43                ;if (eob > 43)
    cmovg                   r4, r5                ;  iteration_count++
    inc                     r5
    cmp                   eobd, 150               ;if (eob > 150)
    cmovg                   r4, r5                ;  iteration_count++
    inc                     r5
    cmp                   eobd, 278               ;if (eob > 278)
    cmovg                   r4, r5                ;  iteration_count++

%if ARCH_X86_32
    LEA                     r5, $$
%endif
    lea                     r3, [dstq+8]
    mov             [rsp+16*3], r3
    mov                     r3, r4
    mov     [rsp+gprsize+16*3], r4
    mov   [rsp+gprsize*2+16*3], coeffq

.loop:
    LOAD_8ROWS          coeffq, 64, 1
    REPX      {psllw    x, 2 }, m0, m1, m2, m3, m4, m5, m6, m7
    mova            [rsp+16*1], m6
    lea                   tx2q, [o(m(idct_32x16_internal).end)]
    call  m(idct_8x8_internal).pass1_end3
    pmulhrsw                m7, [o(pw_5793x4)]
    paddw                   m7, [o(pw_5)]
    psraw                   m7, 3
    mova            [rsp+16*0], m7
    mova                    m7, [o(pw_5793x4)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova                    m7, [o(pw_5)]
    REPX      {paddw    x, m7}, m0, m1, m2, m3, m4, m5, m6
    REPX      {psraw    x, 3 }, m0, m1, m2, m3, m4, m5, m6
    mova            [rsp+16*2], m5
    mova            [rsp+16*1], m6
    call  m(idct_8x8_internal).end3
    lea                   dstq, [dstq+strideq*2]

    pxor                    m7, m7
    REPX   {mova [coeffq+64*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7

    add                 coeffq, 16
    dec                     r3
    jg .loop

    mov                 coeffq, [rsp+gprsize*2+16*3]
    add                 coeffq, 64*8
    mov                     r3, [rsp+gprsize+16*3]
    xor                   dstq, dstq
    mov     [rsp+gprsize+16*3], dstq
    mov                   dstq, [rsp+16*3]
    test                    r3, r3
    jnz .loop

    RET


cglobal inv_txfm_add_identity_identity_32x16, 4, 6, 8, 16*4, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r4, 12                ;0100b
    mov                     r5, 136               ;1000 1000b
    cmp                   eobd, 43                ;if (eob > 43)
    cmovg                   r4, r5                ;  iteration_count+2
    mov                     r5, 34952             ;1000 1000 1000 1000b
    cmp                   eobd, 150               ;if (eob > 150)
    cmovg                   r4, r5                ;  iteration_count += 4

%if ARCH_X86_32
    LEA                     r5, $$
%endif
    lea                     r3, [dstq+8]
    mov             [rsp+16*3], r3
    mov                     r3, r4

.loop:
    LOAD_8ROWS          coeffq, 32, 1
    REPX         {psllw  x, 3}, m0, m1, m2, m3, m4, m5, m6, m7
    mova            [rsp+16*1], m6
    lea                   tx2q, [o(m(idct_32x16_internal).end)]
    call  m(idct_8x8_internal).pass1_end3
    pmulhrsw                m7, [o(pw_5793x4)]
    pmulhrsw                m7, [o(pw_2048)]
    mova            [rsp+16*0], m7
    mova                    m7, [o(pw_5793x4)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova                    m7, [o(pw_2048)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova            [rsp+16*2], m5
    mova            [rsp+16*1], m6
    call  m(idct_8x8_internal).end3
    lea                   dstq, [dstq+strideq*2]

    pxor                    m7, m7
    REPX   {mova [coeffq+32*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7

.loop_end:
    add                 coeffq, 16
    shr                     r3, 2
    test                    r3, r3
    jz .ret
    test                    r3, 2
    jnz .loop
    mov                     r4, r3
    and                     r4, 1
    shl                     r4, 3
    add                 coeffq, r4
    add                 coeffq, 32*7
    mov                   dstq, [rsp+16*3]
    lea                     r4, [dstq+8]
    mov             [rsp+16*3], r4
    jmp .loop

.ret:
    RET


cglobal inv_txfm_add_dct_dct_32x32, 4, 6, 8, 16*36, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_32x32_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_8192)]
    mov               [coeffq], eobd
    mov                    r3d, 32
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_32x8).end)]
    jmp m(inv_txfm_add_dct_dct_32x8).body


cglobal idct_32x32_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r5, 4
    mov                     r4, 2
    sub                   eobd, 136
    cmovge                  r4, r5

%if ARCH_X86_32
    LEA                     r5, $$
%endif

    mov  [rsp+gprsize*1+16*35], eobd
    mov                     r3, r4
    mov  [rsp+gprsize*2+16*35], coeffq

.pass1_loop:
    LOAD_8ROWS     coeffq+64*1, 64*2
    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7
    mova   [rsp+gprsize+16*21], m4                        ;in9
    mova   [rsp+gprsize+16*24], m5                        ;in11
    mova   [rsp+gprsize+16*25], m6                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15

    mov                   tx2d, [rsp+gprsize*1+16*35]
    test                  tx2d, tx2d
    jl .fast

.full:
    LOAD_8ROWS     coeffq+64*0, 64*4
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+64*2, 64*4
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS    coeffq+64*17, 64*2
    mova   [rsp+gprsize+16*33], m0                        ;in17
    mova   [rsp+gprsize+16*28], m1                        ;in19
    mova   [rsp+gprsize+16*29], m2                        ;in21
    mova   [rsp+gprsize+16*32], m3                        ;in23
    mova   [rsp+gprsize+16*31], m4                        ;in25
    mova   [rsp+gprsize+16*30], m5                        ;in27
    mova   [rsp+gprsize+16*27], m6                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31

    call m(idct_8x32_internal).main
    jmp .pass1_end

.fast:
    mova                    m0, [coeffq+256*0]
    mova                    m1, [coeffq+256*1]
    mova                    m2, [coeffq+256*2]
    mova                    m3, [coeffq+256*3]
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main

    SAVE_7ROWS    rsp+gprsize+16*3, 16
    mova                    m0, [coeffq+128*1]
    mova                    m1, [coeffq+128*3]
    mova                    m2, [coeffq+128*5]
    mova                    m3, [coeffq+128*7]
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call m(idct_8x32_internal).main_fast

.pass1_end:
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x32_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS     coeffq+64*0, 64
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x32_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end2:
    SAVE_8ROWS     coeffq+64*8, 64
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x32_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end3:
    SAVE_8ROWS    coeffq+64*16, 64
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_32x32_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end4:
    SAVE_8ROWS    coeffq+64*24, 64

    add                 coeffq, 16
    dec                     r3
    jg .pass1_loop


.pass2:
    mov                 coeffq, [rsp+gprsize*2+16*35]
    mov                     r3, 4
    lea                   tx2q, [o(m(idct_32x32_internal).pass2_end)]

.pass2_loop:
    mov  [rsp+gprsize*3+16*35], r3
    lea                     r3, [dstq+8]
    mov  [rsp+gprsize*2+16*35], r3

    mova                    m0, [coeffq+16*4 ]
    mova                    m1, [coeffq+16*12]
    mova                    m2, [coeffq+16*20]
    mova                    m3, [coeffq+16*28]
    mova                    m4, [coeffq+16*5 ]
    mova                    m5, [coeffq+16*13]
    mova                    m6, [coeffq+16*21]
    mova                    m7, [coeffq+16*29]
    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7
    mova   [rsp+gprsize+16*21], m4                        ;in9
    mova   [rsp+gprsize+16*24], m5                        ;in11
    mova   [rsp+gprsize+16*25], m6                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15

    mov                   eobd, [rsp+gprsize*1+16*35]
    test                  eobd, eobd
    jl .fast1

.full1:
    mova                    m0, [coeffq+16*0 ]
    mova                    m1, [coeffq+16*16]
    mova                    m2, [coeffq+16*1 ]
    mova                    m3, [coeffq+16*17]
    mova                    m4, [coeffq+16*2 ]
    mova                    m5, [coeffq+16*18]
    mova                    m6, [coeffq+16*3 ]
    mova                    m7, [coeffq+16*19]
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    mova                    m0, [coeffq+16*8 ]
    mova                    m1, [coeffq+16*24]
    mova                    m2, [coeffq+16*9 ]
    mova                    m3, [coeffq+16*25]
    mova                    m4, [coeffq+16*10]
    mova                    m5, [coeffq+16*26]
    mova                    m6, [coeffq+16*11]
    mova                    m7, [coeffq+16*27]
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    mova                    m0, [coeffq+16*6 ]
    mova                    m1, [coeffq+16*14]
    mova                    m2, [coeffq+16*22]
    mova                    m3, [coeffq+16*30]
    mova                    m4, [coeffq+16*7 ]
    mova                    m5, [coeffq+16*15]
    mova                    m6, [coeffq+16*23]
    mova                    m7, [coeffq+16*31]
    mova   [rsp+gprsize+16*33], m0                        ;in17
    mova   [rsp+gprsize+16*28], m1                        ;in19
    mova   [rsp+gprsize+16*29], m2                        ;in21
    mova   [rsp+gprsize+16*32], m3                        ;in23
    mova   [rsp+gprsize+16*31], m4                        ;in25
    mova   [rsp+gprsize+16*30], m5                        ;in27
    mova   [rsp+gprsize+16*27], m6                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31

    call m(idct_8x32_internal).main
    jmp                   tx2q

.fast1:
    mova                    m0, [coeffq+16*0 ]
    mova                    m1, [coeffq+16*16]
    mova                    m2, [coeffq+16*1 ]
    mova                    m3, [coeffq+16*17]
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    mova                    m0, [coeffq+16*8 ]
    mova                    m1, [coeffq+16*24]
    mova                    m2, [coeffq+16*9 ]
    mova                    m3, [coeffq+16*25]
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call m(idct_8x32_internal).main_fast
    jmp                   tx2q

.pass2_end:
    lea                     r3, [o(m(idct_32x32_internal).pass2_end1)]
    jmp  m(idct_8x32_internal).end

.pass2_end1:
    lea                   tx2q, [o(m(idct_32x32_internal).pass2_end)]
    add                 coeffq, 16*32
    mov                   dstq, [rsp+gprsize*2+16*35]
    mov                     r3, [rsp+gprsize*3+16*35]
    dec                     r3
    jg .pass2_loop

    ret


cglobal inv_txfm_add_identity_identity_32x32, 4, 6, 8, 16*5, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r4, 2
    mov                     r5, 4
    cmp                   eobd, 136
    cmovge                  r4, r5

%if ARCH_X86_32
    LEA                     r5, $$
%endif

    lea                     r3, [dstq+8]
    mov   [rsp+gprsize*0+16*3], r3
    mov   [rsp+gprsize*1+16*3], r4
    mov   [rsp+gprsize*2+16*3], r4
    mov   [rsp+gprsize*3+16*3], coeffq
    mov                     r3, r4

.loop:
    LOAD_8ROWS          coeffq, 64
    mova            [rsp+16*1], m6
    lea                   tx2q, [o(m(idct_32x16_internal).end)]
    call  m(idct_8x8_internal).pass1_end3
    pmulhrsw                m7, [o(pw_8192)]
    mova            [rsp+16*0], m7
    mova                    m7, [o(pw_8192)]
    REPX      {pmulhrsw x, m7}, m0, m1, m2, m3, m4, m5, m6
    mova            [rsp+16*1], m6
    mova            [rsp+16*2], m5
    call  m(idct_8x8_internal).end3
    lea                   dstq, [dstq+strideq*2]

    pxor                    m7, m7
    REPX   {mova [coeffq+64*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7

    add                 coeffq, 16
    dec                     r3
    jg .loop

    mov                     r4, [rsp+gprsize*2+16*3]
    dec                     r4
    jle .ret

    mov                   dstq, [rsp+gprsize*0+16*3]
    mov                 coeffq, [rsp+gprsize*3+16*3]
    mov   [rsp+gprsize*2+16*3], r4
    lea                     r3, [dstq+8]
    add                 coeffq, 64*8
    mov   [rsp+gprsize*0+16*3], r3
    mov                     r3, [rsp+gprsize*1+16*3]
    mov   [rsp+gprsize*3+16*3], coeffq
    jmp .loop

.ret:
    RET


cglobal inv_txfm_add_dct_dct_16x64, 4, 6, 8, 16*68, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_16x64_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_8192)]
    mov               [coeffq], eobd
    mov                    r2d, 32
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_16x64).end)]
    jmp m(inv_txfm_add_dct_dct_16x4).dconly

.end:
    RET


cglobal idct_16x64_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r5, 4
    mov                     r4, 2
    sub                   eobd, 151
    cmovge                  r4, r5

%if ARCH_X86_32
    LEA                     r5, $$
%endif

    mov  [rsp+gprsize*1+16*67], eobd
    mov                     r3, r4
    mov  [rsp+gprsize*2+16*67], coeffq

.pass1_loop:
    LOAD_8ROWS     coeffq+64*0, 64*2
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+64*1, 64*2
    call m(idct_16x8_internal).main
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_16x64_internal).pass1_end)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS     coeffq+64*8, 64
    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_16x64_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS     coeffq+64*0, 64

    add                 coeffq, 16
    dec                     r3
    jg .pass1_loop

    mov                 coeffq, [rsp+gprsize*2+16*67]
    mov                     r3, 2
    lea                     r4, [dstq+8]
    mov  [rsp+gprsize*2+16*67], r4
    lea                     r4, [o(m(idct_16x64_internal).end1)]

.pass2_loop:
    mov  [rsp+gprsize*3+16*67], r3
    mov                   eobd, [rsp+gprsize*1+16*67]

    mova                    m0, [coeffq+16*4 ]            ;in1
    mova                    m1, [coeffq+16*12]            ;in3
    mova                    m2, [coeffq+16*20]            ;in5
    mova                    m3, [coeffq+16*28]            ;in7
    mova                    m4, [coeffq+16*5 ]            ;in9
    mova                    m5, [coeffq+16*13]            ;in11
    mova                    m6, [coeffq+16*21]            ;in13
    mova                    m7, [coeffq+16*29]            ;in15
    mova   [rsp+gprsize+16*35], m0                        ;in1
    mova   [rsp+gprsize+16*49], m1                        ;in3
    mova   [rsp+gprsize+16*43], m2                        ;in5
    mova   [rsp+gprsize+16*41], m3                        ;in7
    mova   [rsp+gprsize+16*39], m4                        ;in9
    mova   [rsp+gprsize+16*45], m5                        ;in11
    mova   [rsp+gprsize+16*47], m6                        ;in13
    mova   [rsp+gprsize+16*37], m7                        ;in15

    pxor                    m4, m4
    mova                    m0, [coeffq+16*0]
    mova                    m1, [coeffq+16*1]

    test                  eobd, eobd
    jl .fast

.full:
    mova                    m2, [coeffq+16*2]
    mova                    m3, [coeffq+16*3]

    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    pxor                    m4, m4
    mova                    m0, [coeffq+16*16]
    mova                    m1, [coeffq+16*17]
    mova                    m2, [coeffq+16*18]
    mova                    m3, [coeffq+16*19]

    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    mova                    m0, [coeffq+16*8 ]
    mova                    m1, [coeffq+16*24]
    mova                    m2, [coeffq+16*9 ]
    mova                    m3, [coeffq+16*25]
    mova                    m4, [coeffq+16*10]
    mova                    m5, [coeffq+16*26]
    mova                    m6, [coeffq+16*11]
    mova                    m7, [coeffq+16*27]
    mova   [rsp+gprsize+16*19], m0
    mova   [rsp+gprsize+16*26], m1
    mova   [rsp+gprsize+16*23], m2
    mova   [rsp+gprsize+16*22], m3
    mova   [rsp+gprsize+16*21], m4
    mova   [rsp+gprsize+16*24], m5
    mova   [rsp+gprsize+16*25], m6
    mova   [rsp+gprsize+16*20], m7

    call m(idct_8x32_internal).main_fast
    SAVE_8ROWS    rsp+gprsize+16*3, 16

    mova                    m0, [coeffq+16*6 ]            ;in17
    mova                    m1, [coeffq+16*14]            ;in19
    mova                    m2, [coeffq+16*22]            ;in21
    mova                    m3, [coeffq+16*30]            ;in23
    mova                    m4, [coeffq+16*7 ]            ;in25
    mova                    m5, [coeffq+16*15]            ;in27
    mova                    m6, [coeffq+16*23]            ;in29
    mova                    m7, [coeffq+16*31]            ;in31
    mova   [rsp+gprsize+16*63], m0                        ;in17
    mova   [rsp+gprsize+16*53], m1                        ;in19
    mova   [rsp+gprsize+16*55], m2                        ;in21
    mova   [rsp+gprsize+16*61], m3                        ;in23
    mova   [rsp+gprsize+16*59], m4                        ;in25
    mova   [rsp+gprsize+16*57], m5                        ;in27
    mova   [rsp+gprsize+16*51], m6                        ;in29
    mova   [rsp+gprsize+16*65], m7                        ;in31

    call .main
    jmp  .end

.fast:
    REPX          {mova x, m4}, m2, m3, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    pxor                    m4, m4
    mova                    m0, [coeffq+16*16]
    mova                    m1, [coeffq+16*17]

    REPX          {mova x, m4}, m2, m3, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    mova                    m0, [coeffq+16*8 ]
    mova                    m1, [coeffq+16*24]
    mova                    m2, [coeffq+16*9 ]
    mova                    m3, [coeffq+16*25]
    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7

    call m(idct_8x32_internal).main_veryfast
    SAVE_8ROWS    rsp+gprsize+16*3, 16

    call .main_fast

.end:
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mov                     r3, r4
    jmp  m(idct_8x32_internal).end2

.end1:
    LOAD_8ROWS   rsp+gprsize+16*35, 16
    lea                   dstq, [dstq+strideq*2]
    add                    rsp, 16*32
    lea                     r3, [o(m(idct_16x64_internal).end2)]
    jmp  m(idct_8x32_internal).end

.end2:
    add                 coeffq, 16*32
    sub                    rsp, 16*32

    mov                   dstq, [rsp+gprsize*2+16*67]
    mov                     r3, [rsp+gprsize*3+16*67]
    lea                     r4, [dstq+8]
    mov  [rsp+gprsize*2+16*67], r4
    lea                     r4, [o(m(idct_16x64_internal).end1)]

    dec                     r3
    jg .pass2_loop
    ret


ALIGN function_align
.main_fast:
    mova                    m0, [rsp+gprsize*2+16*35]     ;in1
    pmulhrsw                m3, m0, [o(pw_4095x8)]        ;t62,t63
    pmulhrsw                m0, [o(pw_101x8)]             ;t32,t33
    mova                    m7, [o(pd_2048)]
    mova [rsp+gprsize*2+16*35], m0                        ;t32
    mova [rsp+gprsize*2+16*66], m3                        ;t63
    ITX_MULSUB_2W            3, 0, 1, 2, 7,  401, 4076    ;t33a, t62a
    mova [rsp+gprsize*2+16*36], m3                        ;t33a
    mova [rsp+gprsize*2+16*65], m0                        ;t62a

    mova                    m1, [rsp+gprsize*2+16*37]     ;in15
    pmulhrsw                m2, m1, [o(pw_3822x8)]        ;t60,t61
    pmulhrsw                m1, [o(pw_m1474x8)]           ;t34,t35
    mova [rsp+gprsize*2+16*38], m1                        ;t35
    mova [rsp+gprsize*2+16*63], m2                        ;t60
    pxor                    m6, m6
    psubw                   m3, m6, m1
    ITX_MULSUB_2W            3, 2, 0, 1, 7,  401, 4076    ;t34a, t61a
    mova [rsp+gprsize*2+16*37], m3                        ;t34a
    mova [rsp+gprsize*2+16*64], m2                        ;t61a

    mova                    m0, [rsp+gprsize*2+16*39]     ;in9
    pmulhrsw                m3, m0, [o(pw_3996x8)]        ;t58,t59
    pmulhrsw                m0, [o(pw_897x8)]             ;t36,t37
    mova [rsp+gprsize*2+16*39], m0                        ;t36
    mova [rsp+gprsize*2+16*62], m3                        ;t59
    ITX_MULSUB_2W            3, 0, 1, 2, 7, 3166, 2598    ;t37a, t58a
    mova [rsp+gprsize*2+16*40], m3                        ;t37a
    mova [rsp+gprsize*2+16*61], m0                        ;t58a

    mova                    m1, [rsp+gprsize*2+16*41]     ;in7
    pmulhrsw                m2, m1, [o(pw_4036x8)]        ;t56,t57
    pmulhrsw                m1, [o(pw_m700x8)]            ;t38,t39
    mova [rsp+gprsize*2+16*42], m1                        ;t39
    mova [rsp+gprsize*2+16*59], m2                        ;t56
    psubw                   m3, m6, m1
    ITX_MULSUB_2W            3, 2, 0, 1, 7, 3166, 2598    ;t38a, t57a
    mova [rsp+gprsize*2+16*41], m3                        ;t38a
    mova [rsp+gprsize*2+16*60], m2                        ;t57a

    mova                    m0, [rsp+gprsize*2+16*43]     ;in5
    pmulhrsw                m3, m0, [o(pw_4065x8)]        ;t54,t55
    pmulhrsw                m0, [o(pw_501x8)]             ;t40,t41
    mova [rsp+gprsize*2+16*43], m0                        ;t40
    mova [rsp+gprsize*2+16*58], m3                        ;t55
    ITX_MULSUB_2W            3, 0, 1, 2, 7, 1931, 3612    ;t41a, t54a
    mova [rsp+gprsize*2+16*44], m3                        ;t41a
    mova [rsp+gprsize*2+16*57], m0                        ;t54a

    mova                    m1, [rsp+gprsize*2+16*45]     ;in11
    pmulhrsw                m2, m1, [o(pw_3948x8)]        ;t52,t53
    pmulhrsw                m1, [o(pw_m1092x8)]           ;t42,t43
    mova [rsp+gprsize*2+16*46], m1                        ;t43
    mova [rsp+gprsize*2+16*55], m2                        ;t52
    psubw                   m3, m6, m1
    ITX_MULSUB_2W            3, 2, 0, 1, 7, 1931, 3612    ;t42a, t53a
    mova [rsp+gprsize*2+16*45], m3                        ;t42a
    mova [rsp+gprsize*2+16*56], m2                        ;t53a

    mova                    m0, [rsp+gprsize*2+16*47]     ;in13
    pmulhrsw                m3, m0, [o(pw_3889x8)]        ;t50,t51
    pmulhrsw                m0, [o(pw_1285x8)]            ;t44,t45
    mova                    m6, m0
    mova [rsp+gprsize*2+16*54], m3                        ;t51
    ITX_MULSUB_2W            3, 0, 1, 2, 7, 3920, 1189    ;t45a, t50a
    mova [rsp+gprsize*2+16*48], m3                        ;t45a
    mova [rsp+gprsize*2+16*53], m0                        ;t50a

    mova                    m0, [rsp+gprsize*2+16*49]     ;in3
    pmulhrsw                m3, m0, [o(pw_4085x8)]        ;t48,t49
    pmulhrsw                m0, [o(pw_m301x8)]            ;t46,t47
    mova                    m4, m3
    mova                    m5, m0

    jmp .main2

ALIGN function_align
.main:
    mova                    m0, [rsp+gprsize*2+16*35]     ;in1
    mova                    m1, [rsp+gprsize*2+16*65]     ;in31
    pmulhrsw                m3, m0, [o(pw_4095x8)]        ;t63a
    pmulhrsw                m0, [o(pw_101x8)]             ;t32a
    pmulhrsw                m2, m1, [o(pw_2967x8)]        ;t62a
    pmulhrsw                m1, [o(pw_m2824x8)]           ;t33a
    mova                    m7, [o(pd_2048)]
    psubsw                  m4, m0, m1                    ;t33
    paddsw                  m0, m1                        ;t32
    psubsw                  m5, m3, m2                    ;t62
    paddsw                  m3, m2                        ;t63
    ITX_MULSUB_2W            5, 4, 1, 2, 7,  401, 4076    ;t33a, t62a
    mova [rsp+gprsize*2+16*35], m0                        ;t32
    mova [rsp+gprsize*2+16*36], m5                        ;t33a
    mova [rsp+gprsize*2+16*65], m4                        ;t62a
    mova [rsp+gprsize*2+16*66], m3                        ;t63

    mova                    m0, [rsp+gprsize*2+16*63]     ;in17
    mova                    m1, [rsp+gprsize*2+16*37]     ;in15
    pmulhrsw                m3, m0, [o(pw_3745x8)]        ;t61a
    pmulhrsw                m0, [o(pw_1660x8)]            ;t34a
    pmulhrsw                m2, m1, [o(pw_3822x8)]        ;t60a
    pmulhrsw                m1, [o(pw_m1474x8)]           ;t35a
    psubsw                  m4, m1, m0                    ;t34
    paddsw                  m0, m1                        ;t35
    psubsw                  m5, m2, m3                    ;t61
    paddsw                  m3, m2                        ;t60
    pxor                    m6, m6
    psubw                   m2, m6, m4
    ITX_MULSUB_2W            2, 5, 1, 4, 7,  401, 4076    ;t34a, t61a
    mova [rsp+gprsize*2+16*37], m2                        ;t34a
    mova [rsp+gprsize*2+16*38], m0                        ;t35
    mova [rsp+gprsize*2+16*63], m3                        ;t60
    mova [rsp+gprsize*2+16*64], m5                        ;t61a

    mova                    m0, [rsp+gprsize*2+16*39]     ;in9
    mova                    m1, [rsp+gprsize*2+16*61]     ;in23
    pmulhrsw                m3, m0, [o(pw_3996x8)]        ;t59a
    pmulhrsw                m0, [o(pw_897x8)]             ;t36a
    pmulhrsw                m2, m1, [o(pw_3461x8)]        ;t58a
    pmulhrsw                m1, [o(pw_m2191x8)]           ;t37a
    psubsw                  m4, m0, m1                    ;t37
    paddsw                  m0, m1                        ;t36
    psubsw                  m5, m3, m2                    ;t58
    paddsw                  m3, m2                        ;t59
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 3166, 2598    ;t37a, t58a
    mova [rsp+gprsize*2+16*39], m0                        ;t36
    mova [rsp+gprsize*2+16*40], m5                        ;t37a
    mova [rsp+gprsize*2+16*61], m4                        ;t58a
    mova [rsp+gprsize*2+16*62], m3                        ;t59

    mova                    m0, [rsp+gprsize*2+16*59]     ;in25
    mova                    m1, [rsp+gprsize*2+16*41]     ;in7
    pmulhrsw                m3, m0, [o(pw_3349x8)]        ;t57a
    pmulhrsw                m0, [o(pw_2359x8)]            ;t38a
    pmulhrsw                m2, m1, [o(pw_4036x8)]        ;t56a
    pmulhrsw                m1, [o(pw_m700x8)]            ;t39a
    psubsw                  m4, m1, m0                    ;t38
    paddsw                  m0, m1                        ;t39
    psubsw                  m5, m2, m3                    ;t57
    paddsw                  m3, m2                        ;t56
    psubw                   m2, m6, m4
    ITX_MULSUB_2W            2, 5, 1, 4, 7, 3166, 2598    ;t38a, t57a
    mova [rsp+gprsize*2+16*41], m2                        ;t38a
    mova [rsp+gprsize*2+16*42], m0                        ;t39
    mova [rsp+gprsize*2+16*59], m3                        ;t56
    mova [rsp+gprsize*2+16*60], m5                        ;t57a

    mova                    m0, [rsp+gprsize*2+16*43]     ;in5
    mova                    m1, [rsp+gprsize*2+16*57]     ;in27
    pmulhrsw                m3, m0, [o(pw_4065x8)]        ;t55a
    pmulhrsw                m0, [o(pw_501x8)]             ;t40a
    pmulhrsw                m2, m1, [o(pw_3229x8)]        ;t54a
    pmulhrsw                m1, [o(pw_m2520x8)]           ;t41a
    psubsw                  m4, m0, m1                    ;t41
    paddsw                  m0, m1                        ;t40
    psubsw                  m5, m3, m2                    ;t54
    paddsw                  m3, m2                        ;t55
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 1931, 3612    ;t41a, t54a
    mova [rsp+gprsize*2+16*43], m0                        ;t40
    mova [rsp+gprsize*2+16*44], m5                        ;t41a
    mova [rsp+gprsize*2+16*57], m4                        ;t54a
    mova [rsp+gprsize*2+16*58], m3                        ;t55

    mova                    m0, [rsp+gprsize*2+16*55]     ;in21
    mova                    m1, [rsp+gprsize*2+16*45]     ;in11
    pmulhrsw                m3, m0, [o(pw_3564x8)]        ;t53a
    pmulhrsw                m0, [o(pw_2019x8)]            ;t42a
    pmulhrsw                m2, m1, [o(pw_3948x8)]        ;t52a
    pmulhrsw                m1, [o(pw_m1092x8)]           ;t43a
    psubsw                  m4, m1, m0                    ;t42
    paddsw                  m0, m1                        ;t43
    psubsw                  m5, m2, m3                    ;t53
    paddsw                  m3, m2                        ;t52
    psubw                   m2, m6, m4
    ITX_MULSUB_2W            2, 5, 1, 4, 7, 1931, 3612    ;t42a, t53a
    mova [rsp+gprsize*2+16*45], m2                        ;t42a
    mova [rsp+gprsize*2+16*46], m0                        ;t43
    mova [rsp+gprsize*2+16*55], m3                        ;t52
    mova [rsp+gprsize*2+16*56], m5                        ;t53a

    mova                    m0, [rsp+gprsize*2+16*47]     ;in13
    mova                    m1, [rsp+gprsize*2+16*53]     ;in19
    pmulhrsw                m3, m0, [o(pw_3889x8)]        ;t51a
    pmulhrsw                m0, [o(pw_1285x8)]            ;t44a
    pmulhrsw                m2, m1, [o(pw_3659x8)]        ;t50a
    pmulhrsw                m1, [o(pw_m1842x8)]           ;t45a
    psubsw                  m4, m0, m1                    ;t45
    paddsw                  m0, m1                        ;t44
    psubsw                  m5, m3, m2                    ;t50
    paddsw                  m3, m2                        ;t51
    ITX_MULSUB_2W            5, 4, 1, 2, 7, 3920, 1189    ;t45a, t50a
    mova                    m6, m0
    mova [rsp+gprsize*2+16*48], m5                        ;t45a
    mova [rsp+gprsize*2+16*53], m4                        ;t50a
    mova [rsp+gprsize*2+16*54], m3                        ;t51

    mova                    m0, [rsp+gprsize*2+16*51]     ;in29
    mova                    m1, [rsp+gprsize*2+16*49]     ;in3
    pmulhrsw                m3, m0, [o(pw_3102x8)]        ;t49a
    pmulhrsw                m0, [o(pw_2675x8)]            ;t46a
    pmulhrsw                m2, m1, [o(pw_4085x8)]        ;t48a
    pmulhrsw                m1, [o(pw_m301x8)]            ;t47a
    psubsw                  m5, m1, m0                    ;t46
    paddsw                  m0, m1                        ;t47
    psubsw                  m4, m2, m3                    ;t49
    paddsw                  m3, m2                        ;t48

ALIGN function_align
.main2:
    pxor                    m2, m2
    psubw                   m2, m5
    ITX_MULSUB_2W            2, 4, 1, 5, 7, 3920, 1189    ;t46a, t49a

    mova                    m1, [rsp+gprsize*2+16*54]     ;t51
    psubsw                  m5, m0, m6                    ;t44a
    paddsw                  m0, m6                        ;t47a
    psubsw                  m6, m3, m1                    ;t51a
    paddsw                  m3, m1                        ;t48a
    mova [rsp+gprsize*2+16*50], m0                        ;t47a
    mova [rsp+gprsize*2+16*51], m3                        ;t48a
    pxor                    m1, m1
    psubw                   m3, m1, m5
    ITX_MULSUB_2W            3, 6, 0, 5, 7, 3406, 2276    ;t44, t51
    mova [rsp+gprsize*2+16*47], m3                        ;t44
    mova [rsp+gprsize*2+16*54], m6                        ;t51

    mova                    m0, [rsp+gprsize*2+16*48]     ;t45a
    mova                    m3, [rsp+gprsize*2+16*53]     ;t50a
    psubsw                  m5, m2, m0                    ;t45
    paddsw                  m2, m0                        ;t46
    psubsw                  m6, m4, m3                    ;t50
    paddsw                  m4, m3                        ;t49
    psubw                   m1, m5
    ITX_MULSUB_2W            1, 6, 0, 3, 7, 3406, 2276    ;t45a, t50a
    mova [rsp+gprsize*2+16*48], m1                        ;t45a
    mova [rsp+gprsize*2+16*49], m2                        ;t46
    mova [rsp+gprsize*2+16*52], m4                        ;t49
    mova [rsp+gprsize*2+16*53], m6                        ;t50a

    mova                    m0, [rsp+gprsize*2+16*43]     ;t40
    mova                    m2, [rsp+gprsize*2+16*46]     ;t43
    mova                    m3, [rsp+gprsize*2+16*55]     ;t52
    mova                    m1, [rsp+gprsize*2+16*58]     ;t55
    psubsw                  m4, m0, m2                    ;t43a
    paddsw                  m0, m2                        ;t40a
    psubsw                  m5, m1, m3                    ;t52a
    paddsw                  m1, m3                        ;t55a
    ITX_MULSUB_2W            5, 4, 2, 3, 7, 3406, 2276    ;t43, t52
    mova [rsp+gprsize*2+16*43], m0                        ;t40a
    mova [rsp+gprsize*2+16*46], m5                        ;t43
    mova [rsp+gprsize*2+16*55], m4                        ;t52
    mova [rsp+gprsize*2+16*58], m1                        ;t55a

    mova                    m0, [rsp+gprsize*2+16*44]     ;t41a
    mova                    m2, [rsp+gprsize*2+16*45]     ;t42a
    mova                    m3, [rsp+gprsize*2+16*56]     ;t53a
    mova                    m1, [rsp+gprsize*2+16*57]     ;t54a
    psubsw                  m4, m0, m2                    ;t42
    paddsw                  m0, m2                        ;t41
    psubsw                  m5, m1, m3                    ;t53
    paddsw                  m1, m3                        ;t54
    ITX_MULSUB_2W            5, 4, 2, 3, 7, 3406, 2276    ;t42a, t53a
    mova [rsp+gprsize*2+16*44], m0                        ;t41
    mova [rsp+gprsize*2+16*45], m5                        ;t42a
    mova [rsp+gprsize*2+16*56], m4                        ;t53a
    mova [rsp+gprsize*2+16*57], m1                        ;t54

    mova                    m0, [rsp+gprsize*2+16*41]     ;t38a
    mova                    m2, [rsp+gprsize*2+16*40]     ;t37a
    mova                    m3, [rsp+gprsize*2+16*61]     ;t58a
    mova                    m1, [rsp+gprsize*2+16*60]     ;t57a
    psubsw                  m4, m0, m2                    ;t37
    paddsw                  m0, m2                        ;t38
    psubsw                  m5, m1, m3                    ;t58
    paddsw                  m1, m3                        ;t57
    pxor                    m6, m6
    psubw                   m3, m6, m4
    ITX_MULSUB_2W            3, 5, 2, 4, 7,  799, 4017    ;t37a, t58a
    mova [rsp+gprsize*2+16*41], m0                        ;t38
    mova [rsp+gprsize*2+16*40], m3                        ;t37a
    mova [rsp+gprsize*2+16*61], m5                        ;t58a
    mova [rsp+gprsize*2+16*60], m1                        ;t57

    mova                    m0, [rsp+gprsize*2+16*42]     ;t39
    mova                    m2, [rsp+gprsize*2+16*39]     ;t36
    mova                    m3, [rsp+gprsize*2+16*62]     ;t59
    mova                    m1, [rsp+gprsize*2+16*59]     ;t56
    psubsw                  m4, m0, m2                    ;t36a
    paddsw                  m0, m2                        ;t39a
    psubsw                  m5, m1, m3                    ;t59a
    paddsw                  m1, m3                        ;t56a
    psubw                   m3, m6, m4
    ITX_MULSUB_2W            3, 5, 2, 4, 7,  799, 4017    ;t36, t59
    mova [rsp+gprsize*2+16*42], m0                        ;t39a
    mova [rsp+gprsize*2+16*39], m3                        ;t36
    mova [rsp+gprsize*2+16*62], m5                        ;t59
    mova [rsp+gprsize*2+16*59], m1                        ;t56a

    mova                    m0, [rsp+gprsize*2+16*35]     ;t32
    mova                    m2, [rsp+gprsize*2+16*38]     ;t35
    mova                    m3, [rsp+gprsize*2+16*63]     ;t60
    mova                    m1, [rsp+gprsize*2+16*66]     ;t63
    psubsw                  m4, m0, m2                    ;t35a
    paddsw                  m0, m2                        ;t32a
    psubsw                  m5, m1, m3                    ;t60a
    paddsw                  m1, m3                        ;t63a
    ITX_MULSUB_2W            5, 4, 2, 3, 7,  799, 4017    ;t35, t60
    mova [rsp+gprsize*2+16*35], m0                        ;t32a
    mova [rsp+gprsize*2+16*38], m5                        ;t35
    mova [rsp+gprsize*2+16*63], m4                        ;t60
    mova [rsp+gprsize*2+16*66], m1                        ;t63a

    mova                    m0, [rsp+gprsize*2+16*36]     ;t33a
    mova                    m2, [rsp+gprsize*2+16*37]     ;t34a
    mova                    m3, [rsp+gprsize*2+16*64]     ;t61a
    mova                    m1, [rsp+gprsize*2+16*65]     ;t62a
    psubsw                  m4, m0, m2                    ;t34
    paddsw                  m0, m2                        ;t33
    psubsw                  m5, m1, m3                    ;t61
    paddsw                  m1, m3                        ;t62
    ITX_MULSUB_2W            5, 4, 2, 3, 7,  799, 4017    ;t34a, t61a

    mova                    m2, [rsp+gprsize*2+16*41]     ;t38
    mova                    m3, [rsp+gprsize*2+16*60]     ;t57
    psubsw                  m6, m0, m2                    ;t38a
    paddsw                  m0, m2                        ;t33a
    psubsw                  m2, m1, m3                    ;t57a
    paddsw                  m1, m3                        ;t62a
    mova [rsp+gprsize*2+16*36], m0                        ;t33a
    mova [rsp+gprsize*2+16*65], m1                        ;t62a
    ITX_MULSUB_2W            2, 6, 0, 3, 7, 1567, 3784    ;t38, t57
    mova [rsp+gprsize*2+16*41], m2                        ;t38
    mova [rsp+gprsize*2+16*60], m6                        ;t57

    mova                    m2, [rsp+gprsize*2+16*40]     ;t37
    mova                    m3, [rsp+gprsize*2+16*61]     ;t58
    psubsw                  m0, m5, m2                    ;t37
    paddsw                  m5, m2                        ;t34
    psubsw                  m1, m4, m3                    ;t58
    paddsw                  m4, m3                        ;t61
    ITX_MULSUB_2W            1, 0, 2, 3, 7, 1567, 3784    ;t37a, t58a
    mova [rsp+gprsize*2+16*37], m5                        ;t34
    mova [rsp+gprsize*2+16*64], m4                        ;t61
    mova [rsp+gprsize*2+16*40], m1                        ;t37a
    mova [rsp+gprsize*2+16*61], m0                        ;t58a

    mova                    m0, [rsp+gprsize*2+16*38]     ;t35
    mova                    m2, [rsp+gprsize*2+16*39]     ;t36
    mova                    m3, [rsp+gprsize*2+16*62]     ;t59
    mova                    m1, [rsp+gprsize*2+16*63]     ;t60
    psubsw                  m4, m0, m2                    ;t36a
    paddsw                  m0, m2                        ;t35a
    psubsw                  m5, m1, m3                    ;t59a
    paddsw                  m1, m3                        ;t60a
    ITX_MULSUB_2W            5, 4, 2, 3, 7, 1567, 3784    ;t36, t59
    mova [rsp+gprsize*2+16*38], m0                        ;t35a
    mova [rsp+gprsize*2+16*39], m5                        ;t36
    mova [rsp+gprsize*2+16*62], m4                        ;t59
    mova [rsp+gprsize*2+16*63], m1                        ;t60a

    mova                    m0, [rsp+gprsize*2+16*35]     ;t32a
    mova                    m2, [rsp+gprsize*2+16*42]     ;t39a
    mova                    m3, [rsp+gprsize*2+16*59]     ;t56a
    mova                    m1, [rsp+gprsize*2+16*66]     ;t63a
    psubsw                  m4, m0, m2                    ;t39
    paddsw                  m0, m2                        ;t32
    psubsw                  m5, m1, m3                    ;t56
    paddsw                  m1, m3                        ;t63
    ITX_MULSUB_2W            5, 4, 2, 3, 7, 1567, 3784    ;t39a, t56a
    mova [rsp+gprsize*2+16*35], m0                        ;t32
    mova [rsp+gprsize*2+16*42], m5                        ;t39a
    mova [rsp+gprsize*2+16*59], m4                        ;t56a
    mova [rsp+gprsize*2+16*66], m1                        ;t63

    mova                    m0, [rsp+gprsize*2+16*50]     ;t47a
    mova                    m2, [rsp+gprsize*2+16*43]     ;t40a
    mova                    m3, [rsp+gprsize*2+16*58]     ;t55a
    mova                    m1, [rsp+gprsize*2+16*51]     ;t48a
    psubsw                  m4, m0, m2                    ;t40
    paddsw                  m0, m2                        ;t47
    psubsw                  m5, m1, m3                    ;t55
    paddsw                  m1, m3                        ;t48
    pxor                    m6, m6
    psubw                   m3, m6, m4
    ITX_MULSUB_2W            3, 5, 2, 4, 7, 1567, 3784    ;t40a, t55a
    mova [rsp+gprsize*2+16*50], m0                        ;t47
    mova [rsp+gprsize*2+16*43], m3                        ;t40a
    mova [rsp+gprsize*2+16*58], m5                        ;t55a
    mova [rsp+gprsize*2+16*51], m1                        ;t48

    mova                    m0, [rsp+gprsize*2+16*49]     ;t46
    mova                    m2, [rsp+gprsize*2+16*44]     ;t41
    mova                    m3, [rsp+gprsize*2+16*57]     ;t54
    mova                    m1, [rsp+gprsize*2+16*52]     ;t49
    psubsw                  m4, m0, m2                    ;t41a
    paddsw                  m0, m2                        ;t46a
    psubsw                  m5, m1, m3                    ;t54a
    paddsw                  m1, m3                        ;t49a
    psubw                   m3, m6, m4
    ITX_MULSUB_2W            3, 5, 2, 4, 7, 1567, 3784    ;t41, t54
    mova [rsp+gprsize*2+16*49], m0                        ;t46a
    mova [rsp+gprsize*2+16*44], m3                        ;t41
    mova [rsp+gprsize*2+16*57], m5                        ;t54
    mova [rsp+gprsize*2+16*52], m1                        ;t49a

    mova                    m0, [rsp+gprsize*2+16*48]     ;t45a
    mova                    m2, [rsp+gprsize*2+16*45]     ;t42a
    mova                    m3, [rsp+gprsize*2+16*56]     ;t53a
    mova                    m1, [rsp+gprsize*2+16*53]     ;t50a
    psubsw                  m4, m0, m2                    ;t42
    paddsw                  m0, m2                        ;t45
    psubsw                  m5, m1, m3                    ;t53
    paddsw                  m1, m3                        ;t50
    psubw                   m3, m6, m4
    ITX_MULSUB_2W            3, 5, 2, 4, 7, 1567, 3784     ;t42a, t53a
    mova [rsp+gprsize*2+16*48], m0                        ;t45
    mova [rsp+gprsize*2+16*45], m3                        ;t42a
    mova [rsp+gprsize*2+16*56], m5                        ;t53a
    mova [rsp+gprsize*2+16*53], m1                        ;t50

    mova                    m0, [rsp+gprsize*2+16*47]     ;t44
    mova                    m2, [rsp+gprsize*2+16*46]     ;t43
    mova                    m5, [rsp+gprsize*2+16*55]     ;t52
    mova                    m1, [rsp+gprsize*2+16*54]     ;t51
    psubsw                  m3, m0, m2                    ;t43a
    paddsw                  m0, m2                        ;t44a
    psubsw                  m4, m1, m5                    ;t52a
    paddsw                  m1, m5                        ;t51a
    psubw                   m5, m6, m3
    ITX_MULSUB_2W            5, 4, 2, 3, 7, 1567, 3784    ;t43, t52

    mova                    m7, [o(pw_2896x8)]
    mova                    m2, [rsp+gprsize*2+16*38]     ;t35a
    mova                    m3, [rsp+gprsize*2+16*31]     ;tmp[28]
    psubsw                  m6, m2, m0                    ;t44
    paddsw                  m2, m0                        ;t35
    psubsw                  m0, m3, m2                    ;out35
    paddsw                  m2, m3                        ;out28
    mova [rsp+gprsize*2+16*38], m0                        ;out35
    mova [rsp+gprsize*2+16*31], m2                        ;out28
    mova                    m3, [rsp+gprsize*2+16*63]     ;t60a
    mova                    m2, [rsp+gprsize*2+16*6 ]     ;tmp[3]
    psubsw                  m0, m3, m1                    ;t51
    paddsw                  m3, m1                        ;t60
    psubw                   m1, m0, m6                    ;t44a
    paddw                   m0, m6                        ;t51a
    psubsw                  m6, m2, m3                    ;out60
    paddsw                  m2, m3                        ;out3
    pmulhrsw                m1, m7                        ;t44a
    pmulhrsw                m0, m7                        ;t51a
    mova                    m3, [rsp+gprsize*2+16*22]     ;tmp[19]
    mova [rsp+gprsize*2+16*63], m6                        ;out60
    mova [rsp+gprsize*2+16*6 ], m2                        ;out3
    psubsw                  m6, m3, m1                    ;out44
    paddsw                  m3, m1                        ;out19
    mova                    m2, [rsp+gprsize*2+16*15]     ;tmp[12]
    mova [rsp+gprsize*2+16*47], m6                        ;out44
    mova [rsp+gprsize*2+16*22], m3                        ;out19
    psubsw                  m1, m2, m0                    ;out51
    paddsw                  m2, m0                        ;out12
    mova [rsp+gprsize*2+16*54], m1                        ;out51
    mova [rsp+gprsize*2+16*15], m2                        ;out12

    mova                    m0, [rsp+gprsize*2+16*39]     ;t36
    mova                    m1, [rsp+gprsize*2+16*62]     ;t59
    psubsw                  m2, m0, m5                    ;t43a
    paddsw                  m0, m5                        ;t36a
    psubsw                  m3, m1, m4                    ;t52a
    paddsw                  m1, m4                        ;t59a
    psubw                   m5, m3, m2                    ;t43
    paddw                   m3, m2                        ;t52
    mova                    m2, [rsp+gprsize*2+16*30]     ;tmp[27]
    mova                    m4, [rsp+gprsize*2+16*7 ]     ;tmp[4 ]
    pmulhrsw                m5, m7                        ;t43
    pmulhrsw                m3, m7                        ;t52
    psubsw                  m6, m2, m0                    ;out36
    paddsw                  m2, m0                        ;out27
    psubsw                  m0, m4, m1                    ;out59
    paddsw                  m4, m1                        ;out4
    mova [rsp+gprsize*2+16*39], m6                        ;out36
    mova [rsp+gprsize*2+16*30], m2                        ;out27
    mova [rsp+gprsize*2+16*62], m0                        ;out59
    mova [rsp+gprsize*2+16*7 ], m4                        ;out4
    mova                    m0, [rsp+gprsize*2+16*23]     ;tmp[20]
    mova                    m2, [rsp+gprsize*2+16*14]     ;tmp[11]
    psubsw                  m4, m0, m5                    ;out43
    paddsw                  m0, m5                        ;out20
    psubsw                  m6, m2, m3                    ;out52
    paddsw                  m2, m3                        ;out11
    mova [rsp+gprsize*2+16*46], m4                        ;out43
    mova [rsp+gprsize*2+16*23], m0                        ;out20
    mova [rsp+gprsize*2+16*55], m6                        ;out52
    mova [rsp+gprsize*2+16*14], m2                        ;out11

    mova                    m0, [rsp+gprsize*2+16*40]     ;t37a
    mova                    m2, [rsp+gprsize*2+16*45]     ;t42a
    mova                    m3, [rsp+gprsize*2+16*56]     ;t53a
    mova                    m1, [rsp+gprsize*2+16*61]     ;t58a
    psubsw                  m4, m0, m2                    ;t42
    paddsw                  m0, m2                        ;t37
    psubsw                  m5, m1, m3                    ;t53
    paddsw                  m1, m3                        ;t58
    psubw                   m6, m5, m4                    ;t42a
    paddw                   m5, m4                        ;t53a
    mova                    m2, [rsp+gprsize*2+16*29]     ;tmp[26]
    mova                    m3, [rsp+gprsize*2+16*8 ]     ;tmp[5 ]
    pmulhrsw                m6, m7                        ;t42a
    pmulhrsw                m5, m7                        ;t53a
    psubsw                  m4, m2, m0                    ;out37
    paddsw                  m2, m0                        ;out26
    psubsw                  m0, m3, m1                    ;out58
    paddsw                  m3, m1                        ;out5
    mova [rsp+gprsize*2+16*40], m4                        ;out37
    mova [rsp+gprsize*2+16*29], m2                        ;out26
    mova [rsp+gprsize*2+16*61], m0                        ;out58
    mova [rsp+gprsize*2+16*8 ], m3                        ;out5
    mova                    m0, [rsp+gprsize*2+16*24]     ;tmp[21]
    mova                    m1, [rsp+gprsize*2+16*13]     ;tmp[10]
    psubsw                  m2, m0, m6                    ;out42
    paddsw                  m0, m6                        ;out21
    psubsw                  m3, m1, m5                    ;out53
    paddsw                  m1, m5                        ;out10
    mova [rsp+gprsize*2+16*45], m2                        ;out42
    mova [rsp+gprsize*2+16*24], m0                        ;out21
    mova [rsp+gprsize*2+16*56], m3                        ;out53
    mova [rsp+gprsize*2+16*13], m1                        ;out10

    mova                    m0, [rsp+gprsize*2+16*41]     ;t38
    mova                    m2, [rsp+gprsize*2+16*44]     ;t41
    mova                    m3, [rsp+gprsize*2+16*57]     ;t54
    mova                    m1, [rsp+gprsize*2+16*60]     ;t57
    psubsw                  m4, m0, m2                    ;t41a
    paddsw                  m0, m2                        ;t38a
    psubsw                  m5, m1, m3                    ;t54a
    paddsw                  m1, m3                        ;t57a
    psubw                   m6, m5, m4                    ;t41
    paddw                   m5, m4                        ;t54
    mova                    m2, [rsp+gprsize*2+16*28]     ;tmp[25]
    mova                    m3, [rsp+gprsize*2+16*9 ]     ;tmp[6 ]
    pmulhrsw                m6, m7                        ;t41a
    pmulhrsw                m5, m7                        ;t54a
    psubsw                  m4, m2, m0                    ;out38
    paddsw                  m2, m0                        ;out25
    psubsw                  m0, m3, m1                    ;out57
    paddsw                  m3, m1                        ;out6
    mova [rsp+gprsize*2+16*41], m4                        ;out38
    mova [rsp+gprsize*2+16*28], m2                        ;out25
    mova [rsp+gprsize*2+16*60], m0                        ;out57
    mova [rsp+gprsize*2+16*9 ], m3                        ;out6
    mova                    m0, [rsp+gprsize*2+16*25]     ;tmp[22]
    mova                    m1, [rsp+gprsize*2+16*12]     ;tmp[9 ]
    psubsw                  m2, m0, m6                    ;out41
    paddsw                  m0, m6                        ;out22
    psubsw                  m3, m1, m5                    ;out54
    paddsw                  m1, m5                        ;out9
    mova [rsp+gprsize*2+16*44], m2                        ;out41
    mova [rsp+gprsize*2+16*25], m0                        ;out22
    mova [rsp+gprsize*2+16*57], m3                        ;out54
    mova [rsp+gprsize*2+16*12], m1                        ;out9

    mova                    m0, [rsp+gprsize*2+16*42]     ;t39a
    mova                    m2, [rsp+gprsize*2+16*43]     ;t40a
    mova                    m3, [rsp+gprsize*2+16*58]     ;t55a
    mova                    m1, [rsp+gprsize*2+16*59]     ;t56a
    psubsw                  m4, m0, m2                    ;t40
    paddsw                  m0, m2                        ;t39
    psubsw                  m5, m1, m3                    ;t55
    paddsw                  m1, m3                        ;t56
    psubw                   m6, m5, m4                    ;t40a
    paddw                   m5, m4                        ;t55a
    mova                    m2, [rsp+gprsize*2+16*27]     ;tmp[24]
    mova                    m3, [rsp+gprsize*2+16*10]     ;tmp[7 ]
    pmulhrsw                m6, m7                        ;t40a
    pmulhrsw                m5, m7                        ;t55a
    psubsw                  m4, m2, m0                    ;out39
    paddsw                  m2, m0                        ;out24
    psubsw                  m0, m3, m1                    ;out56
    paddsw                  m3, m1                        ;out7
    mova [rsp+gprsize*2+16*42], m4                        ;out39
    mova [rsp+gprsize*2+16*27], m2                        ;out24
    mova [rsp+gprsize*2+16*59], m0                        ;out56
    mova [rsp+gprsize*2+16*10], m3                        ;out7
    mova                    m0, [rsp+gprsize*2+16*26]     ;tmp[23]
    mova                    m1, [rsp+gprsize*2+16*11]     ;tmp[8 ]
    psubsw                  m2, m0, m6                    ;out40
    paddsw                  m0, m6                        ;out23
    psubsw                  m3, m1, m5                    ;out55
    paddsw                  m1, m5                        ;out8
    mova [rsp+gprsize*2+16*43], m2                        ;out40
    mova [rsp+gprsize*2+16*26], m0                        ;out23
    mova [rsp+gprsize*2+16*58], m3                        ;out55
    mova [rsp+gprsize*2+16*11], m1                        ;out8

    mova                    m0, [rsp+gprsize*2+16*37]     ;t34
    mova                    m2, [rsp+gprsize*2+16*48]     ;t45
    mova                    m3, [rsp+gprsize*2+16*53]     ;t50
    mova                    m1, [rsp+gprsize*2+16*64]     ;t61
    psubsw                  m4, m0, m2                    ;t45a
    paddsw                  m0, m2                        ;t34a
    psubsw                  m5, m1, m3                    ;t50a
    paddsw                  m1, m3                        ;t61a
    psubw                   m6, m5, m4                    ;t45
    paddw                   m5, m4                        ;t50
    mova                    m2, [rsp+gprsize*2+16*32]     ;tmp[29]
    mova                    m3, [rsp+gprsize*2+16*5 ]     ;tmp[2 ]
    pmulhrsw                m6, m7                        ;t45
    pmulhrsw                m5, m7                        ;t50
    psubsw                  m4, m2, m0                    ;out34
    paddsw                  m2, m0                        ;out29
    psubsw                  m0, m3, m1                    ;out61
    paddsw                  m3, m1                        ;out2
    mova [rsp+gprsize*2+16*37], m4                        ;out34
    mova [rsp+gprsize*2+16*32], m2                        ;out29
    mova [rsp+gprsize*2+16*64], m0                        ;out61
    mova [rsp+gprsize*2+16*5 ], m3                        ;out2
    mova                    m0, [rsp+gprsize*2+16*21]     ;tmp[18]
    mova                    m1, [rsp+gprsize*2+16*16]     ;tmp[13]
    psubsw                  m2, m0, m6                    ;out45
    paddsw                  m0, m6                        ;out18
    psubsw                  m3, m1, m5                    ;out50
    paddsw                  m1, m5                        ;out13
    mova [rsp+gprsize*2+16*48], m2                        ;out45
    mova [rsp+gprsize*2+16*21], m0                        ;out18
    mova [rsp+gprsize*2+16*53], m3                        ;out50
    mova [rsp+gprsize*2+16*16], m1                        ;out13

    mova                    m0, [rsp+gprsize*2+16*36]     ;t33a
    mova                    m2, [rsp+gprsize*2+16*49]     ;t46a
    mova                    m3, [rsp+gprsize*2+16*52]     ;t49a
    mova                    m1, [rsp+gprsize*2+16*65]     ;t62a
    psubsw                  m4, m0, m2                    ;t46
    paddsw                  m0, m2                        ;t33
    psubsw                  m5, m1, m3                    ;t49
    paddsw                  m1, m3                        ;t62
    psubw                   m6, m5, m4                    ;t46a
    paddw                   m5, m4                        ;t49a
    mova                    m2, [rsp+gprsize*2+16*33]     ;tmp[30]
    mova                    m3, [rsp+gprsize*2+16*4 ]     ;tmp[1 ]
    pmulhrsw                m6, m7                        ;t46a
    pmulhrsw                m5, m7                        ;t49a
    psubsw                  m4, m2, m0                    ;out33
    paddsw                  m2, m0                        ;out30
    psubsw                  m0, m3, m1                    ;out62
    paddsw                  m3, m1                        ;out1
    mova [rsp+gprsize*2+16*36], m4                        ;out33
    mova [rsp+gprsize*2+16*33], m2                        ;out30
    mova [rsp+gprsize*2+16*65], m0                        ;out62
    mova [rsp+gprsize*2+16*4 ], m3                        ;out1
    mova                    m0, [rsp+gprsize*2+16*20]     ;tmp[17]
    mova                    m1, [rsp+gprsize*2+16*17]     ;tmp[14]
    psubsw                  m2, m0, m6                    ;out46
    paddsw                  m0, m6                        ;out17
    psubsw                  m3, m1, m5                    ;out49
    paddsw                  m1, m5                        ;out14
    mova [rsp+gprsize*2+16*49], m2                        ;out46
    mova [rsp+gprsize*2+16*20], m0                        ;out17
    mova [rsp+gprsize*2+16*52], m3                        ;out49
    mova [rsp+gprsize*2+16*17], m1                        ;out14

    mova                    m0, [rsp+gprsize*2+16*35]     ;t32
    mova                    m2, [rsp+gprsize*2+16*50]     ;t47
    mova                    m3, [rsp+gprsize*2+16*51]     ;t48
    mova                    m1, [rsp+gprsize*2+16*66]     ;t63
    psubsw                  m4, m0, m2                    ;t47a
    paddsw                  m0, m2                        ;t32a
    psubsw                  m5, m1, m3                    ;t48a
    paddsw                  m1, m3                        ;t63a
    psubw                   m6, m5, m4                    ;t47
    paddw                   m5, m4                        ;t48
    mova                    m2, [rsp+gprsize*2+16*34]     ;tmp[31]
    mova                    m3, [rsp+gprsize*2+16*3 ]     ;tmp[0 ]
    pmulhrsw                m6, m7                        ;t47
    pmulhrsw                m5, m7                        ;t48
    psubsw                  m4, m2, m0                    ;out32
    paddsw                  m2, m0                        ;out31
    psubsw                  m0, m3, m1                    ;out63
    paddsw                  m3, m1                        ;out0
    mova [rsp+gprsize*2+16*35], m4                        ;out32
    mova [rsp+gprsize*2+16*34], m2                        ;out31
    mova [rsp+gprsize*2+16*66], m0                        ;out63
    mova [rsp+gprsize*2+16*3 ], m3                        ;out0
    mova                    m0, [rsp+gprsize*2+16*19]     ;tmp[16]
    mova                    m1, [rsp+gprsize*2+16*18]     ;tmp[15]
    psubsw                  m2, m0, m6                    ;out47
    paddsw                  m0, m6                        ;out16
    psubsw                  m3, m1, m5                    ;out48
    paddsw                  m1, m5                        ;out15
    mova [rsp+gprsize*2+16*50], m2                        ;out47
    mova [rsp+gprsize*2+16*19], m0                        ;out16
    mova [rsp+gprsize*2+16*51], m3                        ;out48
    mova [rsp+gprsize*2+16*18], m1                        ;out15
    ret



cglobal inv_txfm_add_dct_dct_64x16, 4, 6, 8, 16*132, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_64x16_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_8192)]
    mov               [coeffq], eobd
    mov                    r3d, 16
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_64x16).end)]

.body:
    pmulhrsw                m0, m2
    movd                    m2, [o(pw_2048)]  ;intentionally rip-relative
    pmulhrsw                m0, m1
    pmulhrsw                m0, m2
    pshuflw                 m0, m0, q0000
    punpcklwd               m0, m0
    pxor                    m7, m7

.loop:
    mova                    m1, [dstq+16*0]
    mova                    m3, [dstq+16*1]
    mova                    m5, [dstq+16*2]
    mova                    m6, [dstq+16*3]
    punpckhbw               m2, m1, m7
    punpcklbw               m1, m7
    punpckhbw               m4, m3, m7
    punpcklbw               m3, m7
    paddw                   m2, m0
    paddw                   m1, m0
    paddw                   m4, m0
    paddw                   m3, m0
    packuswb                m1, m2
    packuswb                m3, m4
    punpckhbw               m2, m5, m7
    punpcklbw               m5, m7
    punpckhbw               m4, m6, m7
    punpcklbw               m6, m7
    paddw                   m2, m0
    paddw                   m5, m0
    paddw                   m4, m0
    paddw                   m6, m0
    packuswb                m5, m2
    packuswb                m6, m4
    mova           [dstq+16*0], m1
    mova           [dstq+16*1], m3
    mova           [dstq+16*2], m5
    mova           [dstq+16*3], m6
    add                   dstq, strideq
    dec                    r3d
    jg .loop
    jmp                   tx2q

.end:
    RET


%macro LOAD_4ROWS 2-3 0 ;src, stride, is_rect2

%if %3
    mova                 m3, [o(pw_2896x8)]
    pmulhrsw             m0, m3, [%1+%2*0]
    pmulhrsw             m1, m3, [%1+%2*1]
    pmulhrsw             m2, m3, [%1+%2*2]
    pmulhrsw             m3, [%1+%2*3]
%else
    mova                 m0, [%1+%2*0]
    mova                 m1, [%1+%2*1]
    mova                 m2, [%1+%2*2]
    mova                 m3, [%1+%2*3]
%endif
%endmacro

%macro LOAD_4ROWS_H 2 ;src, stride
    mova                 m4, [%1+%2*0]
    mova                 m5, [%1+%2*1]
    mova                 m6, [%1+%2*2]
    mova                 m7, [%1+%2*3]
%endmacro

cglobal idct_64x16_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    mov                    r3d, 2
    mov  [rsp+gprsize*2+16*67], dstq
    lea                   dstq, [rsp+gprsize+16*68]

.pass1_loop:
    LOAD_4ROWS     coeffq+32*0, 32*8
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    pxor                    m4, m4
    LOAD_4ROWS     coeffq+32*4, 32*8

    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS     coeffq+32*2, 32*4
    mova   [rsp+gprsize+16*19], m0
    mova   [rsp+gprsize+16*26], m1
    mova   [rsp+gprsize+16*23], m2
    mova   [rsp+gprsize+16*22], m3
    mova   [rsp+gprsize+16*21], m4
    mova   [rsp+gprsize+16*24], m5
    mova   [rsp+gprsize+16*25], m6
    mova   [rsp+gprsize+16*20], m7

    call m(idct_8x32_internal).main_fast
    SAVE_8ROWS    rsp+gprsize+16*3, 16

    LOAD_8ROWS     coeffq+32*1, 32*2
    mova   [rsp+gprsize+16*35], m0                        ;in1
    mova   [rsp+gprsize+16*49], m1                        ;in3
    mova   [rsp+gprsize+16*43], m2                        ;in5
    mova   [rsp+gprsize+16*41], m3                        ;in7
    mova   [rsp+gprsize+16*39], m4                        ;in9
    mova   [rsp+gprsize+16*45], m5                        ;in11
    mova   [rsp+gprsize+16*47], m6                        ;in13
    mova   [rsp+gprsize+16*37], m7                        ;in15

    LOAD_8ROWS    coeffq+32*17, 32*2
    mova   [rsp+gprsize+16*63], m0                        ;in17
    mova   [rsp+gprsize+16*53], m1                        ;in19
    mova   [rsp+gprsize+16*55], m2                        ;in21
    mova   [rsp+gprsize+16*61], m3                        ;in23
    mova   [rsp+gprsize+16*59], m4                        ;in25
    mova   [rsp+gprsize+16*57], m5                        ;in27
    mova   [rsp+gprsize+16*51], m6                        ;in29
    mova   [rsp+gprsize+16*65], m7                        ;in31

    call m(idct_16x64_internal).main

    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS     coeffq+32*0, 32
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS     coeffq+32*8, 32
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end2:
    SAVE_8ROWS    coeffq+32*16, 32
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end3:
    SAVE_8ROWS    coeffq+32*24, 32
    LOAD_8ROWS   rsp+gprsize+16*35, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end4:
    SAVE_8ROWS       dstq+32*0, 32
    LOAD_8ROWS   rsp+gprsize+16*43, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end5)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end5:
    SAVE_8ROWS       dstq+32*8, 32
    LOAD_8ROWS   rsp+gprsize+16*51, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end6)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end6:
    SAVE_8ROWS      dstq+32*16, 32
    LOAD_8ROWS   rsp+gprsize+16*59, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x16_internal).pass1_end7)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end7:
    SAVE_8ROWS      dstq+32*24, 32

    add                 coeffq, 16
    add                   dstq, 16
    dec                    r3d
    jg .pass1_loop

.pass2:
    mov                   dstq, [rsp+gprsize*2+16*67]
    sub                 coeffq, 32
    mov                    r3d, 4

.pass2_loop:
    mov  [rsp+gprsize*1+16*67], r3d

    LOAD_4ROWS     coeffq+16*0, 32*2
    LOAD_4ROWS_H   coeffq+16*1, 32*2
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_4ROWS     coeffq+16*2, 32*2
    LOAD_4ROWS_H   coeffq+16*3, 32*2
    call m(idct_16x8_internal).main

    mov                    r3, dstq
    lea                  tx2q, [o(m(idct_64x16_internal).end)]
    lea                  dstq, [dstq+strideq*8]
    jmp  m(idct_8x8_internal).end

.end:
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova   [rsp+gprsize+16*0], m7
    lea                  tx2q, [o(m(idct_64x16_internal).end1)]
    mov                  dstq, r3
    jmp  m(idct_8x8_internal).end

.end1:
    pxor                   m7, m7
    REPX  {mova [coeffq+16*x], m7}, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15

    add                 coeffq, 16*16
    mov                    r3d, [rsp+gprsize*1+16*67]
    mov                   dstq, [rsp+gprsize*2+16*67]
    add                   dstq, 8
    mov  [rsp+gprsize*2+16*67], dstq
    dec                    r3d
    jg .pass2_loop

    mov                    r3d, 4
    lea                 coeffq, [rsp+gprsize+16*68]
.pass2_loop2:
    mov  [rsp+gprsize*1+16*67], r3d

    LOAD_4ROWS     coeffq+16*0, 32*2
    LOAD_4ROWS_H   coeffq+16*1, 32*2
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_4ROWS     coeffq+16*2, 32*2
    LOAD_4ROWS_H   coeffq+16*3, 32*2
    call m(idct_16x8_internal).main

    mov                    r3, dstq
    lea                  tx2q, [o(m(idct_64x16_internal).end2)]
    lea                  dstq, [dstq+strideq*8]
    jmp  m(idct_8x8_internal).end

.end2:
    LOAD_8ROWS   rsp+gprsize+16*3, 16
    mova   [rsp+gprsize+16*0], m7
    lea                  tx2q, [o(m(idct_64x16_internal).end3)]
    mov                  dstq, r3
    jmp  m(idct_8x8_internal).end

.end3:

    add                 coeffq, 16*16
    mov                    r3d, [rsp+gprsize*1+16*67]
    mov                   dstq, [rsp+gprsize*2+16*67]
    add                   dstq, 8
    mov  [rsp+gprsize*2+16*67], dstq
    dec                    r3d
    jg .pass2_loop2
    ret


cglobal inv_txfm_add_dct_dct_32x64, 4, 6, 8, 16*68, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_32x64_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_16384)]
    mov               [coeffq], eobd
    pmulhrsw                m0, m1
    mov                    r3d, 64
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_32x64).end)]
    jmp m(inv_txfm_add_dct_dct_32x8).body

.end:
    RET


cglobal idct_32x64_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r5, 4
    mov                     r4, 2
    sub                   eobd, 136
    cmovge                  r4, r5

%if ARCH_X86_32
    LEA                     r5, $$
%endif

    mov  [rsp+gprsize*1+16*67], eobd
    mov                     r3, r4
    mov  [rsp+gprsize*2+16*67], coeffq

.pass1_loop:
    LOAD_8ROWS     coeffq+64*1, 64*2, 1
    mova   [rsp+gprsize+16*19], m0                        ;in1
    mova   [rsp+gprsize+16*26], m1                        ;in3
    mova   [rsp+gprsize+16*23], m2                        ;in5
    mova   [rsp+gprsize+16*22], m3                        ;in7
    mova   [rsp+gprsize+16*21], m4                        ;in9
    mova   [rsp+gprsize+16*24], m5                        ;in11
    mova   [rsp+gprsize+16*25], m6                        ;in13
    mova   [rsp+gprsize+16*20], m7                        ;in15

    mov                   tx2d, [rsp+gprsize*1+16*67]
    test                  tx2d, tx2d
    jl .fast

.full:
    LOAD_8ROWS     coeffq+64*0, 64*4, 1
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_8ROWS     coeffq+64*2, 64*4, 1
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS    coeffq+64*17, 64*2, 1
    mova   [rsp+gprsize+16*33], m0                        ;in17
    mova   [rsp+gprsize+16*28], m1                        ;in19
    mova   [rsp+gprsize+16*29], m2                        ;in21
    mova   [rsp+gprsize+16*32], m3                        ;in23
    mova   [rsp+gprsize+16*31], m4                        ;in25
    mova   [rsp+gprsize+16*30], m5                        ;in27
    mova   [rsp+gprsize+16*27], m6                        ;in29
    mova   [rsp+gprsize+16*34], m7                        ;in31

    call m(idct_8x32_internal).main
    jmp .pass1_end

.fast:
    LOAD_4ROWS          coeffq, 256, 1
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main

    SAVE_7ROWS    rsp+gprsize+16*3, 16
    LOAD_4ROWS    coeffq+128*1, 256, 1
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    call m(idct_8x32_internal).main_fast

.pass1_end:
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_32x64_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end1:
    SAVE_8ROWS     coeffq+64*0, 64
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_32x64_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end2:
    SAVE_8ROWS     coeffq+64*8, 64
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_32x64_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end3:
    SAVE_8ROWS    coeffq+64*16, 64
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_32x64_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end4:
    SAVE_8ROWS    coeffq+64*24, 64

    add                 coeffq, 16
    dec                     r3
    jg .pass1_loop

.pass2:
    mov                 coeffq, [rsp+gprsize*2+16*67]
    mov                     r3, 4
    lea                     r4, [dstq+8]
    mov  [rsp+gprsize*2+16*67], r4
    lea                     r4, [o(m(idct_16x64_internal).end1)]
    jmp m(idct_16x64_internal).pass2_loop


cglobal inv_txfm_add_dct_dct_64x32, 4, 6, 8, 16*197, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_64x32_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_16384)]
    pmulhrsw                m0, m1
    mov               [coeffq], eobd
    mov                    r3d, 32
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_64x32).end)]
    jmp m(inv_txfm_add_dct_dct_64x16).body

.end:
    RET

cglobal idct_64x32_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r5, 4
    mov                     r4, 2
    sub                   eobd, 136
    cmovge                  r4, r5

%if ARCH_X86_32
    LEA                     r5, $$
%endif

    mov  [rsp+gprsize*1+16*67], eobd
    mov                     r3, r4
    mov  [rsp+gprsize*2+16*67], coeffq
    mov  [rsp+gprsize*3+16*67], dstq
    lea                   dstq, [rsp+gprsize+16*69]
    mov  [rsp+gprsize*4+16*67], dstq

.pass1_loop:
    LOAD_4ROWS     coeffq+64*0, 64*8, 1
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    pxor                    m4, m4
    LOAD_4ROWS     coeffq+64*4, 64*8, 1

    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS     coeffq+64*2, 64*4, 1
    mova   [rsp+gprsize+16*19], m0
    mova   [rsp+gprsize+16*26], m1
    mova   [rsp+gprsize+16*23], m2
    mova   [rsp+gprsize+16*22], m3
    mova   [rsp+gprsize+16*21], m4
    mova   [rsp+gprsize+16*24], m5
    mova   [rsp+gprsize+16*25], m6
    mova   [rsp+gprsize+16*20], m7

    call m(idct_8x32_internal).main_fast
    SAVE_8ROWS    rsp+gprsize+16*3, 16

    LOAD_8ROWS     coeffq+64*1, 64*2, 1
    mova   [rsp+gprsize+16*35], m0                        ;in1
    mova   [rsp+gprsize+16*49], m1                        ;in3
    mova   [rsp+gprsize+16*43], m2                        ;in5
    mova   [rsp+gprsize+16*41], m3                        ;in7
    mova   [rsp+gprsize+16*39], m4                        ;in9
    mova   [rsp+gprsize+16*45], m5                        ;in11
    mova   [rsp+gprsize+16*47], m6                        ;in13
    mova   [rsp+gprsize+16*37], m7                        ;in15

    LOAD_8ROWS    coeffq+64*17, 64*2, 1
    mova   [rsp+gprsize+16*63], m0                        ;in17
    mova   [rsp+gprsize+16*53], m1                        ;in19
    mova   [rsp+gprsize+16*55], m2                        ;in21
    mova   [rsp+gprsize+16*61], m3                        ;in23
    mova   [rsp+gprsize+16*59], m4                        ;in25
    mova   [rsp+gprsize+16*57], m5                        ;in27
    mova   [rsp+gprsize+16*51], m6                        ;in29
    mova   [rsp+gprsize+16*65], m7                        ;in31

    call m(idct_16x64_internal).main

    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end:
    SAVE_8ROWS     coeffq+64*0, 64
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end1:
    SAVE_8ROWS     coeffq+64*8, 64
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end2:
    SAVE_8ROWS    coeffq+64*16, 64
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end3:
    SAVE_8ROWS    coeffq+64*24, 64
    LOAD_8ROWS   rsp+gprsize+16*35, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end4:
    SAVE_8ROWS       dstq+64*0, 64
    LOAD_8ROWS   rsp+gprsize+16*43, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end5)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end5:
    SAVE_8ROWS       dstq+64*8, 64
    LOAD_8ROWS   rsp+gprsize+16*51, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end6)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end6:
    SAVE_8ROWS      dstq+64*16, 64
    LOAD_8ROWS   rsp+gprsize+16*59, 16
    mova    [rsp+gprsize+16*0], m7
    lea                   tx2q, [o(m(idct_64x32_internal).pass1_end7)]
    jmp   m(idct_8x8_internal).pass1_end

.pass1_end7:
    SAVE_8ROWS      dstq+64*24, 64

    add                 coeffq, 16
    add                   dstq, 16
    dec                     r3
    jg .pass1_loop

.pass2:
    mov                 coeffq, [rsp+gprsize*4+16*67]
    mov                   dstq, [rsp+gprsize*3+16*67]
    mov                   eobd, [rsp+gprsize*1+16*67]
    lea                   dstq, [dstq+32]
    mov  [rsp+gprsize*1+16*35], eobd
    lea                   tx2q, [o(m(idct_64x32_internal).pass2_end)]
    mov                     r3, 4
    jmp m(idct_32x32_internal).pass2_loop

.pass2_end:
    mova    [rsp+gprsize+16*0], m7
    lea                     r3, [o(m(idct_64x32_internal).pass2_end1)]
    jmp  m(idct_8x32_internal).end2

.pass2_end1:
    lea                   tx2q, [o(m(idct_64x32_internal).pass2_end)]
    add                 coeffq, 16*32
    mov                   dstq, [rsp+gprsize*2+16*35]
    mov                     r3, [rsp+gprsize*3+16*35]
    dec                     r3
    jg m(idct_32x32_internal).pass2_loop

.pass2_end2:
    mov                   dstq, [rsp+gprsize*3+16*67]
    mov                 coeffq, [rsp+gprsize*2+16*67]
    lea                   tx2q, [o(m(idct_32x32_internal).pass2_end)]
    mov                     r3, 4
    jmp m(idct_32x32_internal).pass2_loop


cglobal inv_txfm_add_dct_dct_64x64, 4, 6, 8, 16*197, dst, stride, coeff, eob, tx2
%if ARCH_X86_32
    LEA                     r5, $$
%endif
    test                  eobd, eobd
    jz .dconly

    call m(idct_64x64_internal)
    RET

.dconly:
    movd                    m1, [o(pw_2896x8)]
    pmulhrsw                m0, m1, [coeffq]
    movd                    m2, [o(pw_8192)]
    mov               [coeffq], eobd
    mov                    r3d, 64
    lea                   tx2q, [o(m(inv_txfm_add_dct_dct_64x32).end)]
    jmp m(inv_txfm_add_dct_dct_64x16).body

cglobal idct_64x64_internal, 0, 0, 0, dst, stride, coeff, eob, tx2
    %undef cmp

    mov                     r5, 4
    mov                     r4, 2
    sub                   eobd, 136
    cmovge                  r4, r5

%if ARCH_X86_32
    LEA                     r5, $$
%endif

    mov  [rsp+gprsize*1+16*67], eobd
    mov                     r3, r4
    mov  [rsp+gprsize*4+16*67], coeffq
    mov  [rsp+gprsize*3+16*67], dstq
    lea                   dstq, [rsp+gprsize+16*69]
    mov  [rsp+gprsize*2+16*67], dstq

.pass1_loop:
    LOAD_4ROWS     coeffq+64*0, 64*8
    pxor                    m4, m4
    REPX          {mova x, m4}, m5, m6, m7
    call  m(idct_8x8_internal).main
    SAVE_7ROWS    rsp+gprsize+16*3, 16

    pxor                    m4, m4
    LOAD_4ROWS     coeffq+64*4, 64*8

    REPX          {mova x, m4}, m5, m6, m7
    call m(idct_16x8_internal).main
    mova                    m7, [rsp+gprsize+16*0]
    SAVE_8ROWS   rsp+gprsize+16*11, 16

    LOAD_8ROWS     coeffq+64*2, 64*4
    mova   [rsp+gprsize+16*19], m0
    mova   [rsp+gprsize+16*26], m1
    mova   [rsp+gprsize+16*23], m2
    mova   [rsp+gprsize+16*22], m3
    mova   [rsp+gprsize+16*21], m4
    mova   [rsp+gprsize+16*24], m5
    mova   [rsp+gprsize+16*25], m6
    mova   [rsp+gprsize+16*20], m7

    call m(idct_8x32_internal).main_fast
    SAVE_8ROWS    rsp+gprsize+16*3, 16

    LOAD_8ROWS     coeffq+64*1, 64*2
    mova   [rsp+gprsize+16*35], m0                        ;in1
    mova   [rsp+gprsize+16*49], m1                        ;in3
    mova   [rsp+gprsize+16*43], m2                        ;in5
    mova   [rsp+gprsize+16*41], m3                        ;in7
    mova   [rsp+gprsize+16*39], m4                        ;in9
    mova   [rsp+gprsize+16*45], m5                        ;in11
    mova   [rsp+gprsize+16*47], m6                        ;in13
    mova   [rsp+gprsize+16*37], m7                        ;in15

    LOAD_8ROWS    coeffq+64*17, 64*2
    mova   [rsp+gprsize+16*63], m0                        ;in17
    mova   [rsp+gprsize+16*53], m1                        ;in19
    mova   [rsp+gprsize+16*55], m2                        ;in21
    mova   [rsp+gprsize+16*61], m3                        ;in23
    mova   [rsp+gprsize+16*59], m4                        ;in25
    mova   [rsp+gprsize+16*57], m5                        ;in27
    mova   [rsp+gprsize+16*51], m6                        ;in29
    mova   [rsp+gprsize+16*65], m7                        ;in31

    call m(idct_16x64_internal).main

    LOAD_8ROWS    rsp+gprsize+16*3, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end:
    SAVE_8ROWS     coeffq+64*0, 64
    LOAD_8ROWS   rsp+gprsize+16*11, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end1)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end1:
    SAVE_8ROWS     coeffq+64*8, 64
    LOAD_8ROWS   rsp+gprsize+16*19, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end2)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end2:
    SAVE_8ROWS    coeffq+64*16, 64
    LOAD_8ROWS   rsp+gprsize+16*27, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end3)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end3:
    SAVE_8ROWS    coeffq+64*24, 64
    LOAD_8ROWS   rsp+gprsize+16*35, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end4)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end4:
    SAVE_8ROWS       dstq+64*0, 64
    LOAD_8ROWS   rsp+gprsize+16*43, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end5)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end5:
    SAVE_8ROWS       dstq+64*8, 64
    LOAD_8ROWS   rsp+gprsize+16*51, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end6)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end6:
    SAVE_8ROWS      dstq+64*16, 64
    LOAD_8ROWS   rsp+gprsize+16*59, 16
    mova    [rsp+gprsize+16*0], m7
    mova                    m7, [o(pw_8192)]
    lea                   tx2q, [o(m(idct_64x64_internal).pass1_end7)]
    jmp   m(idct_8x8_internal).pass1_end1

.pass1_end7:
    SAVE_8ROWS      dstq+64*24, 64

    add                 coeffq, 16
    add                   dstq, 16
    dec                     r3
    jg .pass1_loop

.pass2:
    mov                   dstq, [rsp+gprsize*3+16*67]
    mov                 coeffq, [rsp+gprsize*2+16*67]
    lea                   dstq, [dstq+32]
    mov                     r3, 4
    lea                     r4, [dstq+8]
    mov  [rsp+gprsize*2+16*67], r4
    lea                     r4, [o(m(idct_64x64_internal).pass2_end)]
    jmp m(idct_16x64_internal).pass2_loop

.pass2_end:
    LOAD_8ROWS   rsp+gprsize+16*35, 16
    lea                   dstq, [dstq+strideq*2]
    add                    rsp, 16*32
    mova    [rsp+gprsize+16*0], m7
    lea                     r3, [o(m(idct_64x64_internal).pass2_end1)]
    jmp  m(idct_8x32_internal).end2

.pass2_end1:
    add                 coeffq, 16*32
    sub                    rsp, 16*32

    mov                   dstq, [rsp+gprsize*2+16*67]
    mov                     r3, [rsp+gprsize*3+16*67]
    lea                     r4, [dstq+8]
    mov  [rsp+gprsize*2+16*67], r4
    lea                     r4, [o(m(idct_64x64_internal).pass2_end)]

    dec                     r3
    jg  m(idct_16x64_internal).pass2_loop

.pass2_end2:
    mov                 coeffq, [rsp+gprsize*4+16*67]
    mov                   dstq, [rsp+gprsize*2+16*67]
    mov                     r3, 4
    sub                   dstq, 72
    lea                     r4, [dstq+8]
    mov  [rsp+gprsize*2+16*67], r4
    lea                     r4, [o(m(idct_16x64_internal).end1)]
    jmp m(idct_16x64_internal).pass2_loop
