; tré – Copyright (c) 2008–2014,2016 Sven Michael Klose <pixel@copei.de>

(define-js-macro tre_cons (x y)
  `("new " ,(compiled-function-name '%cons) "(" ,x "," ,y ")"))

(mapcan-macro p
	'((tre_car _)
	  (tre_cdr __))
  `((define-js-macro ,p. (x)
      `(%%native ,,(js-nil? x) " ? null : " ,,x "." ,.p.))
    (define-js-macro ,.p. (v x)
      `(%%native ,,x "." ,.p. " = " ,,v))))
