#lang racket

;; 第 13 章の演習 1 / 2 / 3 を 1 ファイルにまとめた解答。
;;
;; DrRacket で開くと絵が REPL 側に並んで表示される。
;; ターミナル実行なら、末尾で pict->bitmap 経由で PNG に書き出してもよい。

(require pict)

;; --- 演習 1: 中央の赤い円と、その上下左右に青い正方形 ---
(define center (colorize (disk 50) "red"))
(define sq     (colorize (filled-rectangle 30 30) "blue"))

(define four-squares-around-circle
  (cc-superimpose
    (hc-append 60 sq center sq)
    (vc-append 60 sq (blank 50 50) sq)))

;; --- 演習 2: n 階のハノイの塔を 1 本分描く ---
;; 下にいくほど太くなる円盤を vc-append で重ねる
(define (hanoi-tower n)
  (define (disk-of i)
    (colorize (filled-rectangle (* 20 (+ i 1)) 10)
              (vector-ref #("tomato" "goldenrod" "mediumseagreen"
                            "royalblue" "orchid" "sienna")
                          (modulo i 6))))
  (apply vc-append 2
         (for/list ([i (in-range (- n 1) -1 -1)])
           (disk-of i))))

(define (hanoi-scene n)
  ;; 3 本の棒のうち一番左だけ円盤を積んだ図(分かりやすさ優先)
  (define pole (colorize (filled-rectangle 4 (* 10 n)) "gray"))
  (define base (colorize (filled-rectangle (* 20 (+ n 2)) 6) "dimgray"))
  (define left (cb-superimpose pole (hanoi-tower n)))
  (vc-append left base))

;; --- 演習 3: sierpinski n (n=1..6) を横に並べる ---
(define (sierpinski n)
  (cond
    [(= n 0) (colorize (filled-rectangle 4 4) "darkslateblue")]
    [else
     (let ([small (sierpinski (- n 1))])
       (vc-append (hc-append small small)
                  (hc-append small (ghost small))))]))

(define sierpinski-row
  (apply hc-append 20
         (for/list ([n (in-range 1 7)]) (sierpinski n))))

(module+ main
  ;; ターミナル実行時に PNG に書き出したい場合はここを有効化する
  (require racket/draw)
  (define (save-pict p path)
    (send (pict->bitmap p) save-file path 'png))
  (save-pict four-squares-around-circle "/tmp/ch13-ex1.png")
  (save-pict (hanoi-scene 5)            "/tmp/ch13-ex2.png")
  (save-pict sierpinski-row             "/tmp/ch13-ex3.png")
  (displayln "saved to /tmp/ch13-ex{1,2,3}.png"))

(provide four-squares-around-circle hanoi-tower hanoi-scene sierpinski sierpinski-row)
