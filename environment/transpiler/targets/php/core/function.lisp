(defun function? (x)
  (?
    (is_a x "__closure") (function_exists x.n)
    (string? x)          (function_exists x)))

(defun builtin? (x))

(defun function-bytecode (x))
(defun function-source (x))
