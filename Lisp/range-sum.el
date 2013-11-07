(defun range-sum (ranges)
  "Sum a list of ranges (min, max), producing a single range.  Given ranges
are either 2-element lists (integer min, max) or integers (min = max)."
  (if (or (null ranges)
          (< (length ranges) 2))
      (if (listp (car ranges))
          (car ranges)
        (list (car ranges) (car ranges)))
    (let* ((first-elt (car ranges))
           (other-elts (cdr ranges))
           sum-range
           )
      (setq sum-range (list (+ (range-sum-min first-elt)
                               (range-sum-min (car other-elts)))
                            (+ (range-sum-max first-elt)
                               (range-sum-max (car other-elts)))))
      (range-sum (cons sum-range (cdr other-elts)))
      )
    )
  )

(defun range-sum-min (range)
  "Return the minimum of the given range, which is either a single integer or
a 2-element list in the form `(min max)'."
  (if (listp range)
      (car range)
    range)
  )

(defun range-sum-max (range)
  "Return the maximum of the given range, which is either a single integer or
a 2-element list in the form `(min max)'."
  (if (listp range)
      (cadr range)
    range)
  )
