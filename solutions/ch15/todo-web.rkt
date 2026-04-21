#lang racket

;; 第 15 章 演習 2 / 3 の解答:
;;   - TODO に完了フラグを追加 (POST /toggle)
;;   - 起動時に /tmp/todos.json から復元、更新時に書き戻し

(require web-server/servlet
         web-server/servlet-env
         json)

(define TODO-FILE "/tmp/todos.json")

;; メモリ上の表現: id -> (hash 'text string 'done boolean)
(define todos (make-hash))
(define next-id 0)

(define (todo-hash id txt done?)
  (hasheq 'id id 'text txt 'done done?))

(define (load-todos!)
  (when (file-exists? TODO-FILE)
    (define parsed
      (with-handlers ([exn:fail? (lambda (_) '())])
        (call-with-input-file TODO-FILE read-json)))
    (for ([item (in-list (if (list? parsed) parsed '()))])
      (define id (hash-ref item 'id))
      (hash-set! todos id item)
      (when (> id next-id) (set! next-id id)))))

(define (save-todos!)
  (call-with-output-file TODO-FILE #:exists 'replace
    (lambda (out)
      (write-json (for/list ([(_ v) (in-hash todos)]) v) out))))

(define (add-todo! text)
  (set! next-id (+ next-id 1))
  (hash-set! todos next-id (todo-hash next-id text #f))
  (save-todos!))

(define (toggle-todo! id)
  (define cur (hash-ref todos id #f))
  (when cur
    (hash-set! todos id
               (hash-set cur 'done (not (hash-ref cur 'done #f))))
    (save-todos!)))

(define (delete-todo! id)
  (hash-remove! todos id)
  (save-todos!))

(define (render-item item)
  (define id   (hash-ref item 'id))
  (define text (hash-ref item 'text))
  (define done (hash-ref item 'done #f))
  (define label (if done `(s ,text) text))
  `(li ,label " "
       (form ((method "POST") (action "/toggle") (style "display:inline"))
             (input ((type "hidden") (name "id")
                     (value ,(number->string id))))
             (button ((type "submit")) ,(if done "↶" "✓")))
       (form ((method "POST") (action "/delete") (style "display:inline"))
             (input ((type "hidden") (name "id")
                     (value ,(number->string id))))
             (button ((type "submit")) "✕"))))

(define (render-page)
  `(html
    (head (meta ((charset "utf-8"))) (title "Mini TODO"))
    (body
     (h1 "Mini TODO")
     (form ((method "POST") (action "/add"))
           (input ((type "text") (name "text")
                   (placeholder "new item") (required ""))) " "
           (button ((type "submit")) "Add"))
     (ul
      ,@(for/list ([item (in-list
                          (sort (hash-values todos) < #:key
                                (lambda (i) (hash-ref i 'id))))])
          (render-item item))))))

(define (post? req) (equal? (request-method req) #"POST"))

(define (dispatch req)
  (define path (map path/param-path (url-path (request-uri req))))
  (define bindings (request-bindings req))
  (cond
    [(and (equal? path '("add")) (post? req))
     (define txt (extract-binding/single 'text bindings))
     (when txt (add-todo! txt))
     (redirect-to "/" temporarily)]
    [(and (equal? path '("toggle")) (post? req))
     (define id (string->number
                 (or (extract-binding/single 'id bindings) "0")))
     (when id (toggle-todo! id))
     (redirect-to "/" temporarily)]
    [(and (equal? path '("delete")) (post? req))
     (define id (string->number
                 (or (extract-binding/single 'id bindings) "0")))
     (when id (delete-todo! id))
     (redirect-to "/" temporarily)]
    [else (response/xexpr (render-page))]))

(module+ main
  (load-todos!)
  (serve/servlet dispatch
                 #:servlet-regexp #rx""
                 #:port 8001
                 #:listen-ip "127.0.0.1"
                 #:command-line? #t))
