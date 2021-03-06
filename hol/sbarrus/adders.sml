(* adders.sml
 *
 * HOL-style netlist of all of the adder circuits 
 *
 * Steve Barrus
 * CS 6110
 *)

(* 16-bit ripple-carry adder circuit *)
val RIPPLE_ADD16_DEF = Define `RIPPLE_ADD16(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,
    A_9,A_10,A_11,A_12,A_13,A_14,A_15,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,
    B_10,B_11,B_12,B_13,B_14,B_15,Cin,Cout,S_0,S_1,S_2,S_3,S_4,S_5,S_6,S_7,S_8,
    S_9,S_10,S_11,S_12,S_13,S_14,S_15) = 
        ?n0 n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12 n13 n14.
        FULLADDER_STR(Cin,A_0,B_0,S_0,n0) /\ 
        FULLADDER_STR(n0,A_1,B_1,S_1,n1) /\
        FULLADDER_STR(n1,A_2,B_2,S_2,n2) /\ 
        FULLADDER_STR(n2,A_3,B_3,S_3,n3) /\
        FULLADDER_STR(n3,A_4,B_4,S_4,n4) /\ 
        FULLADDER_STR(n4,A_5,B_5,S_5,n5) /\
        FULLADDER_STR(n5,A_6,B_6,S_6,n6) /\ 
        FULLADDER_STR(n6,A_7,B_7,S_7,n7) /\
        FULLADDER_STR(n7,A_8,B_8,S_8,n8) /\ 
        FULLADDER_STR(n8,A_9,B_9,S_9,n9) /\
        FULLADDER_STR(n9,A_10,B_10,S_10,n10) /\ 
        FULLADDER_STR(n10,A_11,B_11,S_11,n11) /\
        FULLADDER_STR(n11,A_12,B_12,S_12,n12) /\ 
        FULLADDER_STR(n12,A_13,B_13,S_13,n13) /\
        FULLADDER_STR(n13,A_14,B_14,S_14,n14) /\ 
        FULLADDER_STR(n14,A_15,B_15,S_15,Cout)`;

(* 32-bit ripple-carry adder circuit *)
val RIPPLE_ADD32_DEF = Define `RIPPLE_ADD32(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,
    A_9,A_10,A_11,A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,A_20,A_21,A_22,A_23,
    A_24,A_25,A_26,A_27,A_28,A_29,A_30,A_31,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,
    B_9,B_10,B_11,B_12,B_13,B_14,B_15,B_16,B_17,B_18,B_19,B_20,B_21,B_22,B_23,
    B_24,B_25,B_26,B_27,B_28,B_29,B_30,B_31,Cin,Cout,S_0,S_1,S_2,S_3,S_4,S_5,
    S_6,S_7,S_8,S_9,S_10,S_11,S_12,S_13,S_14,S_15,S_16,S_17,S_18,S_19,S_20,S_21,
    S_22,S_23,S_24,S_25,S_26,S_27,S_28,S_29,S_30,S_31) = 
        ?n0 n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12 n13 n14 n15 n16 n17 n18 n19 
         n20 n21 n22 n23 n24 n25 n26 n27 n28 n29 n30.
        FULLADDER_STR(Cin,A_0,B_0,S_0,n0) /\ 
        FULLADDER_STR(n0,A_1,B_1,S_1,n1) /\
        FULLADDER_STR(n1,A_2,B_2,S_2,n2) /\ 
        FULLADDER_STR(n2,A_3,B_3,S_3,n3) /\
        FULLADDER_STR(n3,A_4,B_4,S_4,n4) /\ 
        FULLADDER_STR(n4,A_5,B_5,S_5,n5) /\
        FULLADDER_STR(n5,A_6,B_6,S_6,n6) /\ 
        FULLADDER_STR(n6,A_7,B_7,S_7,n7) /\
        FULLADDER_STR(n7,A_8,B_8,S_8,n8) /\ 
        FULLADDER_STR(n8,A_9,B_9,S_9,n9) /\
        FULLADDER_STR(n9,A_10,B_10,S_10,n10) /\ 
        FULLADDER_STR(n10,A_11,B_11,S_11,n11) /\
        FULLADDER_STR(n11,A_12,B_12,S_12,n12) /\ 
        FULLADDER_STR(n12,A_13,B_13,S_13,n13) /\
        FULLADDER_STR(n13,A_14,B_14,S_14,n14) /\ 
        FULLADDER_STR(n14,A_15,B_15,S_15,n15) /\
        FULLADDER_STR(n15,A_16,B_16,S_16,n16) /\ 
        FULLADDER_STR(n16,A_17,B_17,S_17,n17) /\
        FULLADDER_STR(n17,A_18,B_18,S_18,n18) /\ 
        FULLADDER_STR(n18,A_19,B_19,S_19,n19) /\
        FULLADDER_STR(n19,A_20,B_20,S_20,n20) /\ 
        FULLADDER_STR(n20,A_21,B_21,S_21,n21) /\
        FULLADDER_STR(n21,A_22,B_22,S_22,n22) /\ 
        FULLADDER_STR(n22,A_23,B_23,S_23,n23) /\
        FULLADDER_STR(n23,A_24,B_24,S_24,n24) /\ 
        FULLADDER_STR(n24,A_25,B_25,S_25,n25) /\
        FULLADDER_STR(n25,A_26,B_26,S_26,n26) /\ 
        FULLADDER_STR(n26,A_27,B_27,S_27,n27) /\
        FULLADDER_STR(n27,A_28,B_28,S_28,n28) /\ 
        FULLADDER_STR(n28,A_29,B_29,S_29,n29) /\
        FULLADDER_STR(n29,A_30,B_30,S_30,n30) /\ 
        FULLADDER_STR(n30,A_31,B_31,S_31,Cout)`;

