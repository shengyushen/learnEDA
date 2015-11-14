;(in-package "ACL2")

; Start definitions from Chapter 10.

(defun in (a b)
  (cond ((atom b) nil)
        ((equal a (car b)) t)
        (t (in a (cdr b)))))

(defun del (a x)
  (cond ((atom x) nil)
        ((equal a (car x)) (cdr x))
        (t (cons (car x) (del a (cdr x))))))

(defun perm (x y)
  (cond ((atom x) (atom y))
        (t (and (in (car x) y)
                (perm (cdr x) (del (car x) y))))))

; End definitions from Chapter 10.

(local (defthm perm-reflexive
         (perm x x)))


  ;; We can imagine that the following rule would loop with perm-symmetric, so
  ;; we make it local to this encapsulate.
;(local 
; (encapsulate 
;  ()
;  (local
(defthm perm-del
  (implies (in a x)
           (equal (perm (del a x) y)
                  (perm x (cons a y))))
  ;; A hint is necessary.
  :hints (("Goal" :induct (perm x y)))))




(defthm perm-symmetric
  (implies (perm x y) (perm y x)))

;)
;)



(defthm perm-del1
  (implies (in a x)
           (equal (perm y (del a x) )
                  (perm (cons a y) x)))
  ;; A hint is necessary.
  :hints (("Goal" :induct (perm x y)))))



(defthm in-a-delbx->in-ax
  (implies (and (in a (del b x))
                (in b x))
           (in a x))
  )



(defthm perm-xy-in-ax->in-ay
  (implies (and (perm x y)
                (in a x))
           (in a y))
  :hints (("Goal" :induct (perm x y)))
  )


(defthm in-simplify-cons-del
  (implies (and (in a (cons b (del b x))
                    )
                (in b x))
           (in a x)
           )
  )


(defthm perm-xy->in-carx-y
  (implies (and (perm x y)
                (consp x))
           (in (car x) y))
;  :hints (("Goal" :induct (perm x y)))
  )

(defthm del-cons-exchange
  (implies (and (in a x)
                (not (equal a b)))
           (equal (del a (cons b x))
                  (cons b (del a x)))
           )
  )

(defthm del-cons-del-exchange
  (implies (and (in a x)
                (in b x)
                (not (equal a b))
                (del a (cons b (del b x))))
           (cons b (del b (del a x)))
           )
  )



(defthm perm-x-cons-a-del-ay
  (implies (and (in a y)
                (perm x (cons a (del a y))))
           (perm x y)
           )
  :hints (("Goal" :induct(perm x y)))
  )



























(defthm perm-trans
  (implies (and (perm x y)
                (perm y z))
           (perm x z)
           )
  )
