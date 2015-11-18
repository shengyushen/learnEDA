(* load is used to load in the theory
whithout it nothing can be accessed 
but we still refer to them with dot , such as xxTheory.xxfun

but with open , we can directly refer to xxfuun
*)
open HolKernel boolLib Parse bossLib
open arithmeticTheory;


val _ =new_theory "euclid";

val divides_def = Define `divides a b  = ? x . b = a * x `;
val _ = set_fixity "divides" (Infix(NONASSOC,450));
val prime_def = Define `prime p = ~(p=1) /\ !x. x divides p ==> (x=1) \/ (x=p)`;

(*proving DIVIDES_0*)
val DIVIDES_0 = store_thm(
"DIVIDES_0",
``!x. x divides 0``,
RW_TAC arith_ss [divides_def]
THEN EXISTS_TAC ``0``
THEN RW_TAC arith_ss []
);

(*DIVIDES_ZERO*)
val DIVIDES_ZERO = store_thm (
"DIVIDES_ZERO",
``!x. (0 divides x) = (x=0)``,
RW_TAC arith_ss [divides_def]
);

(* DIVIDES_ONE *)
val DIVIDES_ONE = store_thm (
"DIVIDES_ONE",
``!x. (x divides 1) = (x=1)``,
RW_TAC arith_ss [divides_def]
);

(* DIVIDES_REFL *)
val DIVIDES_REFL = store_thm (
"DIVIDES_REFL",
``!x. x divides x``,
RW_TAC arith_ss [divides_def]
THEN EXISTS_TAC ``1``
THEN RW_TAC arith_ss []
);

(* DIVIDES_TRANS *)
val DIVIDES_TRANS = store_thm (
"DIVIDES_TRANS",
``!a b c. ( a divides b ) /\ (b divides c) ==> (a divides c)``,
METIS_TAC [divides_def,MULT_ASSOC]
);

(* DIVIDES_ADD  *)
(* METIS_TAC use metisLib, while PROVE_TAC use mesonLib
both are powerful libs*)
val DIVIDES_ADD = store_thm (
"DIVIDES_ADD",
``!a b d. (d divides a) /\ (d divides b) ==> (d divides (a + b))``,
METIS_TAC [divides_def, LEFT_ADD_DISTRIB]
);

(* DIVIDES_SUB *)
val DIVIDES_SUB = store_thm (
"DIVIDES_SUB",
``!a b d. (d divides a) /\ (d divides b) ==> (d divides (a - b))``,
METIS_TAC [divides_def , LEFT_SUB_DISTRIB]
);


(*  DIVIDES_ADDL *)
val DIVIDES_ADDL = store_thm (
"DIVIDES_ADDL",
``!a b d. (d divides a) /\ (d divides (a+b)) ==> (d divides b)``,
RW_TAC arith_ss [divides_def]
THEN EXISTS_TAC ``x'-x``
THEN RW_TAC arith_ss []
);


(* DIVIDES_LMUL  *)
val DIVIDES_LMUL = store_thm (
"DIVIDES_LMUL",
``!d a x. (d divides a) ==> (d divides (x * a))``,
RW_TAC arith_ss [divides_def]
THEN EXISTS_TAC ``x'*x``
THEN RW_TAC arith_ss []
);


(*  DIVIDES_RMUL *)
val DIVIDES_RMUL = store_thm (
"DIVIDES_RMUL",
``!d a x. (d divides a) ==> (d divides (a*x))``,
RW_TAC arith_ss [divides_def]
THEN EXISTS_TAC ``x'*x``
THEN RW_TAC arith_ss []
);


(*
DB.match ["arithmetic"] ``m* SUC n``;
DB.match ["arithmetic"] ``m*0``;
these two both find the MULT_CLAUSES
this equal to coq's similar mechanism
*)

(* DIVIDES_LE *)
val DIVIDES_LE = store_thm (
"DIVIDES_LE",
``!m n. (m divides n) ==> (m <= n) \/ (n=0)``,
RW_TAC arith_ss [divides_def]
THEN Cases_on `x`
THEN RW_TAC arith_ss [MULT_CLAUSES]
);


(*
trying eval in bossLib
*)
EVAL (Term `FACT 2`);


val DIVIDES_FACT = store_thm (
"DIVIDES_FACT",
``!m n. 0<m /\m<=n ==> m divides (FACT n)``,
RW_TAC arith_ss [LESS_EQ_EXISTS]
THEN Induct_on `p`
THEN  RW_TAC arith_ss [FACT , ADD_CLAUSES]
THENL [
  Cases_on `m`
  THENL [METIS_TAC [DECIDE ``!x. ~ (x<x)``]
    ,
    RW_TAC arith_ss [FACT , divides_def]
  ]
,
  METIS_TAC [DIVIDES_RMUL]
]);


val NOT_PRIME_0 = store_thm (
"NOT_PRIME_0",
``~(prime 0)``,
RW_TAC arith_ss [prime_def,DIVIDES_0]
);

val NOT_PRIME_1 = store_thm (
"NOT_PRIME_1",
``~ (prime 1)``,
RW_TAC arith_ss [prime_def]
);

val PRIME_2 = store_thm (
"PRIME_2",
``prime 2``,
RW_TAC arith_ss [prime_def]
THEN METIS_TAC [DIVIDES_LE,DIVIDES_ZERO, DECIDE ``~(2=1)``, DECIDE ``~(2=0)`` , DECIDE ``(x<=2)=(x=0)\/(x=1)\/(x=2)``]
);

