					;-*- lisp-interaction -*-


(setq tree '(root (child-1 subchild-1a subchild-1b)
		  child-2		;Leaf nodes do NOT appear in singleton
					;  lists. 
		  (child-3 (subchild-3a subsubchild-3a1 subsubchild-3a2)
			   (subchild-3b subsubchild-3b1 subsubchild-3b2)
			   )
		  ))

(assq 'child-3 tree)
(child-3 (subchild-3a subsubchild-3a1 subsubchild-3a2) (subchild-3b subsubchild-3b1 subsubchild-3b2))

(assq 'child-5 tree)
nil

(assq 'child-2 tree)
nil

(cdr tree)
((child-1 subchild-1a subchild-1b) child-2 (child-3 (subchild-3a subsubchild-3a1 subsubchild-3a2) (subchild-3b subsubchild-3b1 subsubchild-3b2)))

(journal-child-tag-completions tree)


(completing-read "Tag: " (journal-child-tag-completions tree))
"child-2"


(tree-merge tree '(root (child-2 child-2a child-2b)))


(tree-merge tree '(root (child-2 child-2a child-2b)))

(tree-merge tree '(root child-4))


(tree-merge tree '(root child-4))

(tree-contains tag-tree (intern "run" journal-tag-obarray))

(tree-contains '(a b) 'b)

(tree-clone nil)
nil

(tree-clone 'a)
a

(tree-clone '(a b))
(a b)

(tree-clone '(a (b c)))
(a (b c))

(tree-size nil)
0

(tree-size 'a)
1

(tree-size '(a b))
2

(tree-size tree)
12


;;------------------------------------    ------------------------------------


(if (pp journal-entries)
    nil)

(if (pp (setq tag-tree (journal-get-classification-tree journal-entries)))
    nil)

(if (pp journal-entries)
    nil)

(if (pp (setq tag-tree (journal-get-classification-tree journal-entries)))
    nil)
