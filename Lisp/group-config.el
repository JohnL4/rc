;;; Emacs initialization/customization for the development group.
;;;
;;; $Header: v:/J80Lusk/CVSROOT/usr/local/emacsLisp/group-config.el,v 1.74 2004/05/05 12:04:36 j80lusk Exp $
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

;;--------------------------  reconfigurable items  --------------------------

(defvar author-short-name (user-login-name)
  "*The name you wish to use when identifying yourself as the author of a
document (or piece of code).  This could be your last name, your initials,
something fanciful or something totally random, whatever makes you happy.")

(defvar our-default-fill-column 120
  "*The default value for fill-column in new modes, for the group.")

;; (setq define-font-lock-org-todo-face nil)
(setq define-font-lock-org-todo-face t)

;;---------------------------------  paths  ----------------------------------

(setq load-path
      (fix-filesystem-paths
       (append
        (list
;;;         (concat group-emacs-directory
;;;                 "/usr/local/emacs/Add-ons/jde-"
;;;                 group-jde-version
;;;                 )
;;;         (concat group-emacs-directory
;;;                 "/usr/local/emacs/Add-ons/jde-"
;;;                 group-jde-version
;;;                 "/lisp"
;;;                 )

;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/common"
;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/cogre"
;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/contrib"
;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/ede"
;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/eieio"
;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/semantic"
;;;         "C:/usr/local/emacs/Add-ons/cedet-1.0beta3b/speedbar"

         "c:/usr/local/emacs/Add-ons/elib-1.0"
         "C:/usr/local/emacs/Add-ons/gnuserv"
         "c:/usr/local/emacs/Add-ons/psgml-1.2.4"
         ;;"c:/usr/local/emacs/Add-ons/nxml-mode-20031018"
         "c:/usr/local/share/emacs/site-lisp/org"
         )
        load-path)
       )
      )

(if (not (boundp 'Info-default-directory-list))
    (setq Info-default-directory-list nil)
  )

(setq Info-default-directory-list
      (append '(
                ;;"C:/usr/local/emacs/elisp-manual-21-2.8"
                ;;"C:/usr/local/emacs/Add-ons/elib-1.0" ;Required by JDE 2.3.3.
                ;;"C:/usr/local/emacs/Add-ons/psgml-1.2.4"
                "C:/usr/local/share/info"
                ;;"C:/usr/local/info"
                )
	      Info-default-directory-list))

;;--------------------------------  packages  --------------------------------

(require 'package)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t) ;For haskell-mode.
(package-initialize)

;;---------------------------------  fonts  ----------------------------------

                                        ;See function (set-default-font-w32), defined below.
					;Or use (insert (prin1-to-string (w32-select-font))) in *scratch* to get an
					;  actual font name string.
					;Or maybe: (set-default-font (w32-select-font))

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

      ;; Well... I tried.  It's a nice font, but 8-point is too light and 9-point is too big.
      ;; (if (and (member "IBM Plex Mono Medium" (font-family-list))
      ;;          (member "IBM Plex Mono Text" (font-family-list)))
      ;;     (setq my-default-font "IBM Plex Mono Text-8:medium")
      ;;   )
      
      (if (x-list-fonts "Source Code Pro-9")
          (setq my-default-font "Source Code Pro-9") ;https://github.com/adobe-fonts/source-code-pro; use the OpenType version.
        (setq my-default-font "Consolas-9") ;New with Windows 7 (and Vista?)
        )
      
                                        ;Could also try "Lucida Console-9" or "Courier New-9" or
                                        ;  "Lucida Sans Typewriter-9"

      ;; (setq my-default-font "-outline-Bitstream Vera Sans Mono-normal-r-normal-normal-11-82-96-96-c-*-iso10646-1")
      ;; (setq my-default-font "-outline-Bitstream Vera Sans Mono-normal-r-normal-normal-12-90-96-96-c-*-iso10646-1")
					;8- and 9-point courier:
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-12-90-96-96-c-*-iso8859-1")
      ;; (setq my-default-font "-*-Courier New-normal-r-*-*-11-82-96-96-c-*-iso8859-1") ;Previous default, before Consolas.
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

(if (not (null window-system))
    (progn
      (set-default-font my-default-font)

      ;; (make-face-italic 'italic)
      ;; (make-face-italic 'bold-italic)
      ;; (make-face-bold 'bold-italic)
;;;      (make-face-bold 'mode-line)

					;We seem to tickle a nasty emacs bug
					;  when we put this item in the
					;  default-frame-alist above, so we
					;  add it separately here, AFTER
					;  initial-frame-alist.

      (setq default-frame-alist
            (append (list (cons 'font my-default-font)) default-frame-alist))

					;List colors available with
					;  "ESC x list-colors-display".
      (set-face-inverse-video-p 'mode-line nil)
      (set-face-background 'mode-line
                           (if (eq 'dark preferred-background-mode)
                               "gainsboro"
                             "saddlebrown"
                             ))
      ;; (set-face-background 'mode-line "gainsboro")

                                        ;Mode-Line foreground is same as
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

      (set-face-background 'mode-line-inactive
                           "#DAAF91")   ;Version of SaddleBrown

                                        ; The "fringe" is the strips to the
                                        ;   left and right of the text area
                                        ;   that shows continuation lines.
      (set-face-background 'fringe
                           (if (eq 'dark preferred-background-mode)
                               "DarkSlateGray"
                             ;; "#254745"
                             "FloralWhite"
                             ;; "#E6E1B9"
                             ;; "#f7f3e9"  ;slightly darker shade of FloralWhite
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
    (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))
    
    ;; By default use the Windows HOME.
    ;; Otherwise, uncomment below to set a HOME
    ;;      (setenv "HOME" (concat cygwin-root "/home/eric"))
    
    ;; NT-emacs assumes a Windows shell. Change to baash.
    (setq shell-file-name "bash")
    (setenv "SHELL" shell-file-name) 
    (setq explicit-shell-file-name shell-file-name) 
    
    ;; This removes unsightly ^M characters that would otherwise
    ;; appear in the output of java applications.
    (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)))

;;------------------------------  cygwin ends  -------------------------------

;;--------------------------------  requires  --------------------------------

(require 'generic-util)
(require 'tabs-to-table)
(require 'edebug)			;LISP source-level debugging.
;;(require 'fix-pathnames)                ;For use in converting MS-style pathnames to Unix-style, for use w/Cygnus
                                        ;  utilities like diff(1).  Requires local mod to
                                        ;  ediff-diff.el::ediff-exec-process to transmogrify incoming list of pathname
                                        ;  args.  (Make copy in site-lisp.)

(defun group-jde-mode-hook ()
  ;; (message "jde-mode-hook defined in group-config.el section that requires jde.")
  (setq fill-column our-default-fill-column)
  (abbrev-mode 0)
  (setq adaptive-fill-mode nil)
  (setq jde-gen-cflow-enable nil)
  (modify-syntax-entry 95 "_")
  )

;;;(condition-case signaled-conditions
;;;    (progn
;;;      ;; (setq semantic-load-turn-fewer-useful-features-on t)
;;;
;;;      (setq chart-face-color-list
;;;            '("tomato"                  ;red
;;;              "dodger blue"             ;blue
;;;              "gold"                    ;yellow
;;;              "turquoise"               ;cyan
;;;              "orchid"                  ;purple
;;;              "medium sea green"        ;green
;;;              ))
;;;      ;; (setq jde-check-version-flag nil)
;;;      (require 'cedet)
;;;      (require 'semantic-sb)
;;;      (require 'jde)			;Java Development Environment
;;;      (if (not (featurep 'jde))
;;;          (message "Warning:  `jde' not loaded.")
;;;        (let*
;;;            (
;;;             (jde-extra-filename "jde-extra")
;;;             (jde-extra-location (locate-library jde-extra-filename))
;;;             )
;;;;;           (if (and (string= "2.1.5" jde-version)
;;;;;                    jde-extra-location)
;;;          (progn
;;;              (load-library jde-extra-filename) ;Customizations for Remote
;;;                                        ;Connect group.
;;;              (message (concat jde-extra-filename " loaded"))
;;;              )
;;;;;             (message (concat "Warning:  " jde-extra-filename " not loaded."))
;;;;;             )					
;;;          )
;;;        (setq jdex-package "")
;;;        (add-hook 'jde-mode-hook 'group-jde-mode-hook)
;;;        )
;;;      )
;;;  (error (message (format "Error occurred loading jde, error was:\n\t%S"
;;;                          signaled-conditions))
;;;         (if (and (eq 'file-error (car signaled-conditions))
;;;                  (string= "Cannot open load file" (cadr
;;;                                                    signaled-conditions)))
;;;             (message (format "load-path: %S" load-path))
;;;           )
;;;         )
;;;  )

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

;;; (require 'gnuserv)			;Enables external requests to
					;  edit files.
;;; (gnuserv-start)
(server-start)

(require 'comment-indent)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;------------------------------  end requires  ------------------------------

;;=================================  modes  ==================================
				
(setq default-major-mode 'text-mode)

;; Don't need a separate function for a one-liner.
;;;(defun subword-mode-on ()
;;;  "Turn on `subword-mode'"
;;;  (subword-mode 1)
;;;  )

(add-hook 'graphviz-dot-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq graphviz-dot-preview-extension "svg")
            )
          )

;;----------------------------------------------------  typescript  ----------------------------------------------------

(add-hook 'typescript-mode-hook
          (lambda ()
;;;            (message "typescript-mode-hook running...")
;;;            (message (format "\ttypescript-mode-hook: buffer-narrowed-p: %s" (buffer-narrowed-p)))
;;;            (message (format "\ttypescript-mode-hook: Major mode: %s" major-mode))
;;;            (message (format "\ttypescript-mode-hook: org-src-mode: %s" org-src-mode))
;;;            (if (not (symbolp 'buffer-file-name))
;;;                (message "\ttypescript-mode-hook: buffer-file-name not a symbol")
;;;              (if (not (functionp 'buffer-file-name))
;;;                  (message "\ttypescript-mode-hook: buffer-file-name not a function")
;;;                (if (null (buffer-file-name))
;;;                    (message "\ttypescript-mode-hook: buffer-file-name is null")
;;;                  (message (format "\ttypescript-mode-hook: file-name-extension: %s" (downcase (file-name-extension (buffer-file-name)))))
;;;                )))
;;;            (message "\ttypescript-mode-hook: checking...")
            (if (or (buffer-narrowed-p)
                    (equal 'org-mode major-mode)
                    org-src-mode
                    (null (buffer-file-name))
                    (not (string= "ts" (downcase (file-name-extension (buffer-file-name)))))
                    )
                nil; (message "\ttypescript-mode-hook: Skipping tide setup.")
;;;              (message "\ttypescript-mode-hook: Continuining with tide-setup...")
              (tide-setup)
              (flycheck-mode +1)
              (eldoc-mode +1)
              (local-set-key (kbd "<f2> r") 'tide-rename-symbol)
              (local-set-key (kbd "S-<f12>") 'tide-references)
              )
            (company-mode +1)
            (subword-mode 1)
            (setq fill-column our-default-fill-column)
            (local-set-key "\C-j" 'newline)
            (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
            (local-set-key "\M-o" 'one-line-section-break)
;;;            (message "\ttypescript-mode-hook: Typescript mode set up for current buffer")
            ))

;; Note that the following don't work for me when set inside the mode hook.  Don't know why.
(setq typescript-indent-level 4)
(setq tide-format-options '(:placeOpenBraceOnNewLineForFunctions t :placeOpenBraceOnNewLineForControlBlocks t))

(setq company-tooltip-align-annotations t)

;;-------------------------------------------------------  mmm  --------------------------------------------------------

(require 'mmm-mode)
(when (featurep 'mmm-mode)
  (setq mmm-global-mode 'maybe)
  (add-hook 'haskell-mode-hook 'my-mmm-mode)
  (mmm-add-classes
   '((literate-haskell-bird
      :submode indented-text-mode
      :front "^[^>]"
      :include-front true
      :back "^>"
      ;;:creation-hook (lambda () (message (format "submode region created at %d" (point))))
      )
     (literate-haskell-latex
      :submode literate-haskell-mode
      :front "^\\\\begin{code}"
      :front-offset (end-of-line 1)
      :back "^\\\\end{code}"
      :include-back nil
      :back-offset (beginning-of-line -1)
      )))
  ;;(setq mmm-submode-decoration-level 1)
  (mmm-add-mode-ext-class 'literate-haskell-mode "\\.lhs$" 'literate-haskell-bird)
  )

(defun my-mmm-mode ()
  ;; go into mmm minor mode when class is given
  (make-local-variable 'mmm-global-mode)
  (setq mmm-global-mode 'true))


;;--------------------------------  haskell  ---------------------------------

(ignore-errors
;; (require 'haskell-mode)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

                                        ;Use only one indentation mode.
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook (lambda () (subword-mode 1)))
  (eval-after-load "haskell-mode"
    '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))
)

;;---------------------------------  csharp  ---------------------------------

(ignore-errors
(require 'csharp-mode)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

(defun my-csharp-mode-fn ()
      "function that runs when csharp-mode is initialized for a buffer."
      (setq fill-column our-default-fill-column)
      ;; (c-set-style "bsd")               ;Indentation; could also use M-x c-guess to guess indentation
      (local-set-key "\C-j" 'newline)
      (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
      (local-set-key "\M-o" 'section-break)
      (subword-mode 1)                  ;Case-change == word boundary
      )
(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)
)

;;----------------------------------  calc  ----------------------------------

(require 'calc-mode)
(if (member 'calc-mode features)
    (progn
      ;;(setq calc-gnuplot-name "wgnuplot.exe")
      )
  )

;;-------------------------------  PowerShell  -------------------------------

(autoload 'powershell-mode "powershell-mode" "Microsoft PowerShell mode." t)
(setq auto-mode-alist (append '(("\\.ps1$" . powershell-mode))
                              auto-mode-alist))
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
            (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
            (local-set-key "\M-o" 'one-line-section-break)
            (subword-mode 1)
            ))

;;---------------------------------  VB.NET  ---------------------------------

(autoload 'vbnet-mode "vbnet-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vb\\)$" .
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

;;(require 'python-mode) ;Apparently, it's automatic by the time of emacs 26.3.

(defun group-python-mode-hook ()
  (my-fill-mode)			;Auto Word-wrap
  (local-set-key "\M-o" 'one-line-section-break)
  (setq fill-column our-default-fill-column)
  (subword-mode 1)
  )

(if (member 'python-mode features)
    (progn
      (setq auto-mode-alist
            (append (list '("\\.py$" . python-mode))
                    auto-mode-alist))
      )
  )

(add-hook 'python-mode-hook 'group-python-mode-hook)

;;---------------------------------  psgml  ----------------------------------

;;(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
;;(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
(setq sgml-catalog-files '("c:/usr/local/lib/sgml/catalog"))

;;----------------------------------  sgml  ----------------------------------

(ignore-errors
  (require 'sgml)
  (require 'psgml)

  (setq sgml-markup-faces
        (mapcar (lambda (x)
                  (if (or (equal 'start-tag (car x))
                          (equal 'end-tag (car x)))
                      nil
                    x))
                sgml-markup-faces)
        )

  (defun group-psgml-mode-hook ()
    (message "Running group-psgml-mode-hook")
    (font-lock-mode 1)
    (setq sgml-set-face t)
;;;   (if (and (boundp 'uses-javaserver-faces)
;;;            uses-javaserver-faces
;;;            )
;;;       (progn
    (setq comment-start "<%-- ")
    (setq comment-start-skip "<%-- *")
    (setq comment-end " --%>")
;;;         )
;;;     (setq comment-start "<!-- ")
;;;     (setq comment-start-skip "<!-- *")
;;;     (setq comment-end " -->")
;;;     )
    (setq comment-multi-line nil)
    (setq comment-column 32)
    (setq indent-line-function 'indent-relative-maybe)
    )

  (add-hook 'sgml-mode-hook 'group-psgml-mode-hook)
  )

;;----------------------------------  html  ----------------------------------

(setq html-mode-hook
      '(lambda ()
         (auto-fill-mode 1)
         (show-paren-mode 1)
         (abbrev-mode 1)
         (local-set-key "\C-j" 'newline)
         (local-set-key "\C-m" 'newline-and-indent)
         (local-set-key "\M-o" 'comment)
         (local-set-key [C-tab] 'indent-relative)
         (local-set-key [C-return] 'newline-and-indent-relative)
         (setq comment-start "<!-- ")
         (setq comment-start-skip "<!-- *")
         (setq comment-end " -->")
         (setq comment-multi-line nil)
         (setq comment-column 32)
         )
      )

;;----------------------------------  nxml  ----------------------------------

(setq auto-mode-alist
      (append (list '("\\.xml$" . nxml-mode))
              auto-mode-alist))

(add-hook 'nxml-mode-hook
          (lambda ()
            (setq comment-start "<!-- ")
            (setq comment-end " -->")
            (setq comment-start-skip "\\(<!-- \\s-+\\)")
            (set-face-foreground 'nxml-attribute-local-name
                                 (face-foreground 'font-lock-string-face))
            (set-face-foreground 'nxml-attribute-value
                                 (cdr (assoc 'foreground-color (frame-parameters))))
            ))

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
             (setq ml-mode 'nxml-mode))
            ((null xhtml-locn)
             (setq ml-mode 'sgml-mode))
            ((< xhtml-locn html-locn)
             (setq ml-mode 'nxml-mode))
            (t
             (setq ml-mode 'sgml-mode))
            )
      )
    (multi-mode 1
                ml-mode
                `("<%!" jde-mode)
                `("%>" ,ml-mode)
                `("<script" c++-mode)
                `("<SCRIPT" c++-mode)
                `("</script" ,ml-mode)
                `("</SCRIPT" ,ml-mode)
                )
    )
  )

(setq auto-mode-alist
      (append (list '("\\.jsp$" . jsp-mode)
                    '("\\.jspf$" . jsp-mode)
                    '("\\.jsptemplate$" . jsp-mode)
                    '("\\.html?$" . jsp-mode)
                    '("\\.sql8$" . sql-mode)
                    '("\\.prc$" . sql-mode)
                    '("\\.tab$" . sql-mode)
                    '("\\.xsl$" . nxml-mode)
                    '("\\.xsp$" . nxml-mode)
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
               ;; (c-block-comment-prefix . "*")
               ))

(require 'filladapt)
                                        ;Suggested by cc-mode home page, for
                                        ;cc-mode 5.30.9.
(defun my-c-mode-common-hook ()
  (c-setup-filladapt)
  (filladapt-mode 1)
  (subword-mode 1)
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
  (c-set-offset 'comment-intro 'c-lineup-comment-unless-on-far-right)
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
  (c-set-offset 'comment-intro 'c-lineup-comment-unless-on-far-right)

  (setq c-tab-always-indent nil)
  (my-fill-mode)			;Auto Word-wrap
  (make-variable-buffer-local 'comment-padding)
  (setq comment-padding nil)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'section-break)

					;Change behavior of electric braces.

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
                                        ;NOTE: c-indent stuff doesn't work.
                                        ;  Use perl-indent variables if you
                                        ;  want to change anything.

  (make-variable-buffer-local 'comment-multi-line)
  (setq comment-multi-line nil)
  (setq fill-column our-default-fill-column)
  (my-fill-mode)			;Auto Word-wrap
  
  (local-set-key "\C-j" 'newline)
  (local-set-key "\r" 'newline-and-indent) ;Auto-indent.
  (local-set-key "\M-o" 'section-break)
  (local-set-key "\M-]" 'complete-tag)
  )

(add-hook 'perl-mode-hook 'group-perl-mode-hook)

;;-------------------------------  javascript  -------------------------------

(require 'generic-x)
;;; (add-to-list 'generic-extras-enable-list 'javascript-generic-mode)

;;; (autoload 'javascript-mode
;;;   "javascript-mode"
;;; ;;;   "javascript-cust"
;;;   "JavaScript mode"
;;;   t nil)
;;; 
;;; (setq auto-mode-alist
;;;       (append '(("\\.js$" . javascript-mode))
;;;               auto-mode-alist))

;;; (setq auto-mode-alist
;;;       (append (list '("\\.js$" . c++-mode)
;;;                     )
;;;               auto-mode-alist))

(add-hook 'js-mode-hook (lambda ()
                          (subword-mode 1)
                          (company-mode 1)
                          (local-set-key "\M-o" 'one-line-section-break)
                          (setq fill-column 120)
                          ))

;;----------------------------------  text  ----------------------------------

(defun group-text-mode-hook ()
  ;;(my-fill-mode)
  (visual-line-mode)
  (column-number-mode 1)
  (local-set-key "\C-j" 'newline)
  (local-set-key "\C-m" 'newline-and-indent) ;Auto-indent.
  ;;(local-set-key "\M-o" 'one-line-section-break)
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

         ;; Change:  A (green)   --> B
         ;;          B (yellow)  --> C
         ;;          C (pink)    --> A

	 (set-face-foreground ediff-current-diff-face-B "black")
	 ;; (set-face-background ediff-current-diff-face-B "PaleGreen")
         (set-face-background ediff-current-diff-face-B "#befbbe")
	 (set-face-foreground ediff-current-diff-face-A "black")
	 (set-face-background ediff-current-diff-face-A "#ffd6d6")
	     
	     
	 (set-face-foreground ediff-fine-diff-face-B "black")
	 (set-face-background ediff-fine-diff-face-B "#8be48b")
	 ;;(set-face-background ediff-fine-diff-face-B "LimeGreen")
	     
	 (set-face-foreground ediff-current-diff-face-C "black")
	 ;;(set-face-background ediff-current-diff-face-C "#ffff9e")
	 (set-face-background ediff-current-diff-face-C "#ffffbb")
	 ;;(set-face-background ediff-current-diff-face-C "yellow")
	     
	 (set-face-foreground ediff-fine-diff-face-C "black")
	 (set-face-background ediff-fine-diff-face-C "#e0e08a")
	     
	 (set-face-foreground ediff-fine-diff-face-A "black")
	 (set-face-background ediff-fine-diff-face-A "#e8b5b5")
	     
         (set-face-foreground ediff-current-diff-face-Ancestor "black")
         (set-face-background ediff-current-diff-face-Ancestor "SkyBlue1")

;;;	 (setq ediff-combination-pattern
;;;	       '("<<<<<<<<"
;;;		 "========"
;;;		 ">>>>>>>>"
;;;		 )
;;;	       )
	     
	 ;; (setq ediff-narrow-control-frame-leftward-shift 65)
	 ;; (setq ediff-narrow-control-frame-leftward-shift 134)

         ;; Comment out because the home two-monitor setup (on the Allscripts work laptop) doesn't work well.
;;;         (setq ediff-narrow-control-frame-leftward-shift 0)
;;;	 (setq ediff-wide-control-frame-rightward-shift 0)
;;;	 (setq ediff-control-frame-upward-shift -1100)
	     
         (setenv "CYGWIN" "nodosfilewarning")
	 ;; (setq ediff-diff-program "c:/cygwin64/bin/diff")
	 ;; (setq ediff-diff3-program "c:/cygwin64/bin/diff3")
         (if (boundp 'ediff-diff-options)
             (if (string-match "-dw\\b" ediff-diff-options)
                 nil
               (setq ediff-diff-options (concat ediff-diff-options " -dw")))
           (setq ediff-diff-options "-dw")
           )

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

;;--------------------------------------------------  plantuml-mode  ---------------------------------------------------

(with-demoted-errors "Error (ignored): %S"
  (if (featurep 'plantuml-mode)
      (progn
        (add-hook 'plantuml-mode-hook
                  (lambda ()
                    (setq tab-width 4)
                    (setq indent-tabs-mode nil)
                    ))
        )
    )
  )

;;----------------------------------  org-mode  -----------------------------------

;; (setq org-list-allow-alphabetical t)     ;Must be set before loading org.

(with-demoted-errors "ERROR: %S"
  ;; (require 'org-install)
  (require 'org)
  ;; (require 'ox-hugo)
  ;; (require 'ox-hugo-auto-export)
  (require 'ox-md)
  (require 'ox-org)                     ;Export /subsets/ of org files to .org.
  (require 'ox-reveal)                  ;Export to reveal.js presentation
  (require 'ox-twbs)                    ;Export to Twitter Bootstrap (i.e., just "Bootstrap")

  (require 'org-projects)
  )

(if (member 'org features)
    (progn
      ;; The following lines are always needed.  Choose your own keys.
      (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
      ;; (add-to-list 'auto-mode-alist '("\\.org\\.txt$" . org-mode))
      (global-set-key "\C-cl" 'org-store-link)
      (global-set-key "\C-cc" 'org-capture)
      (global-set-key "\C-ca" 'org-agenda)
      (global-set-key "\C-cb" 'org-iswitchb)

      (setq org-agenda-files "~/org/org-agendas.txt")

      (setq org-export-headline-levels 12)

      (org-babel-do-load-languages
       'org-babel-load-languages
       '((plantuml . t)))               ; this line activates dot

      ;;-----------------------------------------------  export plugins  -----------------------------------------------

      (if (member 'ox-reveal features)
          (progn
            (setq org-reveal-root "file:///c:/usr/local/Reveal")
            )
        )
      (if (member 'ox-twbs features)
          (progn
            )
        )
      (if (member 'ox-hugo features)
          (progn
            (setq org-hugo-default-section-directory "org-mode")
            )
        )

      ;;---------------------------------------------  end export plugins  ---------------------------------------------
      
      (defun my-org-confirm-babel-evaluate (lang body)
        (not (string= lang "plantuml")))  ; don't ask for Plantuml
      (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

      (add-hook 'org-mode-hook 'turn-on-font-lock)  ; org-mode buffers only
      (add-hook 'org-mode-hook
                (lambda ()
                  (auto-fill-mode 1)
                  (transient-mark-mode 1)
                  (abbrev-mode 1)
                  (setq comment-start "#+ ")
                  (setq comment-start-skip "#\\++\\s-*")
                  (setq comment-column 32)
                  (subword-mode 1)
                  ))

      ;; I didn't really find auto-generation-and-display useful, for two reasons:
      ;; (1) It's really too slow.  An extra second or two waiting for even a trivial a save to finish, plus an extra
      ;;     second or two (or quite a bit more, depending on how "smart" the browser is about issuing requests to the
      ;;     actual server when the server's been returning 304s for the last ten minutes) is too long to wait, really.
      ;; (2) I'm concerned about accidentally deploying HTML with an embedded reference to live.js.
      ;; 
      ;; (add-hook 'org-mode-hook
      ;;           (lambda ()
      ;;             (add-hook 'after-save-hook 'org-html-export-to-html nil t)
      ;;             ))

      (setq org-log-done 'note)                     ;time or note -- note to
                                                    ;    be prompted for a closing note.

      (setq org-todo-keywords
            ;; Spelling note: "canceled" with one or two Ls are both correct, but one L is more American and two, more British.
            '((sequence "TODO(t)" "IN-PROGRESS(i)" "HOLD(h@)" "|" "DONE(d)" "CANCELED(k)")
              (sequence "RESEARCH-TODO(r)" "RESEARCH-IN-PROGRESS(s)" "RESEARCH-HOLD(w@)" "|" "RESEARCH-DONE(u)" "RESEARCH-CANCELED(z)")
              (sequence "CODE-TODO(c)" "CODE-IN-PROGRESS(e)" "CODE-HOLD(p@)" "|" "CODE-DONE(f)" "CODE-CANCELED(q)")
              ))

     (setq org-clock-persist t)
     (org-clock-persistence-insinuate)

      ;;---------------------------------------------------  faces  ----------------------------------------------------

      (defface org-in-progress
        (org-compatible-face nil
          '(
            ;;(((class color) (min-colors 16) (background light)) (:foreground "DarkOrange3" :bold t))
            ;;(((class color) (min-colors 16) (background light)) (:foreground "DarkOrchid3" :bold t))
            ;;(((class color) (min-colors 16) (background dark))  (:foreground "DarkOrange2" :bold t))
            (((class color) (min-colors 16) (background light)) (:foreground "magenta" :bold t))
            (((class color) (min-colors 16) (background dark))  (:foreground "DarkOrchid1" :bold t))
            (((class color) (min-colors 8)  (background light)) (:foreground "magenta"  :bold t))
            (((class color) (min-colors 8)  (background dark))  (:foreground "magenta"  :bold t))
            (t (:inverse-video t :bold t))))
        "Face for IN-PROGRESS keywords."
        :group 'org-faces)
      (defface org-hold
        (org-compatible-face nil
          '(
            (((class color) (min-colors 16) (background light)) (:foreground "Maroon" :bold t))
            (((class color) (min-colors 16) (background dark))  (:foreground "IndianRed" :bold t))
            (((class color) (min-colors 8)  (background light)) (:foreground "DarkRed"  :bold t))
            (((class color) (min-colors 8)  (background dark))  (:foreground "Red"  :bold t))
            (t (:inverse-video t :bold t))))
        "Face for HOLD keywords."
        :group 'org-faces
        )
      (defface org-canceled
        (org-compatible-face nil
          '(
            ;; (((class color) (min-colors 8) (background light)) (:foreground "Black" :bold nil))
            (t (:inverse-video nil :bold nil))))
        "Face for CANCELED keywords"
        :group 'org-faces)
      (set-face-foreground 'org-table "Blue4")
      (set-face-foreground 'org-verbatim "Blue4")
      (if (boundp 'my-default-font)
          (set-face-font 'org-column my-default-font)
      )
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
              ("CANCELED" . org-canceled)
              ("HOLD" . org-hold)
              ("RESEARCH-HOLD" . org-hold)
              ("RESEARCH-CANCELED" . org-canceled)
              ("CODE-HOLD" . org-hold)
              ("RESEARCH-CANCELED" . org-canceled)
              ))

      ;; The following seems to muck up org-mode's headline fontification:
      ;; The words get fontified, but then, after them, the rest of the
      ;; headline's fontification is apparently completely missing (although
      ;; the "fontified" property on that text is t).
;;;      (font-lock-add-keywords 'org-mode
;;;                        (list
;;;                         (cons "\\bTODO\\b:?" '(0 'org-todo keep))
;;;                         (cons "\\bDONE\\b:?" '(0 'org-done keep))
;;;                         ))


      ;;-------------------------------------------------  end faces  --------------------------------------------------
      
      ;(setq org-export-html-style-include-default nil) ;Turn off hardcoded
                                        ;default in org-mode in favor of style
                                        ;declared below. (TODO: is this even still used?)

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

;;;(require 'jde-java-font-lock)           ;Slurp in face definitions so we can
;;;                                        ;modify some of 'em.
;;;(set-face-foreground 'jde-java-font-lock-number-face "OrangeRed")

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
;;;(font-lock-add-keywords 'jde-mode group-extra-keyword-list t) ;append
(font-lock-add-keywords 'js-mode group-extra-keyword-list)
(font-lock-add-keywords 'typescript-mode group-extra-keyword-list)

(font-lock-add-keywords 'java-mode group-java-other-lang-keywords)
(font-lock-add-keywords 'html-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'sgml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'xml-mode group-html-other-lang-keywords)
(font-lock-add-keywords 'nxml-mode group-html-other-lang-keywords)
;;;(font-lock-add-keywords 'jde-mode group-java-other-lang-keywords t) ;append

(font-lock-add-keywords 'lisp-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'emacs-lisp-mode
                        (list
                         (cons "\\bTODO\\b:?" '(0 font-lock-todo-face t))))
(font-lock-add-keywords 'sql-mode
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
(font-lock-add-keywords 'python-mode
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
         (cursor-type . box)            ;NOTE: Not a string, but an atom (or a symbol?)
         ;; (cursor-in-non-selected-windows . box)  ; This apparently doesn't work.
         (cursor-color . "Red2")
         )
       ;; (list (cons 'font my-default-font))
       default-frame-alist)
      )

(setq initial-frame-alist
      (append (x-parse-geometry "80x48--4+-1") ;Top right.
              nil                       ;In case the geometry above gets
                                        ;  commented out.
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

;;---------------------------------  align  ----------------------------------

(defun align-repeat (start end regexp)
    "Repeat alignment with respect to 
     the given regular expression."
    (interactive "r\nsAlign regexp (default \\S-+): ")
    (if (or (string= "" regexp) (not regexp))
        (setq regexp "\\S-+"))
    (align-regexp start end 
        (concat "\\(\\s-+\\)" regexp) 1 1 t))

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
;;   (setq align-c++-modes (cons 'jde-mode align-c++-modes))
;; 
;;                                         ; These func-call align rules require
;;                                         ; that the `exc-c-func-params'
;;                                         ; exclusion rule NOT be in play.  I
;;                                         ; had to comment it out of align.el.
;;   (setq align-exclude-rules-list
;;         (append
;;          (list
;;           '(sql
;;             (regexp . "\\(^\\s-*\\)")
;;             (modes . '(sql-mode))
;;             )
;;           '(sql-comment
;;             (regexp . "\\(\\s-*--.*\\)")
;;             (modes . '(sql-mode))
;;             )
;;           )
;;          align-exclude-rules-list))
;;   
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
;;           `(wiki-table
;;             (regexp . "|?  *[^| ]*\\(  *\\)|")
;;             (valid . (lambda ()
;;                        (save-excursion
;;                          (beginning-of-line)
;;                          (looking-at "^|.*|$")
;;                          )))
;;             (repeat . t)
;;             (modes . '(text-mode))
;;             )
;;           `(func-call-first-parm
;;             (regexp . "\\(\\(\\sw\\|\\s_\\)+\\)\\s-*(\\(\\s-*\\)\\(\\(\\sw\\|\\s_\\)+\\).*)")
;;             (group  . 3)
;;             ;; (repeat . t)
;;             (modes  . align-c++-modes)
;; ;;;                (valid  . (lambda ()
;; ;;;                            (message (debug-align
;; ;;;                                      "align rule `func-call-first-parm' matched"
;; ;;;                                      '(0 1 3 4)))
;; ;;;                            t
;; ;;;                            ))
;;             )
;; ;;;          `(func-call-other-parms
;; ;;;            (regexp . "\\(\\sw\\|\\s_\\)+\\s-*(.*,\\(\\s-*\\).*)")
;; ;;;            (group  . 2)
;; ;;;            (repeat . t)
;; ;;;            (modes  . align-c++-modes)
;; ;;;                (valid  . (lambda ()
;; ;;;                            (message (debug-align
;; ;;;                                      "align rule `func-call-other-parms' matched"
;; ;;;                                      '(0 1 2)))
;; ;;;                            t
;; ;;;                            ))
;; ;;;            )
          )
         align-rules-list)
        )
  
;;   (setq align-to-tab-stop nil)
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

;;-------------------------  end Visual SourceSafe  --------------------------

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
                      (- (cadr (cdr (cdr (car (car (display-monitor-attributes-list)))))) ; was: (x-display-pixel-width)
                         (* width (frame-char-width))
                         45             ;scroll bar, window border fudge factor (Windows 10, Lenovo T480, Dell 2709W).
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

;;----------------------------------  wiki  ----------------------------------

(defun wiki-comment ()
  "Insert an empty comment into a wiki page at point."
  (interactive)
  (if (not (bolp))
      (forward-line))
  (beginning-of-line)
  (open-line 3)
  (insert-string "<blockquote><em>")
  (forward-line 2)
  (insert-string "</em></blockquote>")
  (forward-line -1)                     ;backwards :)
  )

(defun wc ()
  (interactive)
  (wiki-comment)
  )

;;--------------------------------  end wiki  --------------------------------

;; ----------------------------  misc  ----------------------------

(setq auto-mode-alist
      (append (list '("\\.war$" . archive-mode)
                    )
              auto-mode-alist))

(make-variable-buffer-local 'auto-fill-inhibit-regexp)

(autoload 'hl7 "hl7" "Functions for working with HL7 messages" t)

(autoload 'hls "highlight" "Highlight a regexp" t)
(autoload 'hlc "highlight" "Clear highlighting set with `hls'" t)
(global-set-key [f3] 'hls)
(global-set-key [S-f3] 'hlc)

(setq archive-zip-use-pkzip nil)
;;; (mouse-avoidance-mode 'banish)

                                        ;Coding system shortcuts

(defun canopy-copyright-statement (date)
  "Insert the Canopy Copyright statement using the year of the given date."
  (interactive "*")
  (concat
   "Copyright "
   (format-time-string "%Y" date)
   " A4 Health Systems, Inc. TM All rights reserved."
   ))

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
          (let ((current-font (if (boundp 'default-frame-alist)
                                (cdr (assq 'font default-frame-alist))
                              (if (boundp 'my-default-font) my-default-font
                                nil))))
               (message (format "Changing frame default font from %s to %s"
                                (prin1-to-string current-font) (prin1-to-string font)))
               (set-default-font font)
               ))
      )
    )
  )

(defun unix ()
  "Alias for `coding-system-argument'"
  (interactive)
  (coding-system-argument 'latin-1-unix)
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
