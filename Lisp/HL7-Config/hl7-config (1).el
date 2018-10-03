;; Configuration for hl7.el.  Specifies which fields are to be highlighted.

;; $Header: v:/J80Lusk/CVSROOT/EmacsLisp/hl7-config.el,v 1.2 2002/06/07 13:48:57 J80Lusk Exp $

(defun hl7-config ()
  "Configure the HL7 stuff in the current buffer."
  
  (setq hl7-field-specs
        '(
          ("MSH"        8  9  11)
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


