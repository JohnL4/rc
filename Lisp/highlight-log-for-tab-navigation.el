(defun highlight-log-for-tab-navigation ()
  "Highlight various interesting things in the current buffer, assuming it's a log buffer."
  (interactive)
  (highlight-regexp "^.*tabindex: [0-9]\\{1,3\\}).*" "pgreen")
  (highlight-regexp "^.*\\[internalid = [0-9]\\{1,3\\}\\].*" "pgreen")
  (highlight-regexp "visualtreehelper" "purple")
  ;; (highlight-regexp "^[a-z].*" "gray") ;Manually-entered text in the log buffer.
  (highlight-regexp "^[^0-9 	\n].+" "pblue") ;Manually-entered text in the log buffer.
  (highlight-regexp "combobox" "red")
  (highlight-regexp "new focus:" "blue")
  (highlight-regexp "(via" "gray")
  (highlight-regexp "keybdnav" "orange")
  (highlight-regexp "is tab stop" "yellow")
  (highlight-regexp "\\bfocusable\\b" "green")
  (highlight-regexp "is focus scope" "cyan")
  (highlight-regexp "TreeView Items.Count:1" "porange")
  (highlight-regexp "\\(\\btab\\b\\|\\bctrltab\\b\\|\\barrow\\b\\): none" "red")
  (highlight-regexp "RequestBringInto\\(Focus\\|View\\)" "maroon")
  )

(defun hll ()
  "Alias for `highlight-log-for-tab-navigation'"
  (interactive)
  (highlight-log-for-tab-navigation)
  )
