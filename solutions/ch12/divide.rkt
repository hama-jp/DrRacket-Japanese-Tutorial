#lang racket

;; 第 12 章 演習 2 の解答: `divide` を ->i 契約で包む。
;;
;;   - 第 1 引数: 任意の数値
;;   - 第 2 引数: 0 でない数値
;;   - 結果:     数値
;;   - 結果が負になるときは契約違反(ポストコンディション)

(provide (contract-out
          [divide (->i ([a number?]
                        [b (and/c number? (not/c zero?))])
                      [result (a b) (and/c number?
                                           (lambda (r) (>= r 0)))])]))

(define (divide a b) (/ a b))

(module+ test
  (require rackunit)
  ;; 正常系
  (check-equal? (divide 10 2) 5)
  (check-equal? (divide 0  3) 0)

  ;; 0 除算 → 契約違反
  (check-exn exn:fail:contract?
             (lambda () (divide 10 0)))

  ;; 第 2 引数が数値でない → 契約違反
  (check-exn exn:fail:contract?
             (lambda () (divide 10 "two")))

  ;; 結果が負 → ポストコンディション違反
  (check-exn exn:fail:contract?
             (lambda () (divide -10 2))))
