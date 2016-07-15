; tré – Copyright (c) 2011–2012,2014–2016 Sven Michael Klose <pixel@hugbox.org>

(defmacro dosequence ((var seq &rest result) &body body)
  (with-gensym (evald-seq idx)
    `(let ,evald-seq ,seq
       (when ,evald-seq
         (dotimes (,idx (length ,evald-seq) ,@result)
           (let ,var (elt ,evald-seq ,idx)
             ,@body))))))

(defmacro adosequence (params &body body)
  (let p (? (atom params)
            (list params)
            params)
    `(dosequence (! ,p. ,.p.)
       ,@body)))