val PRIME_POS = store_thm (
"PRIME_POS",
``!p. prime p ==> 0<p``,
Cases
THEN RW_TAC arith_ss [NOT_PRIME_0]
THEN RW_TAC arith_ss []
);


val PRIME_FACTOR = store_thm (
"PRIME_FACTOR",
``!n. ~(n=1) ==> ?p. prime p /\ p divides n``,
completeInduct_on `n`
THEN RW_TAC arith_ss []
THEN Cases_on `prime n`
THENL  [
  METIS_TAC [DIVIDES_REFL]
,
  `?x. x divides n /\ ~(x=1) /\ ~ (x=n)` by METIS_TAC[prime_def]
  THEN `x<=n\/(n=0) ` by METIS_TAC[prime_def , DIVIDES_LE]
  THENL [
    `x<n` by RW_TAC arith_ss []
    THEN `?p1. prime p1 /\ p1 divides x` by METIS_TAC []
    THEN `prime p1 /\ (p1 divides n)` by METIS_TAC [DIVIDES_TRANS]
    THEN METIS_TAC []
  ,
    RW_TAC arith_ss []
    THEN `prime 2` by METIS_TAC [PRIME_2]
    THEN EXISTS_TAC ``2``
    THEN RW_TAC arith_ss [divides_def, prime_def]
  ]
]
);


val LE_1_SUC = store_thm (
"LE_1_SUC",
``!x. 1<=(SUC x) ``,
Induct_on `x`
THEN RW_TAC arith_ss [ADD1]
THEN RW_TAC arith_ss [ADD1]
);


val LE_1_FACT = store_thm (
"LE_1_FACT",
``!x. 1 <= (FACT x) ``,
RW_TAC arith_ss [FACT]
THEN Induct_on `x`
THENL [
  RW_TAC arith_ss [FACT]
,
  RW_TAC arith_ss [FACT]
  THEN `1*1 <= (FACT x)*(SUC x) ` by METIS_TAC [LE_1_SUC , LESS_MONO_MULT2 ]
  THEN RW_TAC arith_ss []
]
);


val LT_0_SUC = store_thm (
"LT_0_SUC",
``!n. 0 < SUC n``,
Induct_on `n`
THENL [
  RW_TAC arith_ss []
,
  RW_TAC arith_ss []
]
);

val LT_0_FACT = store_thm (
"LT_0_FACT",
``!n. 0 < FACT n``,
Induct_on `n`
THENL [
  RW_TAC arith_ss [FACT]
,
  RW_TAC arith_ss [FACT]
  THEN METIS_TAC [LT_0_SUC , LESS_MULT2]
]
);


val LE_n_FACT = store_thm (
"LE_n_FACT",
``!n. n <= (FACT n ) ``,
Induct_on `n`
THENL [
  RW_TAC arith_ss [FACT]
,
  RW_TAC arith_ss [  FACT]
  THEN METIS_TAC [LT_0_FACT]
]
);

val NOT_EQ_FACT_ADD1_1 = store_thm (
"NOT_EQ_FACT_ADD1_1",
``!n. ~(((FACT n) +1) =1) ``,
RW_TAC arith_ss []
THEN Induct_on `n`
THENL [
  RW_TAC arith_ss [FACT]
,
  RW_TAC arith_ss [FACT]
]
);


val ECLID_THM1 = store_thm (
"ECLID_THM1",
``!n. ?p. n<p /\ prime p``,
SPOSE_NOT_THEN STRIP_ASSUME_TAC
THEN `n <= (FACT n) ` by METIS_TAC [LE_n_FACT]
THEN `n < SUC (FACT n)`  by METIS_TAC [LESS_EQ_IMP_LESS_SUC]
THEN `n < (FACT n)+1` by RW_TAC arith_ss []
THEN `~ (prime ((FACT n)+1))` by METIS_TAC []
THEN `~(((FACT n)+1) = 1)` by METIS_TAC [NOT_EQ_FACT_ADD1_1]
THEN `?p. prime p /\ p divides ((FACT n)+1)` by METIS_TAC [PRIME_FACTOR]
THEN `~(n<p)` by METIS_TAC []
THEN `p<=n` by RW_TAC arith_ss []
THEN `0<p` by METIS_TAC [PRIME_POS]
THEN `p divides (FACT n)` by METIS_TAC [ DIVIDES_FACT ]
THEN `p divides (((FACT n) +1) - (FACT n))` by METIS_TAC [DIVIDES_SUB]
THEN `p divides 1` by METIS_TAC [DIVIDES_ADDL]
THEN `p=1` by METIS_TAC [DIVIDES_ONE]
THEN `~ (prime p)` by METIS_TAC [NOT_PRIME_1]
THEN RW_TAC arith_ss []
);


(*  CCONTR_TAC is also a prove by contradiction *)

val ECLID_THM = store_thm (
"ECLID_THM",
``!n. ?p. n<p /\ prime p``,
SPOSE_NOT_THEN STRIP_ASSUME_TAC
(*SPEC is used to specialize a particular theorem*)
THEN MP_TAC  (SPEC ``(FACT n)+1`` PRIME_FACTOR)
THEN RW_TAC arith_ss []
THENL [
  RW_TAC arith_ss [FACT_LESS , DECIDE ``!x. ~(x=0) = 0< x``]
,
  (*GSYM is rigth to left rewrite*)
  RW_TAC arith_ss [GSYM IMP_DISJ_THM]
  THEN METIS_TAC [DIVIDES_FACT , DIVIDES_ADDL ,DIVIDES_ONE , 
            NOT_PRIME_1 , NOT_LESS , PRIME_POS]
]
);









val _ = export_theory ();
