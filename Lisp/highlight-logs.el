(defun highlight-logs ()
  "Highlight some logs for easier eyeballing."
  (interactive)
  (highlight-regexp "<SeverityLevel>Error</SeverityLevel>" "red")
  (highlight-regexp "<logmessage>.*" "yellow")
  (highlight-regexp "tempuri.org" "orange")
  )

(provide 'highlight-logs)
