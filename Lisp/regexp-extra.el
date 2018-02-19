;; Extra stuff for working w/regexp.

(defun escape-regexp-special-chars (s)
  "Returns `s' with all characters special to regexps escaped by backslashing.
Special chars are:  `.', `*', `+', `?', `[', `]', `^', `$', and `\'"
                                        ;Do fancy text substitution in a
                                        ;scratch buffer, not as string ops.
  (let ((scratch-buffer (generate-new-buffer "*regexp-extra*"))
        retval
        )
    (save-excursion
      (set-buffer scratch-buffer)
      (insert s)
      (goto-char 0)
      (while (re-search-forward
              "\\([.*+?^$]\\|\\[\\|\\]\\|\\\\\\)"
              nil t)
        (replace-match "\\\\\\&" nil nil))
      (setq retval (buffer-string))     ;SLURP! (entire buffer)
      )
    (kill-buffer scratch-buffer)
    retval
    ))

(provide 'regexp-extra)
