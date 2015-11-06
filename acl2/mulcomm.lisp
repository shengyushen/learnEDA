(defthm associativity-of-*-rhs
  (equal (* x y z)
         (* (* x y) z))
  )


(DEFTHM COM2 (EQUAL (* Y (* X Z)) (* X (* Y Z)))
                      :RULE-CLASSES NIL
                      :INSTRUCTIONS ((:DV 1)
                                     (:REWRITE ASSOCIATIVITY-OF-*-RHS)
                                     (:DV 1)
                                     (:REWRITE COMMUTATIVITY-OF-*)
                                     :UP (:REWRITE ASSOCIATIVITY-OF-*)
                                     :TOP :BASH))

(defthm commutativity-of-*-2
  (equal (* y (* x z))
         (* x (* y z)))
  :hints (("Goal"
           :use ((:instance ASSOCIATIVITY-OF-*  (y x) (x y))
                 (:instance ASSOCIATIVITY-OF-*))
           :in-theory (disable associativity-of-*))))

