(defun app (x y)
  (if (endp x)
      y
      (cons (car x) (app (cdr x) y))
  )
)
(defthm appassoc 
  (equal (app (app a a) a) (app a (app a a)))
  :rule-classes nil
)
