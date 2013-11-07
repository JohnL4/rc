;;; Commands meant to be used interactively in the course of checking a file
;;; for non-local assignments to Javascript variables (i.e., variables not
;;; locally defined with a "var" statement), since they may cause new globals
;;; to spring into existence.

(require 'highlight)

(defun jsh ()
  (interactive)
                                        ;Highlight everything in the buffer
                                        ;  that looks like an assignment.
  (highlight-regexp "\\(\\sw\\|\\s_\\)+\\s-*=[^=]" "cyan")

                                        ;Highlight, in a subdued color,
                                        ;  everything that looks like an
                                        ;  assignment to an object member,
                                        ;  since it can't be a local var.
  (highlight-regexp "\\.\\(\\sw\\|\\s_\\)+\\s-*=[^=]" "gray")

                                        ;Highlight "var" definitions (possibly
                                        ;  with assignments) as "safe".
  (highlight-regexp "\\bvar\\s-+\\(\\sw\\|\\s_\\)+\\(\\s-*=.\\)?" "yellow")
  )
                                        ;As you progress in your checking,
                                        ;  highlight as "checked" assignments
                                        ;  that match a "var" definition.
(defun safe1 (string)
  "Marks assignments to a single variable w/the current region as ``safe'',
meaning the variable has been defined locally. Does NOT modify mark, uses
existing mark."
  (interactive "sVariable: ")
  (hlsr (concat "\\b" string "\\s-*=[^=]")
        "gray")
                                        ;Remark definitions that may have been
                                        ;  overeagerly matched by the previous
                                        ;  call. 
  (hlsr (concat "\\bvar\\s-+" string "\\s-*=.")
        "yellow")
  )

(defun safe (string)
  "Mark multiple variables as safe, within the current javascript function.
Temporarily modifies mark for proper functioning."
  (interactive "sVariables (space-delimited list): ")
  (let ((variables (split-string string))
        )
    (save-excursion
      (if (not (looking-at "^\\s-*function\\b"))
          (re-search-backward "^\\s-*function\\b")
        )
      (push-mark)
      (forward-list 2)                  ;() {}
      (exchange-point-and-mark)
      (while variables
        (safe1 (car variables))
        (setq variables (cdr variables))
        )
      (pop-mark)
      )
    )
  )