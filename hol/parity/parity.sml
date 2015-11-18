val PARITY_def = Define `
(PARITY 0 f = T ) /\
(PARITY (SUC n) f = if f(SUC n)  then ~(PARITY n f) else PARITY n f)`;

g `!inp out.
   (out 0 =T)/\
   (!t. out(SUC t) = (if inp (SUC t) then ~(out t) else out t) ) ==>
   (!t. out t =PARITY t inp)
`

expand  (REPEAT GEN_TAC THEN STRIP_TAC);
expand (Induct_on `t`);
  expand (RW_TAC arith_ss [PARITY_def]);

  expand (RW_TAC arith_ss [PARITY_def ]);
