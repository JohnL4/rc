;;; `log' function for debugging, better than message log, which only holds a
;;; limited # of messages.

(defun dbg (msg)
  "Log `msg' to *debug* buffer."
  (save-excursion
    (set-buffer (get-buffer-create "*debug*"))
    (goto-char (point-max))
    (if (stringp msg)
	(insert msg ?\n)
      (insert (format "%S\n" msg)))
    )
  )

(provide 'debug-log)
