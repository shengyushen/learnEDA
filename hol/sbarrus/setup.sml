(* setup.sml
 *
 * Prefix Adder Verification Project Setup
 *                           
 * Steve Barrus
 * CS 6110
 *)

load "metisLib"; 
load "HolSatLib"; 
open metisLib normalForms HolSatLib;


(***********************************
 *        Basic Definitions        *
 ***********************************)

(* Tranistor models *)
val VDD_DEF  = Define `VDD(n) = (n = T)`;
val GND_DEF  = Define `GND(n) = (n = F)`;
val NMOS_DEF = Define `NMOS(g,s,d) = (g ==> (d = s))`;
val PMOS_DEF = Define `PMOS(g,s,d) = (~g ==> (d = s))`;

(* Bit vector definitions *)
val BVS_DEF = Define `(BVS T = 1) /\ (BVS F = 0)`;
val BVL_DEF = Define `(BVL [] = 0) /\ (BVL (h::t) = (if h = T then 2 * BVL t + 1 else 2 * BVL t))`;


(*************************
 *        Tactics        *
 *************************)

(* Simple rewriter for tansistor level goals *)
fun NET_RW_TAC thl = RW_TAC std_ss ([PMOS_DEF,NMOS_DEF,VDD_DEF,GND_DEF] @ thl);

(* MY_SAT_TAC is a tactic that tries to use a sat_solver with
   satOracle to prove a goal.  The assumption list is ignored *)
fun MY_SAT_TAC satprog: tactic = fn (asl,w) =>
  let
    val cnfth = DEF_CNF_CONV (mk_neg(w));
    val (evars, satterm) = strip_exists(rhs(concl(cnfth)));
    val satth = satOracle satprog satterm;
    val varth = LIST_MK_EXISTS evars (EQF_INTRO satth);
    val exeth = RIGHT_CONV_RULE (REWRITE_CONV [RES_EXISTS_FALSE]) varth;
    val nnwth = EQF_ELIM (TRANS cnfth exeth);
    val endth = CONV_RULE (PURE_REWRITE_CONV [NOT_CLAUSES]) nnwth;
  in
    ACCEPT_TAC endth (asl,w)
  end;


(***********************
 *        Cells        *
 ***********************)

(* Inverter *)
val INV_BEH_DEF = Define `INV_BEH(a,y) = (y = ~a)`;
val INV_STR_DEF = Define `INV_STR(a,y) = 
    ?n1 n2. VDD(n1) /\ GND(n2) /\ NMOS(a,n2,y) /\ PMOS(a,n1,y)`;
val INV_STR_BEH_EQ = prove (``INV_STR(a,y) = INV_BEH(a,y)``,
    NET_RW_TAC [INV_BEH_DEF,INV_STR_DEF] THEN METIS_TAC []);

(* NAND Gate *)
val NAND_BEH_DEF = Define `NAND_BEH(a,b,y) = (y = ~(a /\ b))`;
val NAND_STR_DEF = Define `NAND_STR(a,b,y) = 
    ?n1 n2 n3. VDD(n1) /\ PMOS(b,n1,y) /\ PMOS(a,n1,y) /\ 
               NMOS(a,n2,y) /\ NMOS(b,n3,n2) /\ GND(n3)`;
val NAND_STR_BEH_EQ = prove (``NAND_STR(a,b,y) = NAND_BEH(a,b,y)``,
    NET_RW_TAC [NAND_BEH_DEF,NAND_STR_DEF] THEN METIS_TAC []);

(* AND Gate *)
val AND_BEH_DEF = Define `AND_BEH(a,b,y) = (y = (a /\ b))`;
val AND_STR_DEF = Define `AND_STR(a,b,y) = 
    ?n1 n2 n3 n4. VDD(n1) /\ PMOS(b,n1,n4) /\ PMOS(a,n1,n4) /\ PMOS(n4,n1,y) /\
                  NMOS(a,n2,n4) /\ NMOS(b,n3,n2) /\ NMOS(n4,n3,y) /\ GND(n3)`;
val AND_STR_BEH_EQ = prove (``AND_STR(a,b,y) = AND_BEH(a,b,y)``,
    NET_RW_TAC [AND_BEH_DEF,AND_STR_DEF] THEN METIS_TAC []);

(* NOR Gate *)
val NOR_BEH_DEF = Define `NOR_BEH(a,b,y) = (y = ~(a \/ b))`;
val NOR_STR_DEF = Define `NOR_STR(a,b,y) =
    ?n1 n2 n3. VDD(n1) /\ PMOS(a,n1,n2) /\ PMOS(b,n2,y) /\
               NMOS(a,y,n3) /\ NMOS(b,y,n3) /\ GND(n3)`;
val NOR_STR_BEH_EQ = prove (``NOR_STR(a,b,y) = NOR_BEH(a,b,y)``,
    NET_RW_TAC [NOR_BEH_DEF,NOR_STR_DEF] THEN METIS_TAC []);

(* OR Gate *)
val OR_BEH_DEF = Define `OR_BEH(a,b,y) = (y = (a \/ b))`;
val OR_STR_DEF = Define `OR_STR(a,b,y) =
    ?n1 n2 n3 n4. VDD(n1) /\ PMOS(a,n1,n2) /\ PMOS(b,n2,n4) /\ PMOS(n4,n1,y) /\
                  NMOS(a,n3,n4) /\ NMOS(b,n3,n4) /\ NMOS(n4,n3,y) /\ GND(n3)`;
val OR_STR_BEH_EQ = prove (``OR_STR(a,b,y) = OR_BEH(a,b,y)``,
    NET_RW_TAC [OR_BEH_DEF,OR_STR_DEF] THEN Cases_on `y` THEN 
    RW_TAC std_ss [] THEN METIS_TAC []);

(* XOR Gate *)
val XOR_BEH_DEF = Define `XOR_BEH(a,b,y) = (y = ~(a = b))`;
val XOR_STR_DEF = Define `XOR_STR(a,b,y) =
    ?n1 n2 n3 n4 n5 n6 n7 n8. VDD(n1) /\ PMOS(a,n1,n3) /\ PMOS(b,n1,n4) /\ 
        PMOS(b,n1,n5) /\ PMOS(n3,n5,y) /\ PMOS(n4,n1,n6) /\ PMOS(a,n6,y) /\
        NMOS(a,n2,n3) /\ NMOS(b,n2,n4) /\ NMOS(n3,y,n7) /\ NMOS(n4,n7,n2) /\ 
        NMOS(a,y,n8) /\ NMOS(b,n8,n2) /\ GND(n2)`;
val XOR_STR_BEH_EQ = prove (``XOR_STR(a,b,y) = XOR_BEH(a,b,y)``,
    NET_RW_TAC [XOR_BEH_DEF,XOR_STR_DEF] THEN METIS_TAC []);

(* Gray Cell *)
val GRAY_BEH_DEF = Define `GRAY_BEH(pg0,pg1,pgi,pgo) = 
    (pgo = ((pgi /\ pg1) \/ pg0))`;
val GRAY_STR_DEF = Define `GRAY_STR(pg0,pg1,pgi,pgo) =
    ?n1 n2. AND_STR(pgi,pg1,n1) /\ NOR_STR(n1,pg0,n2) /\ INV_STR(n2,pgo)`;
val GRAY_STR_BEH_EQ = prove (``GRAY_STR(pg0,pg1,pgi,pgo) = GRAY_BEH(pg0,pg1,pgi,pgo)``,
    RW_TAC std_ss [GRAY_BEH_DEF,GRAY_STR_DEF,AND_BEH_DEF,NOR_BEH_DEF,
        INV_BEH_DEF,NOR_STR_BEH_EQ,AND_STR_BEH_EQ,INV_STR_BEH_EQ]);
val GRAY_DEF = Define `gray(pg0,pg1,pgi,pgo) = GRAY_STR(pg0,pg1,pgi,pgo)`;

(* Black Cell *)
val BLACK_BEH_DEF = Define `BLACK_BEH(pg0,pg1,pgi0,pgi1,pgo0,pgo1) = 
    ((pgo1 = (pgi1 /\ pg1)) /\ (pgo0 = ((pgi0 /\ pg1) \/ pg0)))`;
val BLACK_STR_DEF = Define `BLACK_STR(pg0,pg1,pgi0,pgi1,pgo0,pgo1) = 
    ?n1 n2 n3. AND_STR(pg1,pgi0,n1) /\ NOR_STR(n1,pg0,n2) /\ 
        INV_STR(n2,pgo0) /\ NAND_STR(pg1,pgi1,n3) /\ INV_STR(n3,pgo1)`;
