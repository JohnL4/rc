(defun fix-build-errors (replacements error-locns)
  "Attempt to fix build errors across a set of files by replacing
regexps with new strings where the errors occur.  This is essentially
a global search-and-replace, but restricted only to those lines of
code that are actually generating build errors.  Each replacement
operates on exactly ONE line of code.  ERROR-LOCNS is a list of error
locations of the form ((FILENAME LINE-NUM ...) ...).  FILENAME should
probably be a complete pathname.  REPLACEMENTS is a list of
replacements of the form ((REGEXP TO-STRING) ...)  REGEXP and
TO-STRING are as in `replace-regexp'."
    (let ((errs error-locns)
          filename
          line-nums
          (err-buf (generate-new-buffer "*error-log*"))
          )
      (while errs
        (setq filename (car (car errs)))
        (setq line-nums (cdr (car errs)))
        (fix-build-errors-in-a-file replacements
                                    filename line-nums
                                    err-buf)
        (setq errs (cdr errs))
        )
      (message (format "Switching to buffer %s"
                       (prin1-to-string err-buf t)))
      (switch-to-buffer err-buf)
      )
    )


(defun fix-build-errors-in-a-file
  (replacements filename line-nums err-buf)
  "Fix build errors by replacing text in all locations where the
errors occur.  This is essentially a global search-and-replace, but
restricted only to those lines of code that are actually generating
build errors.  Each replacement operates on exactly ONE line of code.
LINE-NUMS is a list of line numbers.  FILENAME should probably be a
complete pathname.  REPLACEMENTS is as in `fix-build-errors'."
  (let (
        line-num
        )
    (save-excursion
      (find-file filename)
      (while line-nums
        (let (eol-posn
              (repls replacements)
              (replace-done nil))
          (setq line-num (car line-nums))
          (goto-line line-num)
          (beginning-of-line)
          (save-excursion
            (forward-line 1)
            (setq eol-posn (point))
            )
          (while repls
            (let ((regexp (car (car repls)))
                  (to-string (cadr (car repls)))
                  )
              (if
                  (re-search-forward regexp eol-posn t)
                  (progn
                    (replace-match to-string)
                    (setq replace-done t)
                    ))
              (setq repls (cdr repls))
              (beginning-of-line)
              ))
          (if (not replace-done)
              (warn err-buf (format
                             "No replacements done at %s:%s\n"
                             filename line-num)))
          (setq line-nums (cdr line-nums))
          )
        )
      )
    )
  )

(defun warn (buffer msg)
  "Append text MSG to BUFFER."
  (save-excursion
    (set-buffer buffer)
    (end-of-buffer)
    (insert msg)
    )
  )