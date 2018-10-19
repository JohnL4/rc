(defun simplify-dir (path)
  "Drop last element of path and resolve trailing sequence of `..'s.  Path is
assumed to look like `a/b/c/d/e/../../../f', not `a/b/../b2/c/d/e/../../../f'
(i.e., all occurrences of `..' are assumed to come together)."
  (let ((path-elts (split-string path "/"))
        )
    (setq path-elts (cdr (reverse path-elts))) ;cdr drops "last" (now first)
                                        ; elt
    (mapconcat (lambda (elt) elt)       ;identity
               (reverse (drop-dotdots path-elts))
               "/")
    )
  )

(defun drop-dotdots (&optional rest)
  (if (string= ".." (car rest))
      (progn (setq rest (drop-dotdots (cdr rest))) ;drop, drop, drop
             (cdr rest))                ;for every previously-encounter "..",
                                        ; drop something real
    rest)                               ;else no dotdots, just return what we
                                        ; got. 
  )

(simplify-dir "a/b/c/d/e/../../../f")

(simplify-dir (jde-find-project-file "c:/Work/CanopyIA/R2.1/Source/canopy/"))
