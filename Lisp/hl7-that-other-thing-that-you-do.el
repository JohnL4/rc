;; Configuration for hl7.el.  Specifies which fields are to be highlighted.

;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/hl7-that-other-thing-that-you-do.el,v 1.1 2003/05/23 17:41:29 J80Lusk Exp $

(defun hl7-config ()
  "Configure the HL7 stuff in the current buffer."
  
  (setq hl7-field-specs
        '(
          ("MSH"        9  10  12)
          ("EVN"        1  2)
          ("PID"        3  5  7  11  12  18  19 24 25)
          ("PV1"        3  7  10  14  17  18  20  36  44  45)
          ("PV2"        3  8  9  10)
          ("DG1"        2  3  4  5  6  15)
          ("NK1"        3)
          ("IN1"        2  3  4  8  14  22  28  36)
          ("ZPC"        1  2  3  4  5  6  7  8 )
          )
        )
  )


