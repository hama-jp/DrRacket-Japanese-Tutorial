#lang racket

;; 演習 3: 循環依存の観察用。
;; a.rkt が b.rkt を require し、b.rkt が a.rkt を require すると
;; racket が「module: cycle in loading」エラーを出す。
;;
;; 実行してみる:
;;   racket solutions/ch11/circular/a.rkt

(require "b.rkt")
(provide foo)

(define (foo x) (bar x))
