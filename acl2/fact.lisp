(defun fact (x)
  (cond ((zp x) 1)
        (t (* x (fact (- x 1)))) )
)

(defun tfact ( x y)
  (cond ((zp x) y)
        (t (tfact (- x 1) (* x y))))
  )

(defthm tfact-1
  (implies (integerp p)
  (equal (tfact x p)
         (* p (fact x)))))

(defthm tfact-eq-fact 
  (equal (fact x) 
         (tfact x 1))
)


(defthm com-*2
  (equal (* y (* x z)) 
         (* x (* y z))
         )
)
