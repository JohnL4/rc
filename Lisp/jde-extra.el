;;; Modifications to JDE, in keeping with development group's coding
;;; conventions.
;;;
;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/jde-extra.el,v 1.21 2004/03/24 13:34:58 J80Lusk Exp $

(require 'generic-util)

(defvar jdex-package-root-dir "/"
  "*The absolute pathname of the directory containing the default (root) Java
package.")

(make-variable-buffer-local 'jdex-package-root-dir)

(defvar jdex-package nil
  "The package into which all classes will be placed.  If nil, you will be
prompted at class-generation time.  May be defined in the project file
(`prj.el' or its analogue).")

(make-variable-buffer-local 'jdex-package)

;;-----------------------------  class template  -----------------------------

(defconst jdex-class-template
   '(
     ;; (funcall jde-gen-boilerplate-function) ;Should including trailing
                                            ;  newline.

     "/*" 'n
     " * " (canopy-copyright-statement (current-time)) 'n
     " */" 'n
     'n>
     "package "
     (or jdex-package
         (jdex-package-name-from-directory
          jdex-package-root-dir (file-name-directory (buffer-file-name)))
         '(p "Package: " package-name))
     ";" 'n
     'n
     "/**" 'n
     " * " 'p '> 'n
     " * @version $" "Revision$ $" "Date$" '> 'n ;RCS keywords; funky
                                        ;fragmentation is necessary to keep
                                        ;RCS from instantiating the keywords
                                        ;prematurely.
     " * @author " (if (boundp 'author-short-name) author-short-name
                     (user-login-name)) '> 'n
     " * @see <var>Other spiffy things that might be of "
     "interest/relevance.</var>" '> 'n
     " **/" '> 'n>
     "public class " (file-name-sans-extension
                      (file-name-nondirectory buffer-file-name))
     " " (let ((superclass (read-string "extends: ")))
	   (if (not (string-equal "" superclass))
	       (concat "extends " superclass)))
     " " (let ((interfaces (read-string "implements: ")))
	   (if (not (string-equal "" interfaces))
	       `(l 'n "implements " ,interfaces '>)))
     'n>
     "{"  '> 'n
     'n
     (section-break "constants")
     'n
     " /**" '> 'n
     " * Embed version stamp in class file." '> 'n
     " **/" '> 'n
     '> "public static final String VERSION = \"$" "Revision$\"" 'n
     '> "+ \" $" "Date$\";"
     'n
     'n
     (section-break "constructors, destructors")
     'n
     " /**" '> 'n
     "**/" '> 'n>
     "public " (file-name-sans-extension
                (file-name-nondirectory buffer-file-name)) "()" 'n '>
                "{" '> 'n
                ;; "init();" '> 'n
                "}" '> 'n>
     'n
;;;      " /**" '> 'n
;;;      "* Initializer, factored out of constructor(s):  set data/properties" '> 'n
;;;      "* to initial values." '> 'n
;;;      "**/" '> 'n
;;;      "private void init()" '> 'n
;;;      "{" '> 'n
;;;      "" '> 'n
;;;      "}" '> 'n
;;;      'n
     (section-break "interfaces/operations")
     'n
     " /**" '> 'n
     "* " '> 'n
     "* @throws " '> 'n
     "**/" '> 'n>
     "public static void main( String[] arg)" 'n>
     "{" '> 'n
     '> 'p 'n                           ; 'p is a tempo mark.
     "}" '> 'n
     'n
;;;      (section-break "I/O") 'n
;;;      (section-break "Debugging") 'n
;;;      (section-break "Protected Functions") 'n
;;;      (section-break "Private Functions") 'n
;;;      'n>
;;;      "/**" 'n
;;;      " * Test class invariant." '> 'n
;;;      " * @return Truth value of class invariant." '> 'n
;;;      " **/" '> 'n>
;;;      "private boolean _invariant()" 'n>
;;;      "{"  '> 'n>
;;;      "return true;" 'n>
;;;      "}"  '> 'n
     (section-break "accessors and modifiers")
     'n
     ;; (section-break "Accessors") 'n
     'n
     (section-break "non-public functions")
     'n
     'n
     (section-break "data")
     'n
     'n
     "} // " (file-name-sans-extension
              (file-name-nondirectory buffer-file-name)) '> 'n>
     'n
     "/*" 'n
     " * $" "Log: $" 'n                 ;Broken-up RCS keyword on purpose.
     " */" 'n
     )
   "Generic class tempo template."
   )

(tempo-define-template "jdex-class"
                       jdex-class-template)

;;----------------------------  member templates  ----------------------------

(tempo-define-template
 "jdex-data-member"
 '(
;;;   '>
   " /**" '> 'n
   " * " 'p '> 'n
   " **/" '> 'n>
   '(p "Variable declaration: ") ";" 'n>
   )
 "data"
 "Class data member template."
 )

(tempo-define-template
 "jdex-function-member"
 '(
   (progn
     (template-jdex-function-member)
     nil
     )
   )
 "func"
 "Class function member template."
 )

(defun template-jdex-function-member ()
  "Class function member template, handcoded because `tempo' can't loop over
an indeterminate number of elements."
  (interactive)
  (let (
        next-param-marker               ;Locn of next javadoc '@param'
                                        ;  keyword. 
        user-input                      ;Function name, param name, etc.
        tokens                          ;List of tokens (strings)
        arg-type                        ;Datatype of formal arg.
        arg-name                        ;Formal arg name.
        )
    (indent-according-to-mode)
    (insert "/**\n")
    (insert "* ")
    (indent-according-to-mode)
    (tempo-insert-mark (point-marker))
    (insert "\n")
    (insert "*") (indent-according-to-mode) (insert "\n")
    (insert "* ")
    (indent-according-to-mode)
    (setq next-param-marker (point-marker))
    (insert "\n**/")
    (indent-according-to-mode)
    (insert "\n")
    (indent-according-to-mode)
    (insert (read-string "Function type and name: "))
    (insert "( ")
    (while (progn
             (setq user-input (read-string "Argument type and name: "))
             (setq tokens (split-string user-input))
             )
                                        ;Java lang spec says we'll only get
                                        ;  two tokens:  type and name (i.e.,
                                        ;  Type is exactly one token).
      (setq arg-type (car tokens))
      (setq arg-name (cadr tokens))
      (insert (concat user-input ", ")) ;Formal arg
      (save-excursion
        (goto-char next-param-marker)   ;javadoc '@param'
        (insert-before-markers
         (concat "@param "
                 arg-name
                 " \n* "))
        (indent-according-to-mode)
        )
      )
    (save-excursion
      (backward-char 2)
      (cond
       ((looking-at ", ")
	(delete-char 2))		;Delete ", " after last formal arg.
       ((looking-at "( ")
	(forward-char)			;Only delete single space after
					;  opening "(".
	(delete-char 1))
	)
      )
    (insert ")\n")
    (save-excursion
      (goto-char next-param-marker)
      (insert-before-markers
       "@return \n * ")
      (indent-according-to-mode)
      )
    (indent-according-to-mode)
    (insert "throws ")
    (let ((exc-count 0))
      (while (not (string= "" (setq user-input (read-string "Exception: "))))
        (setq exc-count (+ 1 exc-count))
        (insert (concat user-input ", "))
        (save-excursion
          (goto-char next-param-marker)
          (insert-before-markers
           (concat "@throws "
                   user-input
                   " \n * "))
          (indent-according-to-mode)
          )
        )
      (if (> exc-count 0)
          (progn
            (delete-backward-char 2)    ; ", "
            (insert "\n"))
        (delete-backward-char (length "throws ")))
      )
    (insert "{")
    (indent-according-to-mode)
    (newline)
    (indent-according-to-mode)
    (tempo-insert-mark (point-marker))
    (insert "\n}")
    (indent-according-to-mode)
    (insert "\n")
    (goto-char next-param-marker)
    (beginning-of-line)
    (kill-line 1)                       ;empty line containing only "*", next
                                        ;  line has "*/".
    (indent-according-to-mode)
    (tempo-backward-mark)               ;Back to first line of javadoc
                                        ;  comments. 
    )
;;;  nil                                        ;Return nil, so this can be used
                                        ;  inside a tempo template with
                                        ;  well-define results.
  )

;;---------------------------  control structures  ---------------------------

;; (tempo-define-template
;;  "jdex-if"
;;  '(
;;    '>
;;    "if (" 'p ")" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '> 'n>
;;    "else" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '>
;;    )
;;  "if"
;;  "`if' statement template"
;;  )
;; 
;; (tempo-define-template
;;  "jdex-for"
;;  '(
;;    '>
;;    "for (" 'p ";;)" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '>
;;    )
;;  "for"
;;  "`for' statement template"
;;  )
;; 
;; (tempo-define-template
;;  "jdex-while"
;;  '(
;;    '>
;;    "while (" 'p ")" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '>
;;    )
;;  "while"
;;  "`while' statement template"
;;  )
;;    
;; (tempo-define-template
;;  "jdex-do"
;;  '(
;;    '>
;;    "do" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "} while (" 'p ");" '>
;;    )
;;  "do"
;;  "`do' statement template"
;;  )
;; 
;; (tempo-define-template
;;  "jdex-switch"
;;  '(
;;    '>
;;    "switch (" 'p ")" 'n>
;;    "{" '> 'n>
;;    (progn
;;      (tempo-template-jdex-case)
;;      (tempo-forward-mark)               ;Expect exactly one 'p mark in `case'
;;                                         ;  template -- skip past it to end of
;;                                         ;  `case' template.
;;      nil
;;      )
;;    'n>
;;    "default:" '> 'n>
;;    "break;" 'n>
;;    "}" '>
;;    )
;;  "switch"
;;  "`switch' statement template"
;;  )
;; 
;; (tempo-define-template
;;  "jdex-case"
;;  '(
;;    '>
;;    "case " 'p ":" '> 'n>
;;    "break;" '>
;;    )
;;  "case"
;;  "`case' statement template"
;;  )
;; 
;; (tempo-define-template
;;  "jdex-try"
;;  '(
;;    '>
;;    "try" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '> 'n>
;;    "catch (" 'p ")" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '> 'n>
;;    "finally" 'n>
;;    "{" '> 'n>
;;    'p 'n>
;;    "}" '>
;;    )
;;  "try"
;;  "`try' statement template"
;;  )

;;---------------------------  require other defs  ---------------------------

(require 'jdex-bean)

;;---------------------------  set JDE templates  ----------------------------

(custom-set-variables
 '(jde-gen-class-buffer-template
   (double-quote-list-elts jdex-class-template)
   'now)
 '(jde-gen-console-buffer-template
    (double-quote-list-elts jdex-class-template)
    'now)
 '(jde-gen-code-templates
   (append (list (cons "Data Member" 'tempo-template-jdex-data-member)
                 (cons "Function Member" 'template-jdex-function-member)
;;                  (cons "if stmt" 'tempo-template-jdex-if)
;;                  (cons "for stmt" 'tempo-template-jdex-for)
;;                  (cons "while stmt" 'tempo-template-jdex-while)
;;                  (cons "do stmt" 'tempo-template-jdex-do)
;;                  (cons "switch stmt" 'tempo-template-jdex-switch)
;;                  (cons "case stmt" 'tempo-template-jdex-case)
;;                  (cons "try stmt" 'tempo-template-jdex-try)
                 )
           jde-gen-code-templates)
   'now)
 '(jde-key-bindings
   (append (list (cons "\C-c\C-x\C-l" 'jde-gen-class) ;cLass
                 (cons "\C-c\C-x\C-v" 'tempo-template-jdex-data-member) ;Var
                 (cons "\C-c\C-x\C-m" 'tempo-template-jdex-function-member) ;Method

;;                  (cons "\C-c\C-x\C-i" 'tempo-template-jdex-if)
;;                  (cons "\C-c\C-x\C-f" 'tempo-template-jdex-for)
;;                  (cons "\C-c\C-x\C-w" 'tempo-template-jdex-while)
;;                  (cons "\C-c\C-x\C-d" 'tempo-template-jdex-do)
;;                  (cons "\C-c\C-x\C-s" 'tempo-template-jdex-switch)
;;                  (cons "\C-c\C-x\C-c" 'tempo-template-jdex-case)
;;                  (cons "\C-c\C-x\C-t" 'tempo-template-jdex-try)

                 (cons "[?\C-c ?\C-x (control ?.)]" 'tempo-forward-mark) ;>
                 (cons "[?\C-c ?\C-x (control ?,)]" 'tempo-backward-mark) ;<

                 ;; (cons "\C-c\C-x." 'tempo-forward-mark)      ;>
                 ;; (cons "\C-c\C-x," 'tempo-backward-mark) ;<

;;                  (cons "\M-\C-i" 'jdex-complete-symbol)
                 (cons "\C-c\C-x\C-e" 'jdex-insert-html-code)
                 )
           (if (featurep 'jdex-bean)
               (list (cons "\C-c\C-x\C-p" 'jdex-insert-property)))
           jde-key-bindings)
   'now)
;;  '(jde-complete-function 'jde-complete-minibuf 'now)
   )

;;-----------------------------  misc functions  -----------------------------

(defun jdex-insert-html-code (&optional use-region)
  "Insert html <code> tag.  With a prefix arg, insert the tags around the
current region."
  (interactive "P")                     ;raw prefix arg
  (if use-region
      (save-excursion
        (let
            ((end-marker (copy-marker (region-end)))
             )
          (goto-char (region-beginning))
          (insert "<code>")
          (goto-char end-marker)
          (insert "</code>")
          )
        )
    (insert "<code> </code>")
    (backward-char (length "</code>"))
    )
  )

;; (defun jdex-complete-symbol (arg)
;;   "Perform tags completion on the text around point.  Completes to the set of
;; names listed in the current tags table.  The string to complete is chosen in
;; the same way as the default for \\[find-tag] (which see).  Note that this is a
;; redefined version of `complete-symbol' which does what the documentation says
;; it does."
;;   (interactive "P")
;;   (if arg
;;       (info-complete-symbol)
;;     (if (fboundp 'complete-tag)
;;         (complete-tag)
;;       ;; Don't autoload etags if we have no tags table.
;;       (error (substitute-command-keys
;;               "No tags table loaded; use \\[visit-tags-table] to load one")))
;;     ))

(defun jdex-package-name-from-directory (pkg-root-dir cwd &optional match-case)
  "Return a Java package name generated from `cwd' (a directory pathname),
with the package hierarchy rooted in directory `pkg-root-dir'.  Elements of
`cwd' will be string-matched against corresponding elements of `pkg-root-dir',
so pkg-root-dir (a) may contain regexps, and (b) may NOT contain backslashes
as pathname separators.  If `match-case' is non-nil, case in pathnames is
significant."
  (let ((root-components (split-string pkg-root-dir "/"))
        (cwd-components (split-string cwd "/"))
        (case-fold-search (not match-case))
        )
    (while (and root-components
                (string-match (car root-components) (car cwd-components))
;;;                (cond ((not match-case) (string= (upcase (car root-components))
;;;                                           (upcase (car cwd-components))))
;;;                      (t (string= (car root-components)
;;;                                  (car cwd-components))))
                )
      (setq root-components (cdr root-components))
      (setq cwd-components (cdr cwd-components))
      )
    (mapconcat (lambda (x) x) cwd-components ".")
    )
  )
  
;; (add-hook 'jde-mode-hook
;; 	  (lambda ()
;; 	    ;; (local-set-key "\C-c\C-v." 'jde-complete-menu)
;;             (local-set-key "\C-c\C-x\C-l" 'jde-gen-class) ;cLass
;;             (local-set-key "\C-c\C-x\C-v" 'tempo-template-jdex-data-member)
;;                                         ;Var
;;             (local-set-key "\C-c\C-x\C-m"
;;                            'tempo-template-jdex-function-member) ;Method
;;             (if (featurep 'jdex-bean)
;;                 (local-set-key "\C-c\C-x\C-p" 'jdex-insert-property))
;; 
;;             (local-set-key [?\C-c ?\C-x (control ?.)] 'tempo-forward-mark) ;>
;;             (local-set-key [?\C-c ?\C-x (control ?,)] 'tempo-backward-mark) ;<
;; 	    ))

(set-face-foreground 'jde-java-font-lock-modifier-face
                     "#da00d2")
(set-face-foreground 'jde-java-font-lock-constant-face
                     "#009ca0")
(set-face-foreground 'font-lock-constant-face
                     "#009ca0")
;;------------------------------------    ------------------------------------

(provide 'jde-extra)



;;; Local Variables:
;;; fill-column: 78
;;; End:
