;; Functions for working w/n-ary trees.
;;
;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/tree.el,v 1.3 2002/07/18 13:33:05 J80Lusk Exp $

;;; (require 'debug-log)


;; Tree are assumed to have the following structure:

'(root (child-1 subchild-1a subchild-1b)
       child-2				;Leaf nodes do NOT appear in singleton
					;  lists. 
       (child-3 (subchild-3a subsubchild-3a1 subsubchild-3a2)
		(subchild-3b subsubchild-3b1 subsubchild-3b2)
		)
       )

;; So, for any given node `n', (car n) is the value of the node, and (cdr n)
;; is the list of children of n.
;;
;; Node comparison is done with `eq', so node values cannot be complex.  They
;; are assumed to be symbols.

(defun tree-add-child (tree child)
  "PROBABLY INCORRECT.  Adds child to the first level of tree, if it's not
already there."
  (if tree
      (if (assq child (cdr tree))
	  tree
	(setcdr tree (cons (list child) (cdr tree)))
	tree
       )
    (list child)			;nil tree gets child as ROOT node
					;  value.
    )
  )

(defun tree-merge (big-tree small-tree &optional recurse-depth)
  "Merge `small-tree' into `big-tree', POSSIBLY modifying `big-tree'
in-place. Return `big-tree'.  small-tree's root is exepcted to be the same as
big-tree's root, but if they are not the same, no error will be signalled, and
processing will proceed as if small-tree's root were the same as big-tree's.
Also, merging in a small tree whose structure is incorrect below the first
level MAY not signal an error."
  (let ((me "tree-merge: ")
	)
    (if (null recurse-depth)
	(setq recurse-depth 0))
;;;    (if (and (sequencep big-tree)
;;;	     (sequencep small-tree))
;;;	(dbg (format "%s: depth %-6d; (length big-tree) --> %-6d, (length small-tree) --> %-6d"
;;;		     me recurse-depth (length big-tree) (length small-tree))))
    (if big-tree
	(if (and small-tree
		 (listp small-tree))
	    (let (			;Small-tree may have root w/no
					;  children
		  (first-small-child
		   (cond ((listp (cadr small-tree))
			  (caadr small-tree))
			 ((atom (cadr small-tree))
			  (cadr small-tree))
			 ))
		  (small-tree-clone (tree-clone small-tree))
		  )
	      (if first-small-child
		  (progn
		    (cond ((assq first-small-child (cdr big-tree))
			 		;merge subchild lists
			   (tree-merge (assq first-small-child (cdr big-tree))
				       (cadr small-tree-clone)
				       (1+ recurse-depth))
			   )
			  ((memq first-small-child (cdr big-tree))
					;Discovered node has no children.  Set
					;  contents of small-tree as
					;  children.
			   (tree-set-children (memq first-small-child
						    (cdr big-tree))
					      (cadr small-tree-clone))
			   )
			  (t
					;else, plunk in entire
					;  first-small-child subtree
			   (setcdr big-tree
				   (cons (cadr small-tree-clone)
					 (cdr big-tree)))
			   )
			  )
					;Recurse on next small child.
		    (tree-delete-first-child small-tree-clone)
		    (tree-merge big-tree small-tree-clone (1+ recurse-depth))
		    )
		big-tree		;Small tree contains only a root node,
					;  which doesn't affect big-tree.
					;  Return unchanged big-tree as value
					;  of merge.
		)
	      )
	  big-tree			;If small-tree is nil, just return
					;  big-tree as the result.
	  )
      (tree-clone small-tree)		;If big-tree is nil, just return
					;  small-tree as the value of the
					;  merge. 
      )
    )
  )

(defun tree-delete-first-child (tree)
  "Helper function to delete the first child from the given tree."
  (setcdr tree (cddr tree)))

(defun tree-set-children (subtree children-tree)
  "Add the children of the root of `children-tree' as children of `(car
subtree)', using `setcar'.  Returns modified `subtree'."
  (if (listp children-tree)
      (setcar subtree (cons (car subtree)
			    (cdr children-tree))))
  subtree
  )

(defun tree-from-list (elts)
  "Turn a list of elements into a tree in which element is the parent of a
subtree consisting of the following elements as child, grandchild, etc.  Turns
'(a b c d) into '(a (b (c d)))"
  (cond ((listp elts)
	 (if (> (length elts) 2)
	     (list (car elts)
		   (tree-from-list (cdr elts)))
	   elts)
	 )
	((atom elts)
	 (list elts))
	(t (error "Can't figure out what %S is." elts)))
  )

(defun tree-contains (tree elt)
  "Returns non-nil if the given tree contains the given elt."
  (or (if (listp tree) (eq elt (car tree)) (eq elt tree))
      (if (listp tree)
	  (let ((child-trees (cdr tree))
		)
	    (while (and child-trees
			(not (tree-contains (car child-trees) elt)))
	      (setq child-trees (cdr child-trees)))
	    (not (null child-trees))
	    )))
  )

(defun tree-clone (tree)
  "Returns a clone of `tree', so calls to setcar and setcdr can be executed
safely."
  (if (or (null tree)
	  (atom tree))
      tree				;Not a list -- just return the
					;  original tree.
    (cons (car tree)
	  (mapcar 'tree-clone (cdr tree)))
    ))

(defun tree-size (tree)
  "Returns the number of nodes in the given tree."
  (cond ((null tree)
	 0)
	((atom tree)
	 1)
	(t (let ((tot-subtree-sizes 0)
		 (child-trees (cdr tree))
		 )
	     (while child-trees
	       (setq tot-subtree-sizes (+ tot-subtree-sizes
					  (tree-size (car child-trees))))
	       (setq child-trees (cdr child-trees)))
	     (1+ tot-subtree-sizes)	;Add THIS node to sizes of child
					;  trees.
	     )
	   )
	)
  )


(provide 'lusk-tree)

;; (setq edebug-all-defs old-edebug-all-defs)

;;----------------------------------  Log  -----------------------------------

;; $Log: tree.el,v $
;; Revision 1.3  2002/07/18 13:33:05  J80Lusk
;; Bug fixes, tracing.
;;
;; Revision 1.4  2002/06/30 05:05:02  john
;; Many bug fixes.
;; Seems to be working properly now.
;;
;; Revision 1.3  2002/06/18 04:30:32  john
;; Add VC keywords.
;;

