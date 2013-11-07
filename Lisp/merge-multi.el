;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/merge-multi.el,v 1.4 2002/05/06 18:02:11 J80Lusk Exp $
;;;
;;; Iterate through a list of files, merging them interactively.  This is a
;;; sloppy hack, but it shouldn't be TOO hard to clean up.
;;;
;;; Expected starting conditions:
;;;
;;;   You have a directory ("source" directory) of files containing the latest
;;;   versions of some changes you've just made.  Also in this directory is a
;;;   set of numbered earlier versions (filenames ending in ".v99")
;;;   corresponding to the versions you want to base your merges on (i.e.,
;;;   compute deltas from).  For each file, you may have multiple earlier
;;;   versions; only the latest earlier version will be used (i.e., highest
;;;   number, comparing numericaly, oddly enough).
;;;
;;;   You also have a directory ("target" directory) of the same set of files
;;;   in a different branch of the product, to which you want to apply the
;;;   edits you've just made in the "source" directory.
;;;
;;; Set up the variables below, then execute either (merge-multi files) or
;;; (diff-multi files).
;;;
;;; `merge-multi' will initiate multiple merge sessions which you will have to
;;; resolve.  For each session, when you quit out of it, your merge results
;;; will be automatically saved with a ".merge" suffix in the target
;;; directory and you will be prompted to kill the merge-result buffer.
;;;
;;; John Lusk, 10 Apr 2002.

(setq src-dir "c:/work/canopy/r3.1.1/canopyia/source")
(setq tgt-dir "c:/work/canopy/r3.1.1/canopyia/source")

(setq files '(
              "ui/js/ControlPanel.js"
              "ui/ControlPanelControls.jsp"
              "ui/DischargePlanning.jsp"
              "ui/DischargePlanning_Top.jsp"
              "ui/js/FormChek.js"
              "ui/MainNavigationUI.jsp"
              "ui/PatientAssessmentEditor.jsp"
              "ui/PatientBannerUI.jsp"
              "ui/PatientPayor_Edit.jsp"
              "ui/PatientPayor_Edit_Bottom.jsp"
              "ui/PatientPayor_Edit_Top.jsp"
              "ui/PatientsUI.jsp"
              ))

;;------------------------------  config ends  -------------------------------


                                        ;Convenience for merging:  show
                                        ;only conflicts.
(defun merge-hook ()
  (ediff-toggle-show-clashes-only)
  )

;;; (setq ediff-startup-hook 'merge-hook)

(defun latest-rev (dir file)
  "Return the latest revision number of the given file, assuming each filename
revision ends in ``.v99'' (where ``99'' is the rev. number)."
  (interactive)
  (let ((candidates (directory-files (file-name-directory (concat
                                                           dir "/" file))
                                     nil ;no full name
                                     (concat (file-name-nondirectory file)
                                             "\\.v[0-9]+") ;regexp
                                     t)) ;no sorting
        )
    (setq candidates (sort candidates
                           (lambda (a b)
                                        ;Sort on numeric revision.
                                        ;Expect a and b to have format
                                        ;"blahblah.jsp.v99"
                             (let ((a-suff (split-string a "\\.v"))
                                   (b-suff (split-string b "\\.v"))
                                   )
                                        ;Expect `split' to generate 2-elt
                                        ;lists.  Convert 2nd elt to int.
                               (setq a-suff (read (cadr a-suff)))
                               (setq b-suff (read (cadr b-suff)))
                               (not (< a-suff b-suff))
                               ))))
    (car (reverse (split-string (car candidates) "\\.v"))) ;retval
    )
  )

(defun do-merge (filename)
  "Find the ancestor file (highest version #), call
`ediff-merge-files-with-ancestor' (which merely INITIATES a merge session).
Associate merge buffer w/a file, in which case ediff seems to want to
automatically save it and throw it away, w/confirmation from the user.  Fine
by me."
  (interactive)
  (ediff-merge-files-with-ancestor (concat src-dir "/" filename)
                                   (concat tgt-dir "/" filename)
                                   (concat src-dir "/" filename ".v"
                                           (latest-rev src-dir filename))
                                   '(merge-hook)
                                   (concat tgt-dir "/" filename ".merge")
                                   )
  )

(defun do-diff (filename)
  "Diff the given file (in the src dir) against the latest available version."
  (interactive)
  (ediff-files (concat src-dir "/" filename ".v"
                       (latest-rev src-dir filename))
               (concat src-dir "/" filename)
               nil)
  )

(defun merge-multi (files)
  "Iterate through the list of files, merging each one."
  (interactive)
  (if files
      (progn
;;;         (let ((buf (get-buffer "*ediff-merge*")))
;;;           (if buf
;;;               (kill-buffer buf)))
        (do-merge (car files))
        (merge-multi (cdr files)))))

(defun diff-multi (files)
  "Iterate through the list of files, diffing each one."
  (interactive)
  (if files
      (progn
        (do-diff (car files))
        (diff-multi (cdr files))
        )
    )
  )

                                        ;Start the whole thing off.
;;; (merge-multi files)

;;; $Log: merge-multi.el,v $
;;; Revision 1.4  2002/05/06 18:02:11  J80Lusk
;;; Random commit.
;;;
;;; Revision 1.3  2002/05/01 20:49:31  J80Lusk
;;; Fix problem in which latest-rev didn't work for files BELOW the
;;; current directory (i.e., not IN the current directory).
;;;
;;; Revision 1.2  2002/04/12 14:49:26  J80Lusk
;;; Add VC keywords.
;;;
