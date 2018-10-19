(defun diffum (lis)
  (cond
   ((null lis) nil)
   (t (progn (ediff-merge-files-with-ancestor
              (concat "R2.1/" (car lis))
              (concat "R2.0.3/" (car lis))
              (concat "R2.0.3-build10/" (car lis)))
             (diffum (cdr lis))))))
