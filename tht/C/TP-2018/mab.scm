(define (read-table m n)
  (define (read-row n)
    (if (= n 0)
        '()
        (cons (read)
              (read-row (- n 1)))))
  (if (= m 0)
      '()
      (cons (read-row n)
            (read-table (- m 1) n))))

(define (accumulate-n op last seqs)
  (define (accumulate op last sequence)
    (if (null? sequence)
        last
        (op (car sequence)
            (accumulate op last (cdr sequence)))))
  (if (null? (car seqs))
      '()
      (cons (accumulate op last (map car seqs))
            (accumulate-n op last (map cdr seqs)))))

(define (remove-duplicates sequence)
  (if (< (length sequence) 2)
      sequence
      (let ((a (car sequence))
            (d (remove-duplicates (cdr sequence))))
        (if (= a (car d)) d (cons a d)))))

(define (lol-to-vos matrix cmp)
  (list->vector (map (lambda (lst)
                       (list->vector (remove-duplicates (sort lst cmp))))
                     matrix)))

; Since we're sure that val is in vec, no need to check if low > high.
(define (binary-search vec cmp val low high)
  (let* ((mid (floor (/ (+ high low) 2)))
         (n (vector-ref vec mid)))
    (cond ((= n val) mid)
          ((cmp n val) (binary-search vec cmp val (+ mid 1) high))
          (else (binary-search vec cmp val low (- mid 1))))))

(define (make-lov m n)
  (if (= m 0)
      '()
      (cons (make-vector n 0)
            (make-lov (- m 1) n))))

(define (exact m n a r c e)
  (define (iter i j)
    (let ((val (vector-ref (vector-ref a i) j))
          (row (vector-ref r i))
          (col (vector-ref c j)))
      (let ((alphas (vector-ref e (binary-search row < val 0 (vector-length row))))
            (beta (binary-search col > val 0 (vector-length col))))
        (vector-set! alphas beta (+ (vector-ref alphas beta) 1))))
    (cond ((and (= i m) (= j n)) e)
          ((= j n) (iter (+ i 1) 0))
          (else (iter i (+ j 1)))))
  (iter 0 0))

(define (all-rows matrix m n)
  (define (all-row row)
    (define (iter i)
      (if (< i (- n 1))
          (let ((j (+ i 1)))
            (vector-set! row j (+ (vector-ref row i)
                                  (vector-ref row j)))
            (iter j))))
    (iter 0))
  (let ((i (- m 1)))
    (all-row (vector-ref matrix i))
    (if (> i 0) (all-rows matrix i n))))

(define (all matrix m n)
  (define (iter i j)
    (let ((row (vector-ref matrix i))
          (l (- i 1)))
      (vector-set! row j (+ (vector-ref row j)
                            (vector-ref (vector-ref matrix l) j))))
    (cond ((and (= i m) (= j n)))
          ((= j n) (iter (+ i 1) 0))
          (else (iter i (+ j 1)))))
  (if (> m 0) (iter 1 0)))

(define (answer e m n k)
  (if (> k 0)
      (let* ((a ((lambda (x) (if (= x m) (- x 1) x)) (read)))
             (b ((lambda (x) (if (= x n) (- x 1) x)) (read))))
        (display (vector-ref (vector-ref e a) b))
        (newline)
        (answer e m n (- k 1)))))

(with-input-from-file "MAB.INP"
  (lambda ()
    (with-output-to-file "MAB.OUT"
      (lambda ()
        (let* ((m (read))
               (n (read))
               (k (read))
               (a (read-table m n))
               (e (exact (- m 1)
                         (- n 1)
                         (list->vector (map list->vector a))
                         (lol-to-vos a <)
                         (lol-to-vos (accumulate-n cons '() a) >)
                         (list->vector (make-lov m n)))))
          (all-rows e m n)
          (all e (- m 1) (- n 1))
          (answer e m n k))))))