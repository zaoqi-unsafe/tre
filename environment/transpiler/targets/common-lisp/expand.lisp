; tré – Copyright (c) 2014–2015 Sven Michael Klose <pixel@copei.de>

(add-printer-argument-definition 'cl:labels      '(assignments &body body))
(add-printer-argument-definition 'cl:lambda      '(args &body body))
(add-printer-argument-definition 'cl:defun       '(name args &body body))
(add-printer-argument-definition 'cl:defmacro    '(name args &body body))
(add-printer-argument-definition 'cl:defvar      '(name init))
(add-printer-argument-definition 'cl:defconstant '(name init))

(defmacro define-cl-std-macro (name args &body body)
  `(define-transpiler-std-macro *cl-transpiler* ,name ,args ,@body))

(define-cl-std-macro %set-atom-fun (x v)
  `(cl:setf (cl:symbol-function ',x) ,v))

(define-cl-std-macro defun (name args &body body)
  (print-definition `(defun ,name))
  (add-defined-function name args body)
  `(cl:defun ,name ,args ,@body))

(define-cl-std-macro defvar (name &optional (init nil))
  (print-definition `(defvar ,name))
  (add-defined-variable name)
  (add-delayed-expr `((cl:setq ,name ,init)))
  `(cl:defvar ,name))

(define-cl-std-macro defconstant (name &optional (init nil))
  (print-definition `(defconstant ,name))
  (add-defined-variable name)
  (add-delayed-expr `((cl:defconstant ,name ,init))))

(define-cl-std-macro defmacro (name args &body body)
  (print-definition `(defmacro ,name ,args))
  (make-transpiler-std-macro name args body))

(define-cl-std-macro defspecial (name args &body body)
  (print-definition `(defspecial ,name ,args))
  (add-delayed-expr `((cl:push (. (tre-symbol ',name)
                                  (. ',args
                                     #'(,(argument-expand-names 'defspecial args)
                                        ,@body)))
                               *special-forms*))))

(defun make-? (body)
  (with (tests (group body 2)
         end   (car (last tests)))
    (| body
       (error "Body is missing."))
    `(cl:cond
       ,@(? (sole? end)
            (+ (butlast tests) (list (. t end)))
            tests))))

(define-cl-std-macro ? (&body body)
  (make-? body))
