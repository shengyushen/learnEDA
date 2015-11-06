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

(defun insert (x y)
  (cond ((endp y) (list x))
        ((< x (car y)) (cons x y))
        (t (cons (car y) (insert x (cdr y))))
        )
  )

(defun insert-sort (x)
  (cond ((endp x) nil)
        (t (insert (car x) 
		   (insert-sort (cdr x))))
        )
)


(defthm ismem-insert
  (ismem a (insert a x))
  )



(defthm del-size 
  (implies (ismem a x)
           (< (acl2-count (del a x))
              (acl2-count x))
           )
)
(defthm perm-notmem
  (implies (and (consp x) (not (ismem (car x) y)))
           (not (perm y x))
           )
)



(defun perm2 (x y)
  (cond ((endp x) (endp y))
	(t ))
)

(defthm perm-sym
  (equal (perm x y) 
	 (perm y x)
	 )
)

(defthm perm-sort-self
  (perm x (insert-sort x))
  )

(defthm per-sort-self-ind
  (implies (AND (consp X)
                (perm (CDR X) (INSERT-SORT (CDR X))))
           (perm X
                 (INSERT (CAR X) (INSERT-SORT (CDR X)))))
)
(defthm perm-sort
  (implies (perm x y)
         (equal (insert-sort x) 
		(insert-sort y))
         )
)


(defthm perm-trans
  (implies (and (perm x y) 
		(perm y z))
           (perm x z)
           )
)

(defthm perm-1
  (implies (ismem a y)
           (perm y (cons a (del a y)) )
           )
)











(defthm perm-insert
  (implies (consp x)
           (perm (cons a x) 
		 (cons (car x) 
		       (cons a 
			     (cdr x))))
           )
  )

(defthm perm-sym-ind
  (implies (and (perm (del (car x) y) 
		      (cdr x)) 
		(not (equal nil 
			    (car x))))
           (perm y x)
           )
)
(defthm perm-sym-ind1
  (implies (and (perm (cdr x) 
		      (del (car x) y) ) 
		(ismem (car x) y) 
		(not (equal nil 
			    (car x))))
           (perm x y)
           )
)




