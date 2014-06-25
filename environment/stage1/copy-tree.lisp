;;;;; tré – Copyright (c) 2005–2009,2011–2013 Sven Michael Klose <pixel@copei.de>

(functional copy-tree)

(early-defun copy-tree (x)
  (? (atom x)
     x
     (progn
       (? (cpr x)
          (setq *default-listprop* (cpr x)))
       (#'((p c)
             (rplacp c (setq *default-listprop* p)))
         *default-listprop*
	     (cons (copy-tree (car x))
               (copy-tree (cdr x)))))))