val BLACK_STR_BEH_EQ = prove (``BLACK_STR(pg0,pg1,pgi0,pgi1,pgo0,pgo1) = BLACK_BEH(pg0,pg1,pgi0,pgi1,pgo0,pgo1)``,
    RW_TAC std_ss [BLACK_BEH_DEF,BLACK_STR_DEF,AND_BEH_DEF,NOR_BEH_DEF,NAND_BEH_DEF,
        INV_BEH_DEF,NOR_STR_BEH_EQ,NAND_STR_BEH_EQ,AND_STR_BEH_EQ,INV_STR_BEH_EQ] 
    THEN METIS_TAC []);
val BLACK_DEF = Define `black(pg0,pg1,pgi0,pgi1,pgo0,pgo1) = 
                        BLACK_STR(pg0,pg1,pgi0,pgi1,pgo0,pgo1)`;

(* Full Adder *)
val FULLADDER_BEH_DEF = Define `FULLADDER_BEH(a0,a1,a2,y0,y1) = 
        (BVL [y0;y1] = BVS a0 + BVS a1 + BVS a2)`;
val FULLADDER_SIM_DEF = Define `FULLADDER_SIM(a0,a1,a2,y0,y1) = 
    ((y1 = a0 /\ a1 \/ a2 /\ ~(a0 = a1)) /\ (y0 = ~(~(a0 = a1) = a2)))`;
val FULLADDER_STR_DEF = Define `FULLADDER_STR(a0,a1,a2,y0,y1) = 
    ?n1 n2 n3. NAND_STR(a0,a1,n1) /\ NAND_STR(a2,n2,n3) /\ 
               NAND_STR(n1,n3,y1) /\ XOR_STR(a0,a1,n2) /\ XOR_STR(n2,a2,y0)`;
val FULLADDER_STR_BEH_EQ = prove (``FULLADDER_STR(a0,a1,a2,y0,y1) = FULLADDER_BEH(a0,a1,a2,y0,y1)``,
    NET_RW_TAC [FULLADDER_BEH_DEF,FULLADDER_STR_DEF,NAND_STR_DEF,XOR_STR_DEF] 
    THEN MAP_EVERY Cases_on [`a0`,`a1`,`a2`,`y0`,`y1`] 
    THEN RW_TAC arith_ss [BVS_DEF,BVL_DEF]);
val FULLADDER_STR_SIM_EQ = prove (``FULLADDER_STR(a0,a1,a2,y0,y1) = FULLADDER_SIM(a0,a1,a2,y0,y1)``,
    NET_RW_TAC [FULLADDER_SIM_DEF,FULLADDER_STR_DEF,NAND_STR_BEH_EQ,
        XOR_STR_BEH_EQ,XOR_BEH_DEF,NAND_BEH_DEF]);


(*************************
 *        Modules        *
 *************************)

(* 16-bit XOR module *)
val XOR16_DEF = Define `xor16(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10,A_11,
    A_12,A_13,A_14,A_15,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,B_10,B_11,B_12,
    B_13,B_14,B_15,Y_0,Y_1,Y_2,Y_3,Y_4,Y_5,Y_6,Y_7,Y_8,Y_9,Y_10,Y_11,Y_12,Y_13,
    Y_14,Y_15) = 
        (XOR_STR(A_0,B_0,Y_0) /\ XOR_STR(A_1,B_1,Y_1) /\ 
        XOR_STR(A_2,B_2,Y_2) /\ XOR_STR(A_3,B_3,Y_3) /\ 
        XOR_STR(A_4,B_4,Y_4) /\ XOR_STR(A_5,B_5,Y_5) /\ 
        XOR_STR(A_6,B_6,Y_6) /\ XOR_STR(A_7,B_7,Y_7) /\ 
        XOR_STR(A_8,B_8,Y_8) /\ XOR_STR(A_9,B_9,Y_9) /\ 
        XOR_STR(A_10,B_10,Y_10) /\ XOR_STR(A_11,B_11,Y_11) /\ 
        XOR_STR(A_12,B_12,Y_12) /\ XOR_STR(A_13,B_13,Y_13) /\ 
        XOR_STR(A_14,B_14,Y_14) /\ XOR_STR(A_15,B_15,Y_15))`;

(* 32-bit XOR module *)
val XOR32_DEF = Define `xor32(A_0,A_1,A_2,A_3,A_4,A_5,A_6,A_7,A_8,A_9,A_10,A_11,
    A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,A_20,A_21,A_22,A_23,A_24,A_25,A_26,
    A_27,A_28,A_29,A_30,A_31,B_0,B_1,B_2,B_3,B_4,B_5,B_6,B_7,B_8,B_9,B_10,B_11,
    B_12,B_13,B_14,B_15,B_16,B_17,B_18,B_19,B_20,B_21,B_22,B_23,B_24,B_25,B_26,
    B_27,B_28,B_29,B_30,B_31,Y_0,Y_1,Y_2,Y_3,Y_4,Y_5,Y_6,Y_7,Y_8,Y_9,Y_10,Y_11,
    Y_12,Y_13,Y_14,Y_15,Y_16,Y_17,Y_18,Y_19,Y_20,Y_21,Y_22,Y_23,Y_24,Y_25,Y_26,
    Y_27,Y_28,Y_29,Y_30,Y_31) = 
        (XOR_STR(A_0,B_0,Y_0) /\ XOR_STR(A_1,B_1,Y_1) /\ 
        XOR_STR(A_2,B_2,Y_2) /\ XOR_STR(A_3,B_3,Y_3) /\ 
        XOR_STR(A_4,B_4,Y_4) /\ XOR_STR(A_5,B_5,Y_5) /\ 
        XOR_STR(A_6,B_6,Y_6) /\ XOR_STR(A_7,B_7,Y_7) /\ 
        XOR_STR(A_8,B_8,Y_8) /\ XOR_STR(A_9,B_9,Y_9) /\ 
        XOR_STR(A_10,B_10,Y_10) /\ XOR_STR(A_11,B_11,Y_11) /\ 
        XOR_STR(A_12,B_12,Y_12) /\ XOR_STR(A_13,B_13,Y_13) /\ 
        XOR_STR(A_14,B_14,Y_14) /\ XOR_STR(A_15,B_15,Y_15) /\ 
        XOR_STR(A_16,B_16,Y_16) /\ XOR_STR(A_17,B_17,Y_17) /\ 
        XOR_STR(A_18,B_18,Y_18) /\ XOR_STR(A_19,B_19,Y_19) /\ 
        XOR_STR(A_20,B_20,Y_20) /\ XOR_STR(A_21,B_21,Y_21) /\ 
        XOR_STR(A_22,B_22,Y_22) /\ XOR_STR(A_23,B_23,Y_23) /\ 
        XOR_STR(A_24,B_24,Y_24) /\ XOR_STR(A_25,B_25,Y_25) /\ 
        XOR_STR(A_26,B_26,Y_26) /\ XOR_STR(A_27,B_27,Y_27) /\ 
        XOR_STR(A_28,B_28,Y_28) /\ XOR_STR(A_29,B_29,Y_29) /\ 
        XOR_STR(A_30,B_30,Y_30) /\ XOR_STR(A_31,B_31,Y_31))`;

(* 16-bit Propagate/Generate signal generator *)
val PG16_DEF = Define `pg16(A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,
    A15,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,G0,P0,G1,P1,G2,
    P2,G3,P3,G4,P4,G5,P5,G6,P6,G7,P7,G8,P8,G9,P9,G10,P10,G11,P11,G12,P12,G13,
    P13,G14,P14,G15,P15) =
        (XOR_STR(A0,B0,P0) /\ AND_STR(A0,B0,G0) /\ 
        XOR_STR(A1,B1,P1) /\ AND_STR(A1,B1,G1) /\ 
        XOR_STR(A2,B2,P2) /\ AND_STR(A2,B2,G2) /\ 
        XOR_STR(A3,B3,P3) /\ AND_STR(A3,B3,G3) /\ 
        XOR_STR(A4,B4,P4) /\ AND_STR(A4,B4,G4) /\ 
        XOR_STR(A5,B5,P5) /\ AND_STR(A5,B5,G5) /\ 
        XOR_STR(A6,B6,P6) /\ AND_STR(A6,B6,G6) /\ 
        XOR_STR(A7,B7,P7) /\ AND_STR(A7,B7,G7) /\ 
        XOR_STR(A8,B8,P8) /\ AND_STR(A8,B8,G8) /\ 
        XOR_STR(A9,B9,P9) /\ AND_STR(A9,B9,G9) /\ 
        XOR_STR(A10,B10,P10) /\ AND_STR(A10,B10,G10) /\ 
        XOR_STR(A11,B11,P11) /\ AND_STR(A11,B11,G11) /\ 
        XOR_STR(A12,B12,P12) /\ AND_STR(A12,B12,G12) /\ 
        XOR_STR(A13,B13,P13) /\ AND_STR(A13,B13,G13) /\ 
        XOR_STR(A14,B14,P14) /\ AND_STR(A14,B14,G14) /\ 
        XOR_STR(A15,B15,P15) /\ AND_STR(A15,B15,G15))`;

