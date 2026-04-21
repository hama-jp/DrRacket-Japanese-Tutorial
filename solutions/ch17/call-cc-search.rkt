#lang racket

;; 第 17 章 演習 1: call/cc で早期終了
;;
;; 「条件を満たす要素を全て集めたいが、途中で上限を超えたら打ち切る」
;; を continuation で書く。呼び出し元に値を投げ返すだけ。

(provide collect-up-to find-first-neg)

;; 例 1: pred? を満たす要素を max 個集めるまで走り、
;;       max 個を超えそうになったら 'aborted を返す。
(define (collect-up-to pred? xs max)
  (call/cc
   (lambda (abort)
     (define count 0)
     (for/list ([x (in-list xs)]
                #:when (pred? x))
       (set! count (+ count 1))
       (when (> count max) (abort 'aborted))
       x))))

;; 例 2: 最初に条件を満たす要素を返す。見つからなかったら #f。
;; Python 風に言えば next(filter(pred, xs), None)。
(define (find-first-neg xs)
  (call/cc
   (lambda (return)
     (for ([x (in-list xs)])
       (when (negative? x) (return x)))
     #f)))

(module+ test
  (require rackunit)
  (check-equal? (collect-up-to even? '(1 2 3 4 5 6) 2) 'aborted)
  (check-equal? (collect-up-to even? '(1 2 3 4 5 6) 3) '(2 4 6))
  (check-equal? (find-first-neg '(1 2 -3 4 -5)) -3)
  (check-equal? (find-first-neg '(1 2 3))       #f))
