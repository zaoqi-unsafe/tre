(defmacro with-open-file (str file &body body)
  `(let ,str ,file
     (prog1 (block nil
              ,@body)
       (close ,str))))

(defmacro with-file (f path direction &body body)
  `(with-open-file ,f (open ,path :direction ,direction)
     ,@body))

(defmacro with-input-file (f path &body body)
  `(with-file ,f ,path 'input
     ,@body))

(defmacro with-output-file (f path &body body)
  `(with-file ,f ,path 'output
     ,@body))

(defmacro with-io (i ipath o opath &body body)
  `(with-input-file ,i, ipath
     (with-output-file ,o ,opath
       ,@body)))
