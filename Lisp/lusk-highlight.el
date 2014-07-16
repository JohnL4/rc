;; Functions to highlight text by regexp.
;;
;; USAGE:
;;
;; Add the following to your .emacs:
;;
;;    (autoload 'hls "lusk-highlight" "Highlight a regexp" t)
;;    (autoload 'hlc "lusk-highlight" "Clear highlighting set with `hls'" t)
;;    (global-set-key [f3] 'hls)
;;    (global-set-key [S-f3] 'hlc)
;;
;; To highlight a regexp:  M-x hls
;; To clear highlighting:  M-x hlc
;;
;; Known Imperfections:
;;
;; The highlighting can have funny interactions with font-lock.  Try
;; highlighting something, then starting a string before it.  Also, when
;; font-lock is on, not everything will be highlighted.


(defvar lusk-highlight-styles
  '("yellow" "orange" "cyan" "red" "purple" "green" "blue" "gray"
                                        ; pastels
    "pyellow" "porange" "pcyan" "pink" "pgreen" "pblue"
    )
  "*Abbreviated names of highlight styles.  Make these whatever you want, but
if you change the faces, you might want to change their names appropriately.")

(defface lusk-highlight-yellow-face
  '(;;(DISPLAY ATTS) 			;if DISPLAY criteria are met, face is
                                        ;  given ATTS 
                                        ;CHARACTERISTIC is display
                                        ;  characteristic, VALUE is value of
                                        ;  that characteristic
    ;;(((CHARACTERISTIC VALUE...) (CHARACTERISTIC VALUE...)) ATTS)
    (((background light)) (:background "yellow" :bold t))
    (((background dark)) (:background "yellow4" :bold t))
    (t (:inverse-video t :bold t))      ;Default
    )
  "*Highlight style yellow")

(defface lusk-highlight-orange-face
  '(;;(DISPLAY ATTS) 			;if DISPLAY criteria are met, face is
                                        ;  given ATTS 
                                        ;CHARACTERISTIC is display
                                        ;  characteristic, VALUE is value of
                                        ;  that characteristic
    ;;(((CHARACTERISTIC VALUE...) (CHARACTERISTIC VALUE...)) ATTS)
    (((background light)) (:background "orange" :bold t))
    (((background dark)) (:background "orange4" :bold t))
    (t (:inverse-video t :bold t))      ;Default
    )
  "*Highlight style orange")

(defface lusk-highlight-gray-face
  '(;;(DISPLAY ATTS) 			;if DISPLAY criteria are met, face is
                                        ;  given ATTS 
                                        ;CHARACTERISTIC is display
                                        ;  characteristic, VALUE is value of
                                        ;  that characteristic
    ;;(((CHARACTERISTIC VALUE...) (CHARACTERISTIC VALUE...)) ATTS)
    (((background light)) (:background "gray" :bold t))
    (((background dark)) (:background "DimGray" :bold t))
    (t (:inverse-video t :bold t))      ;Default
    )
  "*Highlight style gray")

(defface lusk-highlight-cyan-face
  '(
    (((background light)) (:background "cyan" :bold t))
    (((background dark)) (:background "cyan4" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style cyan")

(defface lusk-highlight-red-face
  '(
    (((background light)) (:background "red" :foreground "white" :bold t))
    (((background dark)) (:background "red3" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style red")

(defface lusk-highlight-purple-face
  '(
    (((background light)) (:background "purple" :foreground "white" :bold t))
    (((background dark)) (:background "purple3" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style purple")

(defface lusk-highlight-blue-face
  '(
    (((background light)) (:background "blue" :foreground "white" :bold t))
    (((background dark)) (:background "blue3" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style purple")

(defface lusk-highlight-green-face
  '(
    (((background light)) (:background "green" :bold t))
    (((background dark)) (:background "green4" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style green")

(defface lusk-highlight-porange-face
  '(
    (((background light)) (:background "#ffcc99"))
    (((background dark)) (:background "#ffcc99"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel orange")

(defface lusk-highlight-pyellow-face
  '(
    (((background light)) (:background "#ffff99"))
    (((background dark)) (:background "#ffff99"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel yellow")

(defface lusk-highlight-pcyan-face
  '(
    (((background light)) (:background "#ccffff"))
    (((background dark)) (:background "#ccffff"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel cyan")

(defface lusk-highlight-pink-face
  '(
    (((background light)) (:background "#ffcccc"))
    (((background dark)) (:background "#ffcccc"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel red (pink)")

(defface lusk-highlight-pgreen-face
  '(
    (((background light)) (:background "#ccffcc"))
    (((background dark)) (:background "#ccffcc"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel green")

(defface lusk-highlight-pblue-face
  '(
    (((background light)) (:background "#ccccff"))
    (((background dark)) (:background "#ccccff"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel blue")


;;------------------------------  config ends  -------------------------------

(defun lusk-highlight-setup (styles)
  "Called once during initialization."
  (if styles
      (progn
        (let* ((style (car styles))
               (face (intern (format "lusk-highlight-%s-face" style)))
               (category (lusk-highlight-category-from-style style))
               )
          (put category 'face face)
          (setq lusk-highlight-style-completions
                (cons (cons style style)
                      lusk-highlight-style-completions))
          )
        (lusk-highlight-setup (cdr styles))
        )
      )
  )

(defun lusk-highlight-regexp (regexp style)
  "Highlight all occurrences of the given regexp w/the given face."
  (interactive (list
                (read-string "Regexp: ")
                (completing-read "Style: " lusk-highlight-style-completions nil t)
                 ))
  (let ((category (lusk-highlight-category-from-style style))
        (buffer-modified (buffer-modified-p))
        (prev-read-only buffer-read-only)
        (highlight-count 0)
        )
    (save-excursion
      (goto-char (point-min))
      (setq buffer-read-only nil)
      (while (re-search-forward regexp nil t)
        (put-text-property (match-beginning 0)
                           (match-end 0)
                           'category category)
        (setq highlight-count (1+ highlight-count))
        )
      )
    (set-buffer-modified-p buffer-modified)
    (setq buffer-read-only prev-read-only)
    (message (format "%d occurrences of \"%s\" highlighted w/style %S"
                     highlight-count
                     regexp
                     style))
    )
  )

(defun lusk-highlight-clear-all ()
  "Clear all highlighting (remove `category' property from all text)."
  (interactive)
  (let ((buffer-modified (buffer-modified-p))
        (prev-read-only buffer-read-only)
        )
    (setq buffer-read-only nil)
    (remove-text-properties (point-min) (point-max) '(category nil))
    (set-buffer-modified-p buffer-modified)
    (setq buffer-read-only prev-read-only)
    )
  )
                          
(defun lusk-highlight-clear (style &optional confine-to-region)
  "UNIMPLEMENTED.  Clear highlighting of the given style.  If
`confine-to-region' is true, highlighting is only cleared w/in the current region."
  (interactive (list (completing-read "Style: " lusk-highlight-style-completions
                                      nil t) ;require match
                     (y-or-n-p "Confine to region? ")
                     ))
  (let ((category (lusk-highlight-category-from-style style))
        cat-start
        cat-end
        (buffer-modified (buffer-modified-p))
        (prev-read-only buffer-read-only)
        )
                                        ;Yuck.  Find property change in
                                        ;  'category, examine to see if the
                                        ;  category is one of the highlight
                                        ;  categories, then remove it and
                                        ;  loop.
    (save-excursion
      (progn
        (setq buffer-read-only nil)
        (if confine-to-region
            (narrow-to-region (point) (mark)))

                                        ;First char may already have the
                                        ;  category we want to zap, in which
                                        ;  case we need to take steps to
                                        ;  ensure our invariant of "current
                                        ;  spot does not have the category
                                        ;  we're interested in".
        
        (if (eq category (get-text-property (point-min) 'category))
            (remove-text-properties (point-min)
                                    (next-single-property-change (point-min)
                                                                 'category
                                                                 nil
                                                                 (point-max))
                                    '(category)))
        (setq cat-start (point-min))
        (while (< cat-start (point-max))
                                        ;Loop invariant:  character at
                                        ;  cat-start does NOT have the
                                        ;  category we want to clear.
          (setq cat-start (next-single-property-change cat-start 'category
                                                       nil (point-max)))
          (if (< cat-start (point-max))
              (progn
                (setq cat-end (next-single-property-change cat-start 'category
                                                           nil (point-max)))
                (if (eq category (get-text-property cat-start 'category))
                    (remove-text-properties cat-start cat-end '(category)))
                (setq cat-start (1- cat-end))
                )
            )
          )
        (if confine-to-region
            (widen))
        (set-buffer-modified-p buffer-modified)
        (setq buffer-read-only prev-read-only)
        )
      )
    )
  )
    

(defun lusk-highlight-category-from-style (style)
  "Return the category for the given style."
  (intern (format "lusk-highlight-%s-category" style)))

;;-----------------------------  initialization  -----------------------------

(setq lusk-highlight-style-completions nil)
(lusk-highlight-setup lusk-highlight-styles)

(defun hls ()
  "Highlight SET abbrev."
  (interactive)
  (call-interactively 'lusk-highlight-regexp)
  )

(defun hlsr (regexp style)
  "Highlight SET wrapper, narrowed to region."
  (interactive (list
                (read-string "Regexp: ")
                (completing-read "Style: " lusk-highlight-style-completions nil t)
                 ))
  (save-restriction
    (narrow-to-region (point) (mark))
    (lusk-highlight-regexp regexp style)
    (widen)
    )
  )

(defun hlc ()
  "Highlight CLEAR abbrev."
  (interactive)
  (lusk-highlight-clear-all)
  )

(defun hlcr ()
  "Highlight CLEAR abbrev, narrowed to region."
  (interactive)
  (save-restriction
    (narrow-to-region (point) (mark))
    (lusk-highlight-clear-all)
    (widen)
    )
  )

(defun hlcsr (&optional style)
  "Clear the given style from the region."
  (interactive (list (completing-read "Style: " lusk-highlight-style-completions
                                      nil t))) ;require match
  (lusk-highlight-clear style t)
  )

(provide 'lusk-highlight)
