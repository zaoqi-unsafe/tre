;;;;; tré – Copyright (c) 2009–2014 Sven Michael Klose <pixel@copei.de>

(defun used-vars ()
  (alet *funinfo*
    (+ (funinfo-scoped-vars !)
       (intersect (funinfo-vars !) (funinfo-used-vars !) :test #'eq)
       (& (transpiler-copy-arguments-to-stack? *transpiler*)
          (funinfo-args !)))))

(defun remove-unused-scope-arg (fi)
  (when (& (transpiler-optimize-closures? *transpiler*)
           (not (funinfo-fast-scope? fi))
           (funinfo-closure-without-free-vars? fi))
     (= (funinfo-scope-arg fi) nil)
     (pop (funinfo-args fi))
     (pop (funinfo-argdef fi))
     (optimizer-message "; Made ~A a regular function.~%"
                        (human-readable-funinfo-names fi))))

(defun remove-scoped-vars (fi)
  (when (& (== 1 (length (funinfo-scoped-vars fi)))
           (not (funinfo-place? fi (car (funinfo-scoped-vars fi)))))
    (optimizer-message "; Unscoping ~A in ~A.~%"
                       (alet (funinfo-scoped-vars fi) (? .! ! !.))
                       (human-readable-funinfo-names fi))
    (= (funinfo-scoped-vars fi) nil)
    (= (funinfo-scope fi) nil)))

(defun replace-scope-arg (fi)
  (when (& (funinfo-scope-arg fi)
           (not (funinfo-fast-scope? fi))
           (== 1 (length (funinfo-free-vars fi)))
           (not (funinfo-scoped-vars (funinfo-parent fi))))
    (alet (car (funinfo-free-vars fi))
      (= (funinfo-free-vars fi) nil)
      (= (funinfo-scope-arg fi) !)
      (= (funinfo-argdef fi) (cons ! (cdr (funinfo-argdef fi))))
      (= (funinfo-args fi) (cons ! (cdr (funinfo-args fi))))
      (= (funinfo-fast-scope? fi) t)
      (optimizer-message "; Removed array allocation for sole scoped var in ~A.~%"
                         (human-readable-funinfo-names fi)))))

(defun remove-argument-stackplaces (fi)
  (funinfo-vars-set fi (remove-if [& (funinfo-arg? fi _)
                                     (not (funinfo-scoped-var? fi _)
                                          (funinfo-place? fi _))]
                                  (funinfo-vars fi))))

(defun warn-unused-arguments (fi)
  (adolist ((funinfo-args fi))
    (| (funinfo-used-var? fi !)
       (warn "Unused argument ~A of function ~A."
             ! (human-readable-funinfo-names fi)))))

(defun correct-funinfo ()
  (alet *funinfo*
    (when (transpiler-lambda-export? *transpiler*)
      (remove-unused-scope-arg !)
      (remove-scoped-vars !)
      (replace-scope-arg !))
    (funinfo-vars-set ! (intersect (funinfo-vars !) (funinfo-used-vars !) :test #'eq))
    (when (transpiler-stack-locals? *transpiler*)
        (remove-argument-stackplaces !))))
;    (warn-unused-arguments !)

(defun remove-unused-vars (x)
  (& (named-lambda? x.) 
     (with-lambda-funinfo x.
       (correct-funinfo)
       (remove-unused-vars (lambda-body x.))))
  (& x (remove-unused-vars .x)))

(defun optimize-funinfos (x)
  (collect-places x)
  (remove-unused-vars x)
  x)
