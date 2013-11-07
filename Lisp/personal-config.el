;;; Personal config, as opposed to group config.
;;;
;;; $Header: v:/J80Lusk/CVSROOT/usr/local/emacsLisp/personal-config.el,v 1.29 2003/10/30 13:49:42 J80Lusk Exp $

;;-------------------------  Configurable variables  -------------------------

(set-default 'author-short-name "Lusk")
(set-default 'jdex-package-root-dir
             "e:/Work/Canopy/.*/CanopyIA/Source")

;; (set-default 'jdex-package "com.ibm.RemoteConnect.ServiceAgent")

;;---------------------------------  paths  ----------------------------------

(setq load-path
      (fix-filesystem-paths
       (append
        '(
          "C:/usr/Local/Lib"		;Machine-specific.
          ;; "c:/usr/local/emacs/Add-ons/w3-4.0pre.39/lisp"
          "c:/usr/local/emacs/Add-ons/ep3m-097"
          ;; "c:/usr/local/emacs/Add-ons/elib-1.0" ;Added in group-config.el
          "c:/usr/local/emacs/Add-ons/mailcrypt-3.5.8"
          )
        load-path)
       )
      )

(setq Info-default-directory-list
      (append
       '(
	 "~/Info"
	 "C:/Local/Info"
	 "C:/usr/local/emacs/Info/"
	 ;; "C:/usr/local/emacs/Add-ons/w3-4.0pre.39/texi"
	 ;; "C:/usr/local/emacs/Add-ons/elib-1.0" ;Added in group-cnfig.el
         "C:/usr/local/emacs/Add-ons/mailcrypt-3.5.8"
	 )
       Info-default-directory-list
       )
      )

;;----------------------------  requires  ----------------------------

;;; (if (locate-library "w3-auto")
;;;     (require 'w3-auto)
;;;   (message "personal-config: Warning: w3-auto not loaded.")
;;;   )

(require 'bookmark+)
(if (featurep 'bookmark+)
    (progn
      ;;(setq bmkp-light-style-autonamed 'lfringe)
      ;;(setq bmkp-light-style-non-autonamed 'lfringe)
      ))

;;------------------------------  text cursor  -------------------------------

;; (require 'cursor-chg)  ; Load the library
;; (if (featurep 'cursor-chg)
;;     (progn
;;       (toggle-cursor-type-when-idle 1) ; Turn on cursor change when Emacs is idle
;;       (change-cursor-mode 1) ; Turn on change for overwrite, read-only, and input mode
;;       ))

;;---------------------------------  mouse  ----------------------------------

;;; (require 'mouse)
;;; 
;;;                                         ;Hacks for two-button mouse.  :(
;;;                                         ;Button 2 is the middle button, which
;;;                                         ;is missing on a two-button mouse.
;;; 
;;; (global-set-key [mouse-3]	'mouse-yank-at-click)
;;; (global-set-key [S-mouse-3]	'mouse-save-then-kill)
;;; 
;;; (global-set-key [mode-line mouse-3] 'mouse-delete-other-windows)
;;; (global-set-key [mode-line C-mouse-3] 'mouse-split-window-horizontally)
;;; (global-set-key [vertical-scroll-bar C-mouse-3] 'mouse-split-window-vertically)
;;; (global-set-key [vertical-line C-mouse-3] 'mouse-split-window-vertically)
;;; (global-set-key [mode-line S-mouse-3] 'mouse-delete-window)
;;; 
;;; (require 'compile)
;;; 
;;; (define-key compilation-minor-mode-map [mouse-3] 'compile-mouse-goto-error)

;;-------------------------------  end mouse  --------------------------------

;; ----------------------------  mail  ----------------------------
;; Also used when posting news articles via "gnus".

;;;(setq system-name "jl_spambucket-yahoo.com") ;To spoof message-make-message-id
                                             ;and message-make-sender
                                             ;into making something other than
                                             ;"localhost@localdomain" or
                                             ;revealing my true identity and
                                             ;machine name (for security).
(setq user-login-name "somePerson")     ;Spoofing for security (see above).

;;; 					;Sending...
;;; 
;;; (setq smtpmail-default-smtp-server "raleigh.ibm.com")
;;; (setq smtpmail-local-domain nil)
;;; (setq send-mail-function 'smtpmail-send-it)
;;; 
;;; (load-library "smtpmail")		;Must be loaded *after* above
;;; 					;  variables are set.
;;; 

(setq mail-user-agent 'gnus-user-agent)

                                        ;USERNAME -- MS-Windows
                                        ;USER -- Unix

(if (or (and (getenv "USERNAME") (string-match "[Ll]usk\\|^j6l$"
                                               (getenv "USERNAME")))
        (and (getenv "USER") (string-match "john" (getenv "USER")))
        )
    (progn

      (setq user-full-name "John Lusk")

                                        ;For people I trust not to spam me or
                                        ;  get my name on a spammer's list.
      (setq real-user-mail-address "john-emacs-work@how-hard-can-it-be.com")
      ;; (setq real-user-mail-address "john.lusk@canopysystems.com")

					;Public address is for those
					;  situations in which I'm worried
                                        ;  about getting spammed.
      (setq public-user-mail-address "john-public@how-hard-can-it-be.com")

      (setq user-mail-address public-user-mail-address)

                                        ;A signature to be attached to
					;  Usenet postings warning
					;  people about my public
					;  email address.
      (setq public-sig-file "~/.sig.public") 
      ))

(if (boundp 'real-user-mail-address)
    (defun real-user-mail-address ()
      "Function to return the ``real'' user mail address, for use by
`message-required-mail-headers'."
      real-user-mail-address
      ))

;; --------------------------  end mail  --------------------------

;;------------------------------  gnus  ------------------------------

;; See ~/.gnus.el

;;----------------------------  end gnus  ----------------------------

;;-------------------------------  mailcrypt  --------------------------------

(require 'mailcrypt)
(mc-setversion "gpg")
(setq mc-gpg-user-id "john-gpg@ahnlusk.net")
(setq mc-passwd-timeout 1800)
(require 'mc-gpg-file-mode)

;;-----------------------------  end mailcrypt  ------------------------------
			       
;;-------------------------------  supercite  --------------------------------

					;Following two lines are
					;required setup.
(autoload 'sc-cite-original "supercite" "Supercite" t)
(autoload 'sc-submit-bug-report "supercite" "Supercite" t)

(add-hook 'mail-citation-hook 'sc-cite-original)

					;[Do not] auto-fill yanked
					;material
(setq sc-auto-fill-region-p nil)
(setq sc-fixup-whitespace-p nil)

(setq sc-preferred-attribution-list
      '("sc-lastchoice" "x-attribution" "firstname" "emailname"))

(setq sc-citation-leader "  ")
;; (setq sc-citation-delimiter-regexp "\\([]>}]+ ?\\)+") ;Deleted an "="
						      ;sign.

;; (setq sc-citation-root-regexp "[-._a-z]") ;Default value.  Do
					;not change, but copy.
;; (setq sc-citation-nonnested-root-regexp "[-._a-z]") ;Remember to
					;change both root-regexps in
					;parallel.

(setq sc-preferred-header-style 4)
					;Don't show me a sample
					;header, just do it.
(setq sc-electric-references-p nil)
					;[Do not] confirm the attribution
					;tag, just do it.
(setq sc-confirm-always-p t)
					;What goes in front of the
					;attribution line.
(setq sc-reference-tag-string "")

(setq sc-default-attribution "??")

;;-----------------------------  end supercite  ------------------------------

;;---------------------------------  ispell  ---------------------------------

(autoload 'ispell-word "ispell" 
  "Check spelling of word at or before point" t)
(autoload 'ispell-complete-word "ispell" 
  "Complete word at or before point" t)
(autoload 'ispell-region "ispell" 
  "Check spelling of every word in the region" t)
(autoload 'ispell-buffer "ispell" 
  "Check spelling of every word in the buffer" t)
(setq ispell-program-name "aspell")
;; (setq ispell-command "ispell.exe"
;;       ispell-look-dictionary "c:/usr/local/emacs/Add-ons/ispell4/ispell.words"
;;       ispell-look-command "look.exe"
;;       ispell-command-options (list "-d" "c:/usr/local/emacs/Add-ons/ispell4/ispell.dict")
;;       )

(require 'flyspell)
(if (featurep 'flyspell)
    (progn
      (set-face-foreground 'flyspell-duplicate "Tan3")
      ))

;;-------------------------------  end ispell  -------------------------------

;;-------------------------------  vc  -------------------------------

;;; (setq vc-mistrust-permissions t)

;;-----------------------------  end vc  -----------------------------

;;-------------------------------  W3  -------------------------------

;;; (condition-case () (require 'w3-auto "w3-auto") (error nil))

;;-----------------------------  end W3  -----------------------------

;;---------------------------------  maxima  ---------------------------------
;; TODO: surround w/try/catch.
;; (load "c:/Program Files/Maxima-5.22.1/share/maxima/5.22.1/emacs/setup-imaxima-imath.el")

;;-------------------------------  end maxima  -------------------------------

(load-library "powershell")             ; http://www.emacswiki.org/emacs/PowerShell

;;=================================  modes  ==================================

;; (transient-mark-mode 1)

(defvar user-fill-mode-preference 1
  "*User's preference for fill mode:  positive if user wants fill mode turned
on (in general), non-positive if user does not want fill mode.")

(defun my-fill-mode (&optional turn-on-fill-mode)
  "Common function to be called to turn auto-fill mode on or off from other
mode hooks.  Has default behavior which is user configurable via
`user-fill-mode-preference'.  If TURN-ON-FILL-MODE is specified, positive
values turn on auto-fill mode, non-positive values turn it off."
  (interactive)
  
  (if (null turn-on-fill-mode)
      (setq turn-on-fill-mode user-fill-mode-preference))
  (if (and (numberp turn-on-fill-mode)
           (> turn-on-fill-mode 0))
      (progn
        (auto-fill-mode 1)
        (setq auto-hscroll-mode 0)
        (setq truncate-lines nil)
        (if (interactive-p)
            (message "auto-fill mode turned ON, hscroll mode OFF"))
        )
    (auto-fill-mode 0)
    (setq auto-hscroll-mode 1)
    (setq truncate-lines t)
    (if (interactive-p)
        (message "auto-fill mode turned OFF, hscroll mode ON"))
    )
  )

;; (setq default-major-mode 'text-mode)

(setq auto-mode-alist			;Choose mode by filename.
      (append '(
		("[/\\\\\\.]\\(SCORE\\|ADAPT\\)$" . gnus-score-mode)
		("\\.txt$" . text-mode)
		)
	      auto-mode-alist)
      )

;;----------------------------  jde-mode  ----------------------------

(add-hook 'java-mode-hook
	  (lambda ()
	    ;; (setq fill-column 78) ; in group-config.el
            ;; (setq adaptive-fill-mode nil)
	    )
	  )

;;--------------------------  end jde-mode  --------------------------

;;----------------------------------  c++  -----------------------------------

(add-hook 'c++-mode-hook
          (lambda ()
            (setq fill-column 78)
            )
          )

;;--------------------------------  end c++  ---------------------------------

;;----------------------------------  sql  -----------------------------------

(eval-after-load "sql"
   '(load-library "tsql-indent"))

;;------------------------------  sgml  ------------------------------

(add-hook 'sgml-mode-hook
	  (lambda ()
	    (setq comment-indent-function
		  (lambda () comment-column))
	    (setq comment-start-skip "<!--[ \t]*")
	    (setq comment-multi-line t)
            (setq fill-column 78)
	    )
	  )

;;----------------------------  end sgml  ----------------------------

;;----------------------------------  html  ----------------------------------

;;; (if (locate-library "html-helper-mode")
;;;     (progn
;;;       (setq html-helper-mode-is-available t)
;;;       (autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;;;       (setq auto-mode-alist (cons '("\\.html$" . html-helper-mode)
;;; 				  auto-mode-alist))
;;;       (setq auto-mode-alist (cons '("\\.htm$" . html-helper-mode)
;;; 				  auto-mode-alist))
;;;       (setq html-mode-hook
;;; 	    '(lambda ()
;;; 	       (auto-fill-mode 1)
;;; 	       (show-paren-mode 1)
;;; 	       (abbrev-mode 1)
;;; 	       (local-set-key "\C-j" 'newline)
;;; 	       (local-set-key "\C-m" 'newline-and-indent)
;;; 	       (local-set-key "\M-o" 'comment)
;;; 	       (local-set-key [C-tab] 'indent-relative)
;;; 	       (local-set-key [C-return] 'newline-and-indent-relative)
;;; 	       (setq comment-start "<!-- ")
;;; 	       (setq comment-start-skip "<!-- *")
;;; 	       (setq comment-end " -->")
;;; 	       (setq comment-multi-line nil)
;;; 	       (setq comment-column 0)
;;; 	       )
;;; 	    )
;;;   
;;;       (setq html-helper-mode-hook html-mode-hook)
;;;   
;;;       (add-hook 'html-helper-load-hook
;;; ;;; (setq html-helper-load-hook		;load-hook required instead of
;;; 					;  mode-hook, because we need to set
;;; 					;  variables before html-helper-mode
;;; 					;  is called.  mode-hook is called
;;; 					;  *after* that function.
;;; 		'(lambda ()
;;; 		   (require 'html-font)	;font-lock
;;; 		   (setq html-helper-do-write-file-hooks t)
;;; 		   (setq html-helper-build-new-buffer t)
;;; 		   (setq html-helper-address-string
;;; 			 (concat
;;; 			  "<a href=\"mailto:"
;;; 			  real-user-mail-address
;;; 			  "\">" user-full-name "&lt;"
;;; 			  real-user-mail-address
;;; 			  "&gt;</a>"))
;;; 		   )
;;; 		)
;;;       )
;;;   (message (format
;;; 	    "Warning:  html-helper-mode not found on load path %s"
;;; 	    load-path
;;; 	    )
;;; 	   )
;;;   )

;;--------------------------------  htmlize  ---------------------------------

(require 'htmlize)

;;----------------------------------  diff  ----------------------------------

(add-hook 'diff-mode-hook
          (lambda ()
            (set-face-attribute 'diff-refine-change nil
                                :background "yellow"
                                )
            (set-face-attribute 'diff-added nil
                                :background "#baff73"       ; "Chartreuse1"
                                )
            (set-face-attribute 'diff-changed nil
                                :background "#c6faff"       ; "CadetBlue1"
                                )
            (set-face-attribute 'diff-removed nil
                                :background  "#ffadad"      ; "IndianRed1"
                                )
            )
          )

;;-------------------------  enriched text  --------------------------

(defun my-enriched-mode-hook ()
  "Hook called when switching to enriched-mode."
  (interactive)
  ;; (message "my-enriched-mode-hook")
  ;; (auto-fill-mode 1)
  (my-fill-mode)
  (show-paren-mode 1)
  (abbrev-mode 1)
					;Fix that obnoxious
					;  reindent-then-newline-and-indent
					;  command bound to RET.
  (let (
	(enriched-mode-keymap (cdr (assq 'enriched-mode minor-mode-map-alist)))
	)
    (if (not (eq 'newline-and-indent-relative
		 (lookup-key enriched-mode-keymap "\C-m")))
	(progn
	  ;; (local-set-key "\C-j" 'newline)
	  ;; (local-set-key "\C-m" 'newline-and-indent)
	  ;; (local-set-key "\M-o" 'comment)

					;Modify the keymap.
	  (define-key enriched-mode-keymap "\C-m" 'newline-and-indent-relative)
					;Put the modified keymap onto
					;  the front of
					;  minor-mode-map-alist, where
					;  it will take precedence
					;  over the old keymap (which
					;  will still be present).
	  (setq minor-mode-map-alist
		(cons (cons 'enriched-mode enriched-mode-keymap)
		      minor-mode-map-alist))
	  )
	)
    )
  (setq standard-indent 3)
  (make-face 'self-note)
  (set-face-foreground 'self-note "magenta")
  (make-face-bold 'self-note)
  )

(add-hook 'enriched-mode-hook 'my-enriched-mode-hook)

;;-----------------------  end enriched text  ------------------------

;; --------------------------  message  ---------------------------

					;The following construct is emacs's
					;  equivalent of a Java try-catch.
					;  It's also overkill, since a simple
					;  error check on load-library should
					;  suffice.
(condition-case err
    (progn				;Try body
      (require 'message)
      (defun yow-x-message ()
        "Wrapper for `yow' that appends a smidgeon of explanatory text."
        ;;(concat (yow) "  Yow!") ; Really, we should only concat "Yow!" if
                                        ;the message doesn't already contain
                                        ;"yow".
        (yow)
        )
      (setq message-required-mail-headers
	    (append message-required-mail-headers
		    '((Bcc . real-user-mail-address)
                                        ;X-Message-flag is what MS-Outlook
                                        ;uses for "followup flags".
                      ;; (X-Message-flag . yow-x-message) 
		      )
		    )
	    )
      (setq message-generate-headers-first t)
      (setq message-send-mail-function 'message-send-mail-with-sendmail)
      (setq message-sendmail-f-is-evil t)
      (setq message-sendmail-envelope-from 'header)
      (if (equal system-type 'windows-nt)
          (setq sendmail-program
                "c:/usr/sbin/ssmtp.exe"))
      ;; (setq message-send-mail-function 'smtpmail-send-it)
      )
  (error				;Catch all errors (I hope).
   (if (and (eq 'file-error (car err))
	    (equal "Cannot open load file" (cadr err))
	    (equal "message" (caddr err))
	    )
       (message (format "Warning: %s" err)) ;Swallow the exception (emitting a
					    ;  warning), pretend everything's
					    ;  ok.
     (signal (car err) (cdr err))	;Rethrow unhandled exception.
     )
   )
  )

;; ------------------------  end message  -------------------------

;;----------------------------------  org  -----------------------------------

(if (member 'org features)
    (progn
      (set-face-foreground 'org-date "SteelBlue3")
      (set-face-foreground 'org-link "DodgerBlue")
      (set-face-foreground 'org-todo "magenta")
      (set-face-background 'org-todo "white")

      (set-face-attribute 'org-level-1 nil
                          ;;:foreground "Blue1"
                          ;;:background "#ccccff"
                          :foreground "#0046a7"
                          :background "#b8d6ff"
                          :weight 'bold
                          :box t
                          )
      (set-face-attribute 'org-level-2 nil
                          :foreground "FireBrick"
                          :weight 'bold
                          )
      (set-face-foreground 'org-level-3 "DarkViolet")
      (set-face-foreground 'org-level-4 "ForestGreen")
      (set-face-foreground 'org-level-5 "DarkGoldenrod4")
      ;(set-face-foreground 'org-level-6 "")
      ;(set-face-foreground 'org-level-7 "")
      ;(set-face-foreground 'org-level-8 "")

      (setq org-directory "C:/Personal/Org")
      (setq org-mobile-directory "C:/My Dropbox/MobileOrg")
      (setq org-mobile-inbox-for-pull
            "C:/My Dropbox/MobileOrg/org-mobile-inbox-for-pull.org")
      (setq org-mobile-files
            '(
              "journal.org"
              "org-mobile-setup.org"
              ))

      (add-hook 'org-mode-hook
                (lambda ()
                  (setq fill-column 100)
                  (setq comment-column 48)
                  (setq comment-start "-- ")
                  (setq comment-start-skip "---+\\(\\s-*\\)")
                  (setq org-footnote-section nil)
                  (setq org-footnote-auto-adjust t)
                  ))

      ))

;;--------------------------------  end org  ---------------------------------

;;---------------------------------  nxhtml  ---------------------------------

;; (load "c:/usr/local/nxhtml/autostart.el")

;; Workaround the annoying warnings:
;;    Warning (mumamo-per-buffer-local-vars):
;;    Already 'permanent-local t: buffer-file-name
(when (string< "24.1" (format "%d.%d" emacs-major-version emacs-minor-version))
  (eval-after-load "mumamo"
    '(setq mumamo-per-buffer-local-vars
           (delq 'buffer-file-name mumamo-per-buffer-local-vars))))

;;-------------------------------  end nxhtml  -------------------------------

;;---------------------------------  tramp  ----------------------------------

(require 'tramp)
(require 'ange-ftp)
(if (member 'tramp features)
    (progn
      (if (member 'ange-ftp features)
          (progn
            (setq ange-ftp-ftp-program-name "c:/usr/local/bin/ftp")
            '(setq ange-ftp-ftp-program-args nil)
            )
        )
      (add-to-list 'tramp-default-method-alist '("triangle-enlightened.zzl.org" "" "ftp"))
      )
  )

;;-------------------------------  end tramp  --------------------------------

;;===============================  end modes  ================================

;;------------------------  other functions  -------------------------

(require 'journal)

(defun cr (beg end &optional arg)
  "Alias for `comment-region'."
                                        ;Interactive codes:
                                        ;  'r': region (2 args)
                                        ;  'P': raw prefix arg (3rd arg)
  (interactive "r
P")
  (comment-region beg end arg)
  )

(defun nm ()
  "Alias for `normal-mode'."
  (interactive)
  (normal-mode)                         ;normal-mode has an optional FIND-FILE
                                        ;argument, but I don't know whether
                                        ;it's a boolean or a string (or a
                                        ;number), so bag it.
  )

(defun moz ()
  "Alias for `browse-url-of-file'."
  (interactive)
  (browse-url-of-file)
  )

(defun newline-and-indent-relative ()
  "Insert a newline, then call `indent-relative'.  Has slightly
different behavior from `newline-and-indent'."
  (interactive)
  (newline)
  (indent-relative)
  )

(defun rb ()
  "Alias for revert-buffer"
  (interactive)
  (revert-buffer nil                    ;nil ==> Do not ignore auto-save files
                 t                      ;t ==> No confirmation
                 t                      ;t ==> preserve mode (don't
                                        ;  reinitialize mode)
                 )
  )

(defun tr ()
  "Toggle variable truncate-lines."
  (interactive)
  (setq truncate-lines (if truncate-lines nil t))
                                        ;hscroll-mode is now obsolete and
                                        ;  apparently no longer sets
                                        ;  truncate-lines.
  (setq auto-hscroll-mode 1)                 ;sets truncate-lines
  (auto-fill-mode (if truncate-lines 0 1))
  )

(defun ts (regexp)
  "Alias for tags-search"
  (interactive "sts, Tags search (regexp): ")
  (tags-search regexp)
  )

;;----------------------  end other functions  -----------------------

;;-------------------------  miscellaneous  --------------------------

;;; (define-key function-key-map [delete] "\C-d")

(setq explicit-shell-file-name "c:/bin/bash") ;Note: may be messed up by
                                        ;powershell.el

(setq completion-ignored-extensions
      (append '(".$el"
		".$tx"
		".$ja"
		".$ba"
		".$sh"
		".$pl"
		)
	      completion-ignored-extensions))

(make-face 'faint)
(make-face-italic 'faint)
(set-face-foreground 'faint "gray60")

(set-face-background 'secondary-selection "#b6ffe6")

;; (require 'jde)
;; (load-library "jde-extra")

;; Bug in remoting to my Allscripts Raleigh workstation:
;; (x-display-color-cells) returns 20 when many more colors are available.
(if (<= (x-display-color-cells) 20)
    (progn
      (message (format "x-display-color-cells returns %d; redefining..." (x-display-color-cells)))
      (defun x-display-color-cells (&optional rest)
        65536
        )
      )
  )

;;-----------------------  end miscellaneous  ------------------------

;;---------------------------  customize  ----------------------------

(custom-set-variables
 '(archive-zip-use-pkzip nil)
 '(ange-ftp-default-user "anonymous")
 '(gnus-summary-highlight (quote (((= mark gnus-canceled-mark) . gnus-summary-cancelled-face) ((and (> score default) (or (= mark gnus-dormant-mark) (= mark gnus-ticked-mark))) . gnus-summary-high-ticked-face) ((and (< score default) (or (= mark gnus-dormant-mark) (= mark gnus-ticked-mark))) . gnus-summary-low-ticked-face) ((or (= mark gnus-dormant-mark) (= mark gnus-ticked-mark)) . gnus-summary-normal-ticked-face) ((and (> score default) (= mark gnus-ancient-mark)) . gnus-summary-high-ancient-face) ((and (< score default) (= mark gnus-ancient-mark)) . gnus-summary-low-ancient-face) ((= mark gnus-ancient-mark) . gnus-summary-normal-ancient-face) ((and (> score default) (= mark gnus-unread-mark)) . gnus-summary-high-unread-face) ((and (< score default) (= mark gnus-unread-mark)) . gnus-summary-low-unread-face) ((= mark gnus-unread-mark) . gnus-summary-normal-unread-face) ((and (> score default) (memq mark (list gnus-downloadable-mark gnus-undownloaded-mark))) . gnus-summary-high-unread-face) ((and (< score default) (memq mark (list gnus-downloadable-mark gnus-undownloaded-mark))) . gnus-summary-low-unread-face) ((memq mark (list gnus-downloadable-mark gnus-undownloaded-mark)) . gnus-summary-normal-unread-face) ((> score default) . gnus-summary-high-read-face) ((< score default) . gnus-summary-low-read-face) (t . gnus-summary-normal-read-face))))
 )

(custom-set-faces
 '(gnus-summary-high-read-face ((((class color) (background light)) (:bold t :foreground "SlateGray"))))
 '(gnus-summary-low-read-face ((((class color) (background light)) (:italic t :foreground "SlateGray"))))
 '(gnus-summary-low-unread-face ((t (:italic t :foreground "MediumPurple4"))))
 '(gnus-summary-normal-read-face ((((class color) (background light))
				   (:foreground "SlateGray"))))
 )


;;-------------------------  end customize  --------------------------

;;; Local Variables:
;;; fill-column: 78
;;; End:
