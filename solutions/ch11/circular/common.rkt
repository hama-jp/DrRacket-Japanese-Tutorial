#lang racket

;; 循環依存を解消する典型パターン:
;; 「a と b の両方が欲しい関数」を 3 つ目のモジュールに切り出す。
;; a.rkt も b.rkt も common.rkt だけに依存する形にすれば循環しない。

(provide helper)

(define (helper x) (* x 2))
