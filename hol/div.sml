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

(*DIVIDES_ONE*)
g `!x. (x divides 1) = (x=1)`;
