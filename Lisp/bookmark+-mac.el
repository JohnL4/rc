;;; bookmark+-mac.el --- Macros for Bookmark+.
;; 
;; Filename: bookmark+-mac.el
;; Description: Macros for Bookmark+.
;; Author: Drew Adams
;; Maintainer: Drew Adams
;; Copyright (C) 2000-2011, Drew Adams, all rights reserved.
;; Created: Sun Aug 15 11:12:30 2010 (-0700)
;; Last-Updated: Fri Apr  1 16:24:04 2011 (-0700)
;;           By: dradams
;;     Update #: 78
;; URL: http://www.emacswiki.org/cgi-bin/wiki/bookmark+-mac.el
;; Keywords: bookmarks, bookmark+, placeholders, annotations, search, info, url, w3m, gnus
;; Compatibility: GNU Emacs: 20.x, 21.x, 22.x, 23.x
;; 
;; Features that might be required by this library:
;;
;;   `bookmark', `pp'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;; 
;;    Macros for Bookmark+.
;;
;;    The Bookmark+ libraries are these:
;;
;;    `bookmark+.el'     - main (driver) library
;;    `bookmark+-mac.el' - Lisp macros (this file)
;;    `bookmark+-bmu.el' - code for the `*Bookmark List*' (bmenu)
;;    `bookmark+-1.el'   - other (non-bmenu) required code
;;    `bookmark+-lit.el' - (optional) code for highlighting bookmarks
;;    `bookmark+-key.el' - key and menu bindings
;;
;;    `bookmark+-doc.el' - documentation (comment-only file)
;;    `bookmark+-chg.el' - change log (comment-only file)
;;
;;    The documentation (in `bookmark+-doc.el') includes how to
;;    byte-compile and install Bookmark+.  The documentation is also
;;    available in these ways:
;;
;;    1. From the bookmark list (`C-x r l'):
;;       Use `?' to show the current bookmark-list status and general
;;       help, then click link `Doc in Commentary' or link `Doc on the
;;       Web'.
;;
;;    2. From the Emacs-Wiki Web site:
;;       http://www.emacswiki.org/cgi-bin/wiki/BookmarkPlus.
;;    
;;    3. From the Bookmark+ group customization buffer:
;;       `M-x customize-group bookmark-plus', then click link
;;       `Commentary'.
;;
;;    (The commentary links in #1 and #3 work only if you have library
;;    `bookmark+-doc.el' in your `load-path'.)
 
;;(@> "Index")
;;
;;  If you have library `linkd.el' and Emacs 22 or later, load
;;  `linkd.el' and turn on `linkd-mode' now.  It lets you easily
;;  navigate around the sections of this doc.  Linkd mode will
;;  highlight this Index, as well as the cross-references and section
;;  headings throughout this file.  You can get `linkd.el' here:
;;  http://dto.freeshell.org/notebook/Linkd.html.
;;
;;  (@> "Things Defined Here")
;;  (@> "Functions")
;;  (@> "Macros")
 
;;(@* "Things Defined Here")
;;
;;  Things Defined Here
;;  -------------------
;;
;;  Macros defined here:
;;
;;    `bmkp-define-cycle-command',
;;    `bmkp-define-next+prev-cycle-commands',
;;    `bmkp-define-sort-command', `bmkp-define-file-sort-predicate',
;;    `bmkp-menu-bar-make-toggle'.
;;
;;  Non-interactive functions defined here:
;;
;;    `bmkp-assoc-delete-all', `bmkp-replace-regexp-in-string'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;

(require 'bookmark)
;; bookmark-bmenu-bookmark, bookmark-bmenu-ensure-position,
;; bookmark-bmenu-surreptitiously-rebuild-list, bookmark-get-bookmark,
;; bookmark-get-filename

;; (eval-when-compile (require 'bookmark+-bmu))
;; bmkp-bmenu-barf-if-not-in-menu-list,
;; bmkp-bmenu-goto-bookmark-named, bmkp-sort-orders-alist

;; (eval-when-compile (require 'bookmark+-1))
;; bmkp-file-bookmark-p, bmkp-float-time, bmkp-local-file-bookmark-p,
;; bmkp-msg-about-sort-order, bmkp-reverse-sort-p, bmkp-sort-comparer
 
;;(@* "Functions")

;;; Functions --------------------------------------------------------

;;; These functions are general functions.  They are here because they are used in macro
;;; `bmkp-define-sort-command'.  That macro is in this file because it is used only to create
;;; bmenu commands.

;; Used in `bmkp-define-sort-command'.
(defun bmkp-assoc-delete-all (key alist)
  "Delete from ALIST all elements whose car is `equal' to KEY.
Return the modified alist.
Elements of ALIST that are not conses are ignored."
  (while (and (consp (car alist)) (equal (car (car alist)) key))  (setq alist  (cdr alist)))
  (let ((tail  alist)
        tail-cdr)
    (while (setq tail-cdr  (cdr tail))
      (if (and (consp (car tail-cdr))  (equal (car (car tail-cdr)) key))
          (setcdr tail (cdr tail-cdr))
        (setq tail  tail-cdr))))
  alist)

;; Used in `bmkp-define-sort-command'.
(defun bmkp-replace-regexp-in-string (regexp rep string &optional fixedcase literal subexp start)
  "Replace all matches for REGEXP with REP in STRING and return STRING."
  (if (fboundp 'replace-regexp-in-string) ; Emacs > 20.
      (replace-regexp-in-string regexp rep string fixedcase literal subexp start)
    (if (string-match regexp string) (replace-match rep nil nil string) string))) ; Emacs 20
 
;;(@* "Macros")

;;; Macros -----------------------------------------------------------

;;;###autoload
(defmacro bmkp-define-cycle-command (type &optional otherp)
  "Define a cycling command for bookmarks of type TYPE.
Non-nil OTHERP means define a command that cycles in another window."
  `(defun ,(intern (format "bmkp-cycle-%s%s" type (if otherp "-other-window" "")))
    (increment &optional startoverp)
    ,(if otherp
         (format "Same as `bmkp-cycle-%s', but use other window." type)
         (format "Cycle through %s bookmarks by INCREMENT (default: 1).
Positive INCREMENT cycles forward.  Negative INCREMENT cycles backward.
Interactively, the prefix arg determines INCREMENT:
 Plain `C-u': 1
 otherwise: the numeric prefix arg value 

Plain `C-u' also means start over at first bookmark.

In Lisp code:
 Non-nil STARTOVERP means reset `bmkp-current-nav-bookmark' to the
 first bookmark in the navlist." type))
    (interactive (let ((startovr  (consp current-prefix-arg)))
                   (list (if startovr 1 (prefix-numeric-value current-prefix-arg))
                         startovr)))
    (let ((bmkp-nav-alist  (bmkp-sort-and-remove-dups
                            (,(intern (format "bmkp-%s-alist-only" type))))))
      (bmkp-cycle increment ,otherp startoverp))))

;;;###autoload
(defmacro bmkp-define-next+prev-cycle-commands (type)
  "Define `next' and `previous' commands for bookmarks of type TYPE."
  `(progn
    ;; `next' command.
    (defun ,(intern (format "bmkp-next-%s-bookmark" type)) (n &optional startoverp)
      ,(format "Jump to the Nth-next %s bookmark.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkp-cycle-%s'." type type)
      (interactive (let ((startovr  (consp current-prefix-arg)))
                     (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
      (,(intern (format "bmkp-cycle-%s" type)) n startoverp))

    ;; `previous' command.
    (defun ,(intern (format "bmkp-previous-%s-bookmark" type)) (n &optional startoverp)
      ,(format "Jump to the Nth-previous %s bookmark.
See `bmkp-next-%s-bookmark'." type type)
      (interactive (let ((startovr  (consp current-prefix-arg)))
                     (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
      (,(intern (format "bmkp-cycle-%s" type)) (- n) startoverp))

    ;; `next' repeating command.
    (defun ,(intern (format "bmkp-next-%s-bookmark-repeat" type)) (arg)
      ,(format "Jump to the Nth-next %s bookmark.
This is a repeatable version of `bmkp-next-%s-bookmark'.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one (and no repeat)." type type)
      (interactive "P")
      (require 'repeat)
      (bmkp-repeat-command ',(intern (format "bmkp-next-%s-bookmark" type))))

    ;; `previous repeating command.
    (defun ,(intern (format "bmkp-previous-%s-bookmark-repeat" type)) (arg)
      ,(format "Jump to the Nth-previous %s bookmark.
See `bmkp-next-%s-bookmark-repeat'." type type)
      (interactive "P")
      (require 'repeat)
      (bmkp-repeat-command ',(intern (format "bmkp-previous-%s-bookmark" type))))))

;;;###autoload
(defmacro bmkp-define-sort-command (sort-order comparer doc-string)
  "Define a command to sort bookmarks in the bookmark list by SORT-ORDER.
SORT-ORDER is a short string or symbol describing the sorting method.
Examples: \"by last access time\", \"by bookmark name\".

The new command is named by replacing any spaces in SORT-ORDER with
hyphens (`-') and then adding the prefix `bmkp-bmenu-sort-'.  Example:
`bmkp-bmenu-sort-by-bookmark-name', for SORT-ORDER `by bookmark name'.

COMPARER compares two bookmarks, returning non-nil if and only if the
first bookmark sorts before the second.  It must be acceptable as a
value of `bmkp-sort-comparer'.  That is, it is either nil, a
predicate, or a list ((PRED...) FINAL-PRED).  See the doc for
`bmkp-sort-comparer'.

DOC-STRING is the doc string of the new command."
  (unless (stringp sort-order) (setq sort-order  (symbol-name sort-order)))
  (let ((command  (intern (concat "bmkp-bmenu-sort-" (bmkp-replace-regexp-in-string
                                                      "\\s-+" "-" sort-order)))))
    `(progn
      (setq bmkp-sort-orders-alist  (bmkp-assoc-delete-all ,sort-order (copy-sequence
                                                                        bmkp-sort-orders-alist)))
      (push (cons ,sort-order ',comparer) bmkp-sort-orders-alist)
      (defun ,command ()
        ,(concat doc-string "\nRepeating this command cycles among normal sort, reversed \
sort, and unsorted.")
        (interactive)
        (bmkp-bmenu-barf-if-not-in-menu-list)
        (cond (;; Not this sort order - make it this sort order.
               (not (equal bmkp-sort-comparer ',comparer))
               (setq bmkp-sort-comparer   ',comparer
                     bmkp-reverse-sort-p  nil))
              (;; This sort order reversed.  Change to unsorted.
               bmkp-reverse-sort-p
               (setq bmkp-sort-comparer   nil))
              (t;; This sort order - reverse it.
               (setq bmkp-reverse-sort-p  t)))
        (message "Sorting...")
        (bookmark-bmenu-ensure-position)
        (let ((current-bmk  (bookmark-bmenu-bookmark)))
          (bookmark-bmenu-surreptitiously-rebuild-list)
          (bmkp-bmenu-goto-bookmark-named current-bmk)) ; Put cursor back on right line.
        (when (interactive-p)
          (bmkp-msg-about-sort-order
           ,sort-order
           nil
           (cond ((and (not bmkp-reverse-sort-p)
                       (equal bmkp-sort-comparer ',comparer)) "(Repeat: reverse)")
                 ((equal bmkp-sort-comparer ',comparer)       "(Repeat: unsorted)")
                 (t                                           "(Repeat: sort)"))))))))

;;;###autoload
(defmacro bmkp-define-file-sort-predicate (att-nb)
  "Define a predicate for sorting bookmarks by file attribute ATT-NB.
See function `file-attributes' for the meanings of the various file
attribute numbers.

String attribute values sort alphabetically; numerical values sort
numerically; nil sorts before t.

For ATT-NB 0 (file type), a file sorts before a symlink, which sorts
before a directory.

For ATT-NB 2 or 3 (uid, gid), a numerical value sorts before a string
value.

A bookmark that has file attributes sorts before a bookmark that does
not.  A file bookmark sorts before a non-file bookmark.  Only local
files are tested for attributes - remote-file bookmarks are treated
here like non-file bookmarks."
  `(defun ,(intern (format "bmkp-file-attribute-%d-cp" att-nb)) (b1 b2)
    ,(format "Sort file bookmarks by attribute %d.
B1 and B2 are bookmarks or bookmark names.
Sort bookmarks with file attributes before those without attributes
Sort file bookmarks before non-file bookmarks.
Treat remote file bookmarks like non-file bookmarks."
             att-nb)
    (setq b1  (bookmark-get-bookmark b1))
    (setq b2  (bookmark-get-bookmark b2))
    (let (a1 a2)
      (cond (;; Both are file bookmarks.
             (and (bmkp-file-bookmark-p b1) (bmkp-file-bookmark-p b2))
             (setq a1  (file-attributes (bookmark-get-filename b1))
                   a2  (file-attributes (bookmark-get-filename b2)))
             (cond (;; Both have attributes.
                    (and a1 a2)
                    (setq a1  (nth ,att-nb a1)
                          a2  (nth ,att-nb a2))
                    ;; Convert times and maybe inode number to floats.
                    ;; The inode conversion is kludgy, but is probably OK in practice.
                    (when (consp a1) (setq a1  (bmkp-float-time a1)))
                    (when (consp a2) (setq a2  (bmkp-float-time a2)))
                    (cond (;; (1) links, (2) maybe uid, (3) maybe gid, (4, 5, 6) times
                           ;; (7) size, (10) inode, (11) device.
                           (numberp a1)
                           (cond ((< a1 a2)  '(t))
                                 ((> a1 a2)  '(nil))
                                 (t          nil)))
                          ((= 0 ,att-nb) ; (0) file (nil) < symlink (string) < dir (t)
                           (cond ((and a2 (not a1))               '(t)) ; file vs (symlink or dir)
                                 ((and a1 (not a2))               '(nil))
                                 ((and (eq t a2) (not (eq t a1))) '(t)) ; symlink vs dir
                                 ((and (eq t a1) (not (eq t a2))) '(t))
                                 ((and (stringp a1) (stringp a2))
                                  (if (string< a1 a2) '(t) '(nil)))
                                 (t                               nil)))
                          ((stringp a1) ; (2, 3) string uid/gid, (8) modes
                           (cond ((string< a1 a2)  '(t))
                                 ((string< a2 a1)  '(nil))
                                 (t                nil)))
                          ((eq ,att-nb 9) ; (9) gid would change if re-created. nil < t
                           (cond ((and a2 (not a1))  '(t))
                                 ((and a1 (not a2))  '(nil))
                                 (t                  nil)))))
                   (;; First has attributes, but not second.
                    a1
                    '(t))
                   (;; Second has attributes, but not first.
                    a2
                    '(nil))
                   (;; Neither has attributes.
                    t
                    nil)))
            (;; First is a file, second is not.
             (bmkp-local-file-bookmark-p b1)
             '(t))
            (;; Second is a file, first is not.
             (bmkp-local-file-bookmark-p b2)
             '(nil))
            (t;; Neither is a file.
             nil)))))

;;;###autoload
(defmacro bmkp-menu-bar-make-toggle (name variable doc message help &rest body)
  "Return a valid `menu-bar-make-toggle' call in Emacs 20 or later.
NAME is the name of the toggle command to define.
VARIABLE is the variable to set.
DOC is the menu-item name.
MESSAGE is the toggle message, minus status.
HELP is `:help' string.
BODY is the function body to use.  If present, it is responsible for
setting the variable and displaying a status message (not MESSAGE)."
  (if (< emacs-major-version 21)
      `(menu-bar-make-toggle ,name ,variable ,doc ,message ,@body)
    `(menu-bar-make-toggle ,name ,variable ,doc ,message ,help ,@body)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'bookmark+-mac)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark+-mac.el ends here