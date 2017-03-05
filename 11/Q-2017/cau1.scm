(define (cau1 n i)
  (cond ((> (* i i) n) 0)
        ((= (* i i) n) 1)
        ((= (remainder n i) 0) (+ (cau1 n (+ i 1)) 2))
        (else (cau1 n (+ i 1)))))
(with-input-from-file "CAU1.INP" (lambda ()
  (with-output-to-file "CAU1.OUT" (lambda ()
    (format #t "~a\n" (cau1 (read) 1))))))
