					;Combinations of bold, italic,
					;underline: 8.
					;
					;Standard faces: bold, italic,
					;bold-italic, underline (and none).

(defface bold-italic-underline
  '((((type w32 x))
     (:bold t :italic t :underline t))
    )
  "Bold italic underline"
  )
(defface bold-underline
  '((((type w32 x))
     (:bold t :underline t))
    )
  "Bold underline"
  )
(defface italic-underline
  '((((type w32 x))
     (:italic t :underline t))
    )
  "Italic underline"
  )

                                        ;Fix up apparently-messed-up
                                        ;bold-italic face.
(defface bold-italic
  '((((type w32 x))
     (:bold t :italic t))
    )
  "Bold italic"
  )
(if (or (eq 'w32 window-system)
        (eq 'x window-system))
    (make-face-bold-italic 'bold-italic)
  )

(defun group-add-html-tag-keywords (keyword-spec-list keyword-alist)
  "Add spec made from (car keyword-alist) to keyword-spec-list."
  (if keyword-alist
      (progn
	(let* ((face-keywords (car keyword-alist))
	       (face (car face-keywords))
	       (keywords (cdr face-keywords))
	       (kw-re (regexp-opt keywords  t))
	       (kw-re-d (regexp-opt-depth kw-re))
	       (kw-spec (list (concat "<" kw-re ">\\([^<]+\\)</" kw-re ">")
			      (1+ kw-re-d)
			      face))
	       )
	  (group-add-html-tag-keywords
	   (cons kw-spec keyword-spec-list)
	   (cdr keyword-alist))
	  )
	)
    keyword-spec-list
    )
  )

					;HTML to be displayed in the various
					;text styles.
(let ((keyword-alist '(('bold-italic-underline "h1" "h2")
		       ('bold-underline "h3")
		       ('bold-italic "h4")
		       ('italic-underline "h5")
		       ('underline "h6")
		       ('bold "strong" "b")
		       ('italic "em" "var" "dfn" "i")
		       )))
  (setq group-html-tag-keywords
        (group-add-html-tag-keywords nil keyword-alist))
  )

