(defun app (x y)
  (if (endp x) y (cons (car x) (app (cdr x) y)))
)
