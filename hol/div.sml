(* load is used to load in the theory
whithout it nothing can be accessed 
but we still refer to them with dot , such as xxTheory.xxfun

but with open , we can directly refer to xxfuun
*)

open arithmeticTheory;

val divides_def = Define `divides a b  = ? x . b = a * x `;
set_fixity "divides" (Infix(NONASSOC,450));
val prime_def = Define `prime p = ~(p=1) /\ !x. x divides p ==> (x=1) \/ (x=p)`;

(*proving DIVIDES_0*)
g `!x. x divides 0`;
e (RW_TAC arith_ss [divides_def]);
e (EXISTS_TAC ``0``);
e (RW_TAC arith_ss []);


restart();
e (METIS_TAC [divides_def, MULT_CLAUSES]);
val DIVIDES_0 = top_thm ();
drop ();

(*DIVIDES_ZERO*)
g `!x. (0 divides x) = (x=0)`;
e (RW_TAC arith_ss [divides_def]);
val DIVIDES_ZERO = top_thm ();
drop ();

(* DIVIDES_ONE *)
g `!x. (x divides 1) = (x=1)`;
e (RW_TAC arith_ss [divides_def]);
val DIVIDES_ONE = top_thm ();
drop ();

(* DIVIDES_REFL *)
g `!x. x divides x`;
e (RW_TAC arith_ss [divides_def]);
e (EXISTS_TAC ``1``);
e (RW_TAC arith_ss []);
val DIVIDES_REFL = top_thm ();
drop ();

(* DIVIDES_TRANS *)
g `!a b c. ( a divides b ) /\ (b divides c) ==> (a divides c)`;
e (METIS_TAC [divides_def,MULT_ASSOC]);
val DIVIDES_TRANS = top_thm ();
drop ();

(* DIVIDES_ADD  *)
g `!a b d. (d divides a) /\ (d divides b) ==> (d divides (a + b))`;
(* METIS_TAC use metisLib, while PROVE_TAC use mesonLib
both are powerful libs*)
e (METIS_TAC [divides_def, LEFT_ADD_DISTRIB]);
val DIVIDES_ADD = top_thm ();
drop ();

(* DIVIDES_SUB *)
g `!a b d. (d divides a) /\ (d divides b) ==> (d divides (a - b))`;
e (METIS_TAC [divides_def , LEFT_SUB_DISTRIB]);
val DIVIDES_SUB = top_thm ();
drop ();


(*  DIVIDES_ADDL *)
g `!a b d. (d divides a) /\ (d divides (a+b)) ==> (d divides b)`;
e (RW_TAC arith_ss [divides_def]);
e (EXISTS_TAC ``x'-x``);
e (RW_TAC arith_ss []);
val DIVIDES_ADDL = top_thm ();
drop ();


(* DIVIDES_LMUL  *)
g `!d a x. (d divides a) ==> (d divides (x * a))`;
e (RW_TAC arith_ss [divides_def]);
e (EXISTS_TAC ``x'*x``);
e (RW_TAC arith_ss []);
val DIVIDES_LMUL = top_thm ();
drop ();


(*  DIVIDES_RMUL *)
g `!d a x. (d divides a) ==> (d divides (a*x))`;
e (RW_TAC arith_ss [divides_def]);
e (EXISTS_TAC ``x'*x``);
e (RW_TAC arith_ss []);
val DIVIDES_RMUL = top_thm ();
drop ();


(* DIVIDES_LE *)
g `!m n. (m divides n) ==> (m <= n) \/ (n=0)`;
e (RW_TAC arith_ss [divides_def]);
e (Cases_on `x`);
(*
DB.match ["arithmetic"] ``m* SUC n``;
DB.match ["arithmetic"] ``m*0``;
these two both find the MULT_CLAUSES
this equal to coq's similar mechanism
*)
e (RW_TAC arith_ss [MULT_CLAUSES]);
e (RW_TAC arith_ss [MULT_CLAUSES]);
(*
store_thm can save the name of theorem together with its proof
*)
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


g `~(prime 0)`;
e (RW_TAC arith_ss [prime_def,DIVIDES_0]);
val NOT_PRIME_0 = top_thm ();
drop ();

g `~ (prime 1)`;
e (RW_TAC arith_ss [prime_def]);
val NOT_PRIME_1 = top_thm ();
drop ();

g `prime 2`;
e (RW_TAC arith_ss [prime_def]);
e (METIS_TAC [DIVIDES_LE,DIVIDES_ZERO, DECIDE ``~(2=1)``, DECIDE ``~(2=0)`` , DECIDE ``(x<=2)=(x=0)\/(x=1)\/(x=2)``]);
val PRIME_2 = top_thm ();
drop ();

g `!p. prime p ==> 0<p`;
e (Cases) ;
e (RW_TAC arith_ss [NOT_PRIME_0]);
e (RW_TAC arith_ss []);
val PRIME_POS = top_thm ();
drop ();

g `!n. ~(n=1) ==> ?p. prime p /\ p divides n`;
(* 
complete induction means we can use all the lower cases
*)
e (completeInduct_on `n`);
e (RW_TAC arith_ss []);
e (Cases_on `prime n`);
  e (METIS_TAC [DIVIDES_REFL]);

  e (`?x. x divides n /\ ~(x=1) /\ ~ (x=n)` by METIS_TAC[prime_def]);
  e (`x<=n\/(n=0) ` by METIS_TAC[prime_def , DIVIDES_LE]);
    e (`x<n` by RW_TAC arith_ss []);
    e (`?p1. prime p1 /\ p1 divides x` by METIS_TAC []);
    e (`prime p1 /\ (p1 divides n)` by METIS_TAC [DIVIDES_TRANS]);
    e (METIS_TAC []);

    e (RW_TAC arith_ss []);
    e (`prime 2` by METIS_TAC [PRIME_2]);
    e (EXISTS_TAC ``2``);
    e (RW_TAC arith_ss [divides_def, prime_def]) ;

val PRIME_FACTOR = top_thm ();
drop ();

g `!n. ?p. n<p /\ prime p`;

e (SPOSE_NOT_THEN STRIP_ASSUME_TAC);
