(load "C:/Users/Nikolaos/Documents/ACT-UP/load-act-up.lisp")
(load "C:/Users/Nikolaos/Documents/hp_kb_0-97.lsp")
(load "C:/Users/Nikolaos/Documents/hp_fact_frequencies_0-98.lsp")
(load "C:/Users/Nikolaos/Documents/hp_training_regimens_gamma.lsp")
(load "C:/Users/Nikolaos/Documents/hp_test_0-97.lsp")

(reset-model)
(reset-actup)

(define-chunk-type relation ent1 ent2 rel)

(defun train-fact-times (fact freq)
  (dotimes (i freq) (learn-chunk (eval fact))))

(defun train-book-once (book freqs)
  (mapcar #'train-fact-times book (eval freqs)))

(defun train-book-times (book freqs times)
  (dotimes (i times) (train-book-once book freqs)))

; set the retrieval threshold

(setf *rt* 0)

; define procedural rules

(defproc is-in2 (a b)
		 (pass-time 2)
		 (let ((p (retrieve-chunk (list :chunk-type 'relation :rel 'is-in :ent1 a :ent2 b))))
		   (not
			 (not
			   (or p 
				   (let* ((q (retrieve-chunk (list :chunk-type 'relation :rel 'is-in :ent1 a)))
						(aprime (and q (relation-ent2 q))))
					 (and aprime (is-in2 aprime b))))
			 ))))

(defproc has-been (a b)
		 (pass-time 2)
		 (let ((p (retrieve-chunk (list :chunk-type 'relation :rel 'been-in :ent1 a :ent2 b))))
		   (not
			 (not
			   (or p 
				   (let* ((q (retrieve-chunk (list :chunk-type 'relation :rel 'been-in :ent1 a)))
						(aprime (and q (relation-ent2 q))))
					 (and aprime (is-in2 aprime b))))
			 ))))

; this makes a list of (B, F) tuples -- unevaluated lists
(setf bf-tuples (mapcar #'list hp-kb *fact-frequencies*))

(defun deal-tuple (tuple times)
  (let ((b (eval (car tuple)))
		(f (cadr tuple)))
	(train-book-times b f times)))

(defun train-save-model (regimen)
  (reset-model)
  (mapcar #'deal-tuple bf-tuples (eval regimen))
  (setf *models* (append *models* (list (current-model)))))

(setf *models* nil)

(dolist (r *sim-training-regimens*) (train-save-model r))

(setf *key* (list t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
					t  t  t  t  t  t  t 
))

(defun take-test (agent test)
  (setf response nil)
  (with-current-model 
	agent
	(dolist (item test)
	  (push (eval item) response))
  (reverse response)))

(defun scoring-function (response key)
  (mapcar #'(lambda (p q) (eq p q)) response key))

(setf *responses* nil)

(dolist (agent *models*) 
  (setf *responses* 
		(append *responses* 
				(list (scoring-function
						(take-test agent *test*) 
						*key*)))))

(print *responses*)

; this should be copiable to clipboard and readable from r
; read.table("clipboard", header = F, sep = ";") -> simul
(dolist (i *responses*)
  (progn 
	(format t "~%") 
	(dolist (j i) 
	  (format t "~s;" (if j 1 0)))))
