(defvar *keyword-package* (find-package "KEYWORD"))

(defbuiltin make-symbol (x &optional (package nil))
  (cl:intern x (?
                 (cl:not package)       "TRE"
                 (cl:packagep package)  (cl:package-name package)
                 (cl:symbolp package)   (cl:symbol-name package)
                 package)))

(defvar *package* (make-symbol "TRE"))

(defbuiltin symbol-name (x)
  (? (cl:packagep x)
     (cl:package-name x)
     (cl:symbol-name x)))

(defbuiltin symbol-value (x)
  (? (cl:boundp x)
     (cl:symbol-value x)
     x))

(defbuiltin symbol-function (x)
  (? (cl:fboundp x)
     (cl:symbol-function x)))

(defbuiltin symbol-package (x)
  (cl:symbol-package x))

(defbuiltin =-symbol-function (v x)
  (cl:setf (cl:symbol-function x) v))

(defbuiltin find-symbol (x &optional pkg)
  (cl:find-symbol (symbol-name x) (find-package (symbol-name *package*))))
