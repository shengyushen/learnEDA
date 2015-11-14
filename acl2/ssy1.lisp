(defun insert (x y)
  (cond ((endp y) (list x))
        ((<= x (car y)) (cons x y))
        (t (cons (car y) (insert x (cdr y))))
        )
  )

(defun insert-sort (x)
  (cond ((endp x) nil)
        (t (insert (car x) 
		   (insert-sort (cdr x))))
        )
)

(defun is-sorted (x)
  (cond ((endp x) t)
        ((endp (cdr x)) t)
        (t (and (<= (car x) (car (cdr x)) ) 
                (is-sorted (cdr x)) ) 
           ))
  )

(defthm is-sorted-insert 
  (implies (is-sorted y)
           (is-sorted (insert x y))
           )
  )

(defthm is-sorted-insert-sort 
  (is-sorted (insert-sort x))
  )

(defun ismem (x y)
  (cond  ((endp y) nil)
         ((equal x (car y)) t)
         (t (ismem x (cdr y)))
         )
  )
(defun del (x y)
  (cond ((endp y) y)  
   ((equal x (car y)) (cdr y)) 
        (t (cons (car y) (del x (cdr y))))
   )   
  )
(defun perm (x y)
  (cond ((endp x) (endp y)) 
        ((ismem (car x) y) (perm (cdr x) 
				 (del (car x) y)))
        (t nil)
	)
)

(defthm perm-self
  (perm x x)
)


;(defthm perm-sym-base
;  (implies (and (consp x)
;                (not (ismem (car x) y))
;                )
;           (not (perm y x))))


; return the two list before a and after a
(defun del-before-a (a x)
  (cond ((endp x) nil)
        ((equal a (car x))
         nil)
        (t (cons (car x) (del-before-a a (cdr x)))))
  )

(defun del-after-a (a x)
  (cond ((endp x) nil)
        ((equal a (car x))
         (cdr x))
        (t (del-after-a a (cdr x))))
  )



(defun isallmem (x y)
  (cond ((endp x) t)
        ((ismem (car x) y) (isallmem (cdr x) (del (car x) y)))
        (t nil)
        )
  )

(defun delset (x y)
  (cond ((endp x) y)
        (t (delset (cdr x) (del (car x) y)))
        )
  )

(defthm perm-bfy-in-xcdr
  (implies (perm (append x y) z)
           (isallmem x z))
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;
; uselful

(defthm del-equal-before-after 
  (implies (ismem a x)
           (equal (del a x)
                  (append (del-before-a a x) 
                          (del-after-a a x)
                          )
                  )
           )
  )

(defthm perm-delset-bf-equal-cdr-x
  (implies (isallmem bfy xcdr)
           (equal (perm (append bfy afy) xcdr)
                  (perm afy (delset bfy xcdr)))
           )
  )


(defthm permxy-perm-cdr-xy
  (implies (perm x y)
           (perm (cdr x) 
                 (del (car x) y))))

(defthm perm-sym
  (implies (perm x y) 
           (perm y x)
           )
  )


  
(defthm perm-del
  (implies (ismem  a y)
           (equal (perm (del a y) x)
                  (perm y (cons a x))))
  ;; A hint is necessary.
  :hints (("Goal" :induct (perm y x))))

(defthm perm-symmetric
  (implies (perm x y) (perm y x)))))

(local
 (encapsulate
  ()

  ;; We can imagine that the following rule would loop with perm-symmetric, so
  ;; we make it local to this encapsulate.

  (local
   (defthm perm-del
     (implies (ismem a y)
              (equal (perm (del a y) x)
                     (perm y (cons a x))))
     ;; A hint is necessary.
     :hints (("Goal" :induct (perm y x)))))

  (defthm perm-symmetric
    (implies (perm x y) (perm y x)))))


;;;;;;;;;;;;;;;;;;;;;;;;;




(defthm perm-delset-bf-equal-cdr-x
  (implies (isallmem bfy xcdr)
           (equal (perm (append bfy afy) xcdr)
                  (perm afy (delset bfy xcdr)))
           )
  )

(defthm perm-add-bf-equal
  (implies (isallmem bf y)
           (equal (perm x (delset bf y))
                  (perm (append bf x) y)))
  )

(defthm car-x-del-equal-del-car-x
  (implies (and (ismem b x)
                (not (equal a b)))
           (equal (cons a (del b x))
                  (del b (cons a x))))
  )

(defthm car-x-delset-equal-delset-car-x
  (implies (and (isallmem bf x)
                (not (ismem a bf)))
           (equal (cons a (delset bf x))
                  (delset bf (cons a x))))
  )

(defthm append-bfa-a-afa-equal-y
  (implies (and (consp y)
                (ismem a y))
           (equal (append (del-before-a a y) 
                          (cons a
                                (del-after-a a y))
                          )
                  y)
           )
  )


(defthm not-ismem-carx-del-before-a
  (not (ismem a (del-before-a a x))))

;used only in proving perm-induct
; need to be disable in perm-sym
(defthm perm-add-head-equal
  (equal (perm x y)
         (perm (cons a x) (cons a y))))



(defthm perm-induct
  (IMPLIES (AND (CONSP X)
                (ISMEM (CAR X) Y)
                (PERM (APPEND (DEL-BEFORE-A (CAR X) Y)
                              (DEL-AFTER-A (CAR X) Y))
                      (CDR X))
                (PERM (CDR X)
                      (APPEND (DEL-BEFORE-A (CAR X) Y)
                              (DEL-AFTER-A (CAR X) Y))))
           (PERM Y X))
  )

