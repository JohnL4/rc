(defun fmdrk-fixup-markdown-for-roadkill()
  "Fixes up text in the current buffer for import into a RoadKill wiki."
  (interactive)
  (let ((start-code "[[[code lang=|")   ;RoadKill start-code marker
        (end-code "]]]"))               ;RoadKill end-code marker
    (save-excursion
      (goto-char (point-min))
      (let ((cur-state 'normal-text)      ;One of normal-text, indented-text, bulleted-text.
            )
        (while (not (eq (point) (point-max)))
          (if (looking-at "^[ \t]+")
                                        ; Check to make sure we're not in bulleted-text mode
              (if (eq cur-state 'normal-text)
                  (progn
                    (insert start-code)
                    (newline)
                    (setq cur-state 'indented-text)
                    ))
            (if (looking-at "^-[ \t]")
                (progn
                  (if (eq cur-state 'indented-text)
                      (fmdrk-insert-mark end-code))
                  (setq cur-state 'bulleted-text)
                  )
              (if (looking-at "^$") ()      ;Retain current state
                (if (looking-at "^\\S-")
                    (if (eq cur-state 'bulleted-text)
                        (setq cur-state 'normal-text)
                      (if (eq cur-state 'indented-text)
                          (progn
                            (fmdrk-insert-mark end-code)
                            (setq cur-state 'normal-text)
                            )))
                  ))))
          (forward-line)
          )
        )
      )
    )
  )

(defun fmdrk-insert-mark (a-mark)
  "Insert the given mark (a string) before any empty lines preceding point (which is assumed to be at the beginning of
the line), followed by a newline." 
  (let ((inserted nil))
    (save-excursion
      (forward-line -1)   ;Backwards
      (while (and (not (eq (point) (point-min)))
                  (looking-at "^$"))
        (forward-line -1))
      (forward-line 1)
      (insert a-mark)
      (newline)
      )
    ))
