;imported just for testing purposes
(defun maybe-invert-string-case (string)
  (let ((all-upper t)
	(all-lower t)
	(length (length string)))
    (dotimes (i length)
      (let ((ch (char string i)))
	(when (both-case-p ch)
	  (if (upper-case-p ch)
	      (setq all-lower nil)
	      (setq all-upper nil)))))
    (cond (all-upper
	   (string-downcase string))
	  (all-lower
	   (string-upcase string))
	  (t
	   string))))

; (load "maxima-to-ir.lisp")
; (load "ir-to-r.lisp")
(load "parser.lisp")
(load "test-forms.lisp")
; (load "rds.lisp")

(declaim (optimize (debug 3)))

(maxima-to-ir simple-form)
(maxima-to-ir func-form)
(maxima-to-ir expt-form)
(maxima-to-ir cplx-form)
(maxima-to-ir factorial-form)
(maxima-to-ir list-form)
(maxima-to-ir list-form2)
(maxima-to-ir funcdef-form)
(maxima-to-ir jfunc-form)
(maxima-to-ir val-assign-form)
(maxima-to-ir lambda-form)
(maxima-to-ir adv-form)
(maxima-to-ir matrix-form)
(maxima-to-ir pi-form)
(maxima-to-ir atan-form)
(maxima-to-ir compare-form)
(maxima-to-ir longcompare-form)

(maxima-to-r simple-form)
(maxima-to-r func-form)
(maxima-to-r adv-form)
(maxima-to-r expt-form)
(maxima-to-r cplx-form)
(maxima-to-r factorial-form)
(maxima-to-r list-form)
(maxima-to-r list-form2)
(maxima-to-r funcdef-form)
(maxima-to-r jfunc-form)
(maxima-to-r val-assign-form)
(maxima-to-r matrix-form)
(maxima-to-r matrix-compl)
(maxima-to-r lambda-form)
(maxima-to-r pi-form)
(maxima-to-r atan-form)
(maxima2r compare-form)
(maxima2r longcompare-form)

;;; TODO
(maxima-to-ir create-array-form)
(maxima-to-ir set-array-form)
(maxima-to-ir index-array-form)

(ir-to-r create-array-form)
(ir-to-r set-array-form)
(ir-to-r index-array-form)

(;;;) NOTES
;;;
;;; function maybe-invert-string-case turns the string
;;; FOO into foo
;;; foo into FOO
;;; Foo into Foo
;;; Lisp symbols are always upper case
;;; So, in a Maxima expression in LISP form
;;; all uppercase symbols are to be made lower case
;;; except for when the symbol is surrounded by vertical bars
