#lang racket

;; 第 14 章の演習 1 / 2 / 3 への解答を取り込んだ mini-lisp。
;;
;; 元の examples/ch14/mini-lisp.rkt に次を追加:
;;   - cond 構文 (演習 1)
;;   - set! 構文 (演習 2): mcons ベースのフレームで局所束縛を書き換える
;;
;; 動かし方:
;;   raco test solutions/ch14/mini-lisp.rkt    ; 演習 3 の確認も同梱

(require racket/match)

;; --- 環境: フレームは「(mcons name value) の不変リスト」 ---
;; 値を書き換えるために mpair? を使う。フレームそのものは不変で
;; 良いので、入れ物は通常の list に残す。
(struct env (frames globals) #:transparent)

(define (make-root-env)
  (define g (make-hash))
  (hash-set*! g
              '+ + '- - '* * '/ /
              '= = '< < '> > '<= <= '>= >=
              'cons cons 'car car 'cdr cdr 'list list
              'null? null? 'pair? pair? 'not not
              'eq? eq? 'equal? equal?)
  (env '() g))

(define (extend-env e names values)
  ;; 各 binding を可変セルにしておくと set! が書ける
  (define frame (map (lambda (n v) (mcons n v)) names values))
  (env (cons frame (env-frames e)) (env-globals e)))

(define (env-set-global! e name value)
  (hash-set! (env-globals e) name value))

(define (find-cell frames sym)
  (cond
    [(null? frames) #f]
    [else
     (define hit (findf (lambda (c) (eq? (mcar c) sym)) (car frames)))
     (or hit (find-cell (cdr frames) sym))]))

(define (env-lookup e sym)
  (define c (find-cell (env-frames e) sym))
  (cond
    [c (mcdr c)]
    [else (hash-ref (env-globals e) sym
                    (lambda () (error 'lookup "unbound: ~v" sym)))]))

(define (env-set! e sym value)
  (define c (find-cell (env-frames e) sym))
  (cond
    [c (set-mcdr! c value)]
    [(hash-has-key? (env-globals e) sym)
     (hash-set! (env-globals e) sym value)]
    [else (error 'set! "unbound: ~v" sym)]))

;; --- 評価器 ---
(define (mini-eval expr e)
  (match expr
    [(? number?)   expr]
    [(? boolean?)  expr]
    [(? string?)   expr]
    [(? symbol?)   (env-lookup e expr)]
    [(list 'quote datum) datum]
    [(list 'if c a b)
     (if (mini-eval c e)
         (mini-eval a e)
         (mini-eval b e))]
    ;; 演習 1: cond
    [(list* 'cond clauses)
     (let loop ([cs clauses])
       (cond
         [(null? cs) (void)]
         [(eq? (caar cs) 'else) (eval-body (cdar cs) e)]
         [(mini-eval (caar cs) e) (eval-body (cdar cs) e)]
         [else (loop (cdr cs))]))]
    ;; 演習 2: set!
    [(list 'set! (? symbol? name) v-expr)
     (env-set! e name (mini-eval v-expr e))
     (void)]
    [(list* 'lambda params body)
     (list 'closure params body e)]
    [(list* 'let bindings body)
     (define names (map car  bindings))
     (define vals  (map (lambda (b) (mini-eval (cadr b) e)) bindings))
     (eval-body body (extend-env e names vals))]
    [(cons f args)
     (apply-proc (mini-eval f e)
                 (map (lambda (a) (mini-eval a e)) args))]))

(define (eval-body exprs e)
  (cond
    [(null? (cdr exprs)) (mini-eval (car exprs) e)]
    [else
     (mini-eval (car exprs) e)
     (eval-body (cdr exprs) e)]))

(define (apply-proc proc args)
  (match proc
    [(list 'closure params body captured-env)
     (eval-body body (extend-env captured-env params args))]
    [(? procedure?)
     (apply proc args)]
    [else (error 'apply "not a procedure: ~v" proc)]))

;; --- トップレベル ---
(define (run program)
  (define e (make-root-env))
  (for/last ([form (in-list program)])
    (match form
      [(list 'define (cons name params) body ...)
       (env-set-global! e name
                        (mini-eval `(lambda ,params ,@body) e))
       (void)]
      [(list 'define name expr)
       (env-set-global! e name (mini-eval expr e))
       (void)]
      [else (mini-eval form e)])))

(provide run mini-eval make-root-env extend-env env-set-global! env-set!)

;; --- テスト ---
(module+ test
  (require rackunit)

  ;; 演習 1: cond
  (check-equal?
   (run '((define (classify n)
            (cond
              [(= n 0) 'zero]
              [(< n 0) 'negative]
              [else 'positive]))
          (list (classify -1) (classify 0) (classify 5))))
   '(negative zero positive))

  ;; 演習 2: set! で局所束縛を書き換える
  (check-equal?
   (run '((define (make-counter)
            (let ([n 0])
              (lambda ()
                (set! n (+ n 1))
                n)))
          (define c (make-counter))
          (list (c) (c) (c))))
   '(1 2 3))

  ;; 演習 3: 高階関数 compose が mini-lisp 内でも動く
  (check-equal?
   (run '((define (compose f g) (lambda (x) (f (g x))))
          (define (inc x) (+ x 1))
          (define (sq  x) (* x x))
          ((compose sq inc) 4)))
   25))
