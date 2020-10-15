;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/journal.el,v 1.35 2003/05/23 17:39:09 J80Lusk Exp $

;;; Usage notes:
;;;
;;; When ending an entry, you only need to specify the phase, not the rest of
;;; the classification tags.

;;; `journal-append-new-entry' is where the journal file is first loaded, in case you want to set mode variables there.

;;; (require 'debug-log)

                                        ;TODO:  store classification tree at top (or bottom, as local variables) of
                                        ;  file, along with the date/time of the last good line of data contributing to
                                        ;  that tree.  No changes above that line will be visible, unless the entire
                                        ;  datafile is reparsed.

                                        ;Classification tags are tree-structured, for better autocomplete.  Something
                                        ;  like the following.  See tree.el for more details.
'( (task-1 (subtask-1A subsubtask-1A1
                       subsubtask-1A2)
           subtask-1B
           (subtask-1C subsubtask-1C1)
           )
   (task-2 subtask-2A subtask-2B subtask-2C)
   )

(require 'lusk-tree)

;; Function required by (defvar journal-dir ...) below.
(defun journal-home ()
  "Cross-platform way to get the user's home path (I hope)"
  (if (and (getenv "HOMEPATH") (< 0 (length (getenv "HOMEPATH"))))
      (concat (getenv "HOMEDRIVE") (getenv "HOMEPATH")) ;Windows
    (getenv "HOME")                                     ;Everybody else
    )
  )

                                        ;Drive U: is the backed-up, private
                                        ;drive.
(defvar journal-dir (concat (journal-home) "/Documents/Journals") ; "C:/Personal/Journals"
  "*The directory where journal files will be stored.")

(defvar journal-phases '("in - interrupt"
                         "ad - administrative"
                         "mt - meeting"
                         "rs - research"
                         "ds - design"
                         "if - infrastructure (code or otherwise technical)"
                         "cd - code"
                         "cp - compile" 
                         "te - test"
                         "db - debug"
                         "dc - documentation"
                         "dv - development (might encompass ds, if, cd, cp, te, db, dc)"
                         "cr - code review (usually of somebody else's code)"
                         "pm - post mortem"
                         "df - defect"
                         "op - operations (e.g., deploy, configure, etc.)"
                         )
  "Non-exchaustive list of possible phases in an entry.  First word must be unique."
  )

(defvar journal-header
  (concat
   "-- 'evalpplog' entry format:\n"
   "--    <timestamp> <event-type> <phase-name> <classification-tags> [-- comment>]\n"
   "-- <event-type> ::= \"b\" | \"e\"\n"
   "--    (Begin | End)\n"
   "-- <phase-name> ::= (one of the following, or arbitrary text)\n"
   "--    ad - administrative\n"
   "--    mt - meeting\n"
   "--    rs - research\n"
   "--    ds - design\n"
   "--    if - infrastructure (code or otherwise technical)\n"
   "--    cd - code\n"
   "--    cp - compile\n"               ;Probably important for big, slow compiles, like system builds and card decks,
                                        ;etc., but not so much these days.
   "--    te - test\n"
   "--    db - debug\n"
   "--    dc - documentation\n"
   "--    cr - code review (usually of somebody else's code)\n"
   "--    pm - post mortem\n"
   "--    df - defect\n"
   "--    in - interrupt\n"
   "-- (<classification-tags> is frequently the same as arbitrary text)\n"
   "\n"
   )
  "*Text to insert at top of every journal file")

(defun journal-filename (time)
  "*Return the name of the journal file, possibly based on time"
  (concat journal-dir "/journal.txt")
  )

(defvar journal-timestamp-granularity 'minutes
  "The granularity of journal timestamps.  Should be either 'minutes or 'seconds.")

(defun journal-timestamp (time)
  "*Journal timestamp for `time', as in `current-time'."
  (let ((format-string
        (cond ((eq 'minutes journal-timestamp-granularity) "%Y-%m-%d (%a) %H:%M")
              ((eq 'seconds journal-timestamp-granularity) "%Y-%m-%d (%a) %H:%M:%S")
              (t (error "Unexpected value of journal-timestamp-granularity: %S" journal-timestamp-granularity)))))
    (format-time-string format-string time) ;Added seconds for logging ("did such-and-such") while testing
                                        ;software
    )
  )

                                        ;journal-parse-timestamp is not really an easily-configurable thing, but if the
                                        ;user changes the timestamp format, he needs to teach journal how to parse the
                                        ;new format.

(defun journal-parse-timestamp (start end)
  "Parse timestamp between positions `start' and `end', returning
result in same format as `current-time'."
  (interactive)
  (save-excursion
    (goto-char start)
    (if (re-search-forward journal-timestamp-regexp end t)
        (encode-time
         0                              ;seconds
         (string-to-number (buffer-substring-no-properties (elt (match-data) 10) ;minutes
                                             (elt (match-data) 11)))
         (string-to-number (buffer-substring-no-properties (elt (match-data) 8) ;hour
                                             (elt (match-data) 9)))
         (string-to-number (buffer-substring-no-properties (elt (match-data) 6) ;day
                                             (elt (match-data) 7)))
         (string-to-number (buffer-substring-no-properties (elt (match-data) 4) ;month
                                             (elt (match-data) 5)))
         (string-to-number (buffer-substring-no-properties (elt (match-data) 2) ;year
                                             (elt (match-data) 3)))
         )))
  )

(defvar journal-timestamp-regexp
  "\\([0-9]+\\)-\\([0-9]+\\)-\\([0-9]+\\)\\s-+(...)\\s-+\\([0-9]+\\):\\([0-9]+\\)"
  "*Regular expression to match timestamps in journal files.  Many subexpressions to ease parsing.")

(defface journal-error-face
  '(
    (((class color) (background light))
     (:foreground "red" :background "yellow" :bold t))
    (((class color) (background dark))
     (:foreground "yellow" :background "red3" :bold t))
    (t
     (:bold t))
    )
  "*Face for highlighting errors in a journal file."
  )

;;-----------------------  end configuration  ------------------------

(defvar journal-entries nil
  "List of journal entries in physical order, as returned by `journal-parse-entry'.")

(defvar journal-classification-tags nil
  "List of lists of classification tags, for use in completion (tag 1, tag 2,
...).")

(defvar journal-classification-tree '(classification-tree)
  "Tree of classification tags, analogous to `journal-classification-tags',
but more discriminating in that tags appear in a subtree of a parent tag, so
auto-completion can present fewer choices (i.e., the set of subtags given when
a particular parent tag is chosen).")

(defun journal-indent ()
  "Override for `comment-indent-default` to be used as a value for `comment-indent-function` in journal buffers."
  (or (comment-indent-default)
      (save-excursion
        (forward-line -1)
        (beginning-of-line)
        (if (looking-at (concat ".*\\(" comment-start "\\)"))
            (- (match-beginning 1) (point)))
        )
      )
  )

(defun journal-begin-new-entry (time)
  "*Begin a new jounal entry at point.  (Inserts timestamp and sets
fill-prefix.)"
  (insert (journal-timestamp time))
  (insert " ")
  (setq fill-prefix (make-string
                     (save-excursion
                       (let ((cur (point)))
                         (beginning-of-line)
                         (- cur (point))
                         ))
                     ?\x20))
  )

(defun journal-append-new-begin-entry ()
  (interactive)
  (journal-append-new-entry "b"))

(defun journal-append-new-end-entry ()
  (interactive)
  (journal-append-new-entry "e"))

(defun journal-append-new-entry (&optional begin-or-end)
  "*Append a new journal entry at the bottom of the journal buffer.
BEGIN-OR-END is a string (expected to be \"b\" or \"e\"), default \"b\"."
  (interactive)
  (let ((cur-time (current-time))
        (buffer-is-new nil)
        )
    (if (not (get-file-buffer (journal-filename cur-time)))
        (setq buffer-is-new t))
    (find-file (journal-filename cur-time))
    (if buffer-is-new
        (progn                          ;TODO: should probably make this buffer initialization stuff a separate
                                        ;function.
          (local-set-key [f7] 'journal-scan-new-and-highlight-errors)
          (local-set-key [S-f7] 'journal-scan-all-and-highlight-errors)
          (local-set-key [f6] 'journal-clear-error-highlighting)
          (local-set-key [S-f6] 'bury-buffer)

          ;;(setq fill-column 78)

          (setq comment-start "-- ")
          (setq comment-start-skip "--\\s-*")
          ;;(setq comment-multi-line t)
          (setq comment-column 32)
          (setq comment-indent-function 'journal-indent)

          (auto-fill-mode 1)
          (subword-mode 1)              ;Move by case boundary in words.
          )
      )
    (goto-char (point-max))
    (if (bobp)
        (progn
          (insert journal-header)
          )
      )
                                        ;Before we start slapping stuff in,
                                        ;make sure we have a parse, so lazy
                                        ;parsing doesn't parse a
                                        ;half-constructed entry.
    (journal-scan-new)
    
    (if (not (bolp))
        (insert ?\n))
    (journal-begin-new-entry cur-time)
    (insert (or begin-or-end "b"))
    (insert " ")
    (if (equal "e" begin-or-end)
        (insert (or (journal-most-recent-open-phase (reverse journal-entries) nil)
                    "in -- (no unmatched beginnings found)"))
      (insert (car (split-string
                    (completing-read "Phase: "
                                     journal-phases
                                     nil ;Default predicate
                                     nil ;Match not required
                                     "in"
                                     ))))
      ;; Only insert classification tags for 'begin entries, although this is easy enough to change later if desired.
      (insert " ")
      (journal-insert-tags)
      )
    )
  )

(defun journal-most-recent-open-phase (reversed-journal-entries unmatched-ends)
  "Return the most recent phase which is not closed. `reversed-journal-entries' is as the global variable
  `journal-entries`, a list of entries returned by `journal-parse-entry' in REVERSED physical order in the file.
  `unmatched-ends' is a list of unmatched 'end' entries, in physical order in which they occur in the file."
  ;; Let's try some flat-out recursion here.  Hopefully not too horrible (does emacs-lisp do tail recursion)?
  (if (null reversed-journal-entries)
      nil
    (if (eq 'begin (cdr (assoc 'event-type (car reversed-journal-entries))))
        (if (null unmatched-ends)
            ;; Found an unmatched 'begin
            (cdr (assoc 'phase (car reversed-journal-entries)))
          ;; Else this begin is (presumably) matched by the top of the unmatched ends, so pop 'em both and continue.
          (journal-most-recent-open-phase (cdr reversed-journal-entries) (cdr unmatched-ends)))
      ;; Else, this is an end (presumably), so push it onto unmatched-ends and continue
      (journal-most-recent-open-phase (cdr reversed-journal-entries) (cons (car reversed-journal-entries) unmatched-ends)))
    )
  )

(defun journal-insert-tags ()
  "Insert classification tags at point, prompting user w/completing reads."
  (save-excursion
    (let ((classification-tags journal-classification-tags)
	  (classification-tree journal-classification-tree)
          (user-tag "DUMMY-TAG")
          )
;;;      (if (null classification-tags)
;;;          (progn
;;;            (if (null journal-entries)
;;;                (setq journal-entries (journal-parse-all-entries)))
;;;            (setq journal-classification-tags
;;;                  (journal-get-classification-tags journal-entries))
;;;            (setq classification-tags journal-classification-tags)
;;;	    )
;;;	)
      (if (>= 1 (length classification-tree))
	  (progn
            (if (null journal-entries)
                (setq journal-entries (journal-parse-all-entries)))
            (setq journal-classification-tree
                  (journal-get-classification-tree journal-entries))
            (setq classification-tree journal-classification-tree)
	    ))
      (while (not (string= "" user-tag))
        (setq user-tag
              (completing-read
               "Classification tag: "
               ;; (car classification-tags)
	       (journal-child-tag-completions classification-tree)
	       ))
        (if (not (string= "" user-tag))
	    (progn
	      (insert user-tag " ")
	      ;; (setq classification-tags (cdr classification-tags))
	      (setq classification-tree (assq (intern user-tag
						      journal-tag-obarray) 
					      classification-tree))
	      )
	  )
        )
      )
    )
  )

(defun journal-child-tag-completions (tree)
  "Returns a completion list of the 1st-level children of `tree'."
  (cond ((null tree)
	 nil)
	((atom tree)
	 nil)
	(t
	 (let ((children (cdr tree))
	       child
	       (completions nil)
	       )
	   (while children
	     (setq child (car children))
	     (if (listp child)
					;Child is in a list because it has
					;2nd-level subchildren.  We just want
					;the 1st-level child node itself, so
					;we extract it from the list.
		 (setq child (car child))
					;(Otherwise, it's an atom, so it's
					;effectively already extracted.)
	       )
	     (setq completions (cons (cons (symbol-name child) child)
				     completions))
	     (setq children (cdr children))
	     )
	   completions			;retval
	   ))
	)
  )

(defun journal-maybe-append-newline ()
  "Add a newline to the end of the buffer if it doesn't already have
one.  Return non-nil iff a newline was added by this function."
  (save-excursion
    (goto-char (point-max))
      (if (not (bolp))
          (progn
            (insert ?\n)
            t))))
    
(defun journal-parse-entries ()
  "Returns a list of journal entries beginning with the current line."
  (let ((added-newline nil)
        (entries nil)
        entry
        (buffer-modified (buffer-modified-p))
        )
    (setq added-newline (journal-maybe-append-newline))
    (save-excursion
      (beginning-of-line)
                                        ;Ensure that point is at the
                                        ;beginning of an entry, to
                                        ;prevent incorrect entry size
                                        ;for first entry returned.
      (if (re-search-forward journal-timestamp-regexp nil t)
          (progn
            (beginning-of-line)
            (while (< (point) (point-max))
              (setq entry (journal-parse-entry))
              (setq entries (cons entry entries))
              (forward-line (cdr (assq 'entry-size-lines entry)))
              )
            (if added-newline
                (progn
                  (goto-char (point-max))
                  (backward-delete-char 1)
                  (set-buffer-modified-p buffer-modified)
                  ))
            (reverse entries)
            )
        nil)
      )
    )
  )
    
(defun journal-parse-all-entries ()
  "Returns a list of all journal entries in the current buffer."
  (save-excursion
    (goto-char (point-min))
    (journal-parse-entries)
  ))

(defun journal-move-past-last-parsed-entry (entries)
  "Move point to the line following the last parsed entry in ENTRIES."
  (let ((last-entry (elt entries (1- (length entries)))))
    (if last-entry 
        (progn
          (goto-line (cdr (assq 'line-number last-entry)))
          (forward-line (cdr (assq 'entry-size-lines last-entry)))
          ))))

(defun journal-parse-new-entries (entries)
  "Returns list of entries after the last entry in ENTRIES (by line
number)."
  (save-excursion
    (if (null entries)
        (goto-char (point-min))
      (journal-move-past-last-parsed-entry entries))
    (if (< (point) (point-max))
        (journal-parse-entries))
    )
  )

(defun journal-get-classification-tags (entries)
  "Returns list of lists of classification tags in ENTRIES.  Each list is the
list of tags that appear in the corresponding position of all the entries.  In
other words, list 1 is all tags that appear in position 1 in the entries, list
2 is all tags that appear in position 2 in the entries, etc."
  (let (old-list-of-lists
        new-list-of-lists
        classification-tag-list
        entry-tags
        i)
    (while entries
      (setq entry-tags (cdr (assq 'classification-tags (car entries))))
      (setq new-list-of-lists nil)
      (while entry-tags
        (setq classification-tag-list (car old-list-of-lists))
        (setq new-list-of-lists
              (cons (add-to-list 'classification-tag-list
                                 (cons (symbol-name (car entry-tags))
				       (car entry-tags)))
                    new-list-of-lists))
        (setq old-list-of-lists (cdr old-list-of-lists))
        (setq entry-tags (cdr entry-tags))
        )
      (setq old-list-of-lists (append (reverse new-list-of-lists)
                                      old-list-of-lists))
      (setq entries (cdr entries))
      )
    old-list-of-lists
    )
  )

(defun journal-get-classification-tree (entries)
  "Returns tree of classification tags.  ``Root'' node is nil.  1st level of
tree is all tags occurring in 1st position of each entry.  2nd level of tree
is all tags occurring in 2nd position of each entry.  Parent of node is
classification tag appearing before that tag in entry."
  (let ((tag-tree (list 'classification-tags))	;Arbitrary root element
	entry
	(me "journal-get-classification-tree")
        )
;;;    (dbg (format "%s: tag-tree = %S, entries = %S" me tag-tree entries))
    (while entries
      (setq entry (car entries))
      (setq entry-tags (assq 'classification-tags entry))
;;;      (dbg (format "%s: merge tags from entry on line %d: %S"
;;;		   me
;;;		   (cdr (assq 'line-number entry))
;;;		   (assq 'classification-tags entry)
;;;		   ))
;;;      (dbg (format "journal-get-classification-tree: Calling tree-merge."))
      (tree-merge tag-tree (tree-from-list entry-tags))
      (setq entries (cdr entries))
      )
    tag-tree
    )
  )

(defun journal-highlight-errors-parsed (entries)
  "Highlight errors based on a previous parse stored in ENTRIES."
  (let (event-stack
        timestamp
        prev-timestamp
        entry-parse
        (buffer-modified (buffer-modified-p))
        )
    (save-excursion
      (goto-line (cdr (assq 'line-number (car entries))))
      (while (< (point) (point-max))
        (setq entry-parse (car entries))
        (setq entries (cdr entries))
        (setq timestamp (cdr (assq 'timestamp entry-parse)))
        (if (and (not (null prev-timestamp))
                 (not (null timestamp))
                 (journal-later prev-timestamp timestamp))
            (progn (journal-highlight-timestamp-error)))
        (cond
         ((eq 'begin (cdr (assq 'event-type entry-parse)))
          (setq event-stack (cons entry-parse event-stack)))
         ((eq 'end (cdr (assq 'event-type entry-parse)))
          (if (journal-match-stack entry-parse event-stack)
              (setq event-stack (cdr event-stack))
            (progn (journal-highlight-stack-mismatch))))
         (t (journal-highlight-event-type-error))
         )
        (setq prev-timestamp timestamp)
        (forward-line (cdr (assq 'entry-size-lines entry-parse)))
        )
      (while event-stack
        (goto-line (cdr (assq 'line-number (car event-stack))))
        (journal-highlight-unterminated-entry (car event-stack))
        (setq event-stack (cdr event-stack))
        )
      (set-buffer-modified-p buffer-modified)
      )
    )
  )

;;; (defun journal-highlight-errors-all (entries)
;;;   "*Highlight errors (unbalanced entries, unrecognized event types,
;;; out-of-order timestamps, etc.)."
;;;   (interactive)
;;;   (journal-clear-error-highlighting)
;;;   (setq journal-entries (journal-parse-all-entries))
;;;   (journal-highlight-errors-parsed)
;;;   )

;;; (defun journal-highlight-errors-new ()
;;;   "Highlight errors as in `journal-highlight-errors-all'.  As a side effect,
;;; parse only entries added since last parse, and update `journal-entries'."
;;;   (interactive)
;;;   (journal-clear-error-highlighting)
;;;   (journal-parse-new-entries)
;;;   (journal-highlight-errors-parsed)
;;;   )

(defun journal-highlight-errors-old (&optional use-region)
  "*OLD CODE.  Highlight errors (unbalanced entries, unrecognized event types,
out-of-order timestamps, etc.).  If `use-region' is non-nil, work only in the
region.  Partial lines included in the region will be operated on."
  (interactive "P")
  (let (
        event-stack
        timestamp                       ;of this entry
        prev-timestamp                  ;of previous entry
        entry-parse                     ;parsed entry
        added-newline
        (buffer-modified (buffer-modified-p))
        my-journal-entries
        )
    (setq added-newline (journal-maybe-append-newline))
    (save-excursion
      (save-restriction
        (if use-region
            (journal-narrow-to-region-with-line-granularity))
        (goto-char (point-min))
        (journal-clear-error-highlighting)
        (while (< (point) (point-max))
          (setq entry-parse (journal-parse-entry))
          (setq timestamp (cdr (assq 'timestamp entry-parse)))
          (if (and (not (null prev-timestamp))
                   (not (null timestamp))
                   (journal-later prev-timestamp timestamp))
              (progn (journal-highlight-timestamp-error)))
          (cond
           ((eq 'begin (cdr (assq 'event-type entry-parse)))
            (setq event-stack (cons entry-parse event-stack)))
           ((eq 'end (cdr (assq 'event-type entry-parse)))
            (if (journal-match-stack entry-parse event-stack)
                (setq event-stack (cdr event-stack))
              (progn (journal-highlight-stack-mismatch))))
           (t (journal-highlight-event-type-error))
           )
          (setq prev-timestamp timestamp)
          (forward-line (cdr (assq 'entry-size-lines entry-parse)))
          )
        )
      (if added-newline
          (progn
            (goto-char (point-max))
            (backward-delete-char 1)
            (set-buffer-modified-p buffer-modified)
            ))
      (while event-stack
        (goto-line (cdr (assq 'line-number (car event-stack))))
        (journal-highlight-unterminated-entry (car event-stack))
        (setq event-stack (cdr event-stack))
        )
;;;       (if (not (null event-stack))
;;;           (progn
;;;             (goto-char (point-max))
;;;             (if (not (bolp)) (insert ?\n))
;;;             (insert "\nUnterminated entries:\n\n")
;;;             (insert (pp event-stack))
;;;             ))
      )
    )
  )

(defun journal-later (ts-a ts-b)
  "Return non-nil if timestamp `ts-a' is later than `ts-b'."
  (or (> (car ts-a) (car ts-b))
      (and (= (car ts-a) (car ts-b))
           (> (cadr ts-a) (cadr ts-b))))
  )

(defun journal-parse-entry ()
  "Parse current journal entry (beginning on line containing point)
into an alist (returned as function value) with the following keys:

   `line-number' is line number where event starts;
   `timestamp' is event time a la `current-time';
   `event-type' is either 'begin or 'end or nil;
   `phase' is the first word after event-type;
   `classification-tags' is all words after phase (up to comment);
   `entry-size-lines' is number of lines in entry."
  (interactive)
  (let (parse
        event-type-text
        entry-start
        )
    (save-excursion
      (beginning-of-line)
      (setq entry-start (point))
                                        ;line-number
      (setq parse (cons (cons 'line-number (1+ (count-lines 1 (point))))
                        parse))
                                        ;skip leading comments, blank lines.
      (catch 'stuck
        (while (looking-at "\\s-*\\(--\\|\\s-*$\\)")
          (if (= 1 (forward-line 1))
              (throw 'stuck nil))
          ))
                                        ;timestamp
      (if (re-search-forward journal-timestamp-regexp (point-max) t)
          (setq parse (cons (cons 'timestamp
                                  (journal-parse-timestamp
                                   (elt (match-data) 0) ;start of match
                                   (elt (match-data) 1))) ;end of match
                            parse)))
                                        ;event-type
      (if (re-search-forward "\\s-+\\(\\sw+\\)" (point-max) t)
          (progn
            (setq event-type-text
                  (downcase (buffer-substring-no-properties
                             (elt (match-data) 2) ;subexpr 1 start
                             (elt (match-data) 3)))) ;subexpr 1 end
            (setq parse (cons (cons 'event-type
                                    (cond ((equal "b" event-type-text)
                                           'begin)
                                          ((equal "e" event-type-text)
                                           'end)
                                          (t nil)))
                              parse))))
                                        ;phase
      (if (re-search-forward "\\s-+\\(\\sw+\\)" (point-max) t)
          (setq parse (cons (cons 'phase
                                  (buffer-substring-no-properties
                                   (elt (match-data) 2)
                                   (elt (match-data) 3)))
                            parse)))
                                        ;classification-tags, to end
                                        ;of first line.
      (let (classification-tags
            (saw-comment nil))
        (while (looking-at "[ \t]+\\(\\([^-\n]\\|-[^-\n]\\)*\\)\\(--.*\\)?-?$")
          (let ((mb1 (match-beginning 1))
                (mb2 (match-beginning 2))
                (mb3 (match-beginning 3))
                (me1 (match-end 1))
                (me2 (match-end 2))
                (me3 (match-end 3)))
            (if (not saw-comment)
                (progn
                  (setq classification-tags
                        (append classification-tags
                                (mapcar (lambda (name)
					  (intern name journal-tag-obarray))
                                        (split-string
                                         (buffer-substring-no-properties
                                          (match-beginning 1)
                                          (match-end 1)
                                          )))
                                ))
                  (if mb3 (setq saw-comment t))
                  )
              )
            )
          (forward-line 1))
        (if classification-tags
            (setq parse (cons (cons 'classification-tags
                                    classification-tags)
                              parse)))
        )
      (setq parse (cons (cons 'entry-size-lines
                              (max 1 (count-lines entry-start (point))))
                        parse))
      )
    parse
    )
  )

(defun journal-match-stack (event-parse event-stack)
  "Returns non-nil if `event-parse' is an event matching the event on
the top of `event-stack'."
  (let ((top-parse (car event-stack))
        )
    (string= (cdr (assq 'phase event-parse))
             (cdr (assq 'phase top-parse))))
  )

(defun journal-narrow-to-region-with-line-granularity ()
  (save-excursion
    (let (
          start
          )
      (goto-char (region-beginning))
      (if (not (bolp))
          (beginning-of-line))
      (setq start (point))
      (goto-char (region-end))
      (narrow-to-region start (point))
      )
    )
  )

(defun journal-highlight-unterminated-entry (entry-parse)
  "Highlight an entire unterminated entry, starting w/beginning of
current line."
  (let (start
        )
    (save-excursion
      (beginning-of-line)
      (setq start (point))
      (forward-line (cdr (assq 'entry-size-lines entry-parse)))
      (put-text-property start (point) 'category 'journal-error-category)
      )
    )
  )

(defun journal-highlight-stack-mismatch ()
  "Set highlighting on phase on current line."
  (save-excursion
    (beginning-of-line)
    (re-search-forward (concat journal-timestamp-regexp
                               "\\s-+\\sw+")
                       (point-max)
                       t)
    (re-search-forward "\\s-+\\sw+\\s-*" (point-max) t)
    (put-text-property (elt (match-data) 0)
                       (elt (match-data) 1)
                       'category
                       'journal-error-category)
    )
  )

(defun journal-highlight-timestamp-error ()
  "Set highlighting on timestamp on current line."
  (interactive)
  (let (start
        )
    (save-excursion
      (beginning-of-line)
      (setq start (point))
      (re-search-forward journal-timestamp-regexp (point-max) t)
      (put-text-property start (point) 'category 'journal-error-category)
      )
    )
  )

(defun journal-highlight-event-type-error ()
  "Set highlighting on event type on current line."
  (interactive)
  (let (start
        )
    (save-excursion
      (beginning-of-line)
      (re-search-forward journal-timestamp-regexp (point-max) t)
      (setq start (point))
                                        ;highlight next word
      (re-search-forward "\\s-*\\S-+\\s-*" (point-max) t)
      (put-text-property start (point) 'category 'journal-error-category)
      )
    )
  )

(defun journal-clear-error-highlighting ()
  "Clear error highlighting in journal.  Currently, I think this
blasts ALL text properties."
  (interactive)
  (let ((buffer-modified (buffer-modified-p)))
    (remove-text-properties (point-min) (point-max) '(category)) ;Note that
                                        ;copy-paste seems to screw up the
                                        ;'category property, preserving
                                        ;(xforming) only 'face.
    (set-text-properties (point-min) (point-max) nil) ;Brutal hack to address
                                        ;the fact that copying/pasting text in
                                        ;the journal converts the "category"
                                        ;property to a "face" property. :(
    (set-buffer-modified-p buffer-modified)
    )
  )

(defun journal-scan-all ()
  "Scan entire journal, storing parse in `journal-entries' and building
classifications into `journal-classification-tags'."
  (interactive)
  (setq journal-entries (journal-parse-all-entries))
;;;  (setq journal-classification-tags
;;;        (journal-get-classification-tags journal-entries))
  (setq journal-classification-tree
        (journal-get-classification-tree journal-entries))
  )

(defun journal-scan-new ()
  "Scan new entries in journal (entries after last entry in
`journal-entries'), updating `journal-entries' and
`journal-classification-tags'."
  (interactive)
  (let* ((entries (journal-parse-new-entries journal-entries))
;;;         (old-classification-tags journal-classification-tags)
;;;         (new-classification-tags (journal-get-classification-tags entries))
         (old-classification-tree journal-classification-tree)
         (new-classification-tree (journal-get-classification-tree entries))
	 (me "journal-scan-new")
         )
;;;    (let ((es entries)			;NEW entries
;;;	  )
;;;      (if es
;;;	  (while es
;;;	    (dbg (format "%s Entry at line %d, tags = %S"
;;;			 me
;;;			 (cdr (assq 'line-number (car es)))
;;;			 (cdr (assq 'classification-tags (car es)))
;;;			 ))
;;;	    (setq es (cdr es))
;;;	    )
;;;	(dbg "No new entries.")
;;;	)
;;;      )
;;;    (setq journal-classification-tags nil)
    (setq journal-classification-tree '(classification-tree))
;;;					;(Comment added much later.)  It looks
;;;					;  like I was merging two
;;;					;  lists-of-lists, to keep the
;;;					;  invariant declared in the comments
;;;					;  for
;;;					;  `journal-get-classification-tags'.
;;;    (while (or old-classification-tags
;;;               new-classification-tags)
;;;					;TODO: need to figure out how to get
;;;					;  journal-classification-tree here.
;;;      (setq journal-classification-tags
;;;            (cons (append (car new-classification-tags)
;;;                          (car old-classification-tags))
;;;                  journal-classification-tags))
;;;      (setq old-classification-tags (cdr old-classification-tags))
;;;      (setq new-classification-tags (cdr new-classification-tags))
;;;      )
;;;    (setq journal-classification-tags (reverse journal-classification-tags))
    (let ((old-size (tree-size old-classification-tree))
	  (new-size (tree-size new-classification-tree))
	  )
;;;      (dbg (format "journal-scan-new: Calling tree-merge.  old-size = %-6d, new-size = %-6d" old-size new-size))
      (if (< old-size new-size)
	  (progn
	    (message "Warning: journal-scan-new switching order of params to `tree-merge'.  Side effects may screw things up.")
	    (setq journal-classification-tree
		  (tree-merge new-classification-tree
			      old-classification-tree))
	    )
	(setq journal-classification-tree
	      (tree-merge old-classification-tree
			  new-classification-tree))
	)
      )
    (setq journal-entries (append journal-entries entries))
    )
  )

(defun journal-scan-new-and-highlight-errors ()
  "Scan, then highlight errors."
  (interactive)
  (journal-scan-new)
  (journal-clear-error-highlighting)
  (journal-highlight-errors-parsed journal-entries)
  )

(defun journal-scan-all-and-highlight-errors ()
  "Scan, then highlight errors."
  (interactive)
  (journal-scan-all)
  (journal-clear-error-highlighting)
  (journal-highlight-errors-parsed journal-entries)
  )

;;-----------------------------  initialization  -----------------------------

(global-set-key [f8] 'journal-append-new-begin-entry)
(global-set-key [S-f8] 'journal-append-new-end-entry)

(put 'journal-error-category 'face
     'journal-error-face
     )

(setq journal-tag-obarray (make-vector 1023 0))

(provide 'journal)

;; (setq edebug-all-defs old-edebug-all-defs)

;;----------------------------------  Log  -----------------------------------

;; $Log: journal.el,v $
;; Revision 1.35  2003/05/23 17:39:09  J80Lusk
;; Minor usage note.
;;
;; Revision 1.34  2002/07/26 13:14:46  J80Lusk
;; Doc changes, new TODOs.
;;
;; Revision 1.33  2002/07/18 13:34:17  J80Lusk
;; Finally, got tree-based classification tag completion working!
;; This is the initial checkin before I start "fixing" bugs.
;;
;; Revision 1.5  2002/07/17 03:19:35  john
;; Finally appears to be working.
;; Cleaned out references (unecessary, I hope) to the old
;; journal-classification-tags, which I hope will speed things up.
;;
;; Revision 1.4  2002/06/30 05:03:19  john
;; Fleshed out journal-get-classification-tree.
;;
;; Revision 1.3  2002/06/15 18:55:25  john
;; Store classification tags as symbols instead of strings.  This will
;; allow faster processing into tree.
;;
