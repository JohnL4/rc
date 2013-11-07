;;; Emacs initialization/customization for the development group.
;;;
;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/group-config.el,v 1.51 2002/05/06 18:02:11 J80Lusk Exp $
;;;
;;; TO CHANGE COLORS:
;;; Simplest thing to do is set variable `preferred-background-mode' in your
;;; .emacs to either 'light or 'dark.
;;;
;;; The next simplest thing to do is find default-frame-alist and comment
;;; out/in the foreground and background color settings.  If you switch
;;; to/from a dark/light background, be sure to comment in/out
;;; 'background-mode' appropriately.  You should also change the 'modeline'
;;; colors separately (unfortunately, but hey I can only do so much color
;;; hacking while I'm supposed to be working).

;;--------------------------  reconfigurable items  --------------------------

(defvar author-short-name (user-login-name)
  "*The name you wish to use when identifying yourself as the author of a
document (or piece of code).  This could be your last name, your initials,
something fanciful or something totally random, whatever makes you happy.")

;;---------------------------------  paths  ----------------------------------

(setq load-path
      (append
       (list
	(concat group-emacs-directory "/Emacs/Add-ons/jde-" group-jde-version)
	"/Emacs/Add-ons/gnuserv"
        "c:/Emacs/Add-ons/psgml-1.2.4"
	)
       load-path)
      )

(if (not (boundp 'Info-default-directory-list))
    (setq Info-default-directory-list nil)
  )

(setq Info-default-directory-list
      (append '("E:/Emacs/emacs-20.3.1/info/")
	      Info-default-directory-list))

;;--------------------------------  requires  --------------------------------

(require 'generic-util)
(require 'edebug)			;LISP source-level debugging.
(require 'fix-pathnames)                ;For use in converting MS-style
                                        ;  pathnames to Unix-style, for use
                                        ;  w/Cygnus utilities like diff(1).
                                        ;  Requires local mod to
                                        ;  ediff-diff.el::ediff-exec-process
                                        ;  to transmogrify incoming list of
                                        ;  pathname args.  (Make copy in
                                        ;  site-lisp.)

(require 'jde)				;Java Development Environment
(if (not (member 'jde features))
    (message "Warning:  `jde' not loaded."))

(let*
    (
     (jde-extra-filename "jde-extra")
     (jde-extra-location (locate-library jde-extra-filename))
     )
  (if jde-extra-location
      (load-library jde-extra-filename)	;Customizations for Remote Connect
					;  group.
    (message (concat "Warning:  " jde-extra-filename " not loaded."))
    )					
  )

(setq jdex-package "")

(require 'align)
(if (not (member 'align features))
    (message "Warning:  feature `align' not loaded.")
  (setq align-c++-modes (cons 'jde-mode align-c++-modes))
;;;  (setq align-java-list
;;;	(cons '("[(,]\\(\\s-*\\)" 1 t)	;function args, comma-separated lists
;;;	      align-c/c++-list))
;;;  (setq align-mode-alist
;;;	(cons (cons 'jde-mode 'align-java-list) align-mode-alist))
  (setq align-to-tab-stop nil)
  )

(require 'calendar)
(setq calendar-daylight-savings-starts '(calendar-nth-named-day 1 0 4 year))
(setq calendar-daylight-savings-ends '(calendar-nth-named-day -1 0 10 year))

;;; (set-time-zone-rule "EDT4")             ;Gruesome hack to make journal entries
                                        ;work properly.  (current-time-zone)
                                        ;still returns incorrect values.

(set-time-zone-rule nil)                ;During standard time (not summer
                                        ;(daylight)), this works (properly) by
                                        ;querying the system for the requisite
                                        ;info.  Under Win32, does not respect
                                        ;"TZ" env. var, so you'll have to
                                        ;hardcode it here if you want it.

(require 'gnuserv)			;Enables external requests to
					;  edit files.
(gnuserv-start)
;;; (server-start)
;;------------------------------  end requires  ------------------------------

;;=================================  modes  ==================================
				
(setq default-major-mode 'text-mode)

;;---------------------------------  psgml  ----------------------------------

(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

;;----------------------------------  sgml  ----------------------------------

(defun group-psgml-mode-hook ()
  (font-lock-mode 1)
  (setq sgml-set-face t)
  (setq comment-start "<!-- ")
  (setq comment-start-skip "<!-- *")
  (setq comment-end " -->")
  (setq comment-multi-line nil)
  (setq comment-column 32)
  )

(add-hook 'sgml-mode-hook 'group-psgml-mode-hook)

;;----------------------------------  html  ----------------------------------

;;; (setq html-mode-hook
;;;       '(lambda ()
;;; ;;;          (auto-fill-mode 1)
;;; ;;;          (show-paren-mode 1)
;;; ;;;          (abbrev-mode 1)
;;; ;;;          (local-set-key "\C-j" 'newline)
;;; ;;;          (local-set-key "\C-m" 'newline-and-indent)
;;; ;;;          (local-set-key "\M-o" 'comment)
;;; ;;;          (local-set-key [C-tab] 'indent-relative)
;;; ;;;          (local-set-key [C-return] 'newline-and-indent-relative)
;;;          (setq comment-start "<!-- ")
;;;          (setq comment-start-skip "<!-- *")
;;;          (setq comment-end " -->")
;;;          (setq comment-multi-line nil)
;;;          (setq comment-column 32)
;;;          )
;;;       )

;;-------------------------------  multi-mode  -------------------------------

(autoload 'multi-mode
  "multi-mode"
  "Allowing multiple major modes in a buffer."
  t)

(defun multi-jde-mode ()
  (interactive)
  (jde-mode)
  (c-toggle-auto-state -1)              ;But this still doesn't keep
                                        ; electric-paren from reindenting.
  )

(defun jsp-mode () (interactive)
  (multi-mode 1
              'sgml-mode
;;;              '("<% " jde-mode)
;;;              '("<%\t" jde-mode)
;;;              '("<%\n" jde-mode)
              '("<%!" jde-mode)
              '("%>" sgml-mode)
              '("<script" c++-mode)
              '("<SCRIPT" c++-mode)
              '("</script" sgml-mode)
              '("</SCRIPT" sgml-mode)
              ))

(setq auto-mode-alist
      (append (list '("\\.jsp$" . jsp-mode)
                    '("\\.jsptemplate$" . jsp-mode)
                    '("\\.html?$" . jsp-mode)
                    )
              auto-mode-alist))

;;----------------------------------  java  ----------------------------------

(c-add-style "java-bsd"
             '("bsd" (c-comment-continuation-stars . "* ")))

(defun group-java-mode-hook ()
  (c-set-style "java-bsd")              ;Indentation
  (setq c-basic-offset 3)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'topmost-intro-cont '+)
  
  (setq c-tab-always-indent nil)
  (my-fill-mode)			;Auto Word-wrap
  (make-variable-buffer-local 'comment-padding)
  (setq comment-padding nil)
  (setq tempo-interactive t)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'section-break)
  (local-set-key "\M-]" 'complete-tag)
  
					;Change behavior of electric braces.

  (c-toggle-auto-state 1)
  (setq c-hanging-braces-alist
	(cons (cons 'substatement-open '(before after))
					;substatement-open sufficient?  need
					;  we also block-open?
	      c-hanging-braces-alist))

  )

(add-hook 'java-mode-hook 'group-java-mode-hook)

;;-----------------------------------  c  ------------------------------------

(defun group-c-mode-hook ()
  (c-set-style "bsd")
  (setq c-basic-offset 3)
  (c-set-offset 'case-label '+)
  (c-set-offset 'topmost-intro-cont '+)
  (setq c-tab-always-indent nil)
  (my-fill-mode)			;Auto Word-wrap
  (make-variable-buffer-local 'comment-padding)
  (setq comment-padding nil)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'section-break)

					;Change behavior of electric braces.

  (c-toggle-auto-state 1)
  (setq c-hanging-braces-alist
	(cons (cons 'substatement-open '(before after))
					;substatement-open sufficient?  need
					;  we also block-open?
	      c-hanging-braces-alist))
  )

(add-hook 'c-mode-hook 'group-c-mode-hook)

;;----------------------------------  c++  -----------------------------------

(defun group-c++-mode-hook ()
  (c-set-style "bsd")
  (setq c-basic-offset 3)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'topmost-intro-cont '+)

  (setq c-tab-always-indent nil)
  (my-fill-mode)			;Auto Word-wrap
  (make-variable-buffer-local 'comment-padding)
  (setq comment-padding nil)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'section-break)

					;Change behavior of electric braces.

  (c-toggle-auto-state 1)
  (setq c-hanging-braces-alist
	(cons (cons 'substatement-open '(before after))
					;substatement-open sufficient?  need
					;  we also block-open?
	      c-hanging-braces-alist))
  )

(add-hook 'c++-mode-hook 'group-c++-mode-hook)
  
(setq auto-mode-alist
      (append (list '("\\.js$" . c++-mode)
                    )
              auto-mode-alist))

;;----------------------------------  perl  ----------------------------------

(defun group-perl-mode-hook ()
                                        ;NOTE: c-indent stuff doesn't work.
                                        ;  Use perl-indent variables if you
                                        ;  want to change anything.

  (make-variable-buffer-local 'comment-multi-line)
  (setq comment-multi-line nil)
  (setq fill-column 78)
  (my-fill-mode)			;Auto Word-wrap
  
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'section-break)
  (local-set-key "\M-]" 'complete-tag)

  (my-fill-mode)
  )

(add-hook 'perl-mode-hook 'group-perl-mode-hook)

;;-------------------------------  javascript  -------------------------------

;;; (autoload 'javascript-mode
;;;   "javascript-mode"
;;; ;;;   "javascript-cust"
;;;   "JavaScript mode"
;;;   t nil)
;;; 
;;; (setq auto-mode-alist
;;;       (append '(("\\.js$" . javascript-mode))
;;;               auto-mode-alist))

;;----------------------------------  text  ----------------------------------

(defun group-text-mode-hook ()
  (my-fill-mode)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\C-m" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'one-line-section-break)
  (make-variable-buffer-local 'comment-start)
  (make-variable-buffer-local 'comment-end)
  (make-variable-buffer-local 'comment-start-skip)
  (make-variable-buffer-local 'comment-multi-line)
  (setq comment-start "# ")
  (setq comment-end "")
  (setq comment-start-skip "#+\\s-*")
  (setq comment-multi-line nil)
  )

(add-hook 'text-mode-hook 'group-text-mode-hook)

;;----------------------------------  lisp  ----------------------------------

(defun group-lisp-mode-hook ()
  (my-fill-mode)
  (setq fill-column 78)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'one-line-section-break)
  )

(add-hook 'lisp-mode-hook 'group-lisp-mode-hook)
(add-hook 'lisp-interaction-mode-hook 'group-lisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'group-lisp-mode-hook)

;;------------------------------  shell-script  ------------------------------

(add-hook 'sh-mode-hook
	  (lambda ()
	    (setq sh-indentation 3)
	    (my-fill-mode)		;Auto Word-wrap
	    (setq tempo-interactive t)
	    (local-set-key "\C-j" 'newline)
	    (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
	    (local-set-key "\M-o" 'section-break)
	    )
	  )

;;---------------------------------  ediff  ----------------------------------

(setq ediff-load-hook
      (function
       (lambda () 

	 ;;(modify-face FACENAME FG BG STIPL BOLD ITALIC UNDER)
	 (modify-face ediff-even-diff-face-B "black" nil nil t nil nil)
	 (modify-face ediff-odd-diff-face-A "black" nil nil t nil nil)
	 (modify-face ediff-odd-diff-face-C "black" nil nil t nil nil)
	     
	 (modify-face ediff-odd-diff-face-B "black" nil nil t nil nil)
	 (modify-face ediff-even-diff-face-A "black" nil nil t nil nil)
	 (modify-face ediff-even-diff-face-C "black" nil nil t nil nil)
	     
	 (set-face-foreground ediff-current-diff-face-A "black")
	 (set-face-foreground ediff-current-diff-face-C "black")
	     
	     
	 (set-face-foreground ediff-fine-diff-face-A "black")
	 (set-face-background ediff-fine-diff-face-A "LimeGreen")
	     
	 (set-face-foreground ediff-current-diff-face-B "black")
	 ;;(set-face-background ediff-current-diff-face-B ;;"#ffff58")
	 (set-face-background ediff-current-diff-face-B "yellow")
	     
	 (set-face-foreground ediff-fine-diff-face-B "black")
	 (set-face-background ediff-fine-diff-face-B "DarkGoldenrod1")
	     
	 (set-face-foreground ediff-fine-diff-face-C "black")
	 (set-face-background ediff-fine-diff-face-C "Salmon")
	     
         (set-face-foreground ediff-current-diff-face-Ancestor "black")
         (set-face-background ediff-current-diff-face-Ancestor "SkyBlue1")

	 (setq ediff-combination-pattern
	       '("<<<<<<<<"
		 "========"
		 ">>>>>>>>"
		 )
	       )
	     
	 ;; (setq ediff-narrow-control-frame-leftward-shift 65)
	 (setq ediff-narrow-control-frame-leftward-shift 82)
	 ;; (setq ediff-wide-control-frame-rightward-shift 0)
	 (setq ediff-control-frame-upward-shift -1100)
	     
	 (setq ediff-diff-program "diff")
	 (setq ediff-diff-options "-dw --text")

	 ;;(setq ediff-control-frame-parameters
	 ;;   '(
	 ;;    (name . "Ediff")
	 ;;    (minibuffer)
	 ;;    (vertical-scroll-bars)
	 ;;    (scrollbar-width . 0)
	 ;;    (menu-bar-lines . 0)
	 ;;    (auto-lower)
	 ;;    (auto-raise)
	 ;;    (top . 0)
	 ;;    (left . 0))
	 ;;   )
	 )
       )
      )

;;===============================  end modes  ================================

;;---------------------------------  fonts  ----------------------------------

					;Use (insert (prin1-to-string
					;  (w32-select-font))) in *scratch* to
					;  get an actual font name string.
					;  Shift-click mouse-1 will also work.

(if (eq 'w32 window-system)
    (progn
      (setq w32-enable-italics t)       ;This must be done before font
					;  settings!  There is a requirement
					;  for italics: the italic version of
					;  a font must be exactly the same
					;  pixel height as the non-italic
					;  version.  Of the monospaced fonts,
					;  "Courier New" seems to the only one
					;  for which this is true.

					;8- and 9-point courier:
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-12-90-96-96-c-*-iso8859-1")
    (setq my-default-font "-*-Courier New-normal-r-*-*-11-82-96-96-c-*-iso8859-1")
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-11-82-*-*-c-*-*-ansi-")
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-12-90-*-*-c-*-*-ansi-")
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-13-78-*-*-c-*-*-ansi-")
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-15-90-*-*-c-*-*-ansi-")
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-13-78-*-*-c-*-*-ansi-")
    ;; (setq my-default-font "-*-Courier New-normal-r-*-*-15-90-*-*-c-*-*-ansi-")
    )
  )

(if (eq 'x window-system)
    (progn
      (setq my-default-font "-*-courier-medium-r-*-*-*-120-*-*-m-*-*-*")
      )
  )

(set-default-font my-default-font)

(make-face-italic 'italic)
(make-face-italic 'bold-italic)
(make-face-bold 'bold-italic)
(make-face-bold 'modeline)

					;We seem to tickle a nasty emacs bug
					;  when we put this item in the
					;  default-frame-alist above, so we
					;  add it separately here, AFTER
					;  initial-frame-alist.

(setq default-frame-alist
      (append (list (cons 'font my-default-font)) default-frame-alist))

					;List colors available with
					;  "ESC x list-colors-display".

(set-face-background 'modeline
                     (if (eq 'dark preferred-background-mode)
                         "gainsboro"
                       "saddlebrown"
                       ))
;; (set-face-background 'modeline "gainsboro")

                                        ;Modeline foreground is same as
                                        ;  default frame background (see
                                        ;  below). 
(set-face-foreground 'modeline
                     (if (eq 'dark preferred-background-mode)
                         ;; "DarkSlateGray"
                         "#254745"
                       "FloralWhite"
                       ))
;; (set-face-foreground 'modeline "DarkSlateGray")
;; (set-face-foreground 'modeline "Linen")	

;;-------------------------------  font-lock  --------------------------------

(setq font-lock-support-mode
      '(
        (compilation-mode . nil)
        (t . lazy-lock-mode)
        ))
(setq lazy-lock-stealth-time 10)
;; (setq lazy-lock-stealth-verbose t)

(make-face-bold 'font-lock-variable-name-face)

					;Attempt to get numeric literals
					;  highlighted in as many development
					;  modes as possible.

(defface font-lock-numeric-literal-face
                                        ;Should be powerful enough to really
                                        ;highlight those magic numbers, but
                                        ;should also be just short of totally
                                        ;obnoxious.
  
  '(					;SPEC
    (					;DISPLAY/ATTS pair
     ((class color) (background light)) ;DISPLAY: a list of pairs
     (:bold nil :foreground "OrangeRed") ;ATTS: another list of pairs
     )					;end DISPLAY/ATTS pair
    (
     ((class color) (background dark))
     (:bold t :foreground "Orange")
     )
    )					;end SPEC
  "The face to be used to display numeric literals." ;DOC
  :group 'font-lock-highlighting-faces) ;KEYWORD VALUE

(defvar font-lock-numeric-literal-face 'font-lock-numeric-literal-face
  "Face name to use for numeric literals."
  )

(defface font-lock-todo-face
  '(
    (
     ((class color) (background light))
     (:bold t :foreground "magenta"
            :background "white"
            )
     )
    (
     ((class color) (background dark))
     (:bold t :foreground "orchid"
            ;; :background "red3"
            )
     )
    )
  "The face to be used to display ``TODO'' items."
  :group 'font-lock-highlighting-faces)

(defvar font-lock-todo-face 'font-lock-todo-face
  "Face name for TODO items.")

(defface font-lock-embedded-java-face
  '(
    (
     ((class color) (background light))
     (:bold nil :foreground
            ;; "LightSeaGreen"
            ;; "Green4"
            ;; "DarkSeaGreen4"
            "PaleGreen4"
            )
     )
    (
     ((class color) (background dark))
     (:bold nil :foreground "DarkSeaGreen2")
     )
    )
  "A face used to highlight another language embedded in the current language."
  :group 'font-lock-highlighting-faces
  )

(defvar font-lock-embedded-java-face 'font-lock-embedded-java-face
  "A face used to highlight another language embedded in the current
language.")
    
(defface font-lock-embedded-javascript-face
  '(
    (
     ((class color) (background light))
     (:bold nil :foreground
            ;; "MediumVioletRed"
            "magenta3"
            )
     )
    (
     ((class color) (background dark))
     (:bold nil :foreground "plum2")
     )
    )
  "A face used to highlight another language embedded in the current language."
  :group 'font-lock-highlighting-faces
  )

(defvar font-lock-embedded-javascript-face 'font-lock-embedded-javascript-face
  "A face used to highlight another language embedded in the current
language.")
    
(defface font-lock-embedded-html-face
  '(
    (
     ((class color) (background light))
     (:bold nil :foreground "RoyalBlue")
     )
    (
     ((class color) (background dark))
     (:bold nil :foreground "LightSkyBlue")
     )
    )
  "A face used to highlight another language embedded in the current language."
  :group 'font-lock-highlighting-faces
  )

(defvar font-lock-embedded-html-face 'font-lock-embedded-html-face
  "A face used to highlight another language embedded in the current
language.")
    
(defconst group-sgml-font-lock-keywords
  '(("<\\([!?][a-zA-Z][-.a-zA-Z0-9]*\\)" 1 font-lock-keyword-face)
    ("<\\(/?[a-zA-Z][-.a-zA-Z0-9]*\\)" 1 font-lock-function-name-face)
    ("[&%][a-zA-Z][-.a-zA-Z0-9]*;?" . font-lock-variable-name-face)
    ("<! *--.*-- *>" . font-lock-comment-face)
    ))

(setq group-sgml-bold-italic-underline
      '("h1" "h2"))
(setq group-sgml-bold-italic-underline-re
      (regexp-opt group-sgml-bold-italic-underline t))
(setq group-sgml-bold-underline
      '("h3"))
(setq group-sgml-bold-underline-re
      (regexp-opt group-sgml-bold-underline t))
(setq group-sgml-italic-underline
      '("h4" "h5"))
(setq group-sgml-italic-underline-re
      (regexp-opt group-sgml-italic-underline t))
(setq group-sgml-underline
      '("h6"))
(setq group-sgml-underline-re
      (regexp-opt group-sgml-underline t))
(setq group-sgml-italic
      '("em" "var" "dfn" "i"))
(setq group-sgml-italic-re
      (regexp-opt group-sgml-italic t))
(setq group-sgml-bold
      '("strong" "b"))
(setq group-sgml-bold-re
      (regexp-opt group-sgml-bold t))

(defface bold-italic-underline
  '((((type w32 x)) (:bold t :underline t :italic t)))
  "bold italic underline")
(defface bold-underline
  '((((type w32 x)) (:bold t :underline t)))
  "bold underline")
(defface italic-underline
  '((((type w32 x)) (:underline t :italic t)))
  "italic underline")


(setq group-more-sgml-font-lock-keywords
      (list (list (concat "<"
                          group-sgml-bold-italic-underline-re
                          ">\\([^<]+\\)</"
                          group-sgml-bold-italic-underline-re
                          ">")
                  (1+ (regexp-opt-depth group-sgml-bold-italic-underline-re))
                  'bold-italic-underline)
            (list (concat "<"
                          group-sgml-bold-underline-re
                          ">\\([^<]+\\)</"
                          group-sgml-bold-underline-re
                          ">")
                  (1+ (regexp-opt-depth group-sgml-bold-underline-re))
                  'bold-underline)
            (list (concat "<"
                          group-sgml-italic-underline-re
                          ">\\([^<]+\\)</"
                          group-sgml-italic-underline-re
                          ">")
                  (1+ (regexp-opt-depth group-sgml-italic-underline-re))
                  'italic-underline)
            (list (concat "<"
                          group-sgml-underline-re
                          ">\\([^<]+\\)</"
                          group-sgml-underline-re
                          ">")
                  (1+ (regexp-opt-depth group-sgml-underline-re))
                  'underline)
            (list (concat "<"
                          group-sgml-italic-re
                          ">\\([^<]+\\)</"
                          group-sgml-italic-re
                          ">")
                  (1+ (regexp-opt-depth group-sgml-italic-re))
                  'italic)
            (list (concat "<"
                          group-sgml-bold-re
                          ">\\([^<]+\\)</"
                          group-sgml-bold-re
                          ">")
                  (1+ (regexp-opt-depth group-sgml-bold-re))
                  'bold)
            ))

(defvar group-extra-keyword-list
  (list
   (cons
    (concat "\\<\\("			;Word beginning.  Note I'm being a
					;  little sloppy in allowing leading
					;  zeros (which are illegal in Java).
					;See Java Lang. Spec for lexical
					;  syntax of floating point.
	    "[0-9]+\\.[0-9]*\\([Ee][-+]?[0-9]+\\)?[FfDd]?\\|" ;FP1
	    "\\.[0-9]+\\([Ee][-+]?[0-9]+\\)?[FfDd]?\\|" ;FP2
	    "[0-9]+[Ee][-+]?[0-9]+[FfDd]?\\|" ;FP3
	    "[0-9]+\\([Ee][-+]?[0-9]+\\)?[FfDd]\\|" ;FP4
	    "\\(0[Xx]\\)?[0-9]+[lL]?\\|" ;Integer, decimal, hex or octal.
					;  Integer comes last to allow more
					;  complicated regexps for FP to match
					;  earlier (gets decimal point
					;  highlighted).
	    "0[Xx][0-9A-Fa-f]+[Ll]?"
	    "\\)\\>")			;Word ending
    '( 1 font-lock-numeric-literal-face prepend))
   (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))
   )
  "*Extra keywords for font-lock mode."
  )

(require 'non-greedy-search)

;                                         ;Fix up html mode's color display.

(defvar group-html-font-lock-keywords
  (list
;;;   '("<\\([!?][a-z][-.a-z0-9]*\\)" 1 font-lock-keyword-face)
;;;   '("<\\(/?[a-z][-.a-z0-9]*\\)" 1 font-lock-function-name-face)
;;;   '("<\\(/?[a-z][-.a-z0-9]*\\)" (1 font-lock-function-name-face)
;;;   ("\\([a-z][-.a-z0-9]*\\)=\\(\"[^\"]*\\)" nil nil (0 font-lock-type-face)))
;;;   '("[&%][a-z][-.a-z0-9]*;?" . font-lock-variable-name-face)
;;;   ("<! *--.*-- *>" . font-lock-comment-face)
   (cons (lambda (limit)
           (non-greedy-search "<! *--" "-- *>" limit))
         '(0 font-lock-comment-face))
   )
  "*Extra keywords for HTML mode.")

                                        ;Last parm == "set" ==> REPLACE the
                                        ;keywords.
(font-lock-add-keywords 'html-mode group-html-font-lock-keywords)

(font-lock-add-keywords 'sgml-mode group-sgml-font-lock-keywords)
(font-lock-add-keywords 'sgml-mode group-more-sgml-font-lock-keywords)
(font-lock-add-keywords 'xml-mode group-sgml-font-lock-keywords)
(font-lock-add-keywords 'xml-mode group-more-sgml-font-lock-keywords)

                                        ;color Transitions in html-mode:
                                        ;  <%		to java
                                        ;  %>		to html OR javascript
                                        ;  <script\b	to javascript
                                        ;  </script>	to html
                                        ;  onFoo="	to javascript
                                        ;  "		to html???

(defvar group-java-other-lang-keywords
  (list
   (cons (lambda (limit)
           (non-greedy-search "%>" "<%" limit))
         '(0 font-lock-embedded-html-face t))
   (cons (lambda (limit)
           (non-greedy-search "\\b[Oo][Nn]\\sw+\\s-*=\\s-*\"" "[^\\]\""
                              limit))
         '(0 font-lock-embedded-javascript-face prepend))
   (cons (lambda (limit) (non-greedy-search "javascript:" "[^\\]\"" limit))
         '(0 font-lock-embedded-javascript-face prepend))
   '(non-greedy-search-script 0 font-lock-embedded-javascript-face t)
   )
  "*Extra keywords indicating ``other languages'' embedded in Java code."
  )

(defvar group-html-other-lang-keywords
  (list
   '("\\b[Oo][Nn]\\sw+\\s-*=\\s-*\"[^\"]*\"" 0 font-lock-embedded-javascript-face prepend)
   (cons (lambda (limit) (non-greedy-search "javascript:" "[^\\]\"" limit))
         '(0 font-lock-embedded-javascript-face prepend))

   '(non-greedy-search-script 0 font-lock-embedded-javascript-face prepend)
   (cons (lambda (limit)
           (non-greedy-search "<%[^-]" "%>" limit))
         '(0 font-lock-embedded-java-face prepend))
   (cons (lambda (limit)
           (non-greedy-search "<%--" "--%>" limit))
         '(0 font-lock-comment-face prepend))
   )
  "*Extra keywords indicating ``other languages'' embedded in HTML."
  )

(defvar group-javascript-other-lang-keywords
  (list
   )
  "*Extra keywords indicating ``other languages'' embedded in JavaScript."
  )

(font-lock-add-keywords 'perl-mode group-extra-keyword-list)
(font-lock-add-keywords 'c-mode group-extra-keyword-list)
(font-lock-add-keywords 'cc-mode group-extra-keyword-list)
(font-lock-add-keywords 'c++-mode group-extra-keyword-list)
(font-lock-add-keywords 'java-mode group-extra-keyword-list)
(font-lock-add-keywords 'jde-mode group-extra-keyword-list)

(font-lock-add-keywords 'java-mode group-java-other-lang-keywords)
(font-lock-add-keywords 'html-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'sgml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'xml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'jde-mode group-java-other-lang-keywords)

(defun fb ()
  "*Alias for `font-lock-fontify-buffer'"
  (interactive)
  (font-lock-fontify-buffer)
  )

(defun sf (search-text)
  "*Alias for `search-forward'"
  (interactive "sSearch: ")
  (search-forward search-text)
  )

(defun sb (search-text)
  "*Alias for `search-backward'"
  (interactive "sSearch: ")
  (search-backward search-text)
  )



;;-----------------------------  end font-lock  ------------------------------

;;-------------------------------  end fonts  --------------------------------

;;----------------------------  frame attributes  ----------------------------
;; For specific text color settings, use 
;; "ESC x customize"-->Faces->Font Lock-->Highlighting Faces.

(defvar preferred-background-mode 'light
  "The user's preferred color scheme.  Should one of 'light or 'dark.")

(setq default-frame-alist
      (append 
       (x-parse-geometry "80x48+64+-1") ;Slightly in from top left.

					;List colors available with
					;  "ESC x list-colors-display".

       (if (eq 'dark preferred-background-mode)
           '(
             ;; (background-color . "DarkSlateGray")
             (background-color . "#254745") ;Darker than DarkSlateGray
             (foreground-color . "white")
                                        ;Explicitly call out to emacs that the
                                        ;current background is dark, so it can
                                        ;pick appropriate colors out of face
                                        ;definitions (if distinctions are made
                                        ;between light and colors in the face
                                        ;defs).
             (background-mode . dark)
             )
                                        ;else...
         '(
           (background-color . "FloralWhite")
           )
         )
       '(
         ;; (background-color . "Linen") ;High-color only?
         ;; (background-color . "AntiqueWhite") ;Seems to always
                                        ;be available.
         (cursor-color . "Red2")
         )
       ;; (list (cons 'font my-default-font))
       default-frame-alist)
      )

(setq initial-frame-alist
      (append (x-parse-geometry "80x48--4+-1") ;Top right.
	      initial-frame-alist
	      )
      )

					;We seem to tickle a nasty emacs bug
					;  when we put this item in the
					;  default-frame-alist above, so we
					;  add it separately here, AFTER
					;  initial-frame-alist.

(if (boundp 'my-default-font)
    (setq default-frame-alist
          (append (list (cons 'font my-default-font)) default-frame-alist))
  )

;;--------------------------  end frame attributes  --------------------------

;;---------------------------  Visual SourceSafe  ----------------------------

;;; Note that Lanning's and Falkner's stuff are mutually exclusive, I think.

;;; Stan Lanning's SourceSafe functions:

;;; (TBD).

;;; Sam Falkner's hacks to vc-mode:

;;; (setq vc-vss-path "//talisker/vss/users/samf/ss.ini"
;;;       vc-default-back-end 'VSS
;;;       diff-switches "-DV")
;;; (makunbound 'vc-master-templates)
;;; (load-library "vc-hooks")
;;; (load-library "vc")

;;-------------------------  end Visual SourceSafe  --------------------------

;; ---------------------------  shelex  ---------------------------
;; (for browse-url, among others)

(defvar shell-execute-helper "shelex.exe")
(defun shell-execute-url (url &optional new-window)
  "Invoke the shell-execute-helper program to call ShellExecute and
launch or re-direct a web browser on the specified url."
  (interactive "sURL: ")
  (call-process shell-execute-helper nil nil nil url))

(setq browse-url-browser-function 'shell-execute-url)
(setq gnus-button-url 'shell-execute-url)		; GNUS
(setq vm-url-browser 'shell-execute-url)		; VM

;; -------------------------  end shelex  -------------------------

;; ----------------------------  misc  ----------------------------

(setq archive-zip-use-pkzip nil)

(defun set-default-font-w32 ()
  "*Allow the user to set the default font interactively, by picking from a
Win32 font menu.  NOTE:  There is a requirement for italics: the italic
version of a font must be exactly the same pixel height as the non-italic
version.  This is true for `Courier New'."
  (interactive)
  (let ((font (w32-select-font))
        )
    (if font
        (progn
          (message (format "Setting font to %s" (prin1-to-string font)))
          (set-default-font font)
          )
      )
    )
  )
                                        ;Coding system shortcuts

(defun coding-system-argument (coding-system)
  "Execute an I/O command using the latin-1-dos coding system."
  (let* (
	 (keyseq (read-key-sequence
		  (format "Command to execute with %s:" coding-system)))
	 (cmd (key-binding keyseq)))
    (let ((coding-system-for-read coding-system)
	  (coding-system-for-write coding-system))
      (message "")
      (call-interactively cmd))))

(defun dos ()
  "Alias for `coding-system-argument'"
  (interactive)
  (coding-system-argument 'raw-text-dos)
  )

(defun unix ()
  "Alias for `coding-system-argument'"
  (interactive)
  (coding-system-argument 'latin-1-unix)
  )

(defun canopy-copyright-statement (date)
  "Insert the Canopy Copyright statement using the year of the given date."
  (interactive "*")
  (concat
   "Copyright "
   (format-time-string "%Y" date)
   " Canopy Systems, Inc. TM All rights reserved."
   ))

					;Some key remappings
(global-set-key "\M-%" 'query-replace-regexp)
(global-set-key "\C-xl" 'goto-line)

(global-set-key [home] 'beginning-of-line)
(global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-line)
(global-set-key [C-end] 'end-of-buffer)

(global-set-key "\M-[" 'align)

(setq version-control t)		;All those little "~" backup files.
(setq kept-old-versions 1)
(setq kept-new-versions 2)
(setq delete-old-versions 't)

(setq colon-double-space t)		;The way I learned it, you should
					;  always space twice after a colon.

(setq completion-ignored-extensions
      (append '(".class")
              completion-ignored-extensions))

(require 'paren)			;Color matching parens highlighting.

(show-paren-mode 1)			;Show matching parens.
;; (hscroll-global-mode 1)			;Automatic horizontal scroll. Requires
					;  truncate-lines to be non-nil.
                                        ;  (Commented out because multi-mode
                                        ;  puts it back in whenever it changes
                                        ;  modes.  Irritating.)

(if (locate-library "~/.abbrev_defs")
    (read-abbrev-file "~/.abbrev_defs")
  (message
   "Warning:  couldn't load abbrev definition file '~/.abbrev_defs'")
  )

;;; (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68
;;; 			72 76 80 84 88 92 96 100 104 108 112 116 120
;;; 			124 128 132))

(setq tab-stop-list '(3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51
			54 57 60 63 66 69 72 75 78 81 84 87 90 93 96
			99 102 105 108 111 114 117 120 123 126 129
			132))

(setq-default indent-tabs-mode nil)     ;Indentation will be done with space,
                                        ;  not tabs.

(if (boundp 'x-pointer-top-left-arrow)
    (progn
      (setq x-pointer-shape x-pointer-top-left-arrow)
      (set-mouse-color "black")
      )
  )

;;;                                         ;Function used in updating
;;;                                         ;  locally-cached copies of config
;;;                                         ;  files.
;;; 
;;; (defun group-config-copy-files (from-dir to-dir &optional files)
;;;   (if (null files)
;;;       nil
;;;     (message (concat "\t" (car files)))
;;;     (copy-file (concat from-dir "/" (car files))
;;; 	       (concat to-dir "/" (car files))
;;; 	       t)			;Ok if already exists.
;;;     (group-config-copy-files from-dir to-dir (cdr files))
;;;     )
;;;   )
;;; 
;;; 					;Offer to update local cache of config
;;; 					;files.
;;; 
;;; (if (y-or-n-p "Update locally-cached versions of configuration files? ")
;;;     (let
;;; 	(
;;; 	 (files '(
;;; 		  "align.el"
;;; 		  "group-config.el"
;;; 		  "jde-extra.el"
;;; 		  "generic-util.el"
;;; 		  )
;;; 		)
;;; 	 (from-dir "//remconsrv/peruse/Emacs/Site-lisp") ;Default value
;;; 	 (to-dir "~/Lisp")		;Default value
;;; 	 (insert-default-directory nil)
;;; 	 )
;;;       (setq from-dir
;;; 	    (read-file-name
;;; 	     (concat "From (default " from-dir "): ")
;;; 	     ""				;Default directory
;;; 	     from-dir			;Initial value
;;; 	     ))
;;;       (setq to-dir
;;; 	    (read-file-name
;;; 	     (concat "To (default " to-dir "): ")
;;; 	     ""
;;; 	     to-dir
;;; 	     ))
;;;       (message (concat "Copying files from " from-dir
;;; 		       " to " to-dir))
;;;       (group-config-copy-files from-dir to-dir files)
;;;       )
;;;   )

;; --------------------------  end misc  --------------------------



;;------------------------------------    ------------------------------------


;;; Local Variables:
;;; fill-column: 78
;;; End:
