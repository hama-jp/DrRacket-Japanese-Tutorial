#lang racket

;; 第 16 章の演習 1 / 2 の解答。
;;   - my-and  (演習 1): 短絡評価の and をマクロで
;;   - unless-let (演習 2): 値を束縛し、真ならスキップ、偽なら本体を実行

(provide my-and unless-let)

;; 演習 1: 本文のヒントそのまま
(define-syntax my-and
  (syntax-rules ()
    [(_)          #t]
    [(_ e)        e]
    [(_ e1 e2 ...) (if e1 (my-and e2 ...) #f)]))

;; 演習 2: 値を 1 度だけ評価して束縛 → 真ならスキップ、偽なら本体を実行
(define-syntax unless-let
  (syntax-rules ()
    [(_ name expr body ...)
     (let ([name expr])
       (unless name body ...))]))

(module+ test
  (require rackunit)

  ;; my-and
  (check-equal? (my-and) #t)
  (check-equal? (my-and 7) 7)
  (check-equal? (my-and 1 2 3) 3)          ; 最後の真値が結果
  (check-equal? (my-and 1 #f 3) #f)         ; #f があればそこで打ち切り
  ;; 副作用が打ち切られていることを確認
  (define hit 0)
  (my-and #f (begin (set! hit (+ hit 1)) 'unused))
  (check-equal? hit 0)

  ;; unless-let
  (define lines '())
  (unless-let x #f
    (set! lines (cons 'ran-when-false lines)))
  (check-equal? lines '(ran-when-false))

  (unless-let x 42
    (set! lines (cons 'should-not-run lines)))
  (check-equal? lines '(ran-when-false))   ; 増えていない

  ;; expr が 1 回しか評価されないことを確認
  (define evals 0)
  (define (side-effect!)
    (set! evals (+ evals 1))
    42)
  (unless-let v (side-effect!)
    (void))
  (check-equal? evals 1))
