(define-test "NCONC works"
  ((nconc (copy-list '(l i)) (copy-list '(s p))))
  '(l i s p))

(define-test "NCONC works with empty lists"
  ((nconc nil (copy-list '(l i)) nil (copy-list '(s p)) nil))
  '(l i s p))

(define-test "NCONC with NIL first"
  ((nconc nil '(3 4)))
  '(3 4))

(define-test "NCONC with NIL second"
  ((nconc '(1 2) nil))
  '(1 2))
