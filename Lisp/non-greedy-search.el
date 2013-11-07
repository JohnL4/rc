;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/non-greedy-search.el,v 1.8 2002/05/06 18:02:11 J80Lusk Exp $

(defun non-greedy-search (start-re end-re limit)
  "*A non-greedy regexp search that sets match-data (even in the event of
a failed search, in which case `match-data' is probably useless).  This
search acts like `re-search-forward' for the regexp
\"`start-re'\\(.*\\)`end-re'\", where `.*' matches newlines, with the
following exceptions:

   (1) The first regexp matching `end-re' after `start-re' ends the
       search, as opposed to normal regexp searches, in which the matching
       is greedy; 

   (2) No parenthesized subexpression can begin in `start-re' and end in
       `end-re'.
.
This function is appropriate for use in a lambda function in
`font-lock-keywords' (q.v.) as MATCHER as follows:

  (defvar illustrative-keywords
    (list
     (cons (lambda (limit) (non-greedy-search \"foo\" \"bar\" limit))
	   '(0 font-lock-comment-face))))

(although using it to find C-style comments is a bit of overkill).
"
  (interactive)
  (let (
	start-m-data			;match-data
	end-m-data
	m-data
	dot-star-start			;posn of `\(.*\)' virtual
					;  subexpression
	)
    (if (re-search-forward start-re limit t) ;noerror is t; returns nil on
					;  failure w/out signalling an
					;  error.
	(progn
	  (setq start-m-data (match-data))
	  (setq dot-star-start (point))
					;Point is now at end of successful
					;  match of start-re.
	  (if (re-search-forward end-re limit t)
	      (progn
		(setq end-m-data (match-data))
		(setq m-data
		      (append (list (car start-m-data) (point)) ;subexpr 0
			      (cddr start-m-data) ;subexprs 1-n, from
						  ;  start-re
			      (list dot-star-start (car end-m-data)) ;`\(.*\)
			      (cddr end-m-data)	;subexprs 1-n from
						;  end-re.
			      ))
		(set-match-data m-data)
		(point))))))		;return value of successful match,
					;  just like re-search-forward
					;  does.
  )

(defun non-greedy-search-script (limit)
  "Non-greedy search for \"<script\\b.*</script>\"."
  (interactive)
;;;   (message (format "Point is %d" (point)))
;;;   (message (format "limit is %d" limit))
  (non-greedy-search "<[Ss][Cc][Rr][Ii][Pp][Tt]\\b" "</[Ss][Cc][Rr][Ii][Pp][Tt]>" limit)
  )

(provide 'non-greedy-search)

;;; Local Variables:
;;; fill-column: 74
;;; End:
