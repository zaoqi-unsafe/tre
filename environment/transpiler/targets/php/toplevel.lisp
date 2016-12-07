; tré – Copyright (c) 2008–2015 Sven Michael Klose <pixel@copei.de>

(defun php-prologue ()
  (with-string-stream out
    (format out "<?php // tré revision ~A~%" *tre-revision*)
    (format out (+ "if (get_magic_quotes_gpc ()) {~%"
                   "    $vars = array (&$_GET, &$_POST, &$_COOKIE, &$_REQUEST);~%"
                   "    while (list ($key, $val) = each ($vars)) {~%"
                   "        foreach ($val as $k => $v) {~%"
                   "            unset ($vars[$key][$k]);~%"
                   "            $sk = stripslashes ($k);~%"
                   "            if (is_array ($v)) {~%"
                   "                $vars[$key][$sk] = $v;~%"
                   "                $vars[] = &$vars[$key][$sk];~%"
                   "            } else~%"
                   "                $vars[$key][$sk] = stripslashes ($v);~%"
                   "        }~%"
                   "    }~%"
                   "    unset ($vars);~%"
                   "}~%"))
    (php-print-native-core out)))

(defun php-epilogue ()
  (format nil "?>~%"))

(defun php-decl-gen ()
  (codegen (frontend (@ #'list (compiled-inits)))))

(defun php-frontend-init ()
  (add-defined-variable '*keyword-package*))

(defun php-sections-before-import ()
  (+ (list (. 'core-0 (string-source *php-core0*)))
     (& (not (configuration :exclude-core?))
        (list (. 'core (string-source *php-core*))))))

(defun php-sections-after-import ()
  (+ (& (not (configuration :exclude-core?))
        (list (. 'core-2 (string-source *php-core2*))))
     (& (t? *have-environment-tests*)
        (list (. 'env-tests (make-environment-tests))))))

(defun php-identifier-char? (x)
  (unless (eql #\$ x)
    (c-identifier-char? x)))

(defun php-expex-initializer (ex)
  (= (expex-inline? ex)          #'%slot-value?
     (expex-setter-filter ex)    (compose [@ #'php-setter-filter _] #'expex-compiled-funcall)
     (expex-argument-filter ex)  #'php-argument-filter))

(defun make-php-transpiler-0 ()
  (create-transpiler
      :name                     :php
      :frontend-init            #'php-frontend-init
      :prologue-gen             #'php-prologue
      :epilogue-gen             #'php-epilogue
      :decl-gen                 #'php-decl-gen
      :sections-before-import   #'php-sections-before-import
      :sections-after-import    #'php-sections-after-import
      :lambda-export?           t
      :stack-locals?            nil
      :gen-string               [literal-string _ #\" (list #\$)]
	  :identifier-char?         #'php-identifier-char?
      :literal-converter        #'expand-literal-characters
      :expex-initializer        #'php-expex-initializer
      :configurations           '((:exclude-core? . nil)
                                  (:save-sources?            . nil)
                                  (:save-argument-defs-only? . nil))))

(defun make-php-transpiler ()
  (aprog1 (make-php-transpiler-0)
    (transpiler-add-defined-function ! '%cons '(a d) nil)
    (transpiler-add-defined-function ! 'phphash-hash-table '(x) nil)
    (transpiler-add-defined-function ! 'phphash-hashkeys '(x) nil)
    (transpiler-add-plain-arg-funs ! *builtins*)))

(defvar *php-transpiler* (make-php-transpiler))
(defvar *php-newline*    (format nil "~%"))
(defvar *php-separator*  (format nil ";~%"))
(defvar *php-indent*     "    ")
