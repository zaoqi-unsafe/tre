(defmacro define-dom-node-predicate (which type)
  `(fn ,($ which '?) (x)
     (& (object? x)
	    (string== ,(string type) x.node-type))))

(mapcar-macro x '((element 1) (text 3) (comment 8) (document 9))
  `(define-dom-node-predicate ,x. ,.x.))
