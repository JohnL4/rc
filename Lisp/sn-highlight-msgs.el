(require 'highlight)                    ;Lusk's Very Own Highlighting Library.

(defun sn-highlight-messages ()
  "Highlight log messages relevant to Structured Notes pre-caching."
  (interactive)
  (highlight-regexp "SN pre-cache" "maroon")
  (highlight-regexp "Dummy Structured Note construct/show/close took [0-9]+ msec" "yellow")
  (highlight-regexp "Opened Structured Note \".*\" in [0-9]+ msec" "green")
  )
