#lang racket

;; 第 17 章 演習 2: エラトステネスの篩 (Sieve of Eratosthenes) を
;; racket/stream で書く。無限ストリームの代表例。

(require racket/stream)
(provide primes take-primes)

(define (integers-from n)
  (stream-cons n (integers-from (+ n 1))))

(define (sieve s)
  (stream-cons
   (stream-first s)
   (sieve (stream-filter
           (lambda (x) (not (zero? (modulo x (stream-first s)))))
           (stream-rest s)))))

(define primes (sieve (integers-from 2)))

(define (take-primes n)
  (for/list ([p primes] [i (in-range n)]) p))

(module+ main
  ;; 最初の 15 個の素数
  (displayln (take-primes 15)))

(module+ test
  (require rackunit)
  (check-equal? (take-primes 10)
                '(2 3 5 7 11 13 17 19 23 29)))
