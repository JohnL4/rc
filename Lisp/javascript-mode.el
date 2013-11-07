;;; $Header: //v/J80Lusk/CVSROOT/EmacsLisp/javascript-mode.el,v 1.4 2001/06/20 19:03:22 J80Lusk Exp $

;;; This major mode just plain doesn't work, and that's a real shame.  I think
;;; I've cloned cc-mode incorrectly, or else JavaScript is just too
;;; different.

(require 'cc-mode)

;;--------------------------------    --------------------------------
;; Stolen from cc-langs.el, Java section.

(defvar javascript-mode-abbrev-table nil
  "Abbreviation table used in javascript-mode buffers.")
(define-abbrev-table 'javascript-mode-abbrev-table ())

(defvar javascript-mode-map ()
  "Keymap used in javascript-mode buffers.")
(if javascript-mode-map
    nil
  (setq javascript-mode-map (c-make-inherited-keymap))
  ;; add bindings which are only useful for Javascript
  )

(defvar javascript-mode-syntax-table nil
  "Syntax table used in javascript-mode buffers.")
(if javascript-mode-syntax-table
    ()
  (setq javascript-mode-syntax-table (make-syntax-table))
  (c-populate-syntax-table javascript-mode-syntax-table))

(easy-menu-define c-javascript-menu javascript-mode-map "JavaScript Mode Command
s"
                  (c-mode-menu "JavaScript"))

;; keywords introducing conditional blocks
(setq c-Javascript-conditional-key c-C-conditional-key)

(setq c-Javascript-comment-start-regexp c-C++-comment-start-regexp)

;;--------------------------------    --------------------------------
;; Stolen from cc-mode.el, Java section.

(defun javascript-mode ()
  "Major mode for editing JavaScript code.  See definition of (e.g.)
`java-mode' in `cc-mode.el'."
  (interactive)
;;;   (if (boundp 'c-style-alist)
;;;       (message (format
;;;                 "javascript-mode initial: (assoc \"ellemtel\" c-style-alist) =>
;;; %s"
;;;                 (assoc "ellemtel" c-style-alist))))
;;;   (message (format
;;;             "javascript-mode: (get 'c-initialize-builtin-style 'is-run) => %s"
;;;             (prin1-to-string (get 'c-initialize-builtin-style
;;;                                   'is-run))))
;;;   (put 'c-initialize-builtin-style 'is-run (assoc "user" c-style-alist))
;;;                                         ;Force it to be run again if the style
;;;                                         ;  list doesn't contain sty;e "user"
;;;                                         ;  (which it should).

  (c-initialize-cc-mode)
;;;   (message (format
;;;             "javascript-mode: (get 'c-initialize-builtin-style 'is-run) => %s"
;;;             (prin1-to-string (get 'c-initialize-builtin-style
;;;                                   'is-run))))
;;;   (if (boundp 'c-style-alist)
;;;       (message (format
;;;                 "javascript-mode after rerunning c-initialize-cc-mode: (assoc \"
;;; ellemtel\" c-style-alist) => %s"
;;;                 (assoc "ellemtel" c-style-alist))))
  (kill-all-local-variables)
;;;   (if (boundp 'c-style-alist)
;;;       (message (format
;;;                 "javascript-mode after kill-all-local-variables: (assoc \"ellemt
;;; el\" c-style-alist) => %s"
;;;                 (assoc "ellemtel" c-style-alist))))
  (set-syntax-table javascript-mode-syntax-table)
  (setq major-mode 'javascript-mode
        mode-name "JavaScript"
        local-abbrev-table javascript-mode-abbrev-table
        )
  (use-local-map javascript-mode-map)
  (c-common-init)
  (c-set-style "ellemtel")
  (setq comment-start "// "
        comment-end   ""
        c-conditional-key c-Javascript-conditional-key
        c-comment-start-regexp c-Javascript-comment-start-regexp
        c-class-key nil                 ;There are no keywords introducing
                                        ;  class declarations.
        c-method-key nil
        c-baseclass-key nil
        c-recognize-knr-p t             ;K&R style function prototypes are
                                        ;  VALID.  (These are argument
                                        ;  declarations without type
                                        ;  declarations.)
        c-access-key nil
        c-inexpr-class-key nil
        ;; ;defun-prompt-regexp c-Javascript-defun-prompt-regexp
        imenu-generic-expression nil
        imenu-case-fold-search nil
        )
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'javascript-mode-hook)
  (c-update-modeline))

;;; Local Variables:
;;; fill-column: 78
;;; End:
