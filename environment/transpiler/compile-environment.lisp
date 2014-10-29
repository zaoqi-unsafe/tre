;;;;; tré – Copyright (c) 2008–2014 Sven Michael Klose <pixel@copei.de>

(defun %environment-transpiler (tr funs)
  (aprog1 (copy-transpiler tr)
    (transpiler-add-wanted-functions ! (| (!? funs
                                             (ensure-list !))
                                          (+ *universe-functions* *macros*)))))

(defun compile-c-environment (&optional (funs nil))
  (put-file "interpreter/_compiled-env.c"
            (compile-sections nil :transpiler (%environment-transpiler *c-transpiler* funs)))
  nil)

(defun compile-bytecode-environment (&optional (funs nil))
  (alet (%environment-transpiler *bc-transpiler* funs)
    (expr-to-code ! (compile-sections nil :transpiler !))))

(defun compile-c-compiler ()
  (compile-c-environment '(generic-compile)))

(defun compile-bytecode-compiler ()
  (compile-bytecode-environment '(generic-compile)))
