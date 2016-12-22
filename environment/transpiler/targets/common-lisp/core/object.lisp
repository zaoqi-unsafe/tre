; tré – Copyright (c) 2014–2016 Sven Michael Klose <pixel@hugbox.org>

(defbuiltin not (&rest x) (cl:every #'cl:not x))
(defbuiltin eq (a b)      (cl:eq a b))

(defbuiltin eql (a b)
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
          (cl:consp b))        (& (eql a. b.)
                                  (eql .a .b))
       (& (cl:stringp a)
          (cl:stringp b))      (cl:string= a b))))
