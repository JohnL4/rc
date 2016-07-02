                                        ;-*- coding: raw-text-dos -*-

;;; $Header: v:/J80Lusk/CVSROOT/Dotfiles/.emacs,v 1.14 2004/09/24 17:23:42 j80lusk Exp $

;; (setq debug-on-error t)
(message "loading .emacs...")
(setq message-log-max 1000)

(defvar group-emacs-directory "/usr/local"
  "The directory in which the emacs + JDE package was installed.  The
value \"E:\" corresponds to the existence of E:/Emacs/emacs-20.3.1/bin."
  )

(defvar group-jde-version "2.3.5.1"
  "The version of JDE to use.  This will be used to construct the pathname to
the JDE directory to be placed on `load-path'."
  )

;;; (setq group-jde-version "2.3.5")	;I'm using a later version than the
					;  group's production version . 

(load-library "~/Lisp/generic-util")

(setq load-path
      (fix-filesystem-paths
       (append
        (list
         (concat (getenv "HOME") "/Lisp")
         "/usr/share/emacs/site-lisp"
         "/usr/local/share/emacs/site-lisp"
         )
        load-path
        ))
      )

(message (format " . emacs fixed up load-path to: %S" load-path))

                                        ;Note: don't use `eq' here, but
                                        ;`string=' for string comparison.
(if (or (string= (getenv "TERM") "xterm-256color")
        (and (string= (getenv "TERM") "dumb")
             (not (string= window-system 'x))
             )
        )
    (setq preferred-background-mode 'dark)  ;light or dark color scheme . 
  (setq preferred-background-mode 'light)
  )
(message (format ".emacs: TERM = %s; preferred-background-mode = %s"
                 (getenv "TERM")
                 preferred-background-mode))

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
 '(bmkp-auto-light-when-set (quote any-bookmark))
 '(bmkp-light-left-fringe-bitmap (quote right-triangle))
 '(bmkp-light-right-fringe-bitmap (quote left-triangle))
 '(bmkp-light-style-autonamed (quote lfringe))
 '(bmkp-light-style-non-autonamed (quote lfringe))
 '(bsh-vm-args nil)
 '(canlock-password "7dba1437adbcb175c1ba0e748981647e10db2510")
 '(global-font-lock-mode t nil (font-lock))
 '(gnus-summary-highlight (quote (((= mark gnus-canceled-mark) . gnus-summary-cancelled-face) ((and (> score default) (or (= mark gnus-dormant-mark) (= mark gnus-ticked-mark))) . gnus-summary-high-ticked-face) ((and (< score default) (or (= mark gnus-dormant-mark) (= mark gnus-ticked-mark))) . gnus-summary-low-ticked-face) ((or (= mark gnus-dormant-mark) (= mark gnus-ticked-mark)) . gnus-summary-normal-ticked-face) ((and (> score default) (= mark gnus-ancient-mark)) . gnus-summary-high-ancient-face) ((and (< score default) (= mark gnus-ancient-mark)) . gnus-summary-low-ancient-face) ((= mark gnus-ancient-mark) . gnus-summary-normal-ancient-face) ((and (> score default) (= mark gnus-unread-mark)) . gnus-summary-high-unread-face) ((and (< score default) (= mark gnus-unread-mark)) . gnus-summary-low-unread-face) ((= mark gnus-unread-mark) . gnus-summary-normal-unread-face) ((and (> score default) (memq mark (list gnus-downloadable-mark gnus-undownloaded-mark))) . gnus-summary-high-unread-face) ((and (< score default) (memq mark (list gnus-downloadable-mark gnus-undownloaded-mark))) . gnus-summary-low-unread-face) ((memq mark (list gnus-downloadable-mark gnus-undownloaded-mark)) . gnus-summary-normal-unread-face) ((> score default) . gnus-summary-high-read-face) ((< score default) . gnus-summary-low-read-face) (t . gnus-summary-normal-read-face))))
 '(gud-gdb-command-name "gdb --annotate=1")
 '(jde-gen-class-buffer-template (double-quote-list-elts jdex-class-template))
 '(jde-gen-code-templates (append (list (cons "Data Member" (quote tempo-template-jdex-data-member)) (cons "Function Member" (quote template-jdex-function-member))) jde-gen-code-templates))
 '(jde-gen-console-buffer-template (double-quote-list-elts jdex-class-template))
 '(jde-key-bindings (append (list (cons "" (quote jde-gen-class)) (cons "" (quote tempo-template-jdex-data-member)) (cons "" (quote tempo-template-jdex-function-member)) (cons "[? ? (control ?.)]" (quote tempo-forward-mark)) (cons "[? ? (control ?,)]" (quote tempo-backward-mark)) (cons "" (quote jdex-insert-html-code))) (if (featurep (quote jdex-bean)) (list (cons "" (quote jdex-insert-property)))) jde-key-bindings))
 '(package-archives (quote (("marmalade" . "http://marmalade-repo.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/") ("melpa-stable" . "http://stable.melpa.org/packages/")))))
 '(tide-tsserver-process-environment (quote ("--experimentalDecorators"))))
(message "loading ~/.emacs...done")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-marked ((t (:inherit warning :foreground "orange red"))))
 '(font-lock-comment-face ((((class color) (background light)) (:italic t :foreground "SteelBlue4")) (((class color) (background dark)) (:italic t :foreground "gray"))))
 '(font-lock-doc-face ((t (:foreground "dark slate blue" :slant italic))))
 '(font-lock-string-face ((((class color) (min-colors 256)) (:foreground "brightred")) (((class color) (background light)) (:foreground "firebrick")) (((class color) (background dark)) (:foreground "LightSalmon"))))
 '(gnus-summary-high-read-face ((((class color) (background light)) (:bold t :foreground "SlateGray"))))
 '(gnus-summary-low-read-face ((((class color) (background light)) (:italic t :foreground "SlateGray"))))
 '(gnus-summary-low-unread-face ((t (:italic t :foreground "MediumPurple4"))))
 '(gnus-summary-normal-read-face ((((class color) (background light)) (:foreground "SlateGray"))))
 '(haskell-literate-comment-face ((t (:inherit font-lock-doc-face :slant italic))))
 '(mmm-default-submode-face ((t (:background "wheat"))))
 '(mode-line-inactive ((t (:inherit mode-line :background "burlywood" :foreground "grey20" :box (:line-width -1 :color "grey75") :weight light))))
 '(org-code ((t (:inherit shadow :foreground "royal blue"))))
 '(region ((((class color) (background light)) (:background "LightSteelBlue1")) (((class color) (background dark)) (:background "DimGray"))))
 '(speedbar-button-face ((((class color) (background light)) (:background "green4" :foreground "white" :weight bold))))
 '(speedbar-selected-face ((((class color) (background light)) (:background "yellow" :foreground "red" :underline t :slant italic))))
 '(speedbar-separator-face ((((class color) (background light)) (:background "sky blue" :foreground "black" :overline "gray")))))

;;; Local Variables:
;;; fill-column: 78
;;; End:
