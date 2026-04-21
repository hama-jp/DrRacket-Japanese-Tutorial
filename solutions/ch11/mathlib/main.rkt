#lang racket

;; 第 11 章の演習 1 / 2 の解答。
;; - cube / hypot3 を追加
;; - `module+ test` で rackunit によるテストを同梱
;;
;; 動かし方:
;;   raco test solutions/ch11/mathlib/main.rkt
;;   racket    solutions/ch11/user.rkt

(provide square hypot cube hypot3)

(define (square x) (* x x))

(define (hypot a b)
  (sqrt (+ (square a) (square b))))

(define (cube x) (* x x x))

(define (hypot3 a b c)
  (sqrt (+ (square a) (square b) (square c))))

(module+ test
  (require rackunit)
  (check-equal? (square 5) 25)
  (check-equal? (hypot 3 4) 5)
  (check-equal? (cube 0) 0)
  (check-equal? (cube 3) 27)
  (check-equal? (hypot3 0 0 0) 0)
  (check-= (hypot3 1 2 2) 3 1e-9)
  (check-= (hypot3 2 3 6) 7 1e-9))
