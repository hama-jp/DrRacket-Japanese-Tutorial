#lang racket

;; 第 15 章 演習 1 の解答: hello-web.rkt に /sum?a=1&b=2 -> 3 (JSON) を追加

(require web-server/servlet
         web-server/servlet-env
         json)

(define (dispatch req)
  (define bindings (request-bindings req))
  (define path (map path/param-path (url-path (request-uri req))))
  (cond
    [(equal? path '("hello"))
     (define name (or (extract-binding/single 'name bindings) "みなさん"))
     (response/xexpr
      `(html (head (meta ((charset "utf-8"))) (title "Greet"))
             (body (h1 ,(format "こんにちは、~aさん!" name)))))]

    ;; 演習 1: /sum?a=1&b=2 -> { "result": 3 } (JSON)
    [(equal? path '("sum"))
     (define a (string->number (or (extract-binding/single 'a bindings) "")))
     (define b (string->number (or (extract-binding/single 'b bindings) "")))
     (cond
       [(and (number? a) (number? b))
        (response/jsexpr (hasheq 'a a 'b b 'result (+ a b)))]
       [else
        (response/jsexpr #:code 400
                         (hasheq 'error "a and b must be numbers"))])]

    [else
     (response/xexpr
      `(html (head (meta ((charset "utf-8"))) (title "Welcome"))
             (body (h1 "Welcome to Mini Racket Web")
                   (ul (li (a ((href "/hello?name=Reki")) "GET /hello?name=Reki"))
                       (li (a ((href "/sum?a=1&b=2"))      "GET /sum?a=1&b=2"))))))]))

(module+ main
  (serve/servlet dispatch
                 #:servlet-regexp #rx""
                 #:port 8000
                 #:listen-ip "127.0.0.1"
                 #:command-line? #t))
