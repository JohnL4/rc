;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/comment-configurator.el,v 1.1 2001/10/30 22:58:22 J80Lusk Exp $

;;; Configure comment vars for the current bufer.

(defun configure-comments (&optional a-comment-start
                                     a-comment-start-skip
                                     a-comment-end
                                     a-comment-multi-line
                                     a-comment-column)
  "Configure comment vars for the current bufer."
  (interactive)
  (or a-comment-start
      (setq a-comment-start (read-string "comment-start: ")))
  (or a-comment-start-skip
      (setq a-comment-start-skip (read-string "comment-start-skip: "
                                              a-comment-start)))
  (or a-comment-end
      (setq a-comment-end (read-string "comment-end: ")))
  (or a-comment-multi-line
      (setq a-comment-multi-line (read-string "comment-multi-line: ")))

  (setq comment-start a-comment-start)
  (setq comment-start-skip a-comment-start-skip)
  (setq comment-end a-comment-end)
  (setq comment-multi-line a-comment-multi-line)
  (setq comment-column a-comment-column)
  )