(* 16-bit Ladner-Fischer adder circuit (generated by holnetlist) *)
val LADNER_FISCHER16_DEF = Define `LadnerFischer16(A_0,A_1,A_2,A_3,A_4,A_5,A_6,
    A_7,A_8,A_9,A_10,A_11,A_12,A_13,A_14,A_15,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,
    B_8,B_9,B_10,B_11,B_12,B_13,B_14,B_15,Cin,Cout,S_0,S_1,S_2,S_3,S_4,S_5,S_6,
    S_7,S_8,S_9,S_10,S_11,S_12,S_13,S_14,S_15) = 
?r2c1 r6c2 r3c3 r6c4 r4c5 r6c6 r4c7 r6c8 r5c9 r6c10 r5c11 r6c12 r5c13 r6c14 
 r5c15 r1c10_0 r1c10_1 r1c11_0 r1c11_1 r1c12_0 r1c12_1 r1c13_0 r1c13_1 r1c14_0 
 r1c14_1 r1c15_0 r1c15_1 r1c16_0 r1c16_1 r1c1_0 r1c1_1 r1c2_0 r1c2_1 r1c3_0 r1c3_1 
 r1c4_0 r1c4_1 r1c5_0 r1c5_1 r1c6_0 r1c6_1 r1c7_0 r1c7_1 r1c8_0 r1c8_1 r1c9_0 
 r1c9_1 r2c11_0 r2c11_1 r2c13_0 r2c13_1 r2c15_0 r2c15_1 r2c3_0 r2c3_1 r2c5_0 
 r2c5_1 r2c7_0 r2c7_1 r2c9_0 r2c9_1 r3c11_0 r3c11_1 r3c15_0 r3c15_1 r3c7_0 r3c7_1 
 r4c13_0 r4c13_1 r4c15_0 r4c15_1.
    black(r1c11_0,r1c11_1,r1c10_0,r1c10_1,r2c11_0,r2c11_1) /\ 
    pg16(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10,A_11,A_12,A_13,A_14,A_15,
         B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,B_10,B_11,B_12,B_13,B_14,B_15,
         r1c1_0,r1c1_1,r1c2_0,r1c2_1,r1c3_0,r1c3_1,r1c4_0,r1c4_1,r1c5_0,r1c5_1,
         r1c6_0,r1c6_1,r1c7_0,r1c7_1,r1c8_0,r1c8_1,r1c9_0,r1c9_1,r1c10_0,
         r1c10_1,r1c11_0,r1c11_1,r1c12_0,r1c12_1,r1c13_0,r1c13_1,r1c14_0,
         r1c14_1,r1c15_0,r1c15_1,r1c16_0,r1c16_1) /\ 
    gray(r1c6_0,r1c6_1,r4c5,r6c6) /\ 
    gray(r1c12_0,r1c12_1,r5c11,r6c12) /\ 
    gray(r1c16_0,r1c16_1,r5c15,Cout) /\ 
    gray(r1c14_0,r1c14_1,r5c13,r6c14) /\ 
    gray(r3c11_0,r3c11_1,r4c7,r5c11) /\ 
    black(r3c15_0,r3c15_1,r3c11_0,r3c11_1,r4c15_0,r4c15_1) /\ 
    black(r1c3_0,r1c3_1,r1c2_0,r1c2_1,r2c3_0,r2c3_1) /\ 
    gray(r2c3_0,r2c3_1,r2c1,r3c3) /\ 
    gray(r4c15_0,r4c15_1,r4c7,r5c15) /\ 
    black(r2c15_0,r2c15_1,r2c13_0,r2c13_1,r3c15_0,r3c15_1) /\ 
    gray(r4c13_0,r4c13_1,r4c7,r5c13) /\ 
    gray(r1c10_0,r1c10_1,r5c9,r6c10) /\ 
    gray(r2c9_0,r2c9_1,r4c7,r5c9) /\ 
    gray(r3c7_0,r3c7_1,r3c3,r4c7) /\ 
    black(r2c7_0,r2c7_1,r2c5_0,r2c5_1,r3c7_0,r3c7_1) /\ 
    black(r1c7_0,r1c7_1,r1c6_0,r1c6_1,r2c7_0,r2c7_1) /\ 
    xor16(r5c15,r6c14,r5c13,r6c12,r5c11,r6c10,r5c9,r6c8,r4c7,r6c6,r4c5,r6c4,
          r3c3,r6c2,r2c1,Cin,r1c16_1,r1c15_1,r1c14_1,r1c13_1,r1c12_1,r1c11_1,
          r1c10_1,r1c9_1,r1c8_1,r1c7_1,r1c6_1,r1c5_1,r1c4_1,r1c3_1,r1c2_1,
          r1c1_1,S_15,S_14,S_13,S_12,S_11,S_10,S_9,S_8,S_7,S_6,S_5,S_4,S_3,
          S_2,S_1,S_0) /\ 
    gray(r1c4_0,r1c4_1,r3c3,r6c4) /\ 
    black(r2c13_0,r2c13_1,r3c11_0,r3c11_1,r4c13_0,r4c13_1) /\ 
    black(r1c13_0,r1c13_1,r1c12_0,r1c12_1,r2c13_0,r2c13_1) /\ 
    gray(r2c5_0,r2c5_1,r3c3,r4c5) /\ 
    gray(r1c8_0,r1c8_1,r4c7,r6c8) /\ 
    black(r1c15_0,r1c15_1,r1c14_0,r1c14_1,r2c15_0,r2c15_1) /\ 
    black(r1c9_0,r1c9_1,r1c8_0,r1c8_1,r2c9_0,r2c9_1) /\ 
    gray(r1c1_0,r1c1_1,Cin,r2c1) /\ 
    black(r1c5_0,r1c5_1,r1c4_0,r1c4_1,r2c5_0,r2c5_1) /\ 
    gray(r1c2_0,r1c2_1,r2c1,r6c2) /\ 
    black(r2c11_0,r2c11_1,r2c9_0,r2c9_1,r3c11_0,r3c11_1)`;

(* 32-bit Ladner-Fischer adder circuit (generated by holnetlist) *)
val LADNER_FISCHER32_DEF = Define `LadnerFischer32(A_0,A_1,A_2,A_3,A_4,A_5,A_6,
    A_7,A_8,A_9,A_10,A_11,A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,A_20,A_21,
    A_22,A_23,A_24,A_25,A_26,A_27,A_28,A_29,A_30,A_31,B_0,B_1,B_2,B_3,B_4,B_5,
    B_6,B_7,B_8,B_9,B_10,B_11,B_12,B_13,B_14,B_15,B_16,B_17,B_18,B_19,B_20,B_21,
    B_22,B_23,B_24,B_25,B_26,B_27,B_28,B_29,B_30,B_31,Cin,Cout,S_0,S_1,S_2,S_3,
    S_4,S_5,S_6,S_7,S_8,S_9,S_10,S_11,S_12,S_13,S_14,S_15,S_16,S_17,S_18,S_19,
    S_20,S_21,S_22,S_23,S_24,S_25,S_26,S_27,S_28,S_29,S_30,S_31) = 
      ?r2c23_0 r2c23_1 r5c9 r7c2 r7c16 r1c21_0 r1c21_1 r2c13_0 r2c13_1 r1c28_0 
       r1c28_1 r4c13_0 r4c13_1 r7c10 r7c24 r7c4 r7c26 r5c15 r4c7 r1c26_0 r1c26_1 
       r4c21_0 r4c21_1 r1c4_0 r1c4_1 r4c31_0 r4c31_1 r1c20_0 r1c20_1 r5c31_0 
       r5c31_1 r4c23_0 r4c23_1 r2c21_0 r2c21_1 r1c27_0 r1c27_1 r6c25 r1c29_0 
       r1c29_1 r5c29_0 r5c29_1 r4c5 r7c20 r7c28 r7c8 r1c11_0 r1c11_1 r5c25_0 
       r5c25_1 r1c17_0 r1c17_1 r1c16_0 r1c16_1 r2c19_0 r2c19_1 r6c21 r7c18 
       r1c19_0 r1c19_1 r3c19_0 r3c19_1 r1c9_0 r1c9_1 r4c29_0 r4c29_1 r1c31_0 
       r1c31_1 r1c6_0 r1c6_1 r1c5_0 r1c5_1 r7c12 r1c30_0 r1c30_1 r4c15_0 r4c15_1 
       r3c23_0 r3c23_1 r1c25_0 r1c25_1 r2c29_0 r2c29_1 r6c19 r1c23_0 r1c23_1 
       r1c12_0 r1c12_1 r5c27_0 r5c27_1 r2c25_0 r2c25_1 r3c31_0 r3c31_1 r1c8_0 
       r1c8_1 r1c18_0 r1c18_1 r1c7_0 r1c7_1 r2c1 r6c17 r2c31_0 r2c31_1 r6c29 
       r1c13_0 r1c13_1 r1c22_0 r1c22_1 r2c7_0 r2c7_1 r1c15_0 r1c15_1 r1c14_0 
       r1c14_1 r1c10_0 r1c10_1 r1c3_0 r1c3_1 r2c15_0 r2c15_1 r3c7_0 r3c7_1 
       r1c24_0 r1c24_1 r2c5_0 r2c5_1 r2c27_0 r2c27_1 r5c11 r1c32_0 r1c32_1 
       r7c22 r6c23 r1c2_0 r1c2_1 r2c3_0 r2c3_1 r7c30 r1c1_0 r1c1_1 r3c11_0 
       r3c11_1 r3c3 r7c6 r6c27 r2c17_0 r2c17_1 r7c14 r2c11_0 r2c11_1 r3c27_0 
       r3c27_1 r6c31 r2c9_0 r2c9_1 r3c15_0 r3c15_1 r5c13.
black(r2c31_0,r2c31_1,r2c29_0,r2c29_1,r3c31_0,r3c31_1) /\ 
gray(r1c12_0,r1c12_1,r5c11,r7c12) /\ 
gray(r3c19_0,r3c19_1,r5c15,r6c19) /\ 
black(r2c19_0,r2c19_1,r2c17_0,r2c17_1,r3c19_0,r3c19_1) /\ 
black(r3c15_0,r3c15_1,r3c11_0,r3c11_1,r4c15_0,r4c15_1) /\ 
gray(r4c21_0,r4c21_1,r5c15,r6c21) /\ 
black(r1c23_0,r1c23_1,r1c22_0,r1c22_1,r2c23_0,r2c23_1) /\ 
gray(r1c24_0,r1c24_1,r6c23,r7c24) /\ 
black(r3c23_0,r3c23_1,r3c19_0,r3c19_1,r4c23_0,r4c23_1) /\ 
gray(r4c13_0,r4c13_1,r4c7,r5c13) /\ 
black(r1c17_0,r1c17_1,r1c16_0,r1c16_1,r2c17_0,r2c17_1) /\ 
black(r2c7_0,r2c7_1,r2c5_0,r2c5_1,r3c7_0,r3c7_1) /\ 
black(r1c7_0,r1c7_1,r1c6_0,r1c6_1,r2c7_0,r2c7_1) /\ 
black(r2c13_0,r2c13_1,r3c11_0,r3c11_1,r4c13_0,r4c13_1) /\ 
black(r1c21_0,r1c21_1,r1c20_0,r1c20_1,r2c21_0,r2c21_1) /\ 
black(r1c31_0,r1c31_1,r1c30_0,r1c30_1,r2c31_0,r2c31_1) /\ 
gray(r1c20_0,r1c20_1,r6c19,r7c20) /\ 
black(r3c31_0,r3c31_1,r3c27_0,r3c27_1,r4c31_0,r4c31_1) /\ 
pg32(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10,A_11,A_12,A_13,A_14,A_15,A_16,
     A_17,A_18,A_19,A_20,A_21,A_22,A_23,A_24,A_25,A_26,A_27,A_28,A_29,A_30,A_31,
     B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,B_10,B_11,B_12,B_13,B_14,B_15,B_16,
     B_17,B_18,B_19,B_20,B_21,B_22,B_23,B_24,B_25,B_26,B_27,B_28,B_29,B_30,B_31,
     r1c1_0,r1c1_1,r1c2_0,r1c2_1,r1c3_0,r1c3_1,r1c4_0,r1c4_1,r1c5_0,r1c5_1,
     r1c6_0,r1c6_1,r1c7_0,r1c7_1,r1c8_0,r1c8_1,r1c9_0,r1c9_1,r1c10_0,r1c10_1,
     r1c11_0,r1c11_1,r1c12_0,r1c12_1,r1c13_0,r1c13_1,r1c14_0,r1c14_1,r1c15_0,
     r1c15_1,r1c16_0,r1c16_1,r1c17_0,r1c17_1,r1c18_0,r1c18_1,r1c19_0,r1c19_1,
     r1c20_0,r1c20_1,r1c21_0,r1c21_1,r1c22_0,r1c22_1,r1c23_0,r1c23_1,r1c24_0,
     r1c24_1,r1c25_0,r1c25_1,r1c26_0,r1c26_1,r1c27_0,r1c27_1,r1c28_0,r1c28_1,
     r1c29_0,r1c29_1,r1c30_0,r1c30_1,r1c31_0,r1c31_1,r1c32_0,r1c32_1) /\
black(r2c29_0,r2c29_1,r3c27_0,r3c27_1,r4c29_0,r4c29_1) /\ 
gray(r3c11_0,r3c11_1,r4c7,r5c11) /\ 
black(r4c31_0,r4c31_1,r4c23_0,r4c23_1,r5c31_0,r5c31_1) /\ 
gray(r1c10_0,r1c10_1,r5c9,r7c10) /\ 
gray(r1c16_0,r1c16_1,r5c15,r7c16) /\ 
gray(r3c7_0,r3c7_1,r3c3,r4c7) /\ 
black(r2c23_0,r2c23_1,r2c21_0,r2c21_1,r3c23_0,r3c23_1) /\ 
gray(r2c5_0,r2c5_1,r3c3,r4c5) /\ 
black(r1c15_0,r1c15_1,r1c14_0,r1c14_1,r2c15_0,r2c15_1) /\ 
black(r1c27_0,r1c27_1,r1c26_0,r1c26_1,r2c27_0,r2c27_1) /\ 
black(r4c29_0,r4c29_1,r4c23_0,r4c23_1,r5c29_0,r5c29_1) /\ 
gray(r1c18_0,r1c18_1,r6c17,r7c18) /\ 
gray(r2c17_0,r2c17_1,r5c15,r6c17) /\ 
gray(r5c29_0,r5c29_1,r5c15,r6c29) /\ 
black(r1c9_0,r1c9_1,r1c8_0,r1c8_1,r2c9_0,r2c9_1) /\ 
black(r3c27_0,r3c27_1,r4c23_0,r4c23_1,r5c27_0,r5c27_1) /\ 
gray(r1c1_0,r1c1_1,Cin,r2c1) /\ 
gray(r1c2_0,r1c2_1,r2c1,r7c2) /\ 
black(r2c11_0,r2c11_1,r2c9_0,r2c9_1,r3c11_0,r3c11_1) /\ 
gray(r1c22_0,r1c22_1,r6c21,r7c22) /\ 
black(r1c11_0,r1c11_1,r1c10_0,r1c10_1,r2c11_0,r2c11_1) /\ 
gray(r1c14_0,r1c14_1,r5c13,r7c14) /\ 
black(r1c3_0,r1c3_1,r1c2_0,r1c2_1,r2c3_0,r2c3_1) /\ 
gray(r2c3_0,r2c3_1,r2c1,r3c3) /\ 
gray(r1c30_0,r1c30_1,r6c29,r7c30) /\ 
black(r1c25_0,r1c25_1,r1c24_0,r1c24_1,r2c25_0,r2c25_1) /\ 
black(r2c21_0,r2c21_1,r3c19_0,r3c19_1,r4c21_0,r4c21_1) /\ 
black(r1c13_0,r1c13_1,r1c12_0,r1c12_1,r2c13_0,r2c13_1) /\ 
gray(r5c25_0,r5c25_1,r5c15,r6c25) /\ 
xor32(r6c31,r7c30,r6c29,r7c28,r6c27,r7c26,r6c25,r7c24,r6c23,r7c22,r6c21,r7c20,
      r6c19,r7c18,r6c17,r7c16,r5c15,r7c14,r5c13,r7c12,r5c11,r7c10,r5c9,r7c8,
      r4c7,r7c6,r4c5,r7c4,r3c3,r7c2,r2c1,Cin,r1c32_1,r1c31_1,r1c30_1,r1c29_1,
      r1c28_1,r1c27_1,r1c26_1,r1c25_1,r1c24_1,r1c23_1,r1c22_1,r1c21_1,r1c20_1,
      r1c19_1,r1c18_1,r1c17_1,r1c16_1,r1c15_1,r1c14_1,r1c13_1,r1c12_1,r1c11_1,
      r1c10_1,r1c9_1,r1c8_1,r1c7_1,r1c6_1,r1c5_1,r1c4_1,r1c3_1,r1c2_1,r1c1_1,
      S_31,S_30,S_29,S_28,S_27,S_26,S_25,S_24,S_23,S_22,S_21,S_20,S_19,S_18,
      S_17,S_16,S_15,S_14,S_13,S_12,S_11,S_10,S_9,S_8,S_7,S_6,S_5,S_4,S_3,S_2,
      S_1,S_0) /\ 
gray(r5c27_0,r5c27_1,r5c15,r6c27) /\ 
black(r1c29_0,r1c29_1,r1c28_0,r1c28_1,r2c29_0,r2c29_1) /\ 
black(r1c5_0,r1c5_1,r1c4_0,r1c4_1,r2c5_0,r2c5_1) /\ 
black(r1c19_0,r1c19_1,r1c18_0,r1c18_1,r2c19_0,r2c19_1) /\ 
gray(r1c6_0,r1c6_1,r4c5,r7c6) /\ 
gray(r1c32_0,r1c32_1,r6c31,Cout) /\ 
black(r2c25_0,r2c25_1,r4c23_0,r4c23_1,r5c25_0,r5c25_1) /\ 
black(r2c27_0,r2c27_1,r2c25_0,r2c25_1,r3c27_0,r3c27_1) /\ 
black(r2c15_0,r2c15_1,r2c13_0,r2c13_1,r3c15_0,r3c15_1) /\ 
gray(r4c15_0,r4c15_1,r4c7,r5c15) /\ 
gray(r2c9_0,r2c9_1,r4c7,r5c9) /\ 
gray(r1c4_0,r1c4_1,r3c3,r7c4) /\ 
gray(r1c28_0,r1c28_1,r6c27,r7c28) /\ 
gray(r1c8_0,r1c8_1,r4c7,r7c8) /\ 
gray(r5c31_0,r5c31_1,r5c15,r6c31) /\ 
gray(r1c26_0,r1c26_1,r6c25,r7c26) /\ 
gray(r4c23_0,r4c23_1,r5c15,r6c23)`;

