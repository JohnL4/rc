;;; Generic utility functions.
;;;
;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/generic-util.el,v 1.8 2004/05/15 23:14:35 j80lusk Exp $

(defun section-break (&optional title-text)
  "Insert a titled section break as a comment, using comment-start,
comment-end and fill-column.  If TITLE-TEXT is nil, destructively use the text
on the current line for the section title (which may be nil)."
  (interactive)
  (let* (
	 dashes				;String of dashes to place before and
					;  after title text.
	 (title-text-given-as-arg title-text)
	 (comment-start			;Lisp modes do funky things w/comments
					;  starting w/only one ";".
	  (if (string-match "lisp" (symbol-name (symbol-value 'major-mode)))
	      (concat comment-start ";")
	    comment-start))
	 )
    (setq title-text (trim-whitespace title-text))
    (beginning-of-line)

                                        ;Cursor must be properly positioned
                                        ;  (after indenting) in order to
                                        ;  properly generate correct number of
                                        ;  dashes, so we modify the buffer
                                        ;  before setting `dashes'.
    (if (not title-text-given-as-arg)
	(kill-line 1)			;Should kill terminating newline,
					;  also.  This why I said
					;  "destructive".
      )
    (open-line 1)
    (indent-according-to-mode)

    (setq dashes
;;;	  (make-string (/ (- fill-column
;;;			     (current-column) ;Must be indented properly at
;;;					      ;  this point.
;;;			     (length title-text)
;;;			     4		;Leading, trailing spaces around title
;;;					;  text.
;;;			     (length comment-start)
;;;			     (length comment-end)
;;;			     )
;;;			  2		;Two sets of dashes:  leading,
;;;					;  trailing. 
;;;			  )
;;;		       ?-)		;elisp's version of (char) '-'.
          (make-string (- fill-column
                          (current-column)
                          (length comment-start)
                          (length comment-end)
                          )
                       ?-)
          )
;;;     (insert (concat comment-start
;;; 		    dashes
;;; 		    "  " title-text "  "
;;; 		    dashes
;;; 		    comment-end))
                                        ;Now fix up for the following mapcar.
    (beginning-of-line)
    (kill-line 1)
    (mapcar (lambda (text)              ;Apply this function to the
                                        ;  following list.
              (open-line 1)
              (indent-according-to-mode)
              (insert text)
              (beginning-of-line)
              (next-line 1)
              )
            (list (concat comment-start dashes comment-end)
                  (concat comment-start " " title-text comment-end)
                  (concat comment-start dashes comment-end)))

;;;     (if (not (= (current-column) fill-column))
;;; 	(insert "-")			;div-by-2 rounding error
;;;       )
    )
  nil					;Be sure to return nil
  )

(defun one-line-section-break (&optional right-margin title-text)
  "Insert a titled section break as a comment, using comment-start,
comment-end and integer RIGHT-MARGIN.  RIGHT-MARGIN is taken from the numeric
  prefix, or fill-column if no prefix is given.  If TITLE-TEXT is nil, destructively use the text
on the current line for the section title (which may be nil)."
  (interactive "p")
  (let* (
	 dashes				;String of dashes to place before and
					;  after title text.
	 (title-text-given-as-arg title-text)
	 (comment-start			;Lisp modes do funky things w/comments
					;  starting w/only one ";".
	  (if (string-match "lisp" (symbol-name (symbol-value 'major-mode)))
	      (concat comment-start ";")
	    comment-start))
         minimum-right-margin
	 )
    (setq title-text (trim-whitespace title-text))
    (if (eq 1 right-margin) (setq right-margin fill-column)) ;1 ==> no numeric prefix

    (setq minimum-right-margin
          (+ 12                         ;12 is 4 dashes on each side, plus 2 space characters on each side.  I think 4
                                        ;dashes is a reasonable minimum.
             (length comment-start)
             (length comment-end)
             (length title-text)))
    (if (< right-margin minimum-right-margin)
        (setq right-margin minimum-right-margin))
    (beginning-of-line)

                                        ;Cursor must be properly positioned
                                        ;  (after indenting) in order to
                                        ;  properly generate correct number of
                                        ;  dashes, so we modify the buffer
                                        ;  before setting `dashes'.
    (if (not title-text-given-as-arg)
	(kill-line 1)			;Should kill terminating newline,
					;  also.  This why I said
					;  "destructive".
      )
    (open-line 1)
    (indent-according-to-mode)
    (setq dashes
	  (make-string (/ (- right-margin
			     (current-column) ;Must be indented properly at
					      ;  this point.
			     (length title-text)
			     4		;Leading, trailing spaces around title
					;  text.
			     (length comment-start)
			     (length comment-end)
			     )
			  2		;Two sets of dashes:  leading,
					;  trailing. 
			  )
		       ;; ?-		;elisp's version of (char) '-'.
                       (mode-specific-dash)
                       )
          )
    (insert (concat comment-start
		    dashes
		    "  " title-text "  "
		    dashes
		    comment-end))

    (if (not (= (current-column) right-margin))
        (progn
        (save-excursion
          (if (not (string= "" comment-end))
              (search-backward comment-end))
          (insert "-")			;div-by-2 rounding error
        )
        (end-of-line)
        )
      )
    )
  nil					;Be sure to return nil
  )

(defun mode-specific-dash ()
  "Return a single character appropriate for forming a line of ``dashes'' in
the current mode.  Usually, this will be just ``-'' (duh), but in XML and SGML
modes, a string of hyphens is unacceptable in a comment (since ``--''
terminates a comment, thanks IBM), so we need to pick a different character."
  (cond
   ((or (eq 'sgml-mode major-mode)
        (eq 'xml-mode major-mode)
        )
    ?=)
   (t ?-)))

(defun trim-whitespace (&optional text)
  "Trim leading and trailing whitespace from TEXT.  If TEXT is nil, use text
of current line (but don't modify it).  Return trimmed text or nil, if text is
all whitespace."
  (interactive)
  (if (not text)
      (let (
	    bol				;beginning of line
	    )
	(setq text (save-excursion
		     (beginning-of-line)
		     (setq bol (point))
		     (end-of-line)
		     (buffer-substring bol (point))
		     ))))

  (if					;Horrible regexp to prevent problems
					;  w/greedy matching of whitespace.
      (string-match "^\\s-*\\(\\S-.*\\S-\\|\\S-\\)\\s-*$" text)
      (match-string 1 text)
    nil)
  )

(defun double-quote-list-elts (a-list)
  "Return a list whose elements are the double-quoted elements of
A-LIST."
  (interactive)
  (let (
	(retval nil)			;Return value
	)
    (if (null a-list)
	nil
      (setq a-list (reverse a-list))
      (while a-list
	(setq retval (cons (format "%S" (car a-list)) retval))
	(setq a-list (cdr a-list))
	)
      retval
      )
    )
  )

(defun insert-nums (end &optional start incr)
  "Insert numbers into the buffer at point, in increasing order.  `start'
defaults to 1 and `incr' defaults to 1."
  ;;(interactive "NEnd with: \nnStart with: \nnIncrement: ")
  (interactive
   (list (if current-prefix-arg
             current-prefix-arg
           (progn (let (n) (while (not (integerp (setq n (read-minibuffer "End with (integer): " "10"))))) n))
           )
         (progn (let (n) (while (not (integerp (setq n (read-minibuffer "Start with (integer): " "1"))))) n))
         (progn (let (n) (while (not (integerp (setq n (read-minibuffer "Increment (integer): " "1"))))) n))
         ))
  (let ((i start)
        (di incr))
    (if (null i)
        (setq i 1))
    (if (null incr)
        (setq incr 1))
    (while (<= i end)
      (insert (format "%d\n" i))
      (setq i (+ incr i))
      )
    )
  )

(defun fix-filesystem-paths (strings)
  "*Returns a list in which the filesystem paths in `strings' have been fixed
to be correct for the current Operating Environment (Windows, Cygwin,
whathaveyou)."
  (interactive)
  (mapcar (lambda (s)
            (cond
             ((string= "cygwin" system-type)
              (if (string-match "^\\([a-zA-Z]\\):/" s)
                  (replace-match "/\\1/" nil nil s)
                s)
              )
             (t s)
             )
            )
          strings
          )
  )

(provide 'generic-util)

;;; Local Variables:
;;; fill-column: 78
;;; End:
