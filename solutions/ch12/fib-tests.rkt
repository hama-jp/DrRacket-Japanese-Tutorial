#lang racket

;; 第 12 章 演習 1 の解答: fib-iter の rackunit テスト

(provide fib-iter)

(define (fib-iter n)
  (let loop ([i 0] [a 0] [b 1])
    (if (= i n) a (loop (+ i 1) b (+ a b)))))

(module+ test
  (require rackunit)
  (check-equal? (fib-iter 0)  0)
  (check-equal? (fib-iter 1)  1)
  (check-equal? (fib-iter 2)  1)
  (check-equal? (fib-iter 7)  13)
  (check-equal? (fib-iter 10) 55)
  (check-equal? (fib-iter 20) 6765)
  ;; 性質テスト: F(n+2) = F(n+1) + F(n)
  (for ([n (in-range 0 30)])
    (check-equal? (fib-iter (+ n 2))
                  (+ (fib-iter (+ n 1)) (fib-iter n)))))
