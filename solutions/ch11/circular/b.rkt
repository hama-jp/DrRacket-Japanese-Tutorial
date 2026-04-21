#lang racket

(require "a.rkt")   ; ← ここで循環が閉じる
(provide bar)

(define (bar x) (foo x))
