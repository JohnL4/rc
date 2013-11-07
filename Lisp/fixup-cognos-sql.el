(defun fixup-cognos-sql ()
  "Fixes up Cognos-generated SQL to make it easier to read.  Works in current region."
  (interactive)
  (save-excursion
    (let
        (
          (comma-clause-separator
          "\\(\"c[0-9]+\" \\|\\bT[0-9]+\\)\\(,\\)")
         (join-clause-separator
          "\\(LEFT OUTER JOIN\\)")
         (and-clause-separator
          " \\(and \\)")
         )
      (save-excursion
        (goto-char (region-beginning))
        (while (re-search-forward comma-clause-separator (region-end) t)
          (replace-match (concat "\\1" (list ?\n ?\t ?\t) "\\2"))
          )
        )
      (save-excursion
        (goto-char (region-beginning))
        (while (re-search-forward join-clause-separator (region-end) t)
          (replace-match (concat (list ?\n ?\t ?\t) "\\1"))
          )
        )
      (save-excursion
        (goto-char (region-beginning))
        (while (re-search-forward and-clause-separator (region-end) t)
          (replace-match (concat (list ?\n ?\t ?\t) "\\1"))
          )
        )
      )
    )
  )