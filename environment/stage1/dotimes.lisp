;;;;; tré – Copyright (c) 2005–2008,2010–2012 Sven Michael Klose <pixel@copei.de>

(defmacro dotimes ((iter times &rest result) &body body)
  (let g (gensym)
    `(let ,g (integer ,times)
       (do ((,iter 0 (integer+ 1 ,iter)))
	       ((integer== ,iter ,g) ,@result)
	     ,@body))))