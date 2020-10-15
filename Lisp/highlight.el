;; Functions to highlight text by regexp.
;;
;; USAGE:
;;
;; Add the following to your .emacs:
;;
;;    (autoload 'hls "highlight" "Highlight a regexp" t)
;;    (autoload 'hlc "highlight" "Clear highlighting set with `hls'" t)
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
;;
;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/highlight.el,v 1.12 2003/12/10 15:35:33 J80Lusk Exp $


(defvar highlight-styles
  '("yellow" "orange" "cyan" "red" "purple" "green" "blue" "dodger" "gray" "maroon" "black" "brown"
                                        ; pastels
    "pyellow" "porange" "pcyan" "pink" "pgreen" "pblue"
    )
  "*Abbreviated names of highlight styles.  Make these whatever you want, but
if you change the faces, you might want to change their names appropriately.")

(defface highlight-yellow-face
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

(defface highlight-green-face
  '(
    (((background light)) (:background "green" :bold t))
    (((background dark)) (:background "green4" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style green")

(defface highlight-cyan-face
  '(
    (((background light)) (:background "cyan" :bold t))
    (((background dark)) (:background "cyan4" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style cyan")

(defface highlight-dodger-face
  '(
    (((background light)) (:background "#0096ff" :foreground "white" :bold t))
    (((background dark)) (:background "#0096ff" :foreground "white" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style Dodger blue")

(defface highlight-blue-face
  '(
    (((background light)) (:background "blue" :foreground "white" :bold t))
    (((background dark)) (:background "blue3" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style blue")

(defface highlight-purple-face
  '(
    (((background light)) (:background "purple" :foreground "white" :bold t))
    (((background dark)) (:background "purple3" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style purple")

(defface highlight-maroon-face
  '(
    (((background light)) (:background "maroon1" :bold t))
    (((background dark)) (:background "maroon1" :bold t))
    )
  "*Highlight style maroon")

(defface highlight-red-face
  '(
    (((background light)) (:background "red" :foreground "white" :bold t))
    (((background dark)) (:background "red3" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style red")

(defface highlight-orange-face
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

(defface highlight-brown-face
  '(
    (((background light)) (:background "SaddleBrown" :foreground "white"))
    (((background dark)) (:background "SaddleBrown"))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style brown")

(defface highlight-black-face
  '(
    (((background light)) (:background "black" :foreground "white" :bold t))
    (((background dark)) (:background "gray30" :bold t))
    (t (:inverse-video t :bold t))
    )
  "*Highlight style black")

(defface highlight-gray-face
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

;;-----------------------------------------------------  pastels  ------------------------------------------------------

(defface highlight-porange-face
  '(
    (((background light)) (:background "#ffcc99"))
    (((background dark)) (:background "#ffcc99"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel orange")

(defface highlight-pyellow-face
  '(
    (((background light)) (:background "#ffff99"))
    (((background dark)) (:background "#ffff99"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel yellow")

(defface highlight-pcyan-face
  '(
    (((background light)) (:background "#ccffff"))
    (((background dark)) (:background "#ccffff"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel cyan")

(defface highlight-pink-face
  '(
    (((background light)) (:background "#ffcccc"))
    (((background dark)) (:background "#ffcccc"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel red (pink)")

(defface highlight-pgreen-face
  '(
    (((background light)) (:background "#ccffcc"))
    (((background dark)) (:background "#ccffcc"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel green")

(defface highlight-pblue-face
  '(
    (((background light)) (:background "#ccccff"))
    (((background dark)) (:background "#ccccff"))
    (t (:inverse-video t))
    )
  "*Highlight style pastel blue")


;;------------------------------  config ends  -------------------------------

(defun highlight-setup (styles)
  "Called once during initialization."
  (if styles
      (progn
        (let* ((style (car styles))
               (face (intern (format "highlight-%s-face" style)))
               (category (highlight-category-from-style style))
               )
          (put category 'face face)
          (setq highlight-style-completions
                (cons (cons style style)
                      highlight-style-completions))
          )
        (highlight-setup (cdr styles))
        )
      )
  )

(defun highlight-regexp (regexp style)
  "Highlight all occurrences of the given regexp w/the given face."
  (interactive (list
                (read-string "Regexp: ")
                (completing-read "Style: " highlight-style-completions nil t)
                 ))
  (let ((category (highlight-category-from-style style))
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

(defun highlight-clear-all ()
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
                          
(defun highlight-clear (style &optional confine-to-region)
  "UNIMPLEMENTED.  Clear highlighting of the given style.  If
`confine-to-region' is true, highlighting is only cleared w/in the current region."
  (interactive (list (completing-read "Style: " highlight-style-completions
                                      nil t) ;require match
                     (y-or-n-p "Confine to region? ")
                     ))
  (let ((category (highlight-category-from-style style))
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
    

(defun highlight-category-from-style (style)
  "Return the category for the given style."
  (intern (format "highlight-%s-category" style)))

;;-----------------------------  initialization  -----------------------------

(setq highlight-style-completions nil)
(highlight-setup highlight-styles)

(defun hls ()
  "Highlight SET abbrev."
  (interactive)
  (call-interactively 'highlight-regexp)
  )

(defun hlsr (regexp style)
  "Highlight SET wrapper, narrowed to region."
  (interactive (list
                (read-string "Regexp: ")
                (completing-read "Style: " highlight-style-completions nil t)
                 ))
  (save-restriction
    (narrow-to-region (point) (mark))
    (highlight-regexp regexp style)
    (widen)
    )
  )

(defun hlc ()
  "Highlight CLEAR abbrev."
  (interactive)
  (highlight-clear-all)
  )

(defun hlcr ()
  "Highlight CLEAR abbrev, narrowed to region."
  (interactive)
  (save-restriction
    (narrow-to-region (point) (mark))
    (highlight-clear-all)
    (widen)
    )
  )

(defun hlcsr (&optional style)
  "Clear the given style from the region."
  (interactive (list (completing-read "Style: " highlight-style-completions
                                      nil t))) ;require match
  (highlight-clear style t)
  )

(provide 'highlight)

;; $Log: highlight.el,v $
;; Revision 1.12  2003/12/10 15:35:33  J80Lusk
;; Cleanup cygwin buffering stoopidity.
;;
;; Revision 1.11  2003/11/07 15:32:30  J80Lusk
;; Add highlight count to highlight-regexp.
;;
;; Revision 1.10  2003/05/23 17:38:35  J80Lusk
;; highlighting w/in a region, only.
;;
;; Revision 1.9  2002/12/30 23:00:42  J80Lusk
;; Add gray.
;;
;; Revision 1.8  2002/09/19 13:54:32  J80Lusk
;; Add orange style.
;;
;; Revision 1.7  2002/07/18 13:23:01  J80Lusk
;; Blue style.
;;
;; Revision 1.6  2002/07/01 13:05:50  J80Lusk
;; Merge in changes from home.
;;
;; Revision 1.5  2002/06/14 19:14:54  J80Lusk
;; *** empty log message ***
;;
;; Revision 1.4  2002/06/14 19:10:10  J80Lusk
;; Another caveat about interaction w/font-lock.
;;
;; Revision 1.3  2002/06/14 19:00:38  J80Lusk
;; Highlight read-only buffers.
;;
;; Revision 1.2  2002/06/14 18:31:36  J80Lusk
;; Add VC keywords.
;;
