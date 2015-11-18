structure euclidTheory :> euclidTheory =
struct
  val _ = if !Globals.print_thy_loads then print "Loading euclidTheory ... " else ()
  open Type Term Thm
  infixr -->

  fun C s t ty = mk_thy_const{Name=s,Thy=t,Ty=ty}
  fun T s t A = mk_thy_type{Tyop=s, Thy=t,Args=A}
  fun V s q = mk_var(s,q)
  val U     = mk_vartype
  (*  Parents *)
  local open listTheory
  in end;
  val _ = Theory.link_parents
          ("euclid",
          Arbnum.fromString "1447749800",
          Arbnum.fromString "579182")
          [("list",
           Arbnum.fromString "1447473066",
           Arbnum.fromString "29452")];
  val _ = Theory.incorporate_types "euclid" [];

  val idvector = 
    let fun ID(thy,oth) = {Thy = thy, Other = oth}
    in Vector.fromList
  [ID("min", "fun"), ID("min", "bool"), ID("num", "num"), ID("bool", "!"),
   ID("arithmetic", "*"), ID("arithmetic", "+"), ID("arithmetic", "-"),
   ID("bool", "/\\"), ID("num", "0"), ID("prim_rec", "<"),
   ID("arithmetic", "<="), ID("min", "="), ID("min", "==>"),
   ID("bool", "?"), ID("arithmetic", "BIT1"), ID("arithmetic", "BIT2"),
   ID("arithmetic", "FACT"), ID("arithmetic", "NUMERAL"), ID("num", "SUC"),
   ID("arithmetic", "ZERO"), ID("bool", "\\/"), ID("euclid", "divides"),
   ID("euclid", "prime"), ID("bool", "~")]
  end;
  local open SharingTables
  in
  val tyvector = build_type_vector idvector
  [TYOP [1], TYOP [2], TYOP [0, 1, 0], TYOP [0, 1, 2], TYOP [0, 2, 0],
   TYOP [0, 1, 1], TYOP [0, 1, 5], TYOP [0, 0, 0], TYOP [0, 0, 7]]
  end
  val _ = Theory.incorporate_consts "euclid" tyvector
     [("prime", 2), ("divides", 3)];

  local open SharingTables
  in
  val tmvector = build_term_vector idvector tyvector
  [TMV("a", 1), TMV("b", 1), TMV("c", 1), TMV("d", 1), TMV("m", 1),
   TMV("n", 1), TMV("p", 1), TMV("x", 1), TMC(3, 4), TMC(4, 6), TMC(5, 6),
   TMC(6, 6), TMC(7, 8), TMC(8, 1), TMC(9, 3), TMC(10, 3), TMC(11, 8),
   TMC(11, 3), TMC(12, 8), TMC(13, 4), TMC(14, 5), TMC(15, 5), TMC(16, 5),
   TMC(17, 5), TMC(18, 5), TMC(19, 1), TMC(20, 8), TMC(21, 3), TMC(22, 2),
   TMC(23, 7)]
  end
  local
  val DT = Thm.disk_thm val read = Term.read_raw tmvector
  in
  val op divides_def =
    DT([],
       [read"(%8 (|%0. (%8 (|%1. ((%16 ((%27 $1) $0)) (%19 (|%7. ((%17 $1) ((%9 $2) $0)))))))))"])
  val op prime_def =
    DT([],
       [read"(%8 (|%6. ((%16 (%28 $0)) ((%12 (%29 ((%17 $0) (%23 (%20 %25))))) (%8 (|%7. ((%18 ((%27 $0) $1)) ((%26 ((%17 $0) (%23 (%20 %25)))) ((%17 $0) $1)))))))))"])
  val op DIVIDES_0 = DT(["DISK_THM"], [read"(%8 (|%7. ((%27 $0) %13)))"])
  val op DIVIDES_ZERO =
    DT(["DISK_THM"],
       [read"(%8 (|%7. ((%16 ((%27 %13) $0)) ((%17 $0) %13))))"])
  val op DIVIDES_ONE =
    DT(["DISK_THM"],
       [read"(%8 (|%7. ((%16 ((%27 $0) (%23 (%20 %25)))) ((%17 $0) (%23 (%20 %25))))))"])
  val op DIVIDES_REFL = DT(["DISK_THM"], [read"(%8 (|%7. ((%27 $0) $0)))"])
  val op DIVIDES_TRANS =
    DT(["DISK_THM"],
       [read"(%8 (|%0. (%8 (|%1. (%8 (|%2. ((%18 ((%12 ((%27 $2) $1)) ((%27 $1) $0))) ((%27 $2) $0))))))))"])
  val op DIVIDES_ADD =
    DT(["DISK_THM"],
       [read"(%8 (|%0. (%8 (|%1. (%8 (|%3. ((%18 ((%12 ((%27 $0) $2)) ((%27 $0) $1))) ((%27 $0) ((%10 $2) $1)))))))))"])
  val op DIVIDES_SUB =
    DT(["DISK_THM"],
       [read"(%8 (|%0. (%8 (|%1. (%8 (|%3. ((%18 ((%12 ((%27 $0) $2)) ((%27 $0) $1))) ((%27 $0) ((%11 $2) $1)))))))))"])
  val op DIVIDES_ADDL =
    DT(["DISK_THM"],
       [read"(%8 (|%0. (%8 (|%1. (%8 (|%3. ((%18 ((%12 ((%27 $0) $2)) ((%27 $0) ((%10 $2) $1)))) ((%27 $0) $1))))))))"])
  val op DIVIDES_LMUL =
    DT(["DISK_THM"],
       [read"(%8 (|%3. (%8 (|%0. (%8 (|%7. ((%18 ((%27 $2) $1)) ((%27 $2) ((%9 $0) $1)))))))))"])
  val op DIVIDES_RMUL =
    DT(["DISK_THM"],
       [read"(%8 (|%3. (%8 (|%0. (%8 (|%7. ((%18 ((%27 $2) $1)) ((%27 $2) ((%9 $1) $0)))))))))"])
  val op DIVIDES_LE =
    DT(["DISK_THM"],
       [read"(%8 (|%4. (%8 (|%5. ((%18 ((%27 $1) $0)) ((%26 ((%15 $1) $0)) ((%17 $0) %13)))))))"])
  val op DIVIDES_FACT =
    DT(["DISK_THM"],
       [read"(%8 (|%4. (%8 (|%5. ((%18 ((%12 ((%14 %13) $1)) ((%15 $1) $0))) ((%27 $1) (%22 $0)))))))"])
  val op NOT_PRIME_0 = DT(["DISK_THM"], [read"(%29 (%28 %13))"])
  val op NOT_PRIME_1 =
    DT(["DISK_THM"], [read"(%29 (%28 (%23 (%20 %25))))"])
  val op PRIME_2 = DT(["DISK_THM"], [read"(%28 (%23 (%21 %25)))"])
  val op PRIME_POS =
    DT(["DISK_THM"], [read"(%8 (|%6. ((%18 (%28 $0)) ((%14 %13) $0))))"])
  val op PRIME_FACTOR =
    DT(["DISK_THM"],
       [read"(%8 (|%5. ((%18 (%29 ((%17 $0) (%23 (%20 %25))))) (%19 (|%6. ((%12 (%28 $0)) ((%27 $0) $1)))))))"])
  val op LE_1_SUC =
    DT(["DISK_THM"], [read"(%8 (|%7. ((%15 (%23 (%20 %25))) (%24 $0))))"])
  val op LE_1_FACT =
    DT(["DISK_THM"], [read"(%8 (|%7. ((%15 (%23 (%20 %25))) (%22 $0))))"])
  val op LT_0_SUC =
    DT(["DISK_THM"], [read"(%8 (|%5. ((%14 %13) (%24 $0))))"])
  val op LT_0_FACT =
    DT(["DISK_THM"], [read"(%8 (|%5. ((%14 %13) (%22 $0))))"])
  val op LE_n_FACT =
    DT(["DISK_THM"], [read"(%8 (|%5. ((%15 $0) (%22 $0))))"])
  val op NOT_EQ_FACT_ADD1_1 =
    DT(["DISK_THM"],
       [read"(%8 (|%5. (%29 ((%17 ((%10 (%22 $0)) (%23 (%20 %25)))) (%23 (%20 %25))))))"])
  val op ECLID_THM1 =
    DT(["DISK_THM"],
       [read"(%8 (|%5. (%19 (|%6. ((%12 ((%14 $1) $0)) (%28 $0))))))"])
  val op ECLID_THM =
    DT(["DISK_THM"],
       [read"(%8 (|%5. (%19 (|%6. ((%12 ((%14 $1) $0)) (%28 $0))))))"])
  end
  val _ = DB.bindl "euclid"
  [("divides_def",divides_def,DB.Def), ("prime_def",prime_def,DB.Def),
   ("DIVIDES_0",DIVIDES_0,DB.Thm), ("DIVIDES_ZERO",DIVIDES_ZERO,DB.Thm),
   ("DIVIDES_ONE",DIVIDES_ONE,DB.Thm),
   ("DIVIDES_REFL",DIVIDES_REFL,DB.Thm),
   ("DIVIDES_TRANS",DIVIDES_TRANS,DB.Thm),
   ("DIVIDES_ADD",DIVIDES_ADD,DB.Thm), ("DIVIDES_SUB",DIVIDES_SUB,DB.Thm),
   ("DIVIDES_ADDL",DIVIDES_ADDL,DB.Thm),
   ("DIVIDES_LMUL",DIVIDES_LMUL,DB.Thm),
   ("DIVIDES_RMUL",DIVIDES_RMUL,DB.Thm), ("DIVIDES_LE",DIVIDES_LE,DB.Thm),
   ("DIVIDES_FACT",DIVIDES_FACT,DB.Thm),
   ("NOT_PRIME_0",NOT_PRIME_0,DB.Thm), ("NOT_PRIME_1",NOT_PRIME_1,DB.Thm),
   ("PRIME_2",PRIME_2,DB.Thm), ("PRIME_POS",PRIME_POS,DB.Thm),
   ("PRIME_FACTOR",PRIME_FACTOR,DB.Thm), ("LE_1_SUC",LE_1_SUC,DB.Thm),
   ("LE_1_FACT",LE_1_FACT,DB.Thm), ("LT_0_SUC",LT_0_SUC,DB.Thm),
   ("LT_0_FACT",LT_0_FACT,DB.Thm), ("LE_n_FACT",LE_n_FACT,DB.Thm),
   ("NOT_EQ_FACT_ADD1_1",NOT_EQ_FACT_ADD1_1,DB.Thm),
   ("ECLID_THM1",ECLID_THM1,DB.Thm), ("ECLID_THM",ECLID_THM,DB.Thm)]

  local open Portable GrammarSpecials Parse
    fun UTOFF f = Feedback.trace("Parse.unicode_trace_off_complaints",0)f
  in
  val _ = mk_local_grms [("listTheory.list_grammars",
                          listTheory.list_grammars)]
  val _ = List.app (update_grms reveal) []
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("divides", (Term.prim_mk_const { Name = "divides", Thy = "euclid"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("divides", (Term.prim_mk_const { Name = "divides", Thy = "euclid"}))
  val _ = update_grms
       (UTOFF (temp_set_fixity "divides"))
       (Infix(HOLgrammars.NONASSOC, 450))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("prime", (Term.prim_mk_const { Name = "prime", Thy = "euclid"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("prime", (Term.prim_mk_const { Name = "prime", Thy = "euclid"}))
  val euclid_grammars = Parse.current_lgrms()
  end
  val _ = Theory.LoadableThyData.temp_encoded_update {
    thy = "euclid",
    thydataty = "compute",
    data = "euclid.divides_def euclid.prime_def"
  }

val _ = if !Globals.print_thy_loads then print "done\n" else ()
val _ = Theory.load_complete "euclid"
end
