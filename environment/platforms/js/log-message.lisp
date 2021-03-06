(fn make-log-stream ()
  (make-stream :fun-in    #'((str))
               :fun-out   #'((c str)
                              (logwindow-add-string (? (string? c)
                                                       c
                                                       (char-string c))))
	           :fun-eof	  #'((str)
                              t)))

(defvar *standard-log* (make-log-stream))
(= *standard-output* (make-log-stream))
(= *standard-error* (make-log-stream))

(defvar *logwindow* nil)

(defvar *terminal-css* (new :margin "0"
                            :background  "#000"
                            :color       "#0f0"
                            :white-space "pre-wrap"
                            :font-family "monospace"
                            :font-weight "bold"))
 
(defvar *log-event-module* nil)

(fn open-log-window ()
  (unless *logwindow*
    (= *logwindow* (window.open "" "log" "width=1200, height=300, scrollbars=yes"))
    (let doc *logwindow*.document
      (document-extend doc)
      (= doc.title "Console")
      (doc.body.add (new *element "div"))
	  (doc.body.set-styles (hash-merge *terminal-css* (new :width "100%")))
      ,@(when *have-compiler?*
          '((let form (new *element "form")
              (doc.body.add form)
              (with (txt    (new *element "textarea" nil (new :width "98%"
                                                              :height "12em"))
                     submit (new *element "input" (new :type "submit"
                                                       :value "Evaluate...")))
                (form.add txt)
                (form.add submit)
                (*event-manager*.init-document doc)
                (init-event-module *log-event-module* "log")
                (*log-event-module*.click [(_.discard)
                                           (_.send-natively nil)
                                           (with-stream-string s txt.value
                                             (@ (i (read-all s))
                                               (princ "* ")
                                               (print (eval (print i)))))]
                                          submit)))))
      (doc.body.first-child.add-text ""))))

(defvar *logwindow-buffer* "")
(defvar *logwindow-timer* nil)

(fn logwindow-add-string-0 (txt)
  (open-log-window)
  (*logwindow*.document.body.first-child.add-text txt)
  (*logwindow*.scroll-to 0 (%%native 100000))
  txt)

(fn logwindow-timer ()
  (unless (empty-string? *logwindow-buffer*)
    (logwindow-add-string-0 *logwindow-buffer*)
    (= *logwindow-buffer* "")))

(fn logwindow-add-string (txt)
  (unless *logwindow-timer*
    (= *logwindow-timer* (window.set-interval #'logwindow-timer 100)))
  (= *logwindow-buffer* (+ *logwindow-buffer* txt))
  txt)

,(? *transpiler-log*
   `(fn log-message (txt)
      (logwindow-add-string (+ txt (string (code-char 10))))
      txt)
   '(defmacro log-message (txt)
      txt))