(* 16-bit Brent-Kung adder circuit (generated by holnetlist) *)
val BRENT_KUNG16_DEF = Define `BrentKung16(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,
    A_9,A_10,A_11,A_12,A_13,A_14,A_15,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,
    B_10,B_11,B_12,B_13,B_14,B_15,Cin,Cout,S_0,S_1,S_2,S_3,S_4,S_5,S_6,S_7,S_8,
    S_9,S_10,S_11,S_12,S_13,S_14,S_15) = 
  ?r1c12_0 r1c12_1 r7c2 r2c13_0 r2c13_1 r1c8_0 r1c8_1 r7c10 r7c4 r1c7_0 r1c7_1 
   r5c15 r6c9 r2c1 r4c7 r1c4_0 r1c4_1 r6c5 r1c13_0 r1c13_1 r2c7_0 r2c7_1 r1c14_0 
   r1c14_1 r1c15_0 r1c15_1 r2c15_0 r2c15_1 r1c3_0 r1c3_1 r1c10_0 r1c10_1 r3c7_0 
   r3c7_1 r6c13 r2c5_0 r2c5_1 r5c11 r1c2_0 r1c2_1 r2c3_0 r2c3_1 r7c8 r1c11_0 
   r1c11_1 r1c1_0 r1c1_1 r3c11_0 r3c11_1 r1c16_0 r1c16_1 r3c3 r7c6 r7c14 r1c9_0 
   r1c9_1 r1c6_0 r1c6_1 r1c5_0 r1c5_1 r2c11_0 r2c11_1 r7c12 r4c15_0 r4c15_1 
   r2c9_0 r2c9_1 r3c15_0 r3c15_1.
    black(r1c11_0,r1c11_1,r1c10_0,r1c10_1,r2c11_0,r2c11_1) /\ 
    pg16(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10,A_11,A_12,A_13,A_14,A_15,
         B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,B_10,B_11,B_12,B_13,B_14,B_15,
         r1c1_0,r1c1_1,r1c2_0,r1c2_1,r1c3_0,r1c3_1,r1c4_0,r1c4_1,r1c5_0,r1c5_1,
         r1c6_0,r1c6_1,r1c7_0,r1c7_1,r1c8_0,r1c8_1,r1c9_0,r1c9_1,r1c10_0,
         r1c10_1,r1c11_0,r1c11_1,r1c12_0,r1c12_1,r1c13_0,r1c13_1,r1c14_0,
         r1c14_1,r1c15_0,r1c15_1,r1c16_0,r1c16_1) /\ 
    gray(r1c6_0,r1c6_1,r6c5,r7c6) /\ 
    gray(r1c12_0,r1c12_1,r5c11,r7c12) /\ 
    gray(r1c16_0,r1c16_1,r5c15,Cout) /\ 
    gray(r1c14_0,r1c14_1,r6c13,r7c14) /\ 
    black(r3c15_0,r3c15_1,r3c11_0,r3c11_1,r4c15_0,r4c15_1) /\ 
    black(r1c3_0,r1c3_1,r1c2_0,r1c2_1,r2c3_0,r2c3_1) /\ 
    gray(r2c3_0,r2c3_1,r2c1,r3c3) /\ 
    gray(r2c9_0,r2c9_1,r4c7,r6c9) /\ 
    gray(r4c15_0,r4c15_1,r4c7,r5c15) /\ 
    black(r2c15_0,r2c15_1,r2c13_0,r2c13_1,r3c15_0,r3c15_1) /\ 
    gray(r1c10_0,r1c10_1,r6c9,r7c10) /\ 
    gray(r3c7_0,r3c7_1,r3c3,r4c7) /\ 
    black(r2c7_0,r2c7_1,r2c5_0,r2c5_1,r3c7_0,r3c7_1) /\ 
    black(r1c7_0,r1c7_1,r1c6_0,r1c6_1,r2c7_0,r2c7_1) /\ 
    xor16(r5c15,r7c14,r6c13,r7c12,r5c11,r7c10,r6c9,r7c8,r4c7,r7c6,r6c5,r7c4,
          r3c3,r7c2,r2c1,Cin,r1c16_1,r1c15_1,r1c14_1,r1c13_1,r1c12_1,r1c11_1,
          r1c10_1,r1c9_1,r1c8_1,r1c7_1,r1c6_1,r1c5_1,r1c4_1,r1c3_1,r1c2_1,
          r1c1_1,S_15,S_14,S_13,S_12,S_11,S_10,S_9,S_8,S_7,S_6,S_5,S_4,S_3,
          S_2,S_1,S_0) /\ 
    gray(r1c4_0,r1c4_1,r3c3,r7c4) /\ 
    gray(r3c11_0,r3c11_1,r4c7,r5c11) /\ 
    black(r1c13_0,r1c13_1,r1c12_0,r1c12_1,r2c13_0,r2c13_1) /\ 
    gray(r1c8_0,r1c8_1,r4c7,r7c8) /\ 
    black(r1c15_0,r1c15_1,r1c14_0,r1c14_1,r2c15_0,r2c15_1) /\ 
    gray(r2c5_0,r2c5_1,r3c3,r6c5) /\ 
    black(r1c9_0,r1c9_1,r1c8_0,r1c8_1,r2c9_0,r2c9_1) /\ 
    gray(r1c1_0,r1c1_1,Cin,r2c1) /\ 
    black(r1c5_0,r1c5_1,r1c4_0,r1c4_1,r2c5_0,r2c5_1) /\ 
    gray(r1c2_0,r1c2_1,r2c1,r7c2) /\ 
    black(r2c11_0,r2c11_1,r2c9_0,r2c9_1,r3c11_0,r3c11_1) /\ 
    gray(r2c13_0,r2c13_1,r5c11,r6c13)`;

(* 32-bit Brent-Kung adder circuit (generated by holnetlist) *)
val BRENT_KUNG32_DEF = Define `BrentKung32(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,
    A_9,A_10,A_11,A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,A_20,A_21,A_22,A_23,
    A_24, A_25,A_26,A_27,A_28,A_29,A_30,A_31,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,
    B_9,B_10,B_11,B_12,B_13,B_14,B_15,B_16,B_17,B_18,B_19,B_20,B_21,B_22,B_23,
    B_24,B_25,B_26,B_27,B_28,B_29,B_30,B_31,Cin,Cout,S_0,S_1,S_2,S_3,S_4,S_5,
    S_6,S_7,S_8,S_9,S_10,S_11,S_12,S_13,S_14,S_15,S_16,S_17,S_18,S_19,S_20,S_21,
    S_22,S_23,S_24,S_25,S_26,S_27,S_28,S_29,S_30,S_31) = 
      ?r2c23_0 r2c23_1 r1c21_0 r1c21_1 r2c13_0 r2c13_1 r1c28_0 r1c28_1 r9c14 
       r7c11 r5c15 r4c7 r1c26_0 r1c26_1 r1c4_0 r1c4_1 r4c31_0 r4c31_1 r9c12 
       r8c21 r7c19 r1c20_0 r1c20_1 r5c31_0 r5c31_1 r4c23_0 r4c23_1 r2c21_0 
       r2c21_1 r1c27_0 r1c27_1 r1c29_0 r1c29_1 r1c11_0 r1c11_1 r1c17_0 r1c17_1 
       r1c16_0 r1c16_1 r2c19_0 r2c19_1 r9c18 r9c16 r1c19_0 r1c19_1 r9c26 r3c19_0 
       r3c19_1 r1c9_0 r1c9_1 r9c30 r1c31_0 r1c31_1 r1c6_0 r1c6_1 r1c5_0 r1c5_1 
       r1c30_0 r1c30_1 r9c6 r4c15_0 r4c15_1 r3c23_0 r3c23_1 r1c25_0 r1c25_1 
       r9c24 r2c29_0 r2c29_1 r8c25 r1c23_0 r1c23_1 r1c12_0 r1c12_1 r9c8 r2c25_0 
       r2c25_1 r3c31_0 r3c31_1 r1c8_0 r1c8_1 r1c18_0 r1c18_1 r1c7_0 r1c7_1 r8c9 
       r2c1 r2c31_0 r2c31_1 r8c17 r1c13_0 r1c13_1 r1c22_0 r1c22_1 r9c4 r2c7_0 
       r2c7_1 r1c15_0 r1c15_1 r1c14_0 r1c14_1 r1c10_0 r1c10_1 r1c3_0 r1c3_1  
       r2c15_0 r2c15_1 r3c7_0 r3c7_1 r1c24_0 r1c24_1 r2c5_0 r2c5_1 r2c27_0 
       r2c27_1 r1c32_0 r1c32_1 r7c27 r6c23 r1c2_0 r1c2_1 r2c3_0 r2c3_1 r9c22 
       r8c29 r1c1_0 r1c1_1 r3c11_0 r3c11_1 r9c28 r9c20 r8c5 r8c13 r9c10 r9c2 
       r3c3 r2c17_0 r2c17_1 r2c11_0 r2c11_1 r3c27_0 r3c27_1 r6c31 r2c9_0 r2c9_1 
       r3c15_0 r3c15_1.
black(r2c31_0,r2c31_1,r2c29_0,r2c29_1,r3c31_0,r3c31_1) /\ 
black(r1c11_0,r1c11_1,r1c10_0,r1c10_1,r2c11_0,r2c11_1) /\ 
black(r2c19_0,r2c19_1,r2c17_0,r2c17_1,r3c19_0,r3c19_1) /\ 
gray(r1c28_0,r1c28_1,r7c27,r9c28) /\ 
black(r3c15_0,r3c15_1,r3c11_0,r3c11_1,r4c15_0,r4c15_1) /\ 
gray(r1c22_0,r1c22_1,r8c21,r9c22) /\ 
black(r1c3_0,r1c3_1,r1c2_0,r1c2_1,r2c3_0,r2c3_1) /\ 
gray(r2c3_0,r2c3_1,r2c1,r3c3) /\ 
black(r1c23_0,r1c23_1,r1c22_0,r1c22_1,r2c23_0,r2c23_1) /\ 
gray(r1c20_0,r1c20_1,r7c19,r9c20) /\ 
black(r3c23_0,r3c23_1,r3c19_0,r3c19_1,r4c23_0,r4c23_1) /\ 
gray(r1c30_0,r1c30_1,r8c29,r9c30) /\ 
black(r1c17_0,r1c17_1,r1c16_0,r1c16_1,r2c17_0,r2c17_1) /\ 
gray(r2c21_0,r2c21_1,r7c19,r8c21) /\ 
gray(r1c6_0,r1c6_1,r8c5,r9c6) /\ 
black(r1c25_0,r1c25_1,r1c24_0,r1c24_1,r2c25_0,r2c25_1) /\ 
black(r2c7_0,r2c7_1,r2c5_0,r2c5_1,r3c7_0,r3c7_1) /\ 
black(r1c7_0,r1c7_1,r1c6_0,r1c6_1,r2c7_0,r2c7_1) /\ 
gray(r1c18_0,r1c18_1,r8c17,r9c18) /\ 
gray(r3c11_0,r3c11_1,r4c7,r7c11) /\ 
black(r1c13_0,r1c13_1,r1c12_0,r1c12_1,r2c13_0,r2c13_1) /\ 
xor32(r6c31,r9c30,r8c29,r9c28,r7c27,r9c26,r8c25,r9c24,r6c23,r9c22,r8c21,r9c20,
      r7c19,r9c18,r8c17,r9c16,r5c15,r9c14,r8c13,r9c12,r7c11,r9c10,r8c9,r9c8,
      r4c7,r9c6,r8c5,r9c4,r3c3,r9c2,r2c1,Cin,r1c32_1,r1c31_1,r1c30_1,r1c29_1,
      r1c28_1,r1c27_1,r1c26_1,r1c25_1,r1c24_1,r1c23_1,r1c22_1,r1c21_1,r1c20_1,
      r1c19_1,r1c18_1,r1c17_1,r1c16_1,r1c15_1,r1c14_1,r1c13_1,r1c12_1,r1c11_1,
      r1c10_1,r1c9_1,r1c8_1,r1c7_1,r1c6_1,r1c5_1,r1c4_1,r1c3_1,r1c2_1,r1c1_1,
      S_31,S_30,S_29,S_28,S_27,S_26,S_25,S_24,S_23,S_22,S_21,S_20,S_19,S_18,
      S_17,S_16,S_15,S_14,S_13,S_12,S_11,S_10,S_9,S_8,S_7,S_6,S_5,S_4,S_3,S_2,
      S_1,S_0) /\
gray(r1c12_0,r1c12_1,r7c11,r9c12) /\ 
black(r1c21_0,r1c21_1,r1c20_0,r1c20_1,r2c21_0,r2c21_1) /\ 
gray(r1c26_0,r1c26_1,r8c25,r9c26) /\ 
gray(r1c4_0,r1c4_1,r3c3,r9c4) /\ 
black(r1c31_0,r1c31_1,r1c30_0,r1c30_1,r2c31_0,r2c31_1) /\ 
gray(r2c5_0,r2c5_1,r3c3,r8c5) /\ 
gray(r2c17_0,r2c17_1,r5c15,r8c17) /\ 
black(r3c31_0,r3c31_1,r3c27_0,r3c27_1,r4c31_0,r4c31_1) /\ 
black(r1c29_0,r1c29_1,r1c28_0,r1c28_1,r2c29_0,r2c29_1) /\ 
black(r1c5_0,r1c5_1,r1c4_0,r1c4_1,r2c5_0,r2c5_1) /\ 
gray(r1c2_0,r1c2_1,r2c1,r9c2) /\ 
gray(r1c14_0,r1c14_1,r8c13,r9c14) /\ 
black(r1c19_0,r1c19_1,r1c18_0,r1c18_1,r2c19_0,r2c19_1) /\ 
gray(r1c8_0,r1c8_1,r4c7,r9c8) /\ 
pg32(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10,A_11,A_12,A_13,A_14,A_15,A_16,
     A_17,A_18,A_19,A_20,A_21,A_22,A_23,A_24,A_25,A_26,A_27,A_28,A_29,A_30,A_31,
     B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,B_10,B_11,B_12,B_13,B_14,B_15,B_16,
     B_17,B_18,B_19,B_20,B_21,B_22,B_23,B_24,B_25,B_26,B_27,B_28,B_29,B_30,B_31,
     r1c1_0,r1c1_1,r1c2_0,r1c2_1,r1c3_0,r1c3_1,r1c4_0,r1c4_1,r1c5_0,r1c5_1,
     r1c6_0,r1c6_1,r1c7_0,r1c7_1,r1c8_0,r1c8_1,r1c9_0,r1c9_1,r1c10_0,r1c10_1,
     r1c11_0,r1c11_1,r1c12_0,r1c12_1,r1c13_0,r1c13_1,r1c14_0,r1c14_1,r1c15_0,
     r1c15_1,r1c16_0,r1c16_1,r1c17_0,r1c17_1,r1c18_0,r1c18_1,r1c19_0,r1c19_1,
     r1c20_0,r1c20_1,r1c21_0,r1c21_1,r1c22_0,r1c22_1,r1c23_0,r1c23_1,r1c24_0,
     r1c24_1,r1c25_0,r1c25_1,r1c26_0,r1c26_1,r1c27_0,r1c27_1,r1c28_0,r1c28_1,
     r1c29_0,r1c29_1,r1c30_0,r1c30_1,r1c31_0,r1c31_1,r1c32_0,r1c32_1) /\
gray(r1c32_0,r1c32_1,r6c31,Cout) /\ 
gray(r1c24_0,r1c24_1,r6c23,r9c24) /\ 
black(r2c27_0,r2c27_1,r2c25_0,r2c25_1,r3c27_0,r3c27_1) /\ 
black(r4c31_0,r4c31_1,r4c23_0,r4c23_1,r5c31_0,r5c31_1) /\ 
gray(r3c27_0,r3c27_1,r6c23,r7c27) /\ 
black(r2c15_0,r2c15_1,r2c13_0,r2c13_1,r3c15_0,r3c15_1) /\ 
gray(r4c15_0,r4c15_1,r4c7,r5c15) /\ 
gray(r2c29_0,r2c29_1,r7c27,r8c29) /\ 
gray(r1c16_0,r1c16_1,r5c15,r9c16) /\ 
gray(r3c7_0,r3c7_1,r3c3,r4c7) /\ 
black(r2c23_0,r2c23_1,r2c21_0,r2c21_1,r3c23_0,r3c23_1) /\ 
gray(r1c10_0,r1c10_1,r8c9,r9c10) /\ 
black(r1c15_0,r1c15_1,r1c14_0,r1c14_1,r2c15_0,r2c15_1) /\ 
black(r1c27_0,r1c27_1,r1c26_0,r1c26_1,r2c27_0,r2c27_1) /\ 
gray(r5c31_0,r5c31_1,r5c15,r6c31) /\ 
gray(r2c13_0,r2c13_1,r7c11,r8c13) /\ 
black(r1c9_0,r1c9_1,r1c8_0,r1c8_1,r2c9_0,r2c9_1) /\ 
gray(r1c1_0,r1c1_1,Cin,r2c1) /\ 
gray(r3c19_0,r3c19_1,r5c15,r7c19) /\ 
gray(r2c25_0,r2c25_1,r6c23,r8c25) /\ 
black(r2c11_0,r2c11_1,r2c9_0,r2c9_1,r3c11_0,r3c11_1) /\ 
gray(r2c9_0,r2c9_1,r4c7,r8c9) /\ 
gray(r4c23_0,r4c23_1,r5c15,r6c23)`;

