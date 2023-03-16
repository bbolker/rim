; imported just for testing purposes
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

(defparameter *maxima-direct-ir-map*
  (let ((ht (make-hash-table)))
    (setf (gethash 'mtimes ht) '(op *))
    (setf (gethash 'mplus ht) '(op +))
    (setf (gethash 'mexpt ht) '(op ^))
    (setf (gethash 'rat ht) '(op /))
    (setf (gethash 'mquotient ht) '(op /))
    (setf (gethash 'msetq ht) '(op-no-bracket =))
    (setf (gethash 'mlist ht) '(struct-list))
    (setf (gethash 'mand ht) '(boolop (symbol "and")))
    (setf (gethash 'mor ht) '(boolop (symbol "or")))
    (setf (gethash 'mnot ht) '(funcall (symbol "not")))
    (setf (gethash 'mminus ht) '(unary-op -))
    (setf (gethash 'mgreaterp ht) '(comp-op >))
    (setf (gethash 'mequal ht) '(comp-op ==))
    (setf (gethash 'mnotequal ht) '(comp-op !=))
    (setf (gethash 'mlessp ht) '(comp-op <))
    (setf (gethash 'mgeqp ht) '(comp-op >=))
    (setf (gethash 'mleqp ht) '(comp-op <=))
    (setf (gethash '$floor ht) '(funcall (symbol "floor")))
    (setf (gethash '$fix ht) '(funcall (symbol "floor")))
    (setf (gethash '%fix ht) '(funcall (symbol "floor")))
    (setf (gethash '%sqrt ht) '(funcall (symbol "sqrt")))
    (setf (gethash '%log ht) '(funcall (symbol "log")))
    (setf (gethash '%gamma ht) '(funcall (symbol "gamma")))
    (setf (gethash 'mreturn ht) '(funcall (symbol "return")))
    (setf (gethash 'mabs ht) '(funcall (symbol "abs")))
    ht))

(defparameter *maxima-special-ir-map*
  (let ((ht (make-hash-table)))
    (setf (gethash 'mdefine ht) 'func-def-to-ir)
    (setf (gethash '$MATRIX ht) 'matrix-to-ir)
    ; (setf (gethash '%array ht) 'array-def-to-ir)
    ; (setf (gethash 'mprog ht) 'mprog-to-ir)
    ; (setf (gethash 'mprogn ht) 'mprogn-to-ir)
    (setf (gethash 'mcond ht) 'mcond-to-ir)
    (setf (gethash 'lambda ht) 'lambda-to-ir)
    ; (setf (gethash 'mdoin ht) 'for-list-to-ir)
    ; (setf (gethash 'mdo ht) 'for-loop-to-ir)
    ; (setf (gethash '%endcons ht) 'endcons-to-ir)
    ; (setf (gethash '$endcons ht) 'endcons-to-ir)
    ; (setf (gethash '$plot3d ht) 'plot-to-ir)
    ; (setf (gethash '$plot2d ht) 'plot-to-ir)
    ; (setf (gethash 'mexpt ht) 'mexpt-to-ir)
    (setf (gethash 'mfactorial ht) 'mfactorial-to-ir)
    ht))

(defun symbol-name-to-string (form)
  (string-left-trim "$%" (symbol-name form)))

(defun symbol-to-ir (form)
  `(symbol ,(maybe-invert-string-case (symbol-name-to-string form))))

;;; Generates IR for atomic forms
(defun atom-to-ir (form)
  (cond
    ((eq form 'nil) `(symbol "NULL"))
    ((eq form '$true) `(symbol "TRUE"))
    ((stringp form) `(string ,form))
    ((and (not (symbolp form)) (floatp form)) `(num ,form))
    ((and (not (symbolp form)) (integerp form)) `(int ,form))
    ((eq form '$%i) '(cplx 0 1)) ; iota complex number
    ((eq form '$%pi) '(num (symbol "pi") 0)) ; Pi
    ((eq form '$%e) '(funcall (symbol "exp"))) ; Euler's Constant
    ((eq form '$inf) '(symbol "Inf"))
    (t (symbol-to-ir form))))

(defun cons-to-ir (form)
  (cond ((atom (caar form))
	 (let 
	     ((type (gethash (caar form) *maxima-direct-ir-map*)))
	   (cond 
	     (type (append type (mapcar #'maxima-to-ir (cdr form))))
	     ((setf type (gethash (caar form) *maxima-special-ir-map*))
	      (funcall type form))
	     (t 
	      `(funcall 
		 ,(symbol-to-ir (caar form)) 
		 ,@(mapcar 
		     #'maxima-to-ir 
		     (cdr form)))))))))

(defun maxima-to-ir (form)
  (cond ((atom form)
	 (atom-to-ir form))
	((and (consp form) (consp (car form)))
	 (cons-to-ir form))
	(t (cons 'no-convert form))))

(defun mfactorial-to-ir (form)
  `(funcall (string "factorial") ,@(mapcar #'maxima-to-ir (cdr form))))

; (defun mexpt-to-ir (form)
;   `(funcall (string "exp") ,@(mapcar #'maxima-to-ir (cdr form))))

(defun mlist-to-ir (form)
  `(STRUCT-LIST ,@(mapcar #'maxima-to-ir (cdr form))))

;; the second element of the list
;; should be a pairlist
;; (defun lambda-to-ir (form)
;;   `(function ,@(mlist-to-pairlist (cadr form)) ,@(mapcar #'maxima-to-ir (cddr form))))

(defun lambda-to-ir (form)
  `(funcall (string "function") ,@(mapcar #'maxima-to-ir (cdr form))))

(defun func-def-to-ir (form)
  `(func-def ,(maxima-to-ir (caaadr form)) 
             ,(mlist-to-ir (cadr form)) 
             ,@(mapcar #'maxima-to-ir (cddr form))))

(defun matrix-to-ir (form)
  (cons 'MATRIX 
        (mapcar
          (lambda (elm) (maxima-to-ir elm))
          (cdr form))))

(defvar *maxima-special-r-map* ())

(defparameter *ir-r-direct-templates* 
  (let ((ht (make-hash-table)))
    (setf (gethash 'symbol ht) 'symbol-to-r)
    (setf (gethash 'op ht) 'op-to-r)
    (setf (gethash 'op-no-bracket ht) 'op-no-bracket-to-r)
    (setf (gethash 'unary-op ht) 'unary-op-to-r)
    (setf (gethash 'funcall ht) 'funcall-to-r)
    (setf (gethash 'int ht) 'int-to-r)
    (setf (gethash 'cplx ht) 'cplx-to-r)
    (setf (gethash 'string ht) 'string-to-r)
    (setf (gethash 'struct-list ht) 'struct-list-to-r)
    (setf (gethash 'func-def ht) 'func-def-to-r)
    (setf (gethash 'matrix ht) 'matrix-to-r)
    ht))

(defun atom-to-r (form)
  (cond 
    ((eq form 'NIL) 'FALSE)
    ((eq form '$true) 'TRUE)
    (t form)))

(defun cons-to-r (form)
  (cond ((atom (caar form))
	 (let ((fel (gethash (car form) *ir-r-direct-templates*)))
	   (cond (fel 
		  (funcall fel form))
		 ;;((setf type (gethash (caar form *maxima-r-map*))) (funcall type form))
		 (t 'no-convert))))))

; (defun ir-to-r (form)
;   (cond ((atom form) 
; 	 (atom-to-r form))
; 	((and (consp form) (consp (car form))) 
; 	 (cons-to-r form))
; 	(t 
; 	 (cons 'no-convert form))))

(defun ir-to-r (form)
  (typecase form
    (cons               
      (let ((type (gethash (car form) *ir-r-direct-templates*)))
        (cond
          (type (funcall type form))
          (t (format nil "no-convert: ~a" form)))))
    (t 
      (format nil "~a" form))))

(defun op-template (op)
  ;; replaces the control-string by the argument 
  ;; print (in brackets) all elements of the operator
  ;; separated by the operator as a string
  (format nil "~@?" "(~~{~~#[~~;~~a~~:;~~a ~a ~~]~~})"
	  op))

(defun op-no-bracket-template (op)
  (format nil "~@?" "~~{~~#[~~;~~a~~:;~~a ~a ~~]~~}"
	  op))

; (defun mplus-to-r (form)
;   (format nil (op-template "+") 
; 	  (mapcar 
; 	    (lambda (elm) (maxima-to-r elm)) 
; 	    (cdr form))))

; (defun mminus-to-r (form)
;   (format nil "-~A" (cadr form)))

(defun op-to-r (form)
  (format nil (op-template (cadr form))
          (mapcar
            (lambda (elm) (ir-to-r elm))
            (cddr form))))

(defun op-no-bracket-to-r (form)
  (format nil (op-no-bracket-template (cadr form))
          (mapcar
            (lambda (elm) (ir-to-r elm))
            (cddr form))))

(defun symbol-to-r (form)
  (cadr form))

(defun unary-op-to-r (form)
 (format nil "(~a~a)" 
         (cadr form)
         (ir-to-r (caddr form))))

(defun funcall-to-r (form)
  (format nil "~a(~a)"
          (ir-to-r (cadr form))
          (ir-to-r (caddr form))))

(defun int-to-r (form)
  (format nil "~aL" (cadr form)))

(defun cplx-to-r (form)
  (format nil "complex(1, ~a, ~a)"
          (cadr form)
          (caddr form)))

(defun string-to-r (form)
  (format nil "~a" (cadr form)))

(defun struct-list-to-r (form)
  (format nil "list(~{~a~^, ~})" 
          (mapcar
            (lambda (elm) (ir-to-r elm))
            (cdr form))))

(defun func-args-to-r (form)
  (format nil "~{~a~^, ~}"
          (mapcar
            (lambda (elm) (ir-to-r elm))
            (cdr form))))

(defun func-def-to-r (form)
  (format nil "~a <- function(~a) { ~{~a~^~%~} }" 
          (ir-to-r (cadr form))
          (func-args-to-r (caddr form))
          (mapcar
            (lambda (elm) (ir-to-r elm))
            (cdddr form))))

(defun func-args-to-r (form)
  (format nil "~{~a~^, ~}"
          (mapcar
            (lambda (elm) (ir-to-r elm))
            form)))

(defun matrix-to-r (form)
  (format nil "matrix(data = c(~{~a~^, ~}), ncol = ~a, nrow = ~a)"
          (mapcan (lambda (r c) 
                    (list (ir-to-r r) (ir-to-r c)))
                  (cdadr form)
                  (cdaddr form))
          (length (cdr form))
          (- (length (cadr form)) 1)))

(defun stripdollar (form) 
  (string-left-trim "$" (symbol-name form)))

(defun maxima-to-r (form)
  (ir-to-r (maxima-to-ir form)))
