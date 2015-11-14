(*basic term*)
val ssy = [1,2,3];
val triple = (1,2,3);
val first = #1 triple;
val second = #2 triple;
val third = #3 triple ;

(*destructors*)
val t1=``x/\y==>z``;
val imp_pair = dest_imp t1;
val conjt= ``x/\y``;
val conj_pair = dest_conj conjt;

(*logic type and ml expression type*)
(*every xxx in ``xxx`` is a term*)
``(1,2)``;
type_of it;

``(1,2,3)``;
type_of it;

(*but (``xx``,``xxx``) is a term*term*)
val tt=(``1``,``2``);
type_of (#1 tt);
type_of (#2 tt);

(*term constructor*)
val x = mk_var("x",``:bool``)
and y = mk_var("y",``:bool``)
and z = mk_var("z",``:bool``);

val t = mk_imp (mk_conj(x,y),z);

(*type constraint*)
val a =``a:num``;

(*lambda *)
val l = ``\x. x + 1``;

(*axiom*)
BOOL_CASES_AX;


(*specializing*)
val th1 = SPEC ``1 = 2`` BOOL_CASES_AX;

(*show full assumptions*)
show_assums := true;

(*inference rule*)
val th3 = ASSUME `` t1 ==> t2 ``;
dest_thm th3;
(*dischaging change t1,XX |- t2 ro XX|-t1->t2*)
val th4 = DISCH `` t1 ==> t2 `` th3;
(*MP t1==>t2  t1 get
 t1==>t2, t1 |- t2*)
val th5 = ASSUME ``t1:bool``;
val th6 = MP th3 th5;
(*add new t3 not on right side and hyp*)
val th10 = DISCH ``t3:bool`` th6;

(*derived rule*)
(*add an unrelated assumption*)
ADD_ASSUM ``t3:bool`` th6;
(*show full assumptions*)
UNDISCH th10;

open arithmeticTheory;

val rewrite_list = [ADD_CLAUSES,MULT_CLAUSES];

REWRITE_RULE rewrite_list (ASSUME ``(m+0)<(1*n)+(SUCC 0)``);

val thA = ASSUME ``A:bool``;
val thB = ASSUME ``B:bool``;
val thAB = CONJ thA thB;

val goal1 = ([]:term list, ``T /\ T``);
val (subg_list,just_fn) = CONJ_TAC goal1;
just_fn [TRUTH,TRUTH];

