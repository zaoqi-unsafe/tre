; tré – Copyright (c) 2014 Sven Michael Klose <pixel@copei.de>

(defbuiltin number? (x)
  (| (cl:numberp x)
     (cl:characterp x)))

(defbuiltin integer (x)
  (cl:floor x))

(defun chars-to-numbers (x)
  (cl:mapcar #'(lambda (x)
                 (? (cl:characterp x)
                    (cl:char-code x)
                    x))
             x))

(defbuiltin == (&rest x) (apply #'cl:= (chars-to-numbers x)))
(defbuiltin number== (&rest x) (apply #'cl:= (chars-to-numbers x)))
(defbuiltin integer== (&rest x) (apply #'cl:= (chars-to-numbers x)))
(defbuiltin character== (&rest x) (apply #'cl:= (chars-to-numbers x)))
(defbuiltin %+ (&rest x) (apply #'cl:+ (chars-to-numbers x)))
(defbuiltin %- (&rest x) (apply #'cl:- (chars-to-numbers x)))
(defbuiltin %* (&rest x) (apply #'cl:* (chars-to-numbers x)))
(defbuiltin %/ (&rest x) (apply #'cl:/ (chars-to-numbers x)))
(defbuiltin %< (&rest x) (apply #'cl:< (chars-to-numbers x)))
(defbuiltin %> (&rest x) (apply #'cl:> (chars-to-numbers x)))
(defbuiltin code-char (x) (cl:code-char (cl:floor x)))
(defbuiltin number+ (&rest x) (apply #'%+ x))
(defbuiltin integer+ (&rest x) (apply #'%+ x))
(defbuiltin character+ (&rest x) (apply #'%+ x))
(defbuiltin number- (&rest x) (apply #'%- x))
(defbuiltin integer- (&rest x) (apply #'%- x))
(defbuiltin character- (&rest x) (apply #'%- x))
(defbuiltin * (&rest x) (apply #'%* x))
(defbuiltin / (&rest x) (apply #'%/ x))
(defbuiltin < (&rest x) (apply #'%< x))
(defbuiltin > (&rest x) (apply #'%> x))
;(defbuiltin bit-or (a b) (cl:bit-or a b))
