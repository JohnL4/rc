;; Create a generic javascript mode.

(require 'generic)
(require 'font-lock)

;; Javascript mode -- stolen from generic-x.el in the
;; std. distribution.

(define-generic-mode 'lusk-javascript-generic-mode
  (list					;Comments
   "//"
   ;; (cons "<!--" "")
   )
  (list					;Keywords
   "break"
   "continue"
   "do"
   "document"
   "else"
   "for"
   "function"
   "if"
   "in"
   "return"
   "switch"
   "then"
   "var"
   "while"
   "with"
   )
  (list					;Font-lock.
   (list "^\\s-*function\\s-+\\([A-Za-z0-9_]+\\)"
         '(1 font-lock-function-name-face))
   (list "^\\s-*var\\s-+\\([A-Za-z0-9_]+\\)"
	 '(1 font-lock-variable-name-face))
   )    
  (list "\\.js\\$")			;Auto-mode
  (list					;Additional setup (?)
   (function 
    (lambda ()
      (setq imenu-generic-expression 
            '((nil "^function\\s-+\\([A-Za-z0-9_]+\\)" 1)))
      )))
  "Mode for JavaScript files."		;Description
  )
