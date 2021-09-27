(defun tabs-to-table ()
  "Turns a block of tab-delimited text (either the entire buffer or the region, if active) into an org-mode table.
Note that this function will operate on the lines the region touches, so it may stray outside the region."
  (interactive)
  (require 'org-table)
  (save-excursion
    (let* ((char-begin (if (use-region-p) (region-beginning) (point-min)))
           (char-limit (if (use-region-p) (region-end) (point-max)))
           end-marker
           )
      ;; Make sure we're operating on entire lines
      (goto-char char-begin)
      (if (not (bolp)) (progn (beginning-of-line)
                              (setq char-begin (point))))
      (goto-char char-limit)
      (if (not (eolp)) (progn (end-of-line)
                              (setq char-limit (point))))
      (setq end-marker (point-marker))
      (set-marker-insertion-type end-marker t) ;Inserted text goes before marker, not after.
      (goto-char char-begin)
      (while (search-forward "\t" (marker-position end-marker) t) ;TAB character; t ==> no error, just return nil
        (replace-match " | ")
        )
      (goto-char char-begin)
      (while (re-search-forward "^" (marker-position end-marker) t)
        (replace-match "| ")
        )
      (goto-char char-begin)
      (org-table-align)
      (set-marker end-marker nil)       ;Clean up: don't make emacs constantly update this marker when it's no longer
                                        ;needed.
      )))

(defun tt () "Alias to `tabs-to-table'" (interactive) (tabs-to-table))

(provide 'tabs-to-table)
