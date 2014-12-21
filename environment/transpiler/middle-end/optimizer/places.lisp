;;;; tré – Copyright (c) 2008–2014 Sven Michael Klose <pixel@copei.de>

(define-optimizer optimize-places
  (& (%=? a)
     (%=? d.)
     (eq (%=-place a) (%=-value d.))
     (not (will-be-used-again? .d (%=-place a))))
    (. `(%= ,(%=-place d.) ,(%=-value a))
       (optimize-places .d))
  (& (%=? a)
     (%=? d.)
     (atom (%=-value a))
     (cons? (%=-value d.))
     (tree-find (%=-place a) (%=-value d.) :test #'eq)
     (not (will-be-used-again? .d (%=-place a))))
    (. (replace-tree (%=-place a) (%=-value a)
                     `(%= ,(%=-place d.) ,(%=-value d.))
                     :test #'eq)
       (optimize-places .d))
  (& (%=? a)
     (not (will-be-used-again? d (%=-place a))))
    (. `(%= nil ,(%=-value a))
       (optimize-places d)))
