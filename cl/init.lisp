;;;;; tré – Copyright (c) 2014 Sven Michael Klose <pixel@copei.de>

(defpackage :tre-init
  (:use :common-lisp)
  (:export :+renamed-imports+
           :+builtins+
           :make-keyword
           :cl-peek-char :cl-read-char))

(in-package :tre-init)

;;; Symbols directly imported from package CL-USER.
(defconstant +direct-imports+
    '(nil t atom setq quote
      cons car cdr rplaca rplacd
      apply function
      progn block return return-from tagbody go
      mod sqrt sin cos atan exp round floor
      last copy-list nthcdr nth mapcar elt length make-string
      aref code-char char-code
      symbol-name make-package package-name
      logxor bit-and
      print
      list copy-list
      &rest &body &optional &key
      labels))

;;; Functions we import from CL-USER, wrap and export to package TRE.
(defconstant +renamed-imports+
    '((cons? consp)
      (symbol? symbolp)
      (function? functionp)
      (string? stringp)
      (array? arrayp)
      (character? characterp)
      (number< <)
      (integer< <)
      (character< <)
      (number> >)
      (integer> >)
      (character> >)
      (%error error)
      (%nconc nconc)))

;;; Things we have to implement ourselves.
(defconstant +implementations+
    '(%set-atom-fun %eq %eql %equal %not cpr rplacp %load atan2 pow quit string-concat
      %eval %defun %defun-quiet early-defun %defvar %defmacro %string %make-symbol
      %symbol-name %symbol-value %symbol-function %symbol-package
      function-source
      %number? == number== integer== character== %integer %+ %- %* %/ %< %>
      string== list-string
      %make-array =-aref
      %make-hash-table href =-href copy-hash-table hashkeys hremove hash-table?
      ? functional
      builtin? macro?
      %%macrocall %%%macro?
      %princ %force-output
      %fopen %fclose %read-char
      sys-image-create))

(defconstant +builtins+
      (append +direct-imports+
              (mapcar #'car +renamed-imports+)
              +implementations+))

;;; Global variables provided by all tré cores.
(defconstant +core-variables+
    '(*universe* *variables* *functions* *macros*
      *environment-path* *environment-filenames*
      *quasiquoteexpand-hook* *dotexpand-hook*
      *default-listprop* *keyword-package*
      *pointer-size*
      *assert* *targets*))

(defun make-keyword (x) (values (intern (symbol-name x) "KEYWORD")))
(defun make-keywords (x) (mapcar #'make-keyword x))

(defun all-exports ()
  (make-keywords (append +core-variables+
                         +direct-imports+
                         (mapcar #'car +renamed-imports+)
                         +implementations+)))

(defun cl-peek-char (&rest x) (apply #'peek-char x))
(defun cl-read-char (&rest x) (apply #'read-char x))


;;;; The core package where the action happens.

(defmacro define-core-package ()
  `(defpackage :tre-core
     (:use :common-lisp :tre-init)
     (:shadow :read :peek-char :read-char)
     (:export ,@(all-exports)
              +builtins+)))

(define-core-package)

(defpackage :tre
  (:use :tre-core)
  (:export :%backquote :backquote :quasiquote :quasiquote-splice
           :macroexpand :eq :eql
           :square :curly :accent-circonflex $))