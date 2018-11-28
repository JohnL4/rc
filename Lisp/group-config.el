;;; Emacs initialization/customization for the development group.
;;;
;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/group-config.el,v 1.74 2004/05/05 12:04:36 j80lusk Exp $
;;;
;;; TO CHANGE COLORS:
;;; Simplest thing to do is set variable `preferred-background-mode' in your
;;; .emacs to either 'light or 'dark.
;;;
;;; The next simplest thing to do is find default-frame-alist and comment
;;; out/in the foreground and background color settings.  If you switch
;;; to/from a dark/light background, be sure to comment in/out
;;; 'background-mode' appropriately.  You should also change the 'mode-line'
;;; colors separately (unfortunately, but hey I can only do so much color
;;; hacking while I'm supposed to be working).

(message "Begin group-config.el...")

;;--------------------------  reconfigurable items  --------------------------

(defvar author-short-name (user-login-name)
  "*The name you wish to use when identifying yourself as the author of a
document (or piece of code)                                              . This could be your last name, your initials,
something fanciful or something totally random, whatever makes you happy . ")

(defvar our-default-fill-column 120
  "*The default value for fill-column in new modes, for the group.")

;; (setq define-font-lock-org-todo-face nil)
(setq define-font-lock-org-todo-face t)

(defvar user-fill-mode-preference 1
  "*User's preference for fill mode:  positive if user wants fill mode turned
on (in general), non-positive if user does not want fill mode.")

;;---------------------------------  paths  ----------------------------------

(message "paths")
(setq load-path
      (fix-filesystem-paths
       (append
        (list
            "/usr/local/share/emacs/site-lisp/org"
            "/usr/share/emacs/site-lisp/org"
;;;         (concat group-emacs-directory
;;;                 "/usr/local/emacs/Add-ons/jde-"
;;;                 group-jde-version
;;;                 )
;;;         (concat group-emacs-directory
;;;                 "/usr/local/emacs/Add-ons/jde-"
;;;                 group-jde-version
;;;                 "/lisp"
;;;                 )

;;;         "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/common"
;;;         "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/cogre"
;;;         "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/contrib"
;;;	 "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/ede"
;;;         "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/eieio"
;;;         "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/semantic"
;;;         "c:/usr/local/emacs/Add-ons/cedet-1.0pre4/speedbar"
;;;
;;;         "c:/usr/local/emacs/Add-ons/elib-1.0"
;;;         "c:/usr/local/emacs/Add-ons/GnuServe"
;;;         "c:/usr/local/emacs/Add-ons/psgml-1.3.2"
;;;         "c:/usr/local/emacs/Add-ons/nxml-mode-20031018"
         )
        load-path)
       )
      )

(if (not (boundp 'Info-default-directory-list))
    (setq Info-default-directory-list nil)
  )

(setq exec-path (append exec-path '("/usr/local/bin")))

;;;(setq Info-default-directory-list
;;;      (append '(
;;;                "c:/usr/local/emacs/elisp-manual-21-2.8"
;;;                "c:/usr/local/emacs/Add-ons/elib-1.0" ;Required by JDE 2.3.3.
;;;                "c:/usr/local/emacs/Add-ons/psgml-1.3.2"
;;;                "c:/usr/local/info"
;;;                )
;;;	      Info-default-directory-list))

;;--------------------------------  packages  --------------------------------

(condition-case error-description
    (progn
      (require 'package)
      (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
			  (not (gnutls-available-p))))
	     (proto (if no-ssl "http" "https")))
	;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
	(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
	;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable . melpa.org/packages/")) t)
	(when (< emacs-major-version 24)
	  ;; For important compatibility libraries like cl-lib
	  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
;;; (add-to-list 'package-archives
;;;              '("marmalade"                                                         . "http://marmalade-repo.org/packages/"))
      (package-initialize)
      )
  (error 
   (message "Error initializing ``package'': %s" (error-message-string error-description))
   )
  )

;;--------------------------------  requires  --------------------------------

(message "requires")
(require 'generic-util)
(message "edebug")
;;; (require 'edebug)			;LISP source-level debugging       . 
;;; (require 'fix-pathnames)                ;For use in converting MS-style
                                        ;  pathnames to Unix-style, for use
                                        ;  w/Cygnus utilities like diff(1) . 
                                        ;  Requires local mod to
                                        ;  ediff-diff                      . el::ediff-exec-process
                                        ;  to transmogrify incoming list of
                                        ;  pathname args                   . (Make copy in
                                        ;  site-lisp.)

(message "group-jde-mode-hook")
(defun group-jde-mode-hook ()
  ;; (message "jde-mode-hook defined in group-config . el section that requires jde.")
  (setq fill-column our-default-fill-column)
  (abbrev-mode 0)
  (setq adaptive-fill-mode nil)
  (setq jde-gen-cflow-enable nil)
  (modify-syntax-entry 95 "_")
  )


(require 'calendar)

(setq calendar-daylight-savings-starts '(calendar-nth-named-day 1 0 4 year))
(setq calendar-daylight-savings-ends '(calendar-nth-named-day -1 0 10 year))

;;; (set-time-zone-rule "EDT4")             ;Gruesome hack to make journal entries
                                        ;work properly                  . (current-time-zone)
                                        ;still returns incorrect values . 

(set-time-zone-rule nil)                ;During standard time (not summer
                                        ;(daylight)), this works (properly) by
                                        ;querying the system for the requisite
                                        ;info                            . Under Win32, does not respect
                                        ;"TZ" env. var, so you'll have to
                                        ;hardcode it here if you want it . 

;;;(message "Attempting to load gnuserv...")
;;;(require 'gnuserv nil t)		;Enables external requests to
;;;					;  edit files.
;;;(if (featurep 'gnuserv)
;;;	(gnuserv-start)
;;;	(message "No gnuserv")
;;;)
(message "skipping server-start")
;;; (server-start)              ;Runs built-in server in absence of gnuserv.
;;;(message "Attempting to load gnuserv . .. done.")

(message "comment-indent")
(require 'comment-indent)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(message "defun my-fill-mode")
(defun my-fill-mode (&optional turn-on-fill-mode)
  "Common function to be called to turn auto-fill mode on or off from other
mode hooks                                                     . Has default behavior which is user configurable via
`user-fill-mode-preference'                                    . If TURN-ON-FILL-MODE is specified, positive
values turn on auto-fill mode, non-positive values turn it off . "
  (interactive)
  
  (if (null turn-on-fill-mode)
      (setq turn-on-fill-mode user-fill-mode-preference))
  (if (and (numberp turn-on-fill-mode)
           (> turn-on-fill-mode 0))
      (progn
        (auto-fill-mode 1)
        ;; (hscroll-mode 0)
        (setq truncate-lines nil)
        (if (interactive-p)
            (message "auto-fill mode turned ON, hscroll mode OFF"))
        )
    (auto-fill-mode 0)
    ;; (hscroll-mode 1)
    (setq truncate-lines t)
    (if (interactive-p)
        (message "auto-fill mode turned OFF, hscroll mode ON"))
    )
  )

;;------------------------------  end requires  ------------------------------

(message "modes")

;;=================================  modes  ==================================
;;(And other package configs)

(setq default-major-mode 'text-mode)

;;----------------------------------------------------  projectile  ----------------------------------------------------

(with-demoted-errors "Warning loading projectile: %S"
  (require 'projectile)
  (if (featurep 'projectile)
      (progn
        (projectile-mode +1)
        (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
        )))

;;-----------------------------------------------------  company  ------------------------------------------------------

(with-demoted-errors "Warning loading company-mode: %S"
  (require 'company)
  (if (featurep 'company)
      (add-hook 'after-init-hook 'global-company-mode)
    )
  )

;;---------------------------------  magit  ----------------------------------

(require 'magit)
(if (featurep 'magit)
    (progn
      (global-set-key (kbd "C-x g") 'magit-status)
      )
  )

;;----------------------------------------------------  typescript  ----------------------------------------------------

(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (eldoc-mode +1)
	    (if (featurep 'company)
		(progn
		  (company-mode)
		  (setq company-tooltip-align-annotations t) ;Align tooltip annotations on right side of tooltip . 
		  ))
            (setq fill-column 120)
            (local-set-key "\C-j" 'newline)
            (local-set-key "\r" 'newline-and-indent) ;Auto-indent                                                . 
            (local-set-key "\M-o" 'one-line-section-break)
            (local-set-key (kbd "<f2> r") 'tide-rename-symbol)
            (local-set-key (kbd "S-<f12>") 'tide-references)
            ))

;; Note that the following don't work for me when set inside the mode hook.  Don't know why . 
(setq typescript-indent-level 3)
(setq tide-format-options '(:placeOpenBraceOnNewLineForFunctions t :placeOpenBraceOnNewLineForControlBlocks t))

;;--------------------------------  mmm-mode  --------------------------------

;; From https://wiki . haskell.org/Literate_programming
(with-demoted-errors "Warning loading mmm-mode: %S"
  (require 'mmm-mode)
  (if (featurep 'mmm-mode)
      (progn
        (mmm-add-classes
         '((literate-haskell-bird
            :submode text-mode
            :front "^[^>]"
            :include-front true
            :back "^>\\|$"
            )
           (literate-haskell-latex
            :submode literate-haskell-mode
            :front "^\\\\begin{code}"
            :front-offset (end-of-line 1)
            :back "^\\\\end{code}"
            :include-back nil
            :back-offset (beginning-of-line 0)
            )))
        (setq mmm-submode-decoration-level 1)
        )
    ))

(defun my-mmm-mode ()
  ;; go into mmm minor mode when class is given
  (make-local-variable 'mmm-global-mode)
  (setq mmm-global-mode 'true))

;; (defun setup-mmm-mode ()
;;   "Set up mmm-mode.  Called lazily for a mode that requires
;; it (because the load path isn't set up until the end of .emacs),
;; but setup for all modes should go in here."
;;   (interactive)
;;   (message "setup-mmm-mode")
;;   (when (not (featurep 'mmm-mode))
;;     (with-demoted-errors "Warning loading mmm-mode: %S"
;;       (require 'mmm-mode)
;;       (when (featurep 'mmm-mode)
;;         (setq mmm-global-mode 'maybe)
;;         (mmm-add-classes
;;          '((literate-haskell-bird
;;             :submode text-mode
;;             :front "^[^>]"
;;             :include-front true
;;             :back "^>\\|$"
;;             )
;;            (literate-haskell-latex
;;             :submode literate-haskell-mode
;;             :front "^\\begin{code}"
;;             ;; :front-offset (end-of-line 1)
;;             :back "^\\end{code}"
;;             ;; :include-back nil
;;             ;; :back-offset (beginning-of-line -1)
;;             ;; :back-offset (beginning-of-line 1)
;;             )))
;;         ;; (setq mmm-save-local-variables (cons '(auto-fill-function buffer) mmm-save-local-variables))
;;         )))
;;   )
;; 
;; (setup-mmm-mode)

;;--------------------------------  haskell  ---------------------------------

;;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'my-mmm-mode) ;my-mmm-mode defined above
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;;(add-hook 'haskell-mode-hook 'haskell-indentation-mode)

;;(add-hook 'literate-haskell-mode-hook (lambda () (setup-mmm-mode))) ; Might need to add this back, somehow
;;(add-hook 'literate-haskell-mode-hook (lambda () (filladapt-mode 1)))
;;(add-hook 'literate-haskell-mode-hook (lambda () (mmm-mode 1)))

(add-hook 'haskell-mode-hook
          (lambda ()
            (setq fill-column 120)
            ;; (fix-path-for-local-ghc-mod)
            ;; (ghc-init)
            (setq haskell-compile-cabal-build-command "stack build --test")
            (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
            )
          )

(eval-after-load "haskell-mode"
  '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
  )

(eval-after-load "haskell-cabal"
  '(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)

(if (featurep 'company)
    (progn
      (add-to-list 'company-backends 'company-ghc)
      (custom-set-variables '(company-ghc-show-info t))
      ))

(defun fix-path-for-local-ghc-mod ()
  "Fix `exec-path' so that the correct version of ghc-mod will be
found for the current project                                                                  . "
  (interactive)
  (if 't ()                             ;no-op until I figure this out                         . 
    (progn
      (call-process "stack path --local-install-root") ;Or some such; then task on "/bin" and add it to exec-path.  First
                                        ;remove existing dirs from exec-path (that match this) . Blah, this requires
                                        ;creating a temporary buffer to capture the output, reading the output, etc.
                                        ;Maybe later.
      )))

;;---------------------------------  csharp  ---------------------------------

(condition-case err
  (progn
    (require 'csharp-mode)
    (setq auto-mode-alist
          (append '(("\\ . cs$" . csharp-mode)) auto-mode-alist))

;;;(defun my-csharp-mode-fn ()
;;;      "function that runs when csharp-mode is initialized for a buffer."
;;; . ..insert your code here...
;;;      ...most commonly, your custom key bindings ...
;;;   )
;;;   (add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)

    (if (member 'csharp-mode features)
        (progn
          (add-hook 'csharp-mode-hook (lambda ()
                                        (c-set-style "c#")
                                        )
                    )
          )
      )
    )
  (error (message (format "Error: %s" (cdr err))))
  )

;;----------------------------------  calc  ----------------------------------

(require 'calc-mode)

(if (member 'calc-mode features)
    (progn
      ;;(setq calc-gnuplot-name "wgnuplot . exe")
      )
  )

;;-------------------------------  PowerShell  -------------------------------

;;; (autoload 'powershell-mode "powershell-mode" "Microsoft PowerShell mode . " t)
;;; (setq auto-mode-alist (append '(("\\                                    . ps1$" . powershell-mode))
;;;                               auto-mode-alist))

(add-hook 'powershell-mode-hook
          (lambda ()
            (setq fill-column our-default-fill-column)
            (setq powershell-indent 4)
            (setq powershell-continuation-indent 8)
            (setq tab-width 4)
            (setq tab-stop-list nil)    ;Uses tab-wdith to generate
            (setq comment-column 50)
            (setq comment-start "# ")
            (setq comment-start-skip "##*\\s-*")
            (local-set-key "\C-j" 'newline)
            (local-set-key "\r" 'newline-and-indent) ;Auto-indent . 
            (local-set-key "\M-o" 'one-line-section-break)
            (modify-syntax-entry ?- "_")
            ))

;;---------------------------------  VB . NET  ---------------------------------

(autoload 'vbnet-mode "vbnet-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\ . \\(frm\\|bas\\|cls\\|vb\\)$" .
                                 vbnet-mode)) auto-mode-alist))
(add-hook 'vbnet-mode-hook
          (lambda ()
            (setq fill-column our-default-fill-column)
            (setq tab-width 4)
            (setq comment-start "'")
            (setq comment-padding nil)
            (set-face-foreground 'vbnet-funcall-face "blue")
            (subword-mode 1)
            ))

;;---------------------------------  python  ---------------------------------

(require 'python-mode)

(defun group-python-mode-hook ()
  (my-fill-mode)			;Auto Word-wrap
  (local-set-key "\M-o" 'one-line-section-break)
  (setq fill-column our-default-fill-column)
  (subword-mode 1)
  )

(if (member 'python-mode features)
    (progn
      (setq auto-mode-alist
            (append (list '("\\ . py$" . python-mode))
                    auto-mode-alist))
      (add-hook 'python-mode-hook 'group-python-mode-hook)
      )
  )

;;---------------------------------  psgml  ----------------------------------

;; (autoload 'sgml-mode "psgml" "Major mode to edit SGML files . " t)
;; (autoload 'xml-mode "psgml" "Major mode to edit XML files   . " t)
;; (setq sgml-catalog-files '("c:/usr/local/lib/sgml/catalog"))

;;----------------------------------  sgml  ----------------------------------

;; (require 'psgml)
;; 
;; (setq sgml-markup-faces
;;       (mapcar (lambda (x)
;;                 (if (or (equal 'start-tag (car x))
;;                         (equal 'end-tag (car x)))
;;                     nil
;;                   x))
;;               sgml-markup-faces)
;;       )
;; 
(add-hook 'sgml-mode-hook
          (lambda ()
            (progn
              (setq fill-column 120)
              (setq comment-start "<!-- ")
              (setq comment-start-skip "<!-- *")
              (setq comment-end " -->")
              (setq comment-multi-line nil)
              (setq comment-column 32)
              )
            )
          )
;; (defun group-psgml-mode-hook ()
;;   (message "Running group-psgml-mode-hook")
;;   (font-lock-mode 1)
;;   (setq sgml-set-face t)
;; ;;;   (if (and (boundp 'uses-javaserver-faces)
;; ;;;            uses-javaserver-faces
;; ;;;            )
;; ;;;       (progn
;;         (setq comment-start "<%-- ")
;;         (setq comment-start-skip "<%-- *")
;;         (setq comment-end " --%>")
;; ;;;         )
;; ;;;     (setq comment-start "<!-- ")
;; ;;;     (setq comment-start-skip "<!-- *")
;; ;;;     (setq comment-end " -->")
;; ;;;     )
;;   (setq comment-multi-line nil)
;;   (setq comment-column 32)
;;   (setq indent-line-function 'indent-relative-maybe)
;;   )
;; 
;; (add-hook 'sgml-mode-hook 'group-psgml-mode-hook)

;;----------------------------------  html  ----------------------------------

(setq html-mode-hook
      '(lambda ()
         (setq fill-column 120)
;;;          (auto-fill-mode 1)
;;;          (show-paren-mode 1)
;;;          (abbrev-mode 1)
;;;          (local-set-key "\C-j" 'newline)
;;;          (local-set-key "\C-m" 'newline-and-indent)
;;;          (local-set-key "\M-o" 'comment)
;;;          (local-set-key [C-tab] 'indent-relative)
;;;          (local-set-key [C-return] 'newline-and-indent-relative)
         (setq comment-start "<!-- ")
         (setq comment-start-skip "<!-- *")
         (setq comment-end " -->")
         (setq comment-multi-line nil)
         (setq comment-column 32)
         )
      )

;;-------------------------------  multi-mode  -------------------------------

(message "multi-mode")

(ignore-errors
  (require 'css-mode)
)

(autoload 'multi-mode
  "multi-mode"
  "Allowing multiple major modes in a buffer . "
  t)

(defun multi-jde-mode ()
  (interactive)
  (jde-mode)
  (c-toggle-auto-state -1)              ;But this still doesn't keep
                                        ; electric-paren from reindenting . 
  )

(defun jsp-mode () (interactive)
  (let (ml-mode                         ;{x,sg}ml-mode
        )
    (let ((html-locn (save-excursion
                       (goto-char (point-min))
                       (re-search-forward "<!DOCTYPE[^>]*DTD HTML" nil t)))
          (xhtml-locn (save-excursion
                        (goto-char (point-min))
                        (re-search-forward "<!DOCTYPE[^>]*DTD XHTML" nil t)))
          )
      (cond ((and (null html-locn) (null xhtml-locn))
             (setq ml-mode 'sgml-mode))
            ((null html-locn)
             (setq ml-mode 'xml-mode))
            ((null xhtml-locn)
             (setq ml-mode 'sgml-mode))
            ((< xhtml-locn html-locn)
             (setq ml-mode 'xml-mode))
            (t
             (setq ml-mode 'sgml-mode))
            )
      )
    (multi-mode 1
                ml-mode
                `("<%!" jde-mode)
                `("%>" ,ml-mode)
                `("<style" css-mode)
                `("<STYLE" css-mode)
                `("</style" ,ml-mode)
                `("</STYLE" ,ml-mode)
                `("<script" js-mode)
                `("<SCRIPT" js-mode)
                `("</script" ,ml-mode)
                `("</SCRIPT" ,ml-mode)
;;                `("</\\(script\\|style\\)" ,ml-mode)
;;                `("</\\(SCRIPT\\|STYLE\\)" ,ml-mode)
                )
    )
  )

(setq auto-mode-alist
      (append (list '("\\.jsp$" . jsp-mode)
                    '("\\ . jspf$" . jsp-mode)
                    '("\\ . jsptemplate$" . jsp-mode)
                    '("\\ . html?$" . jsp-mode)
                    '("\\ . sql8$" . sql-mode)
                    '("\\ . prc$" . sql-mode)
                    '("\\ . tab$" . sql-mode)
                    '("\\ . xsl$" . xml-mode)
                    '("\\ . xsp$" . xml-mode)
                    )
              auto-mode-alist))

;;----------------------------------  sql  -----------------------------------

(add-hook 'sql-mode-hook
          (lambda ()
            (setq fill-column our-default-fill-column)
            (auto-fill-mode 0)
            (column-number-mode 1)
            (setq indent-line-function 'indent-relative)
            (setq comment-start "-- ")
            ;;(setq indent-tabs-mode t)
            (setq tab-width 4)          ;to match Sql Server Management Studio
            (setq align-to-tab-stop t)
            (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64
                                    68 72 76 80 84 88 92 96 100))
            (local-set-key "\M-o" 'section-break)
            )
          )

;;----------------------------------  jde  -----------------------------------

;;; (add-hook 'java-mode-hook
;;; 	  (lambda ()
;;; 	    (abbrev-mode 0)
;;;             (modify-syntax-entry 95 "_")
;;; 	    )
;;; 	  )

;;----------------------------------  java  ----------------------------------

(c-add-style "java-bsd"
             '("bsd"
               ;; (c-comment-continuation-stars . "* ")
               ;; (c-block-comment-prefix       . "*")
               ))

;; (require 'filladapt)
                                        ;Suggested by cc-mode home page, for
                                        ;cc-mode 5.30.9.
(defun my-c-mode-common-hook ()
;;;  (c-setup-filladapt)
;;;  (filladapt-mode 1)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(defun group-java-mode-hook ()
  (c-set-style "java-bsd")              ;Indentation
  (setq c-basic-offset 3)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'topmost-intro-cont '+)
  (c-set-offset 'comment-intro 'c-lineup-comment-unless-on-far-right)

  (setq c-tab-always-indent nil)

  (my-fill-mode)			;Auto Word-wrap
;;;  (make-variable-buffer-local 'comment-padding)
;;;  (setq comment-padding nil)
  (setq tempo-interactive t)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent . 
  (local-set-key "\M-o" 'section-break)
  (local-set-key "\M-]" 'complete-tag)
  
					;Change behavior of electric braces . 

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
  (c-set-offset 'comment-intro 'c-lineup-comment-unless-on-far-right)
  (setq c-tab-always-indent nil)
  (my-fill-mode)			;Auto Word-wrap
  (make-variable-buffer-local 'comment-padding)
  (setq comment-padding nil)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent . 
  (local-set-key "\M-o" 'section-break)

					;Change behavior of electric braces . 

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
  (c-set-offset 'comment-intro 'c-lineup-comment-unless-on-far-right)

  (setq c-tab-always-indent nil)
  (my-fill-mode)			;Auto Word-wrap
  (make-variable-buffer-local 'comment-padding)
  (setq comment-padding nil)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent . 
  (local-set-key "\M-o" 'section-break)

					;Change behavior of electric braces . 

  (c-toggle-auto-state 1)
  (abbrev-mode 0)
  (setq c-hanging-braces-alist
	(cons (cons 'substatement-open '(before after))
					;substatement-open sufficient?  need
					;  we also block-open?
	      c-hanging-braces-alist))
  )

(add-hook 'c++-mode-hook 'group-c++-mode-hook)
  
;;----------------------------------  perl  ----------------------------------

(defun group-perl-mode-hook ()
                                        ;NOTE: c-indent stuff doesn't work . 
                                        ;  Use perl-indent variables if you
                                        ;  want to change anything         . 

  (make-variable-buffer-local 'comment-multi-line)
  (setq comment-multi-line nil)
  (setq fill-column our-default-fill-column)
  (my-fill-mode)			;Auto Word-wrap
  
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent . 
  (local-set-key "\M-o" 'section-break)
  (local-set-key "\M-]" 'complete-tag)
  )

(add-hook 'perl-mode-hook 'group-perl-mode-hook)

;;-------------------------------  javascript  -------------------------------

(add-hook 'js-mode-hook
          (lambda ()
            (progn
              (setq fill-column 120)
              (local-set-key "\C-j" 'newline)
              (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
              (local-set-key "\M-o" 'one-line-section-break)
              )
            )
          )
                                     
;;; (message "javascript")
;;; (require 'generic-x)
;;; (require 'js)
;;; (add-to-list 'generic-extras-enable-list 'javascript-generic-mode)

;;; (autoload 'javascript-mode
;;;   "javascript-mode"
;;; ;;;   "javascript-cust"
;;;   "JavaScript mode"
;;;   t nil)

;;; (setq auto-mode-alist
;;;       (append '(("\\ . js$" . javascript-mode))
;;;               auto-mode-alist))

;;; (setq auto-mode-alist
;;;       (append (list '("\\ . js$" . c++-mode)
;;;                     )
;;;               auto-mode-alist))

;;----------------------------------  text  ----------------------------------

(defun group-text-mode-hook ()
  ;;(my-fill-mode)
  (visual-line-mode)
  (column-number-mode 1)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\C-m" 'newline-and-indent) ;Auto-indent . 
  (local-set-key "\M-o" 'one-line-section-break)
  (make-variable-buffer-local 'comment-start)
  (make-variable-buffer-local 'comment-end)
  (make-variable-buffer-local 'comment-start-skip)
  (make-variable-buffer-local 'comment-multi-line)
  (setq comment-start "# ")
  (setq comment-end "")
  (setq comment-start-skip "#+\\s-*")
  (setq comment-multi-line nil)
  (setq fill-column our-default-fill-column)
  )

(add-hook 'text-mode-hook 'group-text-mode-hook)

;;----------------------------------  lisp  ----------------------------------

(defun group-lisp-mode-hook ()
  (my-fill-mode)
  (setq fill-column our-default-fill-column)
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
            (if (boundp 'sh-heredoc-face)
                (set-face-foreground sh-heredoc-face
                                     (face-foreground font-lock-string-face)
                                     )
              )
            (subword-mode 1)
	    )
	  )

;;---------------------------------  ediff  ----------------------------------

(message "ediff")
(setq ediff-load-hook
      (function
       (lambda () 

	 ;;(modify-face FACENAME FG BG STIPL BOLD ITALIC UNDER)
;;;	 (modify-face ediff-even-diff-face-B "black" nil nil t nil nil)
;;;	 (modify-face ediff-odd-diff-face-A "black" nil nil t nil nil)
;;;	 (modify-face ediff-odd-diff-face-C "black" nil nil t nil nil)
;;;	     
;;;	 (modify-face ediff-odd-diff-face-B "black" nil nil t nil nil)
;;;	 (modify-face ediff-even-diff-face-A "black" nil nil t nil nil)
;;;	 (modify-face ediff-even-diff-face-C "black" nil nil t nil nil)

	 (set-face-foreground ediff-current-diff-face-A "black")
	 (set-face-background ediff-current-diff-face-A "#ffd6d6") ;#ffd6d6 -- pink-ish

	 (set-face-foreground ediff-current-diff-face-B "black")
         (set-face-background ediff-current-diff-face-B "#befbbe") ;#befbbe -- green-ish

	 (set-face-foreground ediff-current-diff-face-C "black")
	 (set-face-background ediff-current-diff-face-C "#ffffbb") ;#ffffbb -- yellow-ish
	     
         (set-face-foreground ediff-current-diff-face-Ancestor "black")
         (set-face-background ediff-current-diff-face-Ancestor "SkyBlue1")

	 (set-face-foreground ediff-fine-diff-face-A "black")
	 (set-face-background ediff-fine-diff-face-A "#e8b5b5") ;#e8b5b5 -- pink-ish (darker)
	     
	 (set-face-foreground ediff-fine-diff-face-B "black")
	 (set-face-background ediff-fine-diff-face-B "#8be48b") ;#8be48b -- green-ish (darker)
	     
	 (set-face-foreground ediff-fine-diff-face-C "black")
	 (set-face-background ediff-fine-diff-face-C "#e0e08a") ;#e0e08a - yellow-ish (darker)
	     
;;;	 (setq ediff-combination-pattern
;;;	       '("<<<<<<<<"
;;;		 "========"
;;;		 ">>>>>>>>"
;;;		 )
;;;	       )
	     
	 ;; (setq ediff-narrow-control-frame-leftward-shift 65)
	 ;; 
         (setq ediff-narrow-control-frame-leftward-shift 0)
	 (setq ediff-wide-control-frame-rightward-shift 0)
	 (setq ediff-control-frame-upward-shift -900)
	     
	 ;; 
	 (setq ediff-diff-options "-dw")

	 ;;(
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 ;; 
	 )
       )
      )

;;--------------------------------  org-mode  --------------------------------

;; (condition-case err
;;   (progn
;; (require 'org-install)
;; (require 'org))
;; (error (message (format "Error: %s" (cdr err))))
;; )

(setq org-list-allow-alphabetical t)     ;Must be set before loading org.

(with-demoted-errors "WARNING: %S"
  (require 'org-install)
  (require 'org)
  (require 'ox-hugo)
  (require 'ox-hugo-auto-export)
  (require 'ox-reveal)                  ;Export to reveal.js presentation
  (require 'ox-twbs)                    ;Export to Twitter Bootstrap (i.e., just "Bootstrap")
  )

(if (member 'org features)
    (progn
      ;; The following lines are always needed.  Choose your own keys.
      (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
      (global-set-key "\C-cl" 'org-store-link)
      (global-set-key "\C-cc" 'org-capture)
      (global-set-key "\C-ca" 'org-agenda)
      (global-set-key "\C-cb" 'org-iswitchb)

      (setq org-agenda-files "~/org/org-agendas.txt")
      (setq org-export-headline-levels 12) ;I think this is for pandoc (https://pandoc.org)
      (setq org-tags-column -120)          ;Flush right

      ;;-----------------------------------------------  export plugins  -----------------------------------------------

      (if (member 'ox-reveal features)
          (progn
            ;; (setq org-reveal-root "file:///c:/usr/local/Reveal")
            )
        )
      (if (member 'ox-twbs features)
          (progn
            )
        )

      ;;---------------------------------------------------  babel  ----------------------------------------------------

      (setq org-plantuml-jar-path (expand-file-name "/usr/local/lib/plantuml.jar"))
      (setq plantuml-jar-path org-plantuml-jar-path)
      (setq plantuml-default-exec-mode 'jar) ;As opposed to 'server, the default.  See
                                 ;https://medium.com/@shibucite/emacs-and-plantuml-for-uml-diagrams-academic-tools-6c34bc07fd2
      (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
      (setq org-babel-load-languages (cons '(plantuml . t) org-babel-load-languages))
      (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
      (defun my-org-confirm-babel-evaluate (lang body)
            (not (string= lang "plantuml")))  ;don't ask for plantuml
      (setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)

      ;;---------------------------------------------------  hooks  ----------------------------------------------------
      
      (add-hook 'org-mode-hook 'turn-on-font-lock)  ; org-mode buffers only
      (add-hook 'org-mode-hook
                (lambda ()
                  (auto-fill-mode 1)
                  (transient-mark-mode 1)
                  (abbrev-mode 1)
                  (setq comment-start "# ")
                  (setq comment-start-skip "#\\s-*")
                  (setq comment-column 32)
                  ))
      ;; The problem with the postamble hook below is that we wind up setting the same postamble for all files, when we
      ;; really should only be setting a postamble for certain files.  Ideally, org-html-postamble-format would be a
      ;; function, but it's not.
      ;;(add-hook 'org-mode-hook 'set-org-html-postamble-format-from-file) ;defun below

      ;;----------------------------------------------  keywords, faces  -----------------------------------------------
      
      (setq org-log-done 'note)                     ;time or note -- note to be prompted for at closing note.

      (setq org-todo-keywords
            '((sequence "TODO(t)" "IN-PROGRESS(i)" "HOLD(h@)" "|" "DONE(d)" )
              (sequence "RESEARCH-TODO(r)" "RESEARCH-IN-PROGRESS(s)" "RESEARCH-HOLD(w@)" "|" "RESEARCH-DONE(u)" )
              (sequence "CODE-TODO(c)" "CODE-IN-PROGRESS(e)" "CODE-HOLD(p@)" "|" "CODE-DONE(f)" )
              ))
      (defface org-in-progress
        (org-compatible-face nil
          '((((class color) (min-colors 16) (background light))
             ;;(:foreground "DarkOrange3" :bold t :background "White"))
             (:foreground "magenta2" :bold t :background "White"))
            (((class color) (min-colors 16) (background dark))
             ;;(:foreground "DarkOrange2" :bold t :background "Black"))
             (:foreground "magenta2" :bold t :background "Black"))
            (((class color) (min-colors 8)  (background light))
             (:foreground "magenta"  :bold t :background "White"))
            (((class color) (min-colors 8)  (background dark))
             (:foreground "magenta"  :bold t :background "Black"))
            (t (:inverse-video t :bold t))))
        "Face for IN-PROGRESS keywords."
        :group 'org-faces)
      (set-face-foreground 'org-table "Blue4")
;;;      (defface org-table
;;;        (org-compatible-face nil
;;;          '((((class color) (min-colors 16) (background light)) (:foreground "Blue4" :bold nil))
;;;            (((class color) (min-colors 16) (background dark))  (:foreground "LightSkyBlue1" :bold nil))
;;;            (((class color) (min-colors 8)  (background light)) (:foreground "Blue"  :bold nil))
;;;            (((class color) (min-colors 8)  (background dark))  (:foreground "Cyan"  :bold nil))
;;;            (t (:inverse-video nil :bold nil))))
;;;        "Face for IN-PROGRESS keywords."
;;;        :group 'org-faces)
      (setq org-todo-keyword-faces
            '(("TODO" . org-todo)
              ("IN-PROGRESS" . org-in-progress)
              ("DONE" . org-done)
              ("HOLD" . org-hold)
              ("RESEARCH-HOLD" . org-hold)
              ("CODE-HOLD" . org-hold)
              ))

      ;;-----------------------------------------------  org html style  -----------------------------------------------
      
      ;;(setq org-export-html-style-include-default nil) ;Turn off hardcoded default in org-mode in favor of style
                                                       ;declared below.

      ;;For TODO colors, see http://colorschemedesigner.com/#4W51Ew0--w0w0
      ;;
;;;      (setq org-export-html-style       ;No longer used in org-8.2.1 (don't know when they really
;;;                                        ;stopped using it).
;;;"<style type=\"text/css\">
;;; <!--/*--><![CDATA[/*><!--*/
;;;  html { }
;;;  body { margin-left: 7%; }
;;;  /* h1 is doc title */
;;;  h1, h2, h3 { margin-left: -6%; }
;;;  h4 { margin-left: -3%; }
;;;  .title  { text-align: center; }
;;;  .todo   { color: magenta /*#FF0090*/ /*red*/; }
;;;  .done   { color: green; }
;;;  .tag    { background-color: #add8e6; font-weight:normal }
;;;  .target { }
;;;  .timestamp { color: #bebebe; }
;;;  .timestamp-kwd { color: #5f9ea0; }
;;;  p.verse { margin-left: 3% }
;;;  /* pre {	*/
;;;  /*       border: 1pt solid #AEBDCC;	*/
;;;  /*       background-color: #F3F5F7;	*/
;;;  /*       padding: 5pt;	*/
;;;  /*       font-family: monospace;	*/
;;;  /*       font-size: 90%;	*/
;;;  /*       overflow:auto;	*/
;;;  /* }	*/
;;;  table { border-collapse: collapse; }
;;;  td, th { vertical-align: top; }
;;;  dt { font-weight: bold; }
;;;  div.figure { padding: 0.5em; }
;;;  div.figure p { text-align: center; }
;;;  textarea { overflow-x: auto; }
;;;  .linenr { font-size:smaller }
;;;  .code-highlighted {background-color:#ffff00;}
;;;  .org-info-js_info-navigation { border-style:none; }
;;;  #org-info-js_console-label { font-size:smaller; font-weight:bold;
;;;                               white-space:nowrap; }
;;;  .org-info-js_search-highlight {background-color:#ffff00; color:#000000;
;;;                                 font-weight:bold; }
;;;  /*]]>*/-->
;;;</style>"
;;;        )
;;;       (setq org-html-head "
;;; <link href=\"https://fonts.googleapis.com/css?family=IBM+Plex+Mono|IBM+Plex+Sans\" rel=\"stylesheet\">
;;; <!-- <link href=\"https://fonts.googleapis.com/css?family=Asap\" rel=\"stylesheet\"> -->
;;; <!-- <link href=\"https://fonts.googleapis.com/css?family=Chivo|Source+Sans+Pro\" rel=\"stylesheet\"> -->
;;; 
;;; <style type=\"text/css\">
;;;  <!--/*--><![CDATA[/*><!--*/
;;;   body {
;;;   font-family: 'IBM Plex Sans', sans-serif;
;;;   /* font-family: 'Source Sans Pro', sans-serif; */
;;;   /* font-family: 'Asap', sans-serif; */
;;;   }
;;;   pre, code {
;;;   font-family: 'IBM Plex Mono', monospace;
;;;   font-size: smaller;
;;;   }
;;;   pre {
;;;   }
;;;   body { margin-left: 7%; }
;;;   /* h1 is doc title */
;;;   h1, h2, h3 { margin-left: -6%; }
;;;   h4 { margin-left: -3%; }
;;;   h5, h6, h7, h8, h9, h10 { font-size: 1em; font-weight: bold; }
;;;   .title  { text-align: center; }
;;;   .todo   { color: magenta /*#FF0090*/ /*red*/; }
;;;   .done   { color: green; }
;;;   .tag    { background-color: #add8e6; font-weight:normal }
;;;   .target { }
;;;   .timestamp { color: #8681B2; font-style: italic; }
;;;   .timestamp-kwd { color: #5f9ea0; }
;;;   p.verse { margin-left: 3% }
;;;   pre.src, pre.example { background-color: #F3F5F7; overflow: auto;}
;;;   pre.src:before { top: 10px; } /* overrides -10px, to bring box into pre box, so 'overflow: auto;' won't clip it */
;;;   pre.src-csharp:before  { content: 'C#'; }
;;;   pre.src-css:before  { content: 'CSS'; }
;;;   pre.src-haskell:before  { content: 'Haskell'; }
;;;   pre.src-javascript:before  { content: 'JavaScript'; }
;;;   pre.src-powershell:before  { content: 'PowerShell'; }
;;;   pre.src-sql:before  { content: 'SQL'; }
;;;   pre.src-typescript:before  { content: 'TypeScript'; }
;;;   pre.src-vbnet:before  { content: 'VB.Net'; }
;;;   pre.src-xml:before  { content: 'XML'; }
;;; /*]]>*/-->
;;; </style>
;;; ")
      ))

(defun set-org-html-postamble-format-from-file ()
  "Sets `org-html-postamble-format` from file `org-html-postamble-format.html', beginning search in current
directory and proceeding to parent directories until it's found or root is reached."
  (interactive)
  (let* ((postamble-filename "org-html-postamble-format.html")
         (found-dir)
         )
    (if (buffer-file-name)
        (progn
          (setq found-dir (locate-dominating-file (buffer-file-name) postamble-filename))
          (if found-dir
              (setq org-html-postamble-format (get-string-from-file (concat found-dir postamble-filename)))
            (message (format "Unable to find %S starting at %S" postamble-filename (buffer-file-name)))
            ))
      ;;else...
      (message (format "Current buffer (%S) has no associated file." (buffer-name)))
      )
    )
  )

;; Courtesy of http://ergoemacs.org/emacs/elisp_read_file_content.html
(defun get-string-from-file (file-path)
  "Return `file-path' content as a string."
  (interactive)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun escape-code (&optional underscores-only opener closer)
  "Surrounds code tokens (alphanumerics and underscores) with extra strings
  that delimit them as code.  If `underscores-only' is true, only replace
  words containing underscores; otherwise, replace all space-delimited
  strings.  Replacement is surrounding of original string with `opener' and
  `closer'."
  (interactive)
  (if (called-interactively-p 'any)
      (setq underscores-only (y-or-n-p "Target underscores only? ")))
  (if (null opener)
      (setq opener (read-from-minibuffer "Opener: " "=")))
  (if (null closer)
      (setq closer (read-from-minibuffer "Closer: " opener)))
  (let
      ((replace-target (if underscores-only
                           "\\(\\([A-Za-z0-9.@$:/!\\]*_[A-Za-z0-9.@$:/!\\]*\\)+\\)"
                         "\\([A-Za-z0-9._@$:/!\\]+\\)"
                         ))             ;First subexpression will be replaced
       )
    (if (use-region-p)
        (perform-replace replace-target (format "%s\\1%s" opener closer) t t t nil nil
                         (region-beginning) (region-end))
      (perform-replace replace-target (format "%s\\1%s" opener closer) t t t)
      )
    )
  )

;;-----------------------------------------------------  org-mode ends  -----------------------------------------------------

;;===============================  end modes  ================================

;;---------------------------------  cygwin  ---------------------------------
;;;;
;;;; cygwin support
;;;;
;; Sets your shell to use cygwin's bash, if Emacs finds it's running
;; under Windows and c:\cygwin exists. Assumes that C:\cygwin\bin is
;; not already in your Windows Path (it generally should not be).
;;
(let* ((cygwin-root "c:")               ;was "c:/cygwin"
       (cygwin-bin (concat cygwin-root "/bin")))
  (when (and (eq 'windows-nt system-type)
  	     (file-readable-p cygwin-root))
    
    (setq exec-path (cons cygwin-bin exec-path))
    (setenv "CYGWIN" "nodosfilewarning")
    (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))
    
    ;; By default use the Windows HOME.
    ;; Otherwise, uncomment below to set a HOME
    ;;      (setenv "HOME" (concat cygwin-root "/home/eric"))
    
    ;; NT-emacs assumes a Windows shell. Change to bash.
    (setq shell-file-name "bash")
    (setenv "SHELL" shell-file-name) 
    (setq explicit-shell-file-name shell-file-name) 
    
    ;; This removes unsightly ^M characters that would otherwise
    ;; appear in the output of java applications.
    (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)))

;;------------------------------  cygwin ends  -------------------------------

;;---------------------------------  fonts  ----------------------------------

					;Use (insert (prin1-to-string
					;  (w32-select-font))) in *scratch* to
					;  get an actual font name string.

					;  Shift-click mouse-1 will also work.

(message (format "window-system: %s" window-system))

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

      ;; (setq my-default-font "-outline-Bitstream Vera Sans Mono-normal-r-normal-normal-11-82-96-96-c-*-iso10646-1")
      ;; (setq my-default-font "-outline-Bitstream Vera Sans Mono-normal-r-normal-normal-12-90-96-96-c-*-iso10646-1")
					;8- and 9-point courier:
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-12-90-96-96-c-*-iso8859-1")
      (setq my-default-font "-*-Courier New-normal-r-*-*-11-82-96-96-c-*-iso8859-1")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-11-82-*-*-c-*-*-ansi-")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-12-90-*-*-c-*-*-ansi-")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-13-78-*-*-c-*-*-ansi-")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-15-90-*-*-c-*-*-ansi-")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-13-78-*-*-c-*-*-ansi-")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-15-90-*-*-c-*-*-ansi-")
      (setq my-default-font "Consolas-9")
      )
  )

(if (eq 'x window-system)
    (progn
      ;;(setq my-default-font "-*-courier-medium-r-*-*-*-120-*-*-m-*-*-*")
      (setq my-default-font "Courier 10 Pitch-9") ;name-size (Linux Mint 17 (Ubuntu))
      )
  )

;; MacOS/OSX
(if (and (eq 'ns window-system)
	 (eq 'darwin system-type))
    ;; Mac OSX
    (progn
      ;; (setq my-default-font "Monaco")
      (setq my-default-font "Inconsolata-14")
      )
  )

(if (not (fboundp 'set-default-font))
    (defun set-default-font (font-name)
      "Replacement for old set-default-font, which seems to have disappeared."
      (interactive)
      (add-to-list 'default-frame-alist
                   '(font . font-name))
      )
  )

(if (boundp 'my-default-font)		; (not (null window-system))
    (progn
      (message "Setting default font")
      (set-default-font my-default-font)

      ;; (make-face-italic 'italic)
      ;; (make-face-italic 'bold-italic)
      ;; (make-face-bold 'bold-italic)
;;;      (make-face-bold 'mode-line)
      )
  )

(if (not (null window-system))
    (progn

					;We seem to tickle a nasty emacs bug
					;  when we put this item in the
					;  default-frame-alist above, so we
					;  add it separately here, AFTER
					;  initial-frame-alist.

      (setq default-frame-alist
            (append (list (cons 'font my-default-font)) default-frame-alist))

					;List colors available with
					;  "ESC x list-colors-display".

      (set-face-background 'mode-line
                           (if (eq 'dark preferred-background-mode)
                               "gainsboro"
                             "saddlebrown"
                             ))
      ;; (set-face-background 'mode-line "gainsboro")

                                        ;mode-line foreground is same as
                                        ;  default frame background (see
                                        ;  below). 
      (set-face-foreground 'mode-line
                           (if (eq 'dark preferred-background-mode)
                               ;; "DarkSlateGray"
                               "#254745"
                             "FloralWhite"
                             ))
      ;; (set-face-foreground 'mode-line "DarkSlateGray")
      ;; (set-face-foreground 'mode-line "Linen")	

                                        ; The "fringe" is the strips to the
                                        ;   left and right of the text area
                                        ;   that shows continuation lines.
      (set-face-background 'fringe
                           (if (eq 'dark preferred-background-mode)
                               ;; "DarkSlateGray"
                               "#254745"
                             ;; "FloralWhite"
                             "#f7f3e9"  ;slightly darker shade of FloralWhite
                             ;; "#f0ebe2" ;slightly darker shade of FloralWhite
                             ))
      (set-face-foreground 'fringe
                           (if (eq 'dark preferred-background-mode)
                               ;; "DarkSlateGray"
                               "gainsboro"
                             "gray50"
                             ))
      )
  )

;;-------------------------------  font-lock  --------------------------------

(require 'font-lock)

(setq font-lock-support-mode
      '(
        (compilation-mode . nil)
        (t . jit-lock-mode)	;Was lazy-lock-mode, Lusk, 23-Jun-2009.
        ))
(setq lazy-lock-stealth-time 10)
;; (setq lazy-lock-stealth-verbose t)

;;(make-face-bold 'font-lock-variable-name-face)
(if (eq 'light preferred-background-mode)
    (set-face-foreground font-lock-variable-name-face "Goldenrod4")
  )

(defface font-lock-deprecated-face
  '((((class color) (background light)) (:bold t :foreground "OrangeRed"))
    (((class color) (background dark)) (:bold t :foreground "Orange"))
    (t (:bold t))
    )
  "Used to highlight the ``@deprecated'' javadoc keyword."
  :group 'font-lock-highlighting-faces)

(defvar font-lock-deprecated-face 'font-lock-deprecated-face
  "Face name to use for ``@deprecated'' things."
  )

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
            :background unspecified     ;NOTE: merely commenting this out has an undesired effect on faces that inherit
                                        ;from this face (e.g., font-lock-org-todo-face): they can't set their own
                                        ;backgrounds!  If you want this face to inherit its background (either from
                                        ;whatever it's on top of in the buffer or from a parent face), you need to leave
                                        ;it as "unspecified" (unquoted symbol) instead of just commenting it out.
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

(if define-font-lock-org-todo-face
    (progn
      (if (facep 'font-lock-todo-face)
          (message (format "font-lock-todo-face before defface: %S" (face-all-attributes 'font-lock-todo-face))))
      (if (facep 'font-lock-org-todo-face)
          (message (format "font-lock-org-todo-face before defface: %S" (face-all-attributes 'font-lock-org-todo-face))))
      (defface font-lock-org-todo-face ;This seems to clobber TODO face in org-mode (items lose their foreground colors,
                                       ;and return to the default (usually black)). 
        '(
          (
           ((class color) (background light))
           :inherit font-lock-todo-face
           :background "yellow" 
           )
          (
           ((class color) (background dark))
           :inherit font-lock-todo-face
           :background "red"
           )
          (
           t
           :background "magenta"
           :foreground "white"
           :weight bold
           )
          
          )
        "The face to be used to display ``TODO'' items in org-mode."
        :group 'font-lock-highlighting-face)

      (defvar font-lock-org-todo-face 'font-lock-org-todo-face
        "Face name for TODO items in org-mode.")

      (if (facep 'font-lock-org-todo-face)
          (message (format "font-lock-org-todo-face after defface: %S" (face-all-attributes 'font-lock-org-todo-face))))
      ))

;;;(defface font-lock-done-face
;;;  '(
;;;    (
;;;     ((class color) (background light))
;;;     (:bold nil :foreground green
;;;            )
;;;     )
;;;    )
;;;  "The face to be used to display ``DONE'' items."
;;;  :group 'font-lock-highlighting-faces)

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
    
;;; (set-face-foreground 'jde-java-font-lock-number-face "OrangeRed")

(defconst group-sgml-font-lock-keywords
  '(("<\\([!?][a-zA-Z][-.a-zA-Z0-9]*\\)" 1 font-lock-keyword-face)
    ;; ("<\\(/?[a-zA-Z][-.a-zA-Z0-9]*\\(:[a-zA-Z][-.a-zA-Z0-9]*\\)?\\)" 1 font-lock-keyword-face)
    ("[&%][a-zA-Z][-.a-zA-Z0-9]*;?" . font-lock-variable-name-face) ;entities
    ("<! *--.*-- *>" . font-lock-comment-face)
    ("\\bTODO\\b:?" . (0 font-lock-todo-face prepend))
    ("[$#]{[^}]+}" . (0 font-lock-function-name-face)) ;JSTL, JSF expressions
    ))

(defvar group-extra-keyword-list
  (list
;;;    (cons
;;;     (concat "\\<\\("			;Word beginning.  Note I'm being a
;;; 					;  little sloppy in allowing leading
;;; 					;  zeros (which are illegal in Java).
;;; 					;See Java Lang. Spec for lexical
;;; 					;  syntax of floating point.
;;; 	    "[0-9]+\\.[0-9]*\\([Ee][-+]?[0-9]+\\)?[FfDd]?\\|" ;FP1
;;; 	    "\\.[0-9]+\\([Ee][-+]?[0-9]+\\)?[FfDd]?\\|" ;FP2
;;; 	    "[0-9]+[Ee][-+]?[0-9]+[FfDd]?\\|" ;FP3
;;; 	    "[0-9]+\\([Ee][-+]?[0-9]+\\)?[FfDd]\\|" ;FP4
;;; 	    "\\(0[Xx]\\)?[0-9]+[lL]?\\|" ;Integer, decimal, hex or octal.
;;; 					;  Integer comes last to allow more
;;; 					;  complicated regexps for FP to match
;;; 					;  earlier (gets decimal point
;;; 					;  highlighted).
;;; 	    "0[Xx][0-9A-Fa-f]+[Ll]?"
;;; 	    "\\)\\>")			;Word ending
;;;     '( 1 font-lock-numeric-literal-face prepend))
   (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))
   (cons "@deprecated\\b" '(0 font-lock-deprecated-face prepend))
   )
  "*Extra keywords for font-lock mode."
  )

(require 'jde-java-font-lock nil t)     ;Slurp in face definitions so we can
                                        ;modify some of 'em.
(if (featurep 'jde-java-font-lock)
	(set-face-foreground 'jde-java-font-lock-number-face "OrangeRed")
	(message "No jde-java-font-lock")
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

(load-library "html-tag-font-lock-keywords")

                                        ;Last parm == "set" ==> REPLACE the
                                        ;keywords.
(font-lock-add-keywords 'html-mode group-html-font-lock-keywords)
(font-lock-add-keywords 'sgml-mode group-sgml-font-lock-keywords)
(font-lock-add-keywords 'sgml-mode group-html-tag-keywords)
(font-lock-add-keywords 'xml-mode group-sgml-font-lock-keywords)
(font-lock-add-keywords 'nxml-mode group-sgml-font-lock-keywords)
(font-lock-add-keywords 'xml-mode group-html-tag-keywords)
(font-lock-add-keywords 'nxml-mode group-html-tag-keywords)

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
   '("\\b[Oo][Nn]\\sw+\\s-*=\\s-*'[^']*'" 0 font-lock-embedded-javascript-face prepend)
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
(font-lock-add-keywords 'jde-mode group-extra-keyword-list t) ;append

(font-lock-add-keywords 'java-mode group-java-other-lang-keywords)
(font-lock-add-keywords 'html-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'sgml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'xml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'nxml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'jde-mode group-java-other-lang-keywords t) ;append

(font-lock-add-keywords 'lisp-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'emacs-lisp-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'sql-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'typescript-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'csharp-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'powershell-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'haskell-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(if define-font-lock-org-todo-face
    (font-lock-add-keywords 'org-mode
                            (list
                             (cons "\\bTODO\\b:" ;Note REQUIRED colon after TODO.  Prevents bollixing up TODO keyword in
                                                 ;headlines.
                                   '(0 font-lock-org-todo-face t))))
  )

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
  "The user's preferred color scheme.  Should be one of 'light or 'dark.")

(require 'sh-script)
(if (boundp 'sh-heredoc-face)
(set-face-foreground sh-heredoc-face
                     (if (eq 'light preferred-background-mode)
                         (face-foreground font-lock-string-face)
                       )
                     )
		     )

(condition-case err
(setq default-frame-alist
      (append 
       (x-parse-geometry                ;Slightly in from top left.
        "80x48" 
        ;; "80x48+64+-1" 
        )

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
         (cursor-type . box)            ;NOTE: Not a string, but an atom (or a symbol?)
         ;; (cursor-in-non-selected-windows . box)  ; This apparently doesn't work.
         (cursor-color . "Red2")
         )
       ;; (list (cons 'font my-default-font))
       default-frame-alist)
      )
(error (message (format "Error: %s" (cdr err))))
)

(condition-case err
(setq initial-frame-alist
      (append (x-parse-geometry         ;Top right.
               "80x48"              
               ;;"80x48--4+-1"
               )                        
              nil                       ;In case the geometry above gets
                                        ;  commented out.
	      initial-frame-alist
	      )
      )
(error (message (format "Error: %s" (cdr err))))
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

;;---------------------------------  align  ----------------------------------

(defun align-repeat (start end regexp)
    "Repeat alignment with respect to 
     the given regular expression."
    (interactive "r\nsAlign regexp: ")
    (align-regexp start end 
        (concat "\\(\\s-*\\)" regexp) 1 1 t))

;; Some of the following code is for the older align.el, by Matthias Helmling.
;; Later emacsen seem to have acquired a similar capability having the same
;; name.

(require 'align)

;; (defun debug-align (msg matches)
;;   "Add to a string message for use in debugging an align rule."
;;   (if (null matches)
;;       msg
;;     (let* ((match-index (car matches))
;;           (new-msg (concat msg
;;                            (format "\n\t\\%d: pos %d-%d (\"%s\")"
;;                                    match-index
;;                                    (match-beginning match-index)
;;                                    (match-end match-index)
;;                                    (buffer-substring (match-beginning
;;                                                       match-index)
;;                                                      (match-end
;;                                                       match-index))
;;                                    )))
;;           )
;;       (debug-align new-msg (cdr matches))
;;       )
;;     )
;;   )
;; 
;; (defun faux-aligner (beg end mode)
;;   "For debugging use w/`align-region'.  If MODE is a rule (a list), return t
;; if BEG to END are to be searched.  Otherwise BEG to END will be a region of
;; text that matches the rule's definition, and MODE will be non-nil if any
;; changes are necessary."
;;   (cond ((listp mode)
;;          (message (format "faux-aligner list: region %d-%d, mode %S"
;;                           beg end (car mode)))
;;          t
;;          )
;;         (t
;;          (message (format "faux-aligner: region %S-%S, mode %S"
;;                           (marker-position beg)
;;                           (marker-position end)
;;                           mode))
;;          )
;;         )
;;   )
;; 
(if (not (member 'align features))
    (message "Warning:  feature `align' not loaded.")
  (setq align-c++-modes (cons 'jde-mode align-c++-modes))

                                        ; These func-call align rules require
                                        ; that the `exc-c-func-params'
                                        ; exclusion rule NOT be in play.  I
                                        ; had to comment it out of align.el.
  (setq align-rules-list
        (append
         (list
          `(sql                         ;text-column (q.v.)
            (regexp . "\\(^\\|\\S-\\)\\(\\s-+\\)\\(\\S-\\|$\\)")
            (group . 2)
            (repeat . t)
            (tab-stop . t)
            (modes . '(sql-mode))
            )
          )
         align-rules-list)
        )
  
  (setq align-to-tab-stop nil)
  )

;;-------------------------------  end align  --------------------------------


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

;;-----------------------  miscellaneous shell config  -----------------------

(if (member "/usr/local/bin" (split-string (getenv "PATH") ":"))
    nil
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  )

;; ;; ---------------------------  shelex  ---------------------------
;; ;; (for browse-url, among others)
;; 
;; (defvar shell-execute-helper "shelex.exe")
;; (defun shell-execute-url (url &optional new-window)
;;   "Invoke the shell-execute-helper program to call ShellExecute and
;; launch or re-direct a web browser on the specified url."
;;   (interactive "sURL: ")
;;   (call-process shell-execute-helper nil nil nil url))
;; 
;; (setq browse-url-browser-function 'shell-execute-url)
;; (setq gnus-button-url 'shell-execute-url)		; GNUS
;; (setq vm-url-browser 'shell-execute-url)		; VM

;; -------------------------  end shelex  -------------------------

;;------------------------------  frame sizing  ------------------------------

(defun reset-frame-width (width)
  "Set the current frame width in characters, and jam it against the right
side of the display."
  (set-frame-width (selected-frame) width)
  (set-frame-position (selected-frame)
                      (- (x-display-pixel-width)
                         (* width (frame-char-width))
                         40             ;scroll bar, window border fudge
                                        ;  factor
                         )
                      0)
  )

(defun wf ()
  "Make the current frame wide, for use in viewing code written by developers
who didn't feel the need to confine themselves to 80 characters."
  (interactive)
  (reset-frame-width 132)
  )

(defun nf ()
  "Make the current frame the ``standard'' size of 80 characters, which some
developers might consider narrow, after you've made it wide for some reason or
accidentally repositioned it, or whatever."
  (interactive)
  (reset-frame-width 80)
  )

;;----------------------------  end frame sizing  ----------------------------

;; ----------------------------  misc  ----------------------------

(setq auto-mode-alist
      (append (list '("\\.war$" . archive-mode)
                    )
              auto-mode-alist))

(make-variable-buffer-local 'auto-fill-inhibit-regexp)

(autoload 'hl7 "hl7" "Functions for working with HL7 messages" t)

(autoload 'hls "lusk-highlight" "Highlight a regexp" t)
(autoload 'hlc "lusk-highlight" "Clear highlighting set with `hls'" t)
(global-set-key [f3] 'hls)
(global-set-key [S-f3] 'hlc)

(setq archive-zip-use-pkzip nil)
;;; (mouse-avoidance-mode 'banish)

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

(defun canopy-copyright-statement (date)
  "Insert the Canopy Copyright statement using the year of the given date."
  (interactive "*")
  (concat
   "Copyright "
   (format-time-string "%Y" date)
   " A4 Health Systems, Inc. TM All rights reserved."
   ))

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

(defun insert-timestamp ()
  "Insert current date/time at point"
  (interactive)
  (insert (concat (format-time-string "%Y-%m-%d %H:%M:%S.%3N (%a) ") "-- "))
  )

(defun tm ()
  "Alias for `insert-timestamp'"
  (interactive)
  (insert-timestamp)
  )

					;Some key remappings
(global-set-key "\M-%" 'query-replace-regexp)
(global-set-key "\C-xl" 'goto-line)

(global-set-key [home] 'beginning-of-line)
(global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-line)
(global-set-key [C-end] 'end-of-buffer)

(global-set-key "\M-[" 'align)
(global-set-key "\M-]" 'align-repeat)

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
  (progn
    (read-abbrev-file "~/.abbrev_defs")
    (message "~/.abbrev_defs loaded")
    )
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
;;; 	 (from-dir "//remconsrv/peruse/usr/local/emacs/Site-lisp") ;Default value
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
;;; End:


