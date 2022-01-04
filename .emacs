                                        ;-*- coding: raw-text-dos -*-

;;; $Header: v:/J80Lusk/CVSROOT/Dotfiles/.emacs,v 1.14 2004/09/24 17:23:42 j80lusk Exp $

;; (setq debug-on-error t)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(message "loading .emacs...")
(setq message-log-max 1000)

(setq archive-zip-use-pkzip nil)

(defvar group-emacs-directory "c:"
  "The directory in which the emacs + JDE package was installed.  The
value \"E:\" corresponds to the existence of E:/Emacs/emacs-20.3.1/bin."
  )

(defvar group-jde-version "2.3.5"
  "The version of JDE to use.  This will be used to construct the pathname to
the JDE directory to be placed on `load-path'."
  )

;;; (setq group-jde-version "2.3.5")	;I'm using a later version than the
					;  group's production version.

(load-library "~/Lisp/generic-util")

(setq load-path
      (fix-filesystem-paths
       (append
        (list
         "c:/usr/local/share/emacs/site-lisp"
         "c:/usr/local/share/emacs/site-lisp/org"
	 (let ((home-path (getenv "HOME")))
	   (concat home-path
		   (if (or (string-match "/$" home-path)
			   (string-match "\\\\$" home-path)) ;Not sure why I need so many backslashes, but ok....
		       ""
		     "/")
		   "Lisp")
	   )
         )
        load-path
        ))
      )

(message (format ".emacs fixed up load-path to: %S" load-path))

;; (setq preferred-background-mode 'dark)  ;light or dark color scheme.
(setq preferred-background-mode 'light)

(load-library "group-config")

					;Add further customizations
					;here, or in a separate file.

(if (locate-library "personal-config")
  (progn
    (message "Loading personal-config")
    (load-library "personal-config")
  )
  (message "Note:  No library `personal-config'.")
  )

					;Note that `customize' writes lisp
					;code directly into this file, in the
					;section below.  If you ever install a
					;new .emacs, you'll lose those
					;customizations unless you copy them
					;over.

;;; ----------------------------------------------------------------
;;; 'Customize' settings:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ange-ftp-default-user "anonymous")
 '(archive-zip-use-pkzip nil t)
 '(bmkp-auto-light-when-set 'any-bookmark)
 '(bmkp-light-left-fringe-bitmap 'right-triangle)
 '(bmkp-light-right-fringe-bitmap 'left-triangle)
 '(bmkp-light-style-autonamed 'lfringe)
 '(bmkp-light-style-non-autonamed 'lfringe)
 '(bsh-vm-args nil)
 '(canlock-password "7dba1437adbcb175c1ba0e748981647e10db2510")
 '(ediff-patch-options "--verbose -f")
 '(global-font-lock-mode t nil (font-lock))
 '(gnus-summary-highlight
   '(((= mark gnus-canceled-mark)
      . gnus-summary-cancelled-face)
     ((and
       (> score default)
       (or
        (= mark gnus-dormant-mark)
        (= mark gnus-ticked-mark)))
      . gnus-summary-high-ticked-face)
     ((and
       (< score default)
       (or
        (= mark gnus-dormant-mark)
        (= mark gnus-ticked-mark)))
      . gnus-summary-low-ticked-face)
     ((or
       (= mark gnus-dormant-mark)
       (= mark gnus-ticked-mark))
      . gnus-summary-normal-ticked-face)
     ((and
       (> score default)
       (= mark gnus-ancient-mark))
      . gnus-summary-high-ancient-face)
     ((and
       (< score default)
       (= mark gnus-ancient-mark))
      . gnus-summary-low-ancient-face)
     ((= mark gnus-ancient-mark)
      . gnus-summary-normal-ancient-face)
     ((and
       (> score default)
       (= mark gnus-unread-mark))
      . gnus-summary-high-unread-face)
     ((and
       (< score default)
       (= mark gnus-unread-mark))
      . gnus-summary-low-unread-face)
     ((= mark gnus-unread-mark)
      . gnus-summary-normal-unread-face)
     ((and
       (> score default)
       (memq mark
             (list gnus-downloadable-mark gnus-undownloaded-mark)))
      . gnus-summary-high-unread-face)
     ((and
       (< score default)
       (memq mark
             (list gnus-downloadable-mark gnus-undownloaded-mark)))
      . gnus-summary-low-unread-face)
     ((memq mark
            (list gnus-downloadable-mark gnus-undownloaded-mark))
      . gnus-summary-normal-unread-face)
     ((> score default)
      . gnus-summary-high-read-face)
     ((< score default)
      . gnus-summary-low-read-face)
     (t . gnus-summary-normal-read-face)))
 '(jde-gen-class-buffer-template (double-quote-list-elts jdex-class-template))
 '(jde-gen-code-templates
   (append
    (list
     (cons "Data Member" 'tempo-template-jdex-data-member)
     (cons "Function Member" 'template-jdex-function-member))
    jde-gen-code-templates))
 '(jde-gen-console-buffer-template (double-quote-list-elts jdex-class-template))
 '(jde-key-bindings
   (append
    (list
     (cons "" 'jde-gen-class)
     (cons "" 'tempo-template-jdex-data-member)
     (cons "" 'tempo-template-jdex-function-member)
     (cons "[? ? (control ?.)]" 'tempo-forward-mark)
     (cons "[? ? (control ?,)]" 'tempo-backward-mark)
     (cons "" 'jdex-insert-html-code))
    (if
        (featurep 'jdex-bean)
        (list
         (cons "" 'jdex-insert-property)))
    jde-key-bindings))
 '(markdown-command "pandoc -f gfm -t html5")
 '(org-babel-load-languages '((emacs-lisp . t) (plantuml . t)))
 '(org-list-allow-alphabetical t)
 '(org-plantuml-jar-path "c:\\usr\\local\\lib\\plantuml.1.2019.7.jar")
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
   '(rainbow-mode htmlize plantuml-mode magit csharp-mode ox-twbs markdown-mode markdown-mode+ markdown-preview-mode tide lua-mode with-editor web-mode powershell ox-reveal ox-pandoc ox-asciidoc mmm-mode haskell-mode epresent company))
 '(plantuml-default-exec-mode 'jar)
 '(plantuml-jar-args '("-charset" "UTF-8" "-nometadata"))
 '(plantuml-jar-path "c:\\usr\\local\\lib\\plantuml.1.2019.7.jar")
 '(safe-local-variable-values '((flyspell-mode . 1) (org-footnote-section)))
 '(visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)))
(message "loading .emacs...done")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-marked ((t (:foreground "red"))))
 '(font-lock-comment-face ((((class color) (background light)) (:italic t :foreground "SteelBlue4")) (((class color) (background dark)) (:italic t :foreground "gray"))))
 '(font-lock-doc-face ((t (:foreground "dark slate blue" :slant italic))))
 '(font-lock-string-face ((((class color) (background light)) (:foreground "firebrick")) (((class color) (background dark)) (:foreground "LightSalmon"))))
 '(gnus-summary-high-read ((((class color) (background light)) (:bold t :foreground "SlateGray"))))
 '(gnus-summary-high-read-face ((((class color) (background light)) (:bold t :foreground "SlateGray"))))
 '(gnus-summary-low-read ((((class color) (background light)) (:italic t :foreground "SlateGray"))))
 '(gnus-summary-low-read-face ((((class color) (background light)) (:italic t :foreground "SlateGray"))))
 '(gnus-summary-low-unread ((t (:italic t :foreground "MediumPurple4"))))
 '(gnus-summary-low-unread-face ((t (:italic t :foreground "MediumPurple4"))))
 '(gnus-summary-normal-read ((((class color) (background light)) (:foreground "SlateGray"))))
 '(gnus-summary-normal-read-face ((((class color) (background light)) (:foreground "SlateGray"))))
 '(mmm-default-submode-face ((t (:background "linen"))))
 '(org-block ((t (:inherit shadow :foreground "gray40"))))
 '(org-code ((t (:inherit org-verbatim))))
 '(org-column ((t (:background "grey90" :strike-through nil :underline nil :slant normal :weight normal :height 98))))
 '(org-todo ((t (:foreground "magenta" :weight bold))))
 '(region ((((class color) (background light)) (:background "LightSteelBlue1")) (((class color) (background dark)) (:background "DimGray"))))
 '(show-paren-match ((t (:background "cyan2"))))
 '(show-paren-match-expression ((t (:background "DarkSlateGray1"))))
 '(speedbar-button-face ((((class color) (background light)) (:background "green4" :foreground "white" :weight bold))))
 '(speedbar-selected-face ((((class color) (background light)) (:background "yellow" :foreground "red" :underline t :slant italic))))
 '(speedbar-separator-face ((((class color) (background light)) (:background "sky blue" :foreground "black" :overline "gray"))))
 '(vbnet-funcall-face ((t (:foreground "blue"))) t)
 '(warning ((t (:foreground "DarkOrange2" :weight bold)))))
(put 'scroll-left 'disabled nil)
