(defun hl-conflicts ()
  (interactive)
  (highlight-regexp "<<<<*" "green")
  (highlight-regexp "====*" "cyan")
  (highlight-regexp ">>>>*" "red")
  )
