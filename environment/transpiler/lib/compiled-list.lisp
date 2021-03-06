(fn %compiled-atom (x quoted?)
  (? (& quoted? x (symbol? x))
     (list 'quote x)
     x))

(fn compiled-list (x &key (quoted? nil))
  (? (cons? x)
     `(. ,(%compiled-atom x. quoted?)
         ,(compiled-list .x :quoted? quoted?))
	 (%compiled-atom x quoted?)))

(fn compiled-tree (x &key (quoted? nil))
  (? (cons? x)
     `(. ,(compiled-tree x. :quoted? quoted?)
         ,(compiled-tree .x :quoted? quoted?))
	 (%compiled-atom x quoted?)))
