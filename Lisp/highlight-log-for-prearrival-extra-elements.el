(defun highlight-log-for-prearrival-extra-elements ()
  "Highlight various interesting things in the current buffer, assuming it's a log buffer."
  (interactive)
  (highlight-regexp "^[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+:[0-9]+\\S-*" "gray")
  (highlight-regexp "reallyStupidPropertyChangeHandler" "pcyan")
  (highlight-regexp "Created PlaceHolderDefinitionPanelModel" "pink")
  (highlight-regexp "\\breceived\\b" "cyan")
  (highlight-regexp "\\bsubscribing\\b" "yellow")
  (highlight-regexp "<SeverityLevel>Error</SeverityLevel>" "red")
  )

(defun hlee ()
  "Alias for `highlight-log-for-prearrival-extra-elements'"
  (interactive)
  (highlight-log-for-prearrival-extra-elements)
  )
