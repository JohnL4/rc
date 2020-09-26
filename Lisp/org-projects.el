;; Note: this file may exist in multiple places.  Check your emacs-lisp load path, because I may have moved a more
;; up-to-date copy of it there.

(cond ((eq system-type 'windows-nt)
       (setq my-home "C:/Users/J6L")  ;Corporate home dir.  Emacs on Windows may have a different idea of home than the
                                      ;O/S itself.
       )
      ((eq system-type 'darwin)
       (setq my-home "~")
       )
      (t                                ;otherwise...
       ;; All kinds of unix.
       (setq my-home "~")
       )
      )

(setq org-publish-project-alist
      (list
       (list "tarheel-nc"
             :base-directory (concat my-home "/Documents/AmazonS3/Tarheel-NC")
             :base-extension 'any
             :exclude "^\\.git\\|\\(\\\\\\|/\\)#\\|~$\\|template\.org\\|\\.\\(prfsession\\|dtt\\|cab\\|msi\\|pack\\|trc\\)" ;.git subdir, Temp. and backup files.
             :publishing-directory (concat my-home "/Documents/AmazonS3/Tarheel-NC-published")
             :recursive 't
             :headline-levels 12
             :with-author nil
             :with-creator 't
             :publishing-function 'lusk-org-publish
             :html-preamble "<p><a class='button' href='/'>Home</a> <a class='button' href='..'>Up dir</a> <a class='button' href='.'>Current dir</a></p>"
             )
                                        ;Treating the big VadeMecum directories as projects is a bit beyond org-mode's
                                        ;abilities.  It works, but it takes a LONG time.
;;;       (list "sunrise"                  
;;;             :base-directory "c:/Work/Sunrise"
;;;             :publishing-directory "c:/Work/Sunrise-Publish"
;;;             :base-extension 'any
;;;             :exclude "^\\.git\\|\\(\\\\\\|/\\)#\\|~$\\|template\.org\\|\\.\\(prfsession\\|dtt\\|cab\\|msi\\|pack\\|trc\\|blk\\|zip\\|7z\\)" ;.git subdir, Temp. and backup files.
;;;             :recursive 't
;;;             :headline-levels 12
;;;             :with-author nil
;;;             :with-creator 't
;;;             :publishing-function 'lusk-org-publish
;;;             :html-preamble "<p><a class='button' href='/'>Home</a> <a class='button' href='..'>Up dir</a> <a class='button' href='.'>Current dir</a></p>"
;;;             )
;;;       (list "hmed-vademecum"
;;;             :base-directory "c:/Work/HMED/VadeMecum"
;;;             :publishing-directory "c:/Work/HMED/VadeMecum-Publish"
;;;             :base-extension 'any
;;;             :exclude "^\\.git\\|\\(\\\\\\|/\\)#\\|~$\\|template\.org\\|\\.\\(prfsession\\|dtt\\|cab\\|msi\\|pack\\|trc\\)" ;.git subdir, Temp. and backup files.
;;;             :recursive 't
;;;             :headline-levels 12
;;;             :with-author nil
;;;             :with-creator 't
;;;             :publishing-function 'lusk-org-publish
;;;             :html-preamble "<p><a class='button' href='/'>Home</a> <a class='button' href='..'>Up dir</a> <a class='button' href='.'>Current dir</a></p>"
;;;             )
       )
      )

(defun lusk-org-publish (prop-list filename dest-pub-dir)
  "Choose what to do with a given file.  Useful if all your org-mode files live in the directory (org, attachments,
javascript, css, etc."
  (if (string-suffix-p ".org" filename t)
      (with-demoted-errors "Error (ignored): %S"
        (org-html-publish-to-html prop-list filename dest-pub-dir)
        )
    (org-publish-attachment prop-list filename dest-pub-dir)))

(provide 'org-projects)