(* 32-bit Propagate/Generate signal generator *)
val PG32_DEF = Define `pg32(A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,
    A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B0,B1,
    B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,
    B23,B24,B25,B26,B27,B28,B29,B30,B31,G0,P0,G1,P1,G2,P2,G3,P3,G4,P4,G5,P5,G6,
    P6,G7,P7,G8,P8,G9,P9,G10,P10,G11,P11,G12,P12,G13,P13,G14,P14,G15,P15,G16,
    P16,G17,P17,G18,P18,G19,P19,G20,P20,G21,P21,G22,P22,G23,P23,G24,P24,G25,P25,
    G26,P26,G27,P27,G28,P28,G29,P29,G30,P30,G31,P31) =
        (XOR_STR(A0,B0,P0) /\ AND_STR(A0,B0,G0) /\ 
        XOR_STR(A1,B1,P1) /\ AND_STR(A1,B1,G1) /\ 
        XOR_STR(A2,B2,P2) /\ AND_STR(A2,B2,G2) /\ 
        XOR_STR(A3,B3,P3) /\ AND_STR(A3,B3,G3) /\ 
        XOR_STR(A4,B4,P4) /\ AND_STR(A4,B4,G4) /\ 
        XOR_STR(A5,B5,P5) /\ AND_STR(A5,B5,G5) /\ 
        XOR_STR(A6,B6,P6) /\ AND_STR(A6,B6,G6) /\ 
        XOR_STR(A7,B7,P7) /\ AND_STR(A7,B7,G7) /\ 
        XOR_STR(A8,B8,P8) /\ AND_STR(A8,B8,G8) /\ 
        XOR_STR(A9,B9,P9) /\ AND_STR(A9,B9,G9) /\ 
        XOR_STR(A10,B10,P10) /\ AND_STR(A10,B10,G10) /\ 
        XOR_STR(A11,B11,P11) /\ AND_STR(A11,B11,G11) /\ 
        XOR_STR(A12,B12,P12) /\ AND_STR(A12,B12,G12) /\ 
        XOR_STR(A13,B13,P13) /\ AND_STR(A13,B13,G13) /\ 
        XOR_STR(A14,B14,P14) /\ AND_STR(A14,B14,G14) /\ 
        XOR_STR(A15,B15,P15) /\ AND_STR(A15,B15,G15) /\ 
        XOR_STR(A16,B16,P16) /\ AND_STR(A16,B16,G16) /\ 
        XOR_STR(A17,B17,P17) /\ AND_STR(A17,B17,G17) /\ 
        XOR_STR(A18,B18,P18) /\ AND_STR(A18,B18,G18) /\ 
        XOR_STR(A19,B19,P19) /\ AND_STR(A19,B19,G19) /\ 
        XOR_STR(A20,B20,P20) /\ AND_STR(A20,B20,G20) /\ 
        XOR_STR(A21,B21,P21) /\ AND_STR(A21,B21,G21) /\ 
        XOR_STR(A22,B22,P22) /\ AND_STR(A22,B22,G22) /\ 
        XOR_STR(A23,B23,P23) /\ AND_STR(A23,B23,G23) /\ 
        XOR_STR(A24,B24,P24) /\ AND_STR(A24,B24,G24) /\ 
        XOR_STR(A25,B25,P25) /\ AND_STR(A25,B25,G25) /\ 
        XOR_STR(A26,B26,P26) /\ AND_STR(A26,B26,G26) /\ 
        XOR_STR(A27,B27,P27) /\ AND_STR(A27,B27,G27) /\ 
        XOR_STR(A28,B28,P28) /\ AND_STR(A28,B28,G28) /\ 
        XOR_STR(A29,B29,P29) /\ AND_STR(A29,B29,G29) /\ 
        XOR_STR(A30,B30,P30) /\ AND_STR(A30,B30,G30) /\ 
        XOR_STR(A31,B31,P31) /\ AND_STR(A31,B31,G31))`;

