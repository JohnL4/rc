;;; Functions to add properties to Java objects (beans).
;;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/jdex-bean.el,v 1.7 2003/05/23 20:56:03 J80Lusk Exp $

(defvar jdex-default-backing-var-locn-re "^\\s-*//\\s-+data\\s-*$"
  "A regexp below which variables backing properties will be
inserted, in the first blank line.")

(defun jdex-insert-property (data-type property-name
                                       &optional property-type
                                       backing-var-name backing-var-locn-re)
  "Add property accessors at point, possibly with a backing variable at some
other location.  PROPERTY-TYPE is one of '(simple indexed bound constrained),
with `simple' being the default.  DATA-TYPE is the type of the data stored in
the property, a Java type.  PROPERTY-NAME is the name of the property.
BACKING-VAR-NAME is the name of the backing variable; if nil, there will be no
backing variable.  BACKING-VAR-LOCN-RE is a regexp below which the
backing variable will be inserted, in the first blank line."
  (interactive
   (let* (
          (valid-property-types '(("simple" nil)
                                  ("indexed" nil)
                                  ("bound" nil)
                                  ("constrained" nil)
                                  ("bound & constrained" nil)
                                  ("indexed & bound" nil)
                                  ("indexed & constrained" nil)
                                  ("indexed & bound & constrained" nil)
                                  ("dazed & confused" nil)
                                  ))
          (data-type (read-string "Java datatype: "))
          (property-name (read-string "Property name: "))
          (property-type (completing-read "Property type: "
                                                valid-property-types
                                                nil t "simple"))
          (backing-var-name (read-string "Backing variable (or nothing): "
                                         (concat "my" property-name)))
          (backing-var-locn-re (read-string
                                "Backing variable location regexp: "
                                jdex-default-backing-var-locn-re))
          )
     (list data-type property-name property-type backing-var-name
           backing-var-locn-re))
   )
  (let (accessor-start                  ;Point where property accessor(s)
                                        ;  start.
        set-javadoc-marker              ;Location where javadoc for setter
                                        ;  method should start.
        property-types
        is-simple
        is-indexed
        is-bound
        is-constrained
        )

                                        ;Figure out property type(s).
    
    (if (null property-type)
        (setq property-type "simple"))
    (setq property-types (split-string property-type "\\s-*&\\s-*"))
    (while property-types
      (cond ((string= "simple" (car property-types)) (setq is-simple t))
            ((string= "indexed" (car property-types)) (setq is-indexed t))
            ((string= "bound" (car property-types)) (setq is-bound t))
            ((string= "constrained" (car property-types)) (setq is-constrained t))
            )
      (setq property-types (cdr property-types)))
    
    (if (= 0 (length backing-var-name))
        (setq backing-var-name nil))

                                        ;Start inserting code.
    (open-line 1)
                                        ;We don't use indent-region because it
                                        ;  doesn't handle Javadoc comments
                                        ;  properly.

                                        ;Must handle {scalar indexed bound
                                        ;  constrained}:
                                        ;  1 0 0 0 (scalar)
                                        ;  0 1 0 0 indexed
                                        ;  1 0 1 0 (scalar) bound
                                        ;  1 0 0 1 (scalar) constrained
                                        ;  1 0 1 1 (scalar) bound constrained
                                        ;  0 1 1 0 indexed bound
                                        ;  0 1 0 1 indexed constrained
                                        ;  0 1 1 1 indexed bound constrained

    (insert " /**") (indent-according-to-mode)
    (insert "\n * ") (indent-according-to-mode)
    (setq set-javadoc-marker (point-marker))
    (tempo-insert-mark set-javadoc-marker)
    (insert
     "TODO: describe property (value ranges, semantics, meaning of null)")
;;;    (fill-region (progn (beginning-of-line) (point))
;;;                 (progn (end-of-line) (point)))
    (insert "\n **/") (indent-according-to-mode)

                                        ;Special case for boolean properties:
                                        ;  "is" accessor (else "get")
    
    (let ((verb (if (string-match "^[Bb]oolean$" data-type) "is" "get")))
      (insert (format "\npublic %s %s%s()"
                      data-type verb property-name )))

    (indent-according-to-mode)
    (insert "\n{") (indent-according-to-mode)
    (if backing-var-name
        (insert (format "\nreturn %s;" backing-var-name))
      (insert "\n // TODO: implement"))
    (indent-according-to-mode)
    (insert "\n}") (indent-according-to-mode)
    (insert "\n\n /**") (indent-according-to-mode)
    (insert (format
             "\n * TODO: Add more docs if get%s() docs aren't sufficient."
             property-name))
    (indent-according-to-mode)
    (insert (format "\n * See {@link #get%s()}"
                    property-name)) (indent-according-to-mode)
    (insert "\n **/") (indent-according-to-mode)
    (insert (format "\npublic void set%s( %s %s)"
                    property-name
                    data-type
                    property-name
                    )
            )
    (indent-according-to-mode)
    (prefix-with-indefinite-article property-name)
    (insert "\n{") (indent-according-to-mode)
    (if backing-var-name
        (progn
          (insert (format "\n%s = %s;" backing-var-name property-name))
          (prefix-with-indefinite-article property-name))
      (insert "\n // TODO: implement")
      )
    (indent-according-to-mode)
    (insert "\n}") (indent-according-to-mode)
          
    (if backing-var-name
        (save-excursion
          (beginning-of-buffer)
          (re-search-forward backing-var-locn-re)
          (re-search-forward "^\\s-*$")
          (insert "\n /**")
          (indent-according-to-mode)
          (insert (format "\n * See {@link #set%s( %s)}"
                          property-name data-type)) (indent-according-to-mode)
          (insert "\n **/") (indent-according-to-mode)
          (insert (format "\nprivate %s %s;" data-type backing-var-name))
          (indent-according-to-mode)
          (insert "\n")
          ))

    (goto-char set-javadoc-marker)
    )
  )

(defun prefix-with-indefinite-article (word)
  "Prefix most recent occurrence of `word' in buffer (before point) with an
indefinite article (\"a\" or \"an\")."
  (save-excursion
    (search-backward word)
    (if (looking-at "[aeiouAEIOU]")
        (insert "an")
      (insert "a")))
  )

(provide 'jdex-bean)
