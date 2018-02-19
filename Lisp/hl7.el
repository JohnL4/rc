;; Macros for editing HL7 records.
;;
;; Basically, just highlights given fields.
;;
;; CONFIGURATION
;; -------------
;;
;; Edit a lisp file.  See hl7-config.el, for example.  At a
;; minimum, you need to define `hl7-field-specs'.  Basically, you need to
;; specify the segment identifiers, and what fields (numeric index) you edit
;; in the segments.  Whitespace isn't important, but quotes and parentheses
;; ARE.  (Note that single quotes don't necessarily occur in pairs.)
;;
;; USE
;; ---
;;
;; Once you've opened an HL7 message for editing, hit the ESCAPE key, then the
;; "x" key, then type "hl7" and hit ENTER.  You should be prompted for a
;; configuration file to use.  Type in the name of the one you want, and hit
;; ENTER.
;;
;; After that, you can hit F5 to refresh the display (it'll get a bit goofed
;; up as you edit), or shift-F5 to re-highlight with a different config file.
;; (You'll also have to use shift-F5 if you change the config file and want to
;; re-read it.)
;;
;; ASSUMPTIONS
;; -----------
;;
;; Field delimiters are specifed immediately after "(vertical-tab)MSH"
;; occurring at the beginning of a line.
;;
;; Segments are terminated by line terminators.
;;
;; MINIMAL EMACS KNOWLEDGE
;; -----------------------
;;
;; Arrow keys work.  Page Up/Down works.
;;
;; UNDO -- ctrl-/    (There's a gotcha here [mode switch to "redo" after
;;                      cursor movement], but you probably won't find it
;;                      for a while.)
;; ABORT -- ctrl-g   (Use this to bail out of some half-completed command,
;;                      like when the minibuffer says "M-x" and it's waiting
;;                      for you type a command.)
;; To delete an entire line:  hit Home, then ctrl-K (kill line).
;;
;; When opening/saving files, "~" is your home directory (HOME environment
;; variable).  But also, you can drag a file from Windows Explorer onto an
;; existing emacs window to open it.
;;
;; Tab-completion works for filenames.  When there's more than one
;; possibility, emacs will give you a list of choices.  Use the mouse to put
;; the cursor on the file you want and hit ENTER.
;;
;; APOLOGY FOR WHY EMACS IS SO FRIKKIN WEIRD
;; -----------------------------------------
;;
;; Emacs was born in the stone age, when the most advanced computer interface
;; we had was a 24-line, 80-column dumb terminal, and Unix was a new
;; invention.  A long time after X Windows was invented (for Unix), emacs got
;; a GUI grafted onto it.  A long time after MS-Windows was invented, emacs
;; (with its X Windows style GUI) was ported to MS-Windows.  The result is
;; parallel evolution, like the little space alien you meet who evolved
;; parallel to us:  he's got two legs and two arms and a head, but he's got
;; six fingers and three eyes, and, man, is he weird-looking.  All that lovely
;; Win32 file-chooser dialog box stuff is just GONE.
;;
;; COLORS
;; ------
;;
;; The highlighting colors are defined in this file, in the "defface"
;; sections.  The simplest way to pick different colors is to hit the ESCAPE
;; key (just once) and then the "x" key, then type "list-colors-display" and
;; hit ENTER.  Then, find the name of a color you like and replace the
;; background colors below (e.g., "#dfd0ff") with the name of the color you
;; want to try (e.g., "honeydew").
;;
;; If you don't like the named colors available (and they can be suprisingly
;; limiting), roll your own as hexadecimal RGB triples preceded with a "#".
;; The easiest way to get this is to use some Windows color chooser that gives
;; you red, green and blue (probably in decimal).  Then use the Windows
;; calculator in scientific mode to convert to hex.
;;
;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/hl7.el,v 1.6 2002/06/07 17:56:36 J80Lusk Exp $

(defvar hl7-field-specs nil
  "*A list of HL7 FIELD-SPECs to highlight.  FIELD-SPEC has form
(FIELD-SPEC-REGEXP FIELD-INDEXES), where FIELD-INDEXES is one or more integer
field offsets from the beginning of the segment matching the regexp.  For
example:

   '(
     (\"PID\" 2 4 7)
     (\"PV1\" 3 6 9)
     )
")

(defface hl7-highlight-face
  '(
    (((background light)) (:background "#dfd0ff"
                           :bold t))
    (((background dark)) (:background "gray80" :bold t))
    (t (:bold t :inverse-video t))
    )
  "*Highlights interesting fields of an HL7 record")

(defface hl7-delimiter-highlight-face
  '(
    (((background light)) (:background "#dfd0ff"
                           :foreground "red"
                           :bold t))
    (((background dark)) (:background "gray80" :foreground "red" :bold t))
    (t (:bold t :inverse-video t))
    )
  "*Highlights delimiters between interesting fields of an HL7 record")

;;------------------------------  config ends  -------------------------------

(require 'regexp-extra)

(make-variable-buffer-local 'hl7-field-specs)
(make-variable-buffer-local 'hl7-field-delimiter)
(make-variable-buffer-local 'hl7-composite-field-delimiter)

(put 'hl7-highlight-category 'face 'hl7-highlight-face)
(put 'hl7-delimiter-highlight-category 'face 'hl7-delimiter-highlight-face)

(make-local-variable 'hl7-config-file)  ;Path to previously-used config file
                                        ;  for the current buffer.
(setq hl7-config-dir nil)               ;Most-recently-used directory of
                                        ;  config files.  Global on purpose.

(defun hl7 ()
  "*(The main driving function for this package.)  Perform highlighting of HL7
data as specified by `config-file'."
  (interactive)
  (local-set-key [f5] 'hl7)
  (local-set-key [S-f5] 'hl7-new-config-and-highlight)
  (if (not (and (boundp 'hl7-config-file) hl7-config-file))
      (progn
        (setq hl7-config-file (read-file-name "HL7 config file: "
                                              hl7-config-dir))
        (setq hl7-config-dir (file-name-directory hl7-config-file))
        ))
  (load-file hl7-config-file)
  (hl7-config)                          ;should be defined in
                                        ;  hl7-config-file.
  (hl7-clear-and-highlight)
  )

(defun hl7-new-config-and-highlight ()
  (interactive)
  (setq hl7-config-file nil)
  (hl7)
  )

(defun hl7-clear-and-highlight ()
  "In current buffer, clear existing highlighting and scan, highlighting HL7
fields as specified by `hl7-field-specs'"
  (interactive)                         
  (if (and (boundp 'hl7-config-file) hl7-config-file)
      (progn
        (hl7-find-delimiters)
        (hl7-clear-highlighting)
        (let ((buffer-modified (buffer-modified-p)))
          (hl7-highlight hl7-field-specs)
          (set-buffer-modified-p buffer-modified)
          )
        )
    (call-interactively 'hl7)
    )
  )

(defun hl7-find-delimiters ()
  "Scan the contents of the current buffer in an attempt to discover what the
delimiters are for the current message."
  (save-excursion
    (goto-char (point-min))
    (search-forward-regexp "^MSH")    ;MSH == message header?
                                        ;Point is on field delimiter.  Next
                                        ;char is composite field delimiter,
                                        ;then repeating field delimiter.
    (setq hl7-field-delimiter (string (following-char)))
    (setq hl7-field-delimiter-re
          (concat (escape-regexp-special-chars hl7-field-delimiter)
                  "\\|$"))
    (forward-char)
    (setq hl7-composite-field-delimiter (string (following-char)))
    )
  )
  
(defun hl7-highlight (field-specs)
  "In current buffer, scan, highlighting HL7 fields."
  (if field-specs
      (save-excursion
        (goto-char (point-min))
        (let* ((field-spec (car field-specs))
               (segment-re (car field-spec))
               )
                                        ;Search for segment id occurring at
                                        ;beginning of line or possibly
                                        ;preceded by vertical tab (^K), in the
                                        ;case of the MSH (msg header)
                                        ;segment.
          (while (search-forward-regexp (concat "^?\\b" segment-re "\\b")
                                        nil t)
              (progn
                (beginning-of-line)
                (hl7-highlight-fields-of-one-line (cons 0 (cdr field-spec)))
                )
            )
          )
        (hl7-highlight (cdr field-specs))
        ))
  )

(defun hl7-highlight-fields-of-one-line (field-indexes)
  "Highlight the fields of the current line (segment).  (car field-indexes) is
the index of the field that point is currently at the beginning of.  (cadr
field-indexes) is index of next field to highlight."
  (if (> (length field-indexes) 1)
      (progn
        (let ((i 0)
              (n (- (cadr field-indexes) (car field-indexes)))
              field-start               ;Position of beginning of a field.
              )
          (while (< i n)
            (search-forward hl7-field-delimiter)
            (setq i (1+ i))
            )
                                        ;We're now on the first char of the
                                        ;  (possibly empty) field to be
                                        ;  highlighted.
          (setq field-start (point))
          (put-text-property (1- field-start) field-start
                             'category 'hl7-delimiter-highlight-category)
          (search-forward-regexp hl7-field-delimiter-re)
          (if (eolp)
              (put-text-property field-start (point)
                                 'category 'hl7-highlight-category)
                                        ;else...
            (put-text-property field-start (1- (point))
                               'category 'hl7-highlight-category)
            (put-text-property (1- (point)) (point)
                               'category 'hl7-delimiter-highlight-category)
            (goto-char field-start)
            )
          )
        (if (not (eolp))                ;Being at end-of-line stops us cold,
                                        ;  even if there are additional fields
                                        ;  to highlight.  (They don't exist
                                        ;  past end-of-line, so stop.)
            (hl7-highlight-fields-of-one-line (cdr field-indexes)))
        )
    )
  )
    

(defun hl7-clear-highlighting ()
  "Clear highlighting in current buffer.  Currently, I think this blasts ALL
text properties."
  (let ((buffer-modified (buffer-modified-p)))
    (remove-text-properties (point-min) (point-max) '(category nil))
    (set-buffer-modified-p buffer-modified)
    )
  )

;; $Log: hl7.el,v $
;; Revision 1.6  2002/06/07 17:56:36  J80Lusk
;; *** empty log message ***
;;
;; Revision 1.5  2002/06/07 17:38:54  J80Lusk
;; *** empty log message ***
;;
;; Revision 1.4  2002/06/07 17:32:29  J80Lusk
;; *** empty log message ***
;;
;; Revision 1.3  2002/06/07 16:49:33  J80Lusk
;; doc changes
;;
;; Revision 1.2  2002/06/07 13:48:28  J80Lusk
;; vc keywords
;;
