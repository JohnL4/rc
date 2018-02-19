(defun c-lineup-comment-unless-on-far-right (langelem)
  "Line up a comment start according to `c-comment-only-line-offset' unless:
-1- the comment is lined up with a comment starter on the previous line, or
-2- the comment starts on or after column `comment-column'.  Case -1- takes
precedence over case -2-.

Case -1-: preserve alignment w/comment on previous line.
Case -2-: Align to `comment-column'.

Works with: comment-intro.
Code hijacked from `c-lineup-comment'."
  (save-excursion
    (back-to-indentation)
    (let ((col (current-column)))
      (cond
       ;; CASE 1: preserve aligned comments
       ((save-excursion
                                        ; cc-mode 5.30.9 eliminates
                                        ; c-forward-comment as a wrapper for
                                        ; forward-comment, presumably because
                                        ; forward-comment is either fixed or
                                        ; no longer required.
	  (and (forward-comment -1)
	       (= col (current-column))))
	(vector col))			; Return an absolute column.
       ;; CASE 2: align far-right comments to `comment-column'
       ((<= comment-column col)
	(vector comment-column))
       ;; indent as specified by c-comment-only-line-offset
       ((not (bolp))
	(or (car-safe c-comment-only-line-offset)
	    c-comment-only-line-offset))
       (t
	(or (cdr-safe c-comment-only-line-offset)
	    (car-safe c-comment-only-line-offset)
	    -1000))			;jam it against the left side
       ))))

(provide 'comment-indent)
