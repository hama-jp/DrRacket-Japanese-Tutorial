# 解答集

本書各章末の「**手を動かしてみよう**」に対する解答を、章ごとに 1 ファイルずつまとめています。

## 使い方 — 3 段構成

独学では「答えを見る前に、自分の理解がどの段階で詰まっているか」を把握することが一番の学習材料です。そのため各問題は次の 3 段で書いています。**上から順に読んで、進めるところまで自力で進めてから次を開く** ようにすると効果的です。

1. **ヒント** — 何を考えれば前に進めるかだけを示す最小の助け
2. **部分解答** — 骨子となるコードや考え方。残りの穴埋めは読者任せ
3. **完全解答** — そのまま DrRacket / `racket` で走る完成版

完全解答は答え合わせ専用にしてください。目で追って「わかった気になる」のが一番もったいない使い方です。

## 章ごとの解答

| 章 | ファイル | 扱う課題 |
| --- | --- | --- |
| 1 | (演習なし) | — |
| 2 | [ch02.md](ch02.md) | DrRacket 起動、Check Syntax、ターミナル実行 |
| 3 | [ch03.md](ch03.md) | `print` / `write` / `display`、`area`、エラー読み |
| 4 | [ch04.md](ch04.md) | S式の評価、`(1 2 3)` のエラー、シンボル等価性 |
| 5 | [ch05.md](ch05.md) | `pow`、`compose`、`make-counter` |
| 6 | [ch06.md](ch06.md) | `double-all`、末尾再帰化、`mystery` の正体 |
| 7 | [ch07.md](ch07.md) | `my-last` / `my-reverse` / `flatten1` |
| 8 | [ch08.md](ch08.md) | `my-map` / `my-filter`、`for/list` → `map`、平均点 |
| 9 | [ch09.md](ch09.md) | `book` 構造体、図形の面積/外周、`word-count` |
| 10 | [ch10.md](ch10.md) | 素数判定、FizzBuzz ファイル出力、`safe-number` |
| 11 | [ch11.md](ch11.md) | `mathlib` 拡張、`module+ test`、循環依存 |
| 12 | [ch12.md](ch12.md) | `fib-iter` のテスト、`divide` の契約、`string-join` 契約 |
| 13 | [ch13.md](ch13.md) | 円の周囲に四角、ハノイの塔、シェルピンスキー並べ |
| 14 | [ch14.md](ch14.md) | mini-lisp に `cond` / `set!` を追加、`compose` テスト |
| 15 | [ch15.md](ch15.md) | `/sum` JSON、完了フラグ付き TODO、JSON 永続化 |
| 16 | [ch16.md](ch16.md) | `my-and`、`unless-let`、`cond` を `if` 連鎖に展開 |
| 17 | [ch17.md](ch17.md) | `call/cc` 早期終了、エラトステネスの篩、Typed `fib-iter` |

## 添付コード

解答量がまとまっている課題(第 11, 14, 15 章)は、そのまま `racket` コマンドで動くサンプルを章ごとに `solutions/chNN/` に置いています。各章の解答本文からそのファイルへリンクしています。

## 誤りを見つけたら

解答・サンプルコードともに手元の環境で実行確認していますが、誤植や別解の紹介漏れがあれば GitHub の Issue / Pull Request で指摘してもらえると助かります。
