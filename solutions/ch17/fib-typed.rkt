#lang typed/racket

;; 第 17 章 演習 3: Typed Racket で fib-iter に型を付ける。
;;
;; Nonnegative-Integer を引数に取るようにすると、負の n を渡した呼び出しは
;; 型検査の段階で拒否される。試したい場合は下のコメントを外してみること。

(: fib-iter (-> Nonnegative-Integer Nonnegative-Integer))
(define (fib-iter n)
  (let loop : Nonnegative-Integer
       ([i : Nonnegative-Integer 0]
        [a : Nonnegative-Integer 0]
        [b : Nonnegative-Integer 1])
    (if (= i n)
        a
        (loop (+ i 1) b (+ a b)))))

(module+ main
  (displayln (fib-iter 0))     ; 0
  (displayln (fib-iter 10))    ; 55
  (displayln (fib-iter 30)))   ; 832040

;; (fib-iter -1)
;; => Type Checker: type mismatch
;;      expected: Nonnegative-Integer
;;      given: Negative-Integer

(module+ test
  (require typed/rackunit)
  (check-equal? (fib-iter 0)  0)
  (check-equal? (fib-iter 1)  1)
  (check-equal? (fib-iter 10) 55))
