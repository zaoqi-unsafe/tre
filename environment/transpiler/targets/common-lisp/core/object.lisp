; tré – Copyright (c) 2014–2016 Sven Michael Klose <pixel@hugbox.org>

(defbuiltin not (&rest x) (cl:every #'cl:not x))

(defun variable-compare (predicate x)
  (? .x
     (@ (i .x t)
       (| (funcall predicate x. i)
          (return nil)))
     (cl:error "At least 2 arguments required.")))

(defun tre-eql (a b)
  (| (cl:eq a b)
     (?
       (& (cl:characterp a)
          (cl:characterp b))   (cl:= (cl:char-code a)
                                     (cl:char-code b))
       (& (not (cl:characterp a)
               (cl:characterp b))
          (number? a)
          (number? b))         (cl:= a b)
       (& (cl:consp a)
          (cl:consp b))        (& (tre-eql a. b.)
                                  (tre-eql .a .b))
       (& (cl:stringp a)
          (cl:stringp b))      (cl:string= a b))))

(defbuiltin eq (&rest x)  (variable-compare #'cl:eq x))
(defbuiltin eql (&rest x) (variable-compare #'tre-eql x))
