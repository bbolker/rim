; test forms
(setf func-form '(($F SIMP) $X)) ; f(x)
(setf expt-form '((MEXPT) $E ((MEXPT SIMP) $X 2)))
(setf simple-form '((MPLUS) ((MMINUS) $D) $C $B $A))
(setf factorial-form '((MFACTORIAL SIMP) $A))
(setf cplx-form '((MPLUS) ((MTIMES) 3 $%I) 4))
(setf funcdef-form '((MDEFINE SIMP) (($F) $X) ((%SIN) $X)))
(setf val-assign-form '((MSETQ SIMP) $A 4))
(setf list-form '((MLIST SIMP) 1 2 7 ((MPLUS SIMP) $X $Y)))
(setf list-form2 '((MLIST SIMP) ((MSETQ SIMP) $A 100) ((MSETQ SIMP) $B 200)))
(setf lambda-form '((LAMBDA SIMP) ((MLIST) $I) ((MPLUS) $I 1)))
(setf adv-form '((MPLUS) ((MQUOTIENT) ((%LOG SIMP) ((MPLUS SIMP) 1 $X)) 2) ((MMINUS) ((MQUOTIENT) ((%LOG SIMP) ((MPLUS SIMP) -1 $X)) 2))))
(setf matrix-form '(($MATRIX SIMP) ((MLIST SIMP) 1 2) ((MLIST SIMP) 2 3)))
(setf array-function '((MDEFINE SIMP) (($C ARRAY) $X $Y) ((MQUOTIENT) $Y $X)))
(setf matrix-compl '(($MATRIX SIMP) ((MLIST SIMP) ((MPLUS SIMP) ((MTIMES SIMP) -1 $ALPHA ((MEXPT SIMP) ((MPLUS SIMP) $ALPHA $BETA) -2)) ((MEXPT SIMP) ((MPLUS SIMP) $ALPHA $BETA) -1)) ((MTIMES SIMP) -1 $ALPHA ((MEXPT SIMP) ((MPLUS SIMP) $ALPHA $BETA) -2))) ((MLIST SIMP) ((MTIMES SIMP) ((RAT SIMP) -1 2) ((MEXPT SIMP) ((MPLUS SIMP) $ALPHA $BETA) ((RAT SIMP) -3 2))) ((MTIMES SIMP) ((RAT SIMP) -1 2) ((MEXPT SIMP) ((MPLUS SIMP) $ALPHA $BETA) ((RAT SIMP) -3 2))))))
(setf jfunc-form '((MDEFINE SIMP) (($F) $X $Y) ((MPLUS) ((MEXPT) $X 2) ((MEXPT) $Y 2) ((MTIMES) 2 $X $Y) ((%LOG) ((MQUOTIENT) $X $Y)))))
(setf block-form '((MPROG SIMP) ((MLIST SIMP) $X $Y) ((MSETQ SIMP) $X 1) ((MSETQ SIMP) $Y 2) ((MPLUS SIMP) $X $Y)))
(setf atan-form '((%ATAN SIMP) ((MTIMES SIMP) ((RAT SIMP) 1 4) $%PI)))
(setf pi-form '$%PI)
(setf compare-form '((MCOND SIMP) ((MGREATERP SIMP) $X $Y) $X T $Y))
(setf longcompare-form '((MCOND SIMP) ((MGREATERP SIMP) $X $Y) $X ((MGREATERP SIMP) $Y $Z) $Z T $Y))
