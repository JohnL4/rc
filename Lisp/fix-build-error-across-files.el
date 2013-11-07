(defun fix-build-error-across-files (regexp to-string error-locns)
  "Fix a particular build error by replacing text in all locations
where the error occurs.  This is essentially a global
search-and-replace, but restricted only to those lines of code that
are actually generating build errors.  Each replacement operates on
exactly ONE line of code.  ERROR-LOCNS is a list of error locations of
the form ((FILENAME LINE-NUM ...) ...).  FILENAME should probably be
a complete pathname.  REGEXP and TO-STRING are as in
`replace-regexp'."
  (let ((errs error-locns)
        filename
        line-nums
        line-num
        (err-buf (generate-new-buffer "*error-log*"))
        )
    (save-excursion
      (while errs
        (setq filename (car (car errs)))
        (find-file filename)
        (setq line-nums (cdr (car errs)))
        (while line-nums
          (setq line-num (car line-nums))
          (goto-line line-num)
          (let (eol-posn)
            (beginning-of-line)
            (save-excursion
              (forward-line 1)
              (setq eol-posn (point))
              )
            (if
                (re-search-forward regexp eol-posn t)
                (replace-match to-string)
              (warn err-buf (format
                             "Expected regexp \"%s\" not found at %s:%s\n"
                             regexp filename line-num))
              )
            )
          (setq line-nums (cdr line-nums))
          )
        (setq errs (cdr errs))
        )
      )
    (switch-to-buffer err-buf)
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