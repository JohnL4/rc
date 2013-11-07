;;; $Header: //v/J80Lusk/CVSROOT/EmacsLisp/fix-pathnames.el,v 1.4 2001/06/20 19:03:21 J80Lusk Exp $

(defun fix-pathnames (files)
  "Transform double backslashes to single forward slashes and drive
letters to UNC conventions, for use w/Cygnus shell.  Returns
transformed list."
  (interactive)
  ;; (message (format "(fix-pathnames %s)" (prin1-to-string files)))
  (if files
      (cons (fix-pathname (car files))
            (fix-pathnames (cdr files))))
  )

(defun fix-pathname (file)
  "Operate on a single filename, returning fixed version.  See
`fix-pathnames'.  Only transform filename if it has backslashes,
otherwise, assume it's ok for use."
  (interactive)
  (if file
      (if (string-match "\\\\" file)
          (progn
            (while (string-match "\\\\" file)
              (setq file (replace-match "/" t t file)))
            (if (string-match "^\\([a-z]\\):/?" file)
                (setq file (replace-match "//\\1/" t nil file)))
            ))
    )
  file
  )

(provide 'fix-pathnames)
