;;;;; tré – Copyright (c) 2009–2010,2012–2013 Sven Michael Klose <pixel@copei.de>

(defun form-action-get (x)
  ((x.ancestor-or-self "form").read-attribute "action"))

(defun form-input-element? (x)
  (& (not (submit-button? x))
     (x.has-tag-name? '("input" "textarea" "select"))))

(defun form-get-input-elements (x)
  (+ (find-all-if #'form-input-element? (get-input-elements x))
     (get-textarea-elements x)
     (get-select-elements x)))

(defun form-get-submit-buttons (x)
  (find-all-if #'submit-button? (get-input-elements x)))

(defun get-submit-button (form)
  (dolist (elm (form.get-list "input"))
	(& (elm.attribute-value? "type" "submit")
	   (return elm))))

(defun form-rename (x name)
  ((x.ancestor-or-self "form").set-name name))