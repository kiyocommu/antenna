# Web Antenna 変更履歴

work-log から抽出した Web Antenna コーディング関連の変更記録。

---

## 2026-06-02

### コードレビュー指摘への堅牢化対応

**対象ファイル**: `output/antenna/antenna.html`

`reference/antenna-コードレビュー-2026-06-02.md` の指摘のうち、データ仕様変更や操作感の大きな変更を伴わない項目を修正。

#### 変更内容

- 起動時 Cloud マージを配列再代入ではなく in-place 更新に変更し、確認処理中のサイトオブジェクトが差し替わらないよう調整
- Cloud ロード後の全件アップロードを、ローカル側に Cloud より新しい変更がある場合のみに制限
- 設定モーダル・タイル詳細・画像ライトボックス・スマホ詳細が開いている間、背面のキーボードショートカットが発火しないようガードを追加
- `APP_VERSION` を `2026-06-02.review-hardening` に更新
- 画像URL抽出の `data:` 判定を1条件に整理
- `#custom-proxy-input` の重複CSSを統合
- URLホスト名取得を `hostnameOf()` に集約
- `escapeHtml()` でシングルクォートもエスケープ
- 新規サイト作成時に `snippetDiff` を初期化
- 画像キャッシュに上限を設け、サイト削除時に該当キャッシュを削除

#### 保留

- 削除伝播の tombstone 化は、Supabase スキーマと同期仕様の変更を伴うため未実装
- `prev_text` を Cloud に送らない設計は、端末間の差分履歴共有に影響するため未実装
- `renderList()` の差分描画化は実装範囲が大きく、フォーカス・並び替え・表示モードへの副作用があり得るため未実装

#### 確認

- 埋め込みJavaScriptの構文チェックを実施

---

### 非表示メニューを更新チェック対象から除外

**対象ファイル**: `output/antenna/antenna.html`

Web Antenna の本文抽出で、画面上は見えていないヘッダー・メニュー・アクセシビリティ用テキストが差分に出る問題を修正。

#### 変更内容

- `removeNonVisibleAndChrome()` を追加し、非表示要素・ヘッダー・ナビゲーション・フォーム・フッター類を抽出前に除外
- `hidden` / `aria-hidden` / `display:none` / `visibility:hidden` / `opacity:0` / `.hide` などを自動除外
- 愛媛県庁サイトのような `#header`、`#top_search`、`#header_fixed_div` 由来のメニュー文が差分に混ざりにくいよう調整
- 監視範囲プリセットに `#main` を追加
- 監視範囲ヘルプに「非表示要素やヘッダー・メニュー類は自動除外する」旨を追記

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- 愛媛県庁ページHTMLでノイズ源の `class="hide"`、`#header`、`#top_search`、`#header_fixed_div`、本文領域 `#main` を確認

---

### ライトモードのロゴ色を青系アクセントへ変更

**対象ファイル**: `output/antenna/antenna.html`

Web Antenna のライトモードロゴ色を、RSS Reader ライトモードのロゴと同じ青系アクセント（`#64779f`）へ統一。

#### 変更内容

- `body.light #logo` に `var(--antenna-accent)` を適用
- ロゴhover時の更新マーク色も `var(--antenna-accent)` に統一
- PC表示（`min-width: 761px`）でも `#logo` と更新マークに `#64779f` を明示適用
- 既存の `--antenna-accent: #64779f` を利用し、ダークモードの赤系ロゴ色は維持

---

## 2026-06-01

### スマホ設定画面の同期・保存ボタン配置を調整

**対象ファイル**: `output/antenna/antenna.html`

スマホ表示の設定画面で保存ボタンが下部にはみ出す場合があったため、RSS Reader Cloud と同じく同期ボタンと保存ボタンをフッター内に横並びで配置。

#### 変更内容

- Cloud設定セクション内にあった「同期」ボタンを設定フッターへ移動
- 設定フッターで「同期」「保存」を横並び表示
- スマホ表示では下部 safe area を含めたフッター余白を確保
- スマホ表示の設定本文高さをフッター分だけ差し引き、保存ボタンが画面外へはみ出しにくいよう調整
- 「同期」はアウトライン、「保存」は塗りボタンとして RSS Reader Cloud に近い見た目へ調整

#### 確認

- 埋め込みJavaScriptの構文チェックを実施

---

### Cloud同期結果の表示を一時通知に統一

**対象ファイル**: `output/antenna/antenna.html`

Web Antenna の Cloud 同期成功・失敗メッセージが常設ステータスバーに残る表示になっていたため、RSS Reader Cloud / AI Blog と同じく画面下部の一時通知として表示するよう変更。

#### 変更内容

- 画面下部中央に一時通知用の `#status` を追加
- 同期成功は成功色、同期失敗はエラー色で表示
- 同期成功・同期データ取得・同期失敗・Cloud設定未入力の表示を一時通知へ変更
- 表示文言を `同期しました（サイトN件）` / `同期データを取得しました（サイトN件）` に整理

#### 確認

- 埋め込みJavaScriptの構文チェックを実施

---

### スマホ設定画面の表示テーマ切り替えデザインを統一

**対象ファイル**: `output/antenna/antenna.html`

Web Antenna の設定画面にある「表示設定」のテーマ切り替え部分が、RSS Reader Cloud / AI Blog と異なる塗りボタン表示になっていたため、同じ行カード型の見た目へ統一。

#### 変更内容

- 「表示テーマ」行を、薄い背景・枠線付きのカード状レイアウトへ変更
- テーマ切り替えボタンを、保存/同期ボタンとは別の丸いアウトラインボタンへ変更
- ライトモード時の背景・枠線・hover 表示を RSS Reader Cloud / AI Blog と同系統に調整
- ボタン表示を「切り替え先」ではなく、他2アプリと同じく現在のテーマ名（ライト / ダーク）に変更

#### 確認

- 埋め込みJavaScriptの構文チェックを実施

---

### ホーム画面追加時のスマホ safe area を補正

**対象ファイル**: `output/antenna/antenna.html`

ホーム画面に追加した Web Antenna をスマホ横向きにした時、上部に空白ができる場合があったため、AI Blog と同じ方針で iOS standalone 表示向けの viewport と高さ計算を調整。

#### 変更内容

- viewport に `viewport-fit=cover` を追加
- iOS ホーム画面アプリ用のステータスバー表示を `black-translucent` に設定
- `visualViewport` の高さを CSS 変数へ反映し、回転後の表示高さを再計算
- 横向きスマホでは上方向の safe area 余白を 0 にし、左右の safe area は維持
- 縦向き standalone ではステータスバーや角丸にボタンが被らないよう上部・左右の safe area を確保
- HTML背景色をテーマに合わせ、余白が見えても背景色がずれないよう調整

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- manifestのJSON構文チェックを実施

---

### 3アプリのホーム画面アイコン配色を統一

**対象ファイル**: `output/antenna/antenna.html`、`output/antenna/manifest.webmanifest`、`output/antenna/icons/app-icon.svg`、`output/antenna/icons/favicon-16.png`、`output/antenna/icons/favicon-32.png`、`output/antenna/icons/apple-touch-icon.png`、`output/antenna/icons/app-icon-192.png`、`output/antenna/icons/app-icon-512.png`

RSS Reader Cloud / AI Blog / Web Antenna のホーム画面アイコンを、RSS Reader Cloud のライトモードタイトル色に合わせて統一。

#### 変更内容

- アイコン背景を `#64779f` の角丸背景へ変更
- アイコン内の使用色を `#64779f` と白のみに整理
- A型アンテナ塔と電波アークの位置を微調整し、他2アプリと余白・サイズ感が揃うよう変更
- SVGソースから180px/192px/512pxのPNGアイコンを再生成
- 同じデザインの16px/32px favicon PNGを追加し、HTMLから参照
- `theme-color` とmanifestのテーマ色を共通ベースカラーへ変更

#### 確認

- 3アプリの512pxアイコンを一覧画像で目視確認
- PNGアイコンの画像サイズを確認

---

### 取扱説明書をHTML版として再構成しPR資料を削除

**対象ファイル**: `output/antenna/antenna-取扱説明書.html`、`output/antenna/antenna-取扱説明書.md`、`output/antenna/antenna-PR.md`、`output/antenna/antenna-PR.pdf`

RSS Reader Cloud / AI Blog と同じ構成に合わせ、Web Antenna の取扱説明書をHTML版として作り直した。
あわせて、古いPR資料のMarkdown/PDFを `output/antenna/` から削除した。

#### 変更内容

- HTML版の取扱説明書を新規作成
- 概要、最短セットアップ、画面構成、更新確認、差分表示、監視設定、タグ・ピン、タイル/画像、Cloud同期、スマホ操作、import/export、データ仕様、トラブル対応を章立てで整理
- `application/ld+json` とAI向け構造化サマリーを追加
- 旧Markdown説明書はHTML版への案内に差し替え
- `antenna-PR.md` と `antenna-PR.pdf` を削除

#### 確認

- HTML版に主要章が含まれることを確認
- `antenna-PR.md` / `antenna-PR.pdf` が削除済みであることを確認

---

### スマホ設定画面にテーマ切り替えを追加

**対象ファイル**: `output/antenna/antenna.html`、`output/antenna/antenna-取扱説明書.md`

スマホ表示では下部ショートカットバーが非表示になるため、RSS Reader / AI Blog と同様に設定モーダルからライト / ダークを切り替えられるようにした。

#### 変更内容

- 設定モーダルの先頭に「表示設定」セクションを追加
- `表示テーマ` 行とライト / ダーク切り替えボタンを追加
- 既存の下部テーマボタンと同じ `toggleTheme()` を使うよう整理
- 切り替え後、設定内ボタンの表示名とアクセシブル名を即時更新

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- in-app Browser のスマホ幅で設定画面を開き、テーマ切り替えが反映されることを確認

---

### ホーム画面追加用アイコンを追加

**対象ファイル**: `output/antenna/antenna.html`、`output/antenna/manifest.webmanifest`、`output/antenna/icons/`

スマホのホーム画面に追加した時に、Web Antenna のファビコンを元にした専用アイコンが表示されるようにした。

#### 変更内容

- Aの文字をモチーフにしたアンテナ塔のデザインを維持
- アンテナ上部に左右の電波アークを追加
- 元データ `icons/app-icon.svg` を追加
- `apple-touch-icon.png`、`app-icon-192.png`、`app-icon-512.png` を生成
- `manifest.webmanifest` を追加
- HTMLに `favicon`、`apple-touch-icon`、`manifest`、スマホWeb App用メタタグを追加

#### 確認

- PNGアイコンの画像サイズを確認
- `manifest.webmanifest` のJSON構文チェックを実施
- 埋め込みJavaScriptの構文チェックを実施
- 512pxアイコンを目視確認

---

### Cloud同期とスマホ表示を追加

**対象ファイル**: `output/antenna/antenna.html`、`output/antenna/supabase-schema.sql`、`output/antenna/antenna-取扱説明書.md`

RSS Reader Cloud / AI Blog と同じ Supabase REST API 方式で、Web Antenna の監視サイトを複数端末間で同期できるようにした。
同時にスマホ幅では一覧と詳細を切り替える表示にし、スマホでは import/export とタイル表示を出さない構成へ調整。

#### 変更内容

- 設定モーダルに `Supabase URL`、`anon key`、`共有ID` を追加
- ヘッダーに `local` / `sync: 共有ID` の Cloud 状態表示を追加
- `antenna_sites` テーブル用の Supabase スキーマを追加
- サイト追加、削除、確認、タグ変更、ピン変更、監視設定変更時に Cloud 同期をキューする処理を追加
- 起動時に Cloud 設定がある場合は Supabase から取得し、URLごとに新しいデータを優先してローカルとマージ
- Cloud 保存は upsert 後に差分削除する方式にして、通信失敗時に Cloud 側が空になりにくいよう調整
- スマホ表示では URL 入力欄を **＋** で開閉し、一覧タップで詳細画面を全画面表示
- スマホ表示では import/export ボタンとタイル表示ボタンを非表示化
- タイルモード保存済みでもスマホではリスト表示で開くよう調整

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- in-app Browser でPC幅の基本表示、スマホ幅のボタン非表示、URL入力開閉、一覧→詳細→戻る、Cloud設定画面を確認

---

## 2026-05-25

### ボタン説明を独自ツールチップへ統一

**対象ファイル**: `output/antenna/antenna.html`

ボタンにカーソルを重ねた時の説明表示を、AI Blog と同じ `data-tooltip` ベースの独自ツールチップへ変更。

#### 変更内容

- `button[data-tooltip]` 用のラベル・矢印スタイルを追加
- ライトモードでは既存の `--antenna-*` 変数を使ってツールチップ配色を調整
- ヘッダー、一覧、タイル、画像モード、オーバーレイ、設定、テーマ切替の主要ボタンを `data-tooltip` / `aria-label` 対応に変更
- 右端の画像モードボタンは、説明ラベルを右揃えにして画面端で切れないよう調整
- ピン状態に応じてツールチップ文言が `ピンを立てる` / `ピンを外す` に更新される動作を維持

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- ローカルブラウザで `data-tooltip` の位置と表示スタイルを確認

---

### 全確認ボタンをロゴ内に統合

**対象ファイル**: `output/antenna/antenna.html`、`output/antenna/antenna-取扱説明書.md`

全確認の `⟳` を RSS Reader と同じくロゴ内のマークとして表示し、ロゴ全体のクリックで全サイト確認を実行する形に変更。

#### 変更内容

- 独立した `#refresh-btn` をヘッダーから外し、`#site-refresh-mark` を `#logo` 内に追加
- ロゴ hover 時に `⟳` が軽く回転する表示を追加
- `checkAll()` から独立ボタンの無効化処理を外し、追加ボタンの実行中無効化は維持
- 取扱説明書の全確認操作説明を更新

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- ローカルブラウザでロゴクリックと `r` キーによる全確認開始を確認

---

### 一覧ヘッダー右上ボタンのデザイン統一

**対象ファイル**: `output/antenna/antenna.html`

一覧ヘッダー右側のピン済み表示・タイル表示・画像モードの3ボタンを、同じサイズと状態表現のシンプルなアイコンボタンに統一。

#### 変更内容

- `#pin-filter-btn`、`#view-toggle-btn`、`#image-mode-btn` に共通クラスを追加
- 3ボタンを固定サイズのアイコンボタンに揃え、ボタングループとしてまとまって見える余白に調整
- hover / active 表示を既存のアクセント色ベースで統一
- 既存のクリック動作、ショートカット、tooltip は維持

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- ローカルブラウザでライト/ダーク、ピン済み表示、タイル表示、画像モードの切り替えを確認

---

## 2026-05-24

### ボタンとライトモード配色をRSS Reader / AI Blog調に統一

**対象ファイル**: `output/antenna/antenna.html`、`output/antenna/antenna-取扱説明書.md`

Web Antenna の操作ボタンを透明アウトライン中心の控えめな表示に揃え、ライトモードを RSS Reader 寄りの暖色パレットへ調整。

#### 変更内容

- ヘッダー、一覧、タイル、画像モード、オーバーレイ、設定モーダルのボタン形状を統一
- 通常時は muted 色、hover時は淡い背景とアクセント枠、active時はアクセント色で表示
- ライトモード用の `--antenna-*` CSS変数を追加し、背景・パネル・入力欄・スニペット・タグ・モーダルをRSS Reader寄せの配色に調整
- ピンアイコンを 📍 に変更し、未ピンは控えめ、ピン済みは色付き表示に変更
- フッターのショートカットキー表示をRSS Readerと同じ淡いパネル色・枠線・muted文字色に調整
- 取扱説明書のピンアイコン表記を更新

#### 確認

- 埋め込みJavaScriptの構文チェックを実施
- ローカルブラウザでライト/ダーク、リスト、タイル、画像モード、オーバーレイ、設定モーダルの表示を確認

---

## 2026-05-12

### 全確認ボタンの挙動を RSS Reader に合わせて調整

- ヘッダーの全確認ボタン横に RSS Reader と同じ小スピナーを表示
- 下部ローダーの開始・進捗・完了処理を関数化し、RSS Reader の更新ローダーと同じ流れに統一
- 全確認後、一部サイトの取得に失敗した場合は失敗サイト名をステータスバーに表示
- `#refresh-btn` の背景色・枠線・文字色・サイズ・hover 指定を RSS Reader と同じデザインに調整

---

## 2026-04-08

### Web Antenna ツールの新規作成

**ファイル**: `output/antenna/antenna.html`（新規作成）

はてなアンテナのような「Webページ更新監視ツール」を rss-reader と同じデザイン哲学で作成。

#### 機能
- 任意のURLを登録して更新を監視
- 更新されたサイトを上から順に表示（`lastChangedAt` でソート）
- 更新箇所の抜粋（スニペット）を表示
- ファビコン表示
- export / import（JSON形式）
- ダーク／ライトモード切替
- キーボードショートカット（j/k/o/r）
- サイドバーリサイズ対応

#### 技術仕様
| 項目 | 内容 |
|------|------|
| データ保存 | localStorage（`antenna-sites`、`antenna-proxy-cache`、`antenna-theme`） |
| 変更検出 | SHA-256 ハッシュ（Web Crypto API）でテキスト全体を比較 |
| スニペット生成 | 初回差分発生位置の前後からテキスト抽出（約280文字） |
| CORSプロキシ | allorigins-raw / allorigins-json / codetabs / corsproxy.io |
| 同時確認数 | 最大3件並列 |
| テキスト抽出 | DOMParser + script/style/nav/footer 等を除去して本文テキストのみ |
| テキスト上限 | 20,000 文字 |

---

### UI 調整

- テーマ切替ボタンをヘッダー右端 → ショートカットバー右端に移動（rss-reader と統一）
- ヘッダー各要素のサイズを rss-reader に合わせて拡大（ロゴ 18px/600・URL入力 14px 等）
- 📋ボタンを削除
- ライトモードの add ボタン色を追加（`background: #B8C2D8`）
- 監視サイトの並び順を固定：`lastChangedAt` のみでソート。一度も更新がないサイトは `addedAt` 順で末尾に固定

---

### 細部調整

- 既読にした後もスニペットを表示し続けるよう変更（次回確認で変化なし判定まで維持）
- サイト一覧の時刻表示を `lastChangedAt` のみに変更（`lastCheckedAt` を削除）
- ⟳ボタンをアイコンのみ（テキスト「全確認」を削除）・フォントサイズ20px・tooltip に変更

---

### タイル表示の追加

- `#site-list-header` 右端に **⊞** ボタン追加、`t` キーでも切替
- タイルモードでは `#detail-panel` が非表示になり一覧が全幅に拡大
- タイルクリック → オーバーレイ（中央モーダル）で詳細表示
- `buildDetailHtml()` を切り出してリスト・オーバーレイ両方で共用
- ライト/ダークモード両対応

---

### コードレビュー対応

- `buildDetailHtml` にステータス分岐追加（`'changed'`/`'checking'` に応じた表示修正）
- 既読後のスニペットラベルを「前回の差分（参照用）」に変更
- `checkSite` 重複実行防止（`_checkPromise` で進行中の Promise を返す方式に変更）
- インポート時に URL のスキーム検証を追加（`javascript:`/`file:` 等を除外）
- `checkAll` 二重起動防止（`checkAllRunning` フラグ）

---

### 更新バッジが全確認で消えるバグ修正

- チェック開始前に `prevStatus = site.status` を保存
- 「変化なし」分岐を `prevStatus === 'changed' ? 'changed' : 'ok'` に変更
  - 変更前：全確認実行中に `status: 'checking'` で上書きされ元の `'changed'` が失われていた

---

### ファビコン変更

- 細い弧のデザイン → 極太「A」（font-weight 900）＋頂点から上に伸びるスパイク縦線
- 「A = 鉄塔、縦線 = アンテナ先端」をシンプルに表現
- 色・形（角丸四角）は変更なし

---

## 2026-04-09

### CSSセレクタによる監視範囲の絞り込み機能を実装

広告・カウンター等の動的要素による誤検知を抑制するため、サイトごとに監視範囲を指定できるよう変更。

- サイトオブジェクトに `selector` フィールドを追加
- `extractPageContent(html, selector)` にセレクタ引数を追加
- 詳細パネル（リスト・タイル両対応）に「監視範囲」入力欄（`.selector-input`）を追加
- セレクタ変更時は `prevHash` / `prevText` をリセット（次回確認でベースラインを再取得）

---

### 抽出テキストの文字数上限を引き上げ

- `.slice(0, 20000)` → `.slice(0, 50000)` に変更
- ページ後半（20,000文字以降）の更新を見逃す問題に対応

---

### 全確認中のローダー表示をリニューアル

画面下部中央に浮き上がるローダーパネル（`#check-loader`）を追加。

- 「受信中」テキスト + ドット3つ（waiting/done アニメーション）+ `N / 合計` カウント
- RSS Reader と同じアニメーション仕様

---

### 全確認後に「確認中」バッジが残る不具合を修正（3段階対応）

| 原因 | 修正内容 |
|------|---------|
| `_checking` ガードの早期リターン | 進行中の `_checkPromise` を返す方式に変更。呼び出し元は完了を `await` してから次へ |
| `fetchPage` の無期限待機 | `Promise.race` で30秒強制タイムアウトを追加 |
| `'checking'` が localStorage に保存される | `saveSites()` を修正：`status === 'checking'` のサイトは `'ok'`/`'unchecked'` に変換して保存 |

---

### タイルモード時に⊟ボタンを非表示化

- タイルモードでは全展開ボタンが機能しないため `#main.tile-mode #expand-all-btn { display: none; }` を追加

---

### 監視範囲（selector）を export / import に対応

- `exportSites()`：`{ url, label, selector }` に変更
- `importSites()`：`selector: item.selector || ''` を追加（旧形式との後方互換性維持）

---

### コードレビュー指摘に基づくバグ修正（2件）

- `checkAll()` 例外時に `checkAllRunning = true` のまま復旧しない問題を `try/catch/finally` で修正
- `importSites()` で配列内の `null` による `TypeError` を防止（先頭に null ガードを追加）

---

### 通常表示（リスト表示）を横一列展開レイアウトにリニューアル

2ペイン（左リスト＋右詳細）から、1カラム・インライン展開方式に変更。

- `#detail-panel` / `#resizer` を CSS で非表示にし `#site-list-panel` を全幅化
- 各行を「常時2行（サイト名＋メタ情報）」＋「クリックで展開（スニペット・監視範囲）」の構造に変更
- `buildRowDetailHtml()` 関数を新設

---

### 全行一括展開ボタン（⊟）を追加

- `#expand-all-btn` を一覧ヘッダーに追加（`e` キーでも切替）
- CSS で `#site-list.expand-all .row-detail { display: flex }` を追加して一括表示

---

### 展開中の行を再クリックで折りたたむ機能を追加

- すでにアクティブな行をクリックすると `selectedIndex = -1` で折りたたむ

---

### 行間に薄い仕切り線を追加

- `.site-item` の `border-bottom` を `#0d1b2e`（ほぼ背景色）→ `#1a2a42`（うっすら見える程度）に変更

---

### UIの細かい改善

- 個別サイトの確認中表示を緑バッジ → 赤い回転スピナー（12px）に変更
- ⟳ボタンをロゴ直後に移動（URL入力欄の右から変更）
- `e` キーで全展開ショートカット追加
- `selectSite()` に `scrollIntoView({ block: 'nearest' })` を追加（キー送りで画面外に出たサイトを自動スクロール）

---

## 2026-04-15

### コード全体レビューと不具合修正（10件）

| # | 内容 |
|---|------|
| 1 | `rel="noreferrer"` 追加（開くボタン4箇所） |
| 2 | `isSafeUrl()` 関数を追加し、favicon `<img src>` に `http`/`https` 以外が入らないようガード |
| 3 | `checkAll()` 実行中に「追加」ボタンも無効化（`add-btn.disabled`） |
| 4 | セレクタ変更時に `proxyCache` もリセット（`prevHash`/`prevText` と合わせて無効化） |
| 5 | `delete site._checkPromise` を `renderList()` より後に移動 |
| 6 | キーボードショートカットの `activeElement` チェックに `isContentEditable` も追加 |
| 7 | `site._checkPromise` が削除済みの場合に `undefined` を返さないよう null ガード追加 |
| 8 | `#tile-overlay-check-btn` / `#tile-overlay-open-btn` のライトモード CSS を追加 |
| 9 | `FileReader` のエラーハンドラ（`onerror` / `onabort`）を追加 |
| 10 | `_timeoutId` を `null` で明示的に初期化 |

---

### 開くボタンをタイトル直後に移動

- リストモードの `↗ 開く` リンクをタイトル（`row-label`）の直後に移動
- テキストを `↗ 開く` → `↗︎` のみに簡略化
- `.row-title-group` ラッパーを追加（`flex: 1; min-width: 0; display: flex; gap: 4px`）
- `row-actions` には「確認」「削除」ボタンのみ残す

---

### 詳細展開の折りたたみ判定を上部のみに変更

- 展開済みアイテムの折りたたみ判定に `e.target.closest('.row-detail')` チェックを追加
- スニペット・監視範囲入力欄（`.row-detail`）内のクリックでは折りたたまれないよう変更

---

### 更新箇所（抜粋）を差分カラー表示に変更

- `diffLines()`（LCS ベース行単位 diff）、`buildDiffSnippet()`、`buildDiffHtml()` を追加
- 確認時に `site.snippetDiff`（diff 配列）を `site.snippet` と共に保存
- 表示：緑（`+` 追加行）/ 赤（`−` 削除行）/ グレー（文脈行・最大2行）/ `· · ·`（省略）
- `snippetDiff` を持たない既存データはプレーンテキスト表示にフォールバック
- 変更範囲：差分検出位置前後 1800 文字・最大 30 行

---

### 差分表示の削除行（赤）を1行に制限

- `buildDiffHtml()` にpost-processingを追加
- `del` 行をグローバルカウントで最大1行に制限し、2行目以降を `· · ·`（omit）に置換

---

### 差分表示の色合いを薄く調整

- ダークモード：`.diff-add` → 背景 `#0a1f0a`・文字 `#5a9e66`、`.diff-del` → 背景 `#1f0a0a`・文字 `#a85050`
- ライトモード：`.diff-add` → 背景 `#e4f0e4`・文字 `#4a7a4a`、`.diff-del` → 背景 `#f0e4e4`・文字 `#9a4a4a`

---

### サイトタグ機能を実装

登録サイトにタグを付けてカテゴリ分けし、タグフィルターバーで絞り込める機能を追加。

- 各サイトオブジェクトに `tags: string[]` フィールドを追加
- `#tag-filter-bar`（水平スクロール可能なピルボタンバー）を追加（タグ0件時は非表示）
- `renderList()` に `activeTag` フィルタリングを追加、件数表示を `N/全M件` 形式に
- `buildRowDetailHtml()` にタグ入力欄を追加（blur/Enter で保存）
- export / import に `tags` フィールドを追加

---

### Shift-JIS / EUC-JP サイトの文字化け修正

- `detectCharset(buffer)`：生バイト列の先頭2KBから charset 宣言を検出（Shift-JIS/EUC-JP の別名を正規化）
- `decodeBuffer(buffer)`：`TextDecoder` に charset を渡してデコード（未知の charset は UTF-8 にフォールバック）
- allorigins-raw / codetabs / corsproxy で `resp.text()` → `decodeBuffer(await resp.arrayBuffer())` に変更

---

## 2026-04-16

### 「更新」バッジが意図せず消える問題の修正

**原因①（checkAll 実行中のページリロード）**
- `saveSites()` が `status: 'checking'` のサイトを `'ok'` に変換する際、`'changed'` 状態が失われていた
- 修正：`checkSite()` 開始時に `site._prevStatus = prevStatus` を保存し、`saveSites()` の変換処理で `_prevStatus` を参照

**原因②（ネットワークエラー時の上書き）**
- エラー発生時のキャッチブロックが無条件に `site.status = 'error'` を設定していた
- 修正：エラー時も `prevStatus === 'changed'` の場合は `'changed'` を維持

---

### フッター・ボタン・フォントサイズを My Blog に統一

| 変更箇所 | 変更前 | 変更後 |
|---------|--------|--------|
| `#header` padding | `12px 16px` | `10px 16px` |
| ヘッダーボタン font-size | `14px` | `13px` |
| ヘッダーボタン padding（縦） | `8px` | `6px` |
| `#shortcuts` padding | `8px 12px` | `6px 16px` |
| `#statusbar` padding（横） | `12px` | `16px` |

---

### ⟳ボタンをスクエア化

- export/import ボタンと同じ縦サイズ（`padding: 6px`）に揃え、`aspect-ratio: 1/1` でスクエア化
- `font-size: 16px; line-height: 1`
- HTML のインラインスタイルを削除して CSS で管理

---

## 2026-04-17

### 更新の新しさ視覚化

`lastChangedAt` からの経過時間に応じて時刻テキストに色クラスを付与。

**`recencyTier(date)` 関数**（5段階）:

| クラス | 条件 | ダークモード | ライトモード |
|--------|------|------------|------------|
| `recency-justnow` | 1分未満 | 赤・太字・点滅 | 同左 |
| `recency-fresh` | 1時間未満 | `#e94560`（赤・太字） | `#c0203a` |
| `recency-recent` | 〜6時間 | `#f0a040`（オレンジ・太字） | `#c07010` |
| `recency-today` | 〜24時間 | `#c8d6e5`（白） | `#2a3a5a` |
| `recency-old` | 24時間以降 | `#7a8ba0`（グレー） | `#6a7090` |

- `@keyframes recency-blink`（1.2秒周期）を追加
- 適用箇所：リスト行ヘッダーの時刻・行メタの「最終更新:」・タイルの時刻

---

### 既読ボタンの削除

「更新」バッジは次回確認で変化なしと判定された時点で自動的に消えるため、手動既読ボタンは不要と判断し全箇所から削除。

- `buildDetailHtml()` / `buildRowDetailHtml()` から `.mark-read-btn` を削除
- `bindMarkReadBtn()` 関数を削除
- CSS の `.mark-read-btn` スタイルを削除

---

### 「更新」バッジ機能の削除

- `status === 'changed'` の表示分岐を完全に削除
- 変化あり時も `site.status = 'ok'` に統一
- `prevStatus`/`_prevStatus` 追跡を削除
- スニペットラベルを「前回の差分（参照用）」に統一

---

### `_checking` フラグが localStorage に残る不具合を修正

- `saveSites()`：`status` に関わらず常に `_checking` / `_checkPromise` を除外してシリアライズ
- ページ読み込み時に `delete s._checking; delete s._checkPromise;` を追加

---

### 最終確認時間を⟳ボタン左に移動・最終更新の色強調

- ⟳ボタン左に「最終確認: X分前」を表示（`lastCheckedAt` ベース）
- row-meta から「最終確認:」を削除（重複排除）
- 最終更新の recency カラーを強化（`recencyTier` の5段階カラーを適用）

---

### ピン機能を追加

「後で確認したい」サイトにピンを立て、ピン済みサイトのみ表示するフィルタを追加。

- `site.pinned: boolean`（デフォルト `false`）を追加
- 各行（`row-actions`）・タイルカード・タイルオーバーレイ・サイトリストヘッダーに 📌 ボタンを追加
- `togglePin(index)` 関数を追加
- ピン済み：ゴールド（`#f0c040`）/ 未ピン：暗い青灰色 opacity 0.4
- `p` キーでピンフィルタ切替
- export / import に `pinned` フィールドを追加

---

### ピンフィルタボタンの位置・デザイン調整

- ボタン順を `📌 ⊟ ⊞` → `⊟ 📌 ⊞` に変更（📌 を ⊞ の直左に移動）
- `#pin-filter-btn` のスタイルを `#view-toggle-btn` に統一
- `margin-left: auto` で 📌・⊞ が右端にまとまるレイアウトに

---

### コードレビュー指摘2件を修正

- `checkAll()` 中のサイト削除でインデックスがずれる問題：`queue` をオブジェクト参照の配列に変更し、`sites.indexOf(site)` で実行時に索引を解決
- HTML に存在しない `#paste-btn` の CSS（6行）を削除

---

### 差分表示の改善（インライン差分・行展開）

#### インライン差分（文字レベルハイライト）

- `inlineDiff(oldStr, newStr)` 関数を追加
- `−` 行と `+` 行が隣接するペアを検出し、文字レベルの差分をハイライト
- `<mark class="idel">` / `<mark class="iadd">` でハイライト表示
- 合計 2000 文字超の場合は `null` を返して全行表示にフォールバック

#### 差分行の展開機能

- `−`/`+` 行（インライン差分なし）は `text-overflow: ellipsis` で省略
- クリックで全文展開・再クリックで折りたたむ（`.expanded` クラスをトグル）

---

### 差分表示バグ修正（3件）

- `diffLines()` タイブレーク条件を修正（`>=` → `>` で del 優先に変更、`+` / `−` の出力順序を修正）
- `inlineDiff()` の文字数上限を 600 → 2000 に引き上げ
- 改行なし1行ページのインライン差分を全面改修（共通 prefix/suffix を先に除去し、変更部分のみに LCS を適用）

---

### カスタム CORS プロキシ設定機能を追加

- ヘッダー右端に **⚙** ボタンを追加 → 設定モーダルを開く
- カスタム CORS プロキシ URL 入力欄（省略可）
- `customProxyUrl` を localStorage（`antenna-custom-proxy`）に保存
- 設定時は公開プロキシへのリクエストを行わず、カスタムプロキシのみ使用
- 空欄保存時は公開プロキシにフォールバック（後方互換）

---

## 2026-04-22

### 受信中ローダーを RSS Reader と同デザインに変更

| 変更箇所 | 変更前 | 変更後 |
|---------|--------|--------|
| 向き | `flex-direction: column` | `flex-direction: row`（横並び） |
| `border-radius` | `14px` | `20px` |
| ドット数 | 3個（9px） | 5個（8px）・staggered delay（0.18s 間隔） |
| カウント表示 | 赤・太字 | `#8899cc`（シンプル化） |

---

## 2026-04-24

### 差分表示の順序変更（追加を上に）

差分表示で削除行（−）が上、追加行（+）が下に表示されていた問題を修正。

- `buildDiffHtml()` のループ前に、連続する del/add ブロックを検出して `add → del` 順に並び替える処理を追加
- インライン差分ペアでも `+` 行を上、`−` 行を下に統一

---

## 2026-04-28

### ノイズ除去ルールを追加

広告・ランキング・日付・閲覧数などの変動要素による誤検知を減らすため、サイトごとにノイズ除去ルールを設定できるよう変更。

- サイトオブジェクトに `ignoreSelector`（除外要素）と `ignoreTextPattern`（除外文字）を追加
- 詳細表示・行展開エリアに「除外要素」/「除外文字」の入力欄を追加
- `extractPageContent()` で `ignoreSelector` の要素を削除してからテキスト化する処理を追加
- テキスト化後に `ignoreTextPattern` を正規表現で除去する処理を追加
- ルール変更時は `prevHash` / `prevText` をリセット（次回確認からベースラインを再取得）
- export / import に `ignoreSelector` / `ignoreTextPattern` を追加

---

## 2026-04-29

### 監視設定をクリックで開閉する形式に変更

詳細表示（タイルオーバーレイ）・行展開の両方で、「監視範囲」「除外要素」「除外文字」の3入力欄を折りたたみ式に変更。

- `<details>` 要素でまとめ、`<summary>` に「監視設定 ▶」を表示
- クリックで展開し「監視設定 ▼」に変わる（▶ アイコンが90度回転するアニメーション付き）

---

### タイルモードの詳細（オーバーレイ）で監視設定を最下部に移動

タイルオーバーレイ内の「監視設定」折りたたみブロックをコンテンツの最下部に移動。

表示順：URL → 最終確認/最終更新 → 確認状態 → 前回の差分 → 監視設定（折りたたみ）

---

### タイルの時刻表示を「最終更新」に変更

- タイルカードの経過時間表示を「最終確認」（`lastCheckedAt`）→「最終更新」（`lastChangedAt`）に変更
- 変更が一度も検出されていないサイトは時刻を非表示

---

### 画像モードを実装

各登録サイトのページから画像を抽出してサイトごとにグループ表示する画像モードを追加。

- `viewMode` に `'image'` を追加（`'list' | 'tile' | 'image'`）
- `#site-list-header` に **🖼** ボタン（`#image-mode-btn`）を追加（`i` キーでもトグル）
- `extractPageImages(html, siteUrl, selector)` 関数を追加
  - `<meta property="og:image">` を最優先で抽出
  - `<img src>` を収集・絶対 URL 化、48px 未満・data:gif/png は除外（最大20枚）
- `renderImageGrid()` 関数を追加（`onerror` で壊れた画像を非表示）
- `imageCache[url]` でメモリキャッシュし再取得を防止
- 各サイトグループヘッダーに ⟳ ボタン（`.image-reload-btn`）を追加（キャッシュ削除して再取得）
- ライトボックス（`#image-lightbox`）：画像クリックで拡大表示・←→ キーで同一サイト内を移動・`Escape` / 背景クリックで閉じる
- タイルモードとの排他制御

---

## 2026-04-30

### 監視設定の改善（ヘルプ・プリセット・テスト機能）

#### ヘルプツールチップ（? アイコン）
- 各入力ラベル横に `?` アイコンを追加
- クリックでその設定の説明・使用例をポップアップ表示
- `HELP_TEXTS` オブジェクトで管理（selector / ignoreSelector / ignoreText の3種）

#### プリセット提案ドロップダウン
- 空の入力欄にフォーカスすると、よく使うセレクタ／パターンのドロップダウンを表示
  - 監視範囲：`main`、`article`、`#content`、`.post-content` など7件
  - 除外要素：`.ad, .ads`、`.sidebar`、`time, .date` など6件
  - 除外文字：`閲覧数:\s*\d+`、`\d+件のコメント` など5件
- 選択するとそのまま入力欄に挿入して保存

#### テスト/プレビューボタン
- 「テスト」ボタンをクリックすると `fetchPage()` → `extractPageContent()` を実行
- 抽出テキストの先頭500文字をプレビュー表示
- 未保存の設定のままテスト可能
- セレクタが一致しない場合は警告表示

---

## 2026-05-02

### 画像モードの「↗ 開く」ボタンをタイトル隣に移動

- `.image-group-header a` の `margin-left: auto` を削除
- `.image-reload-btn` に `margin-left: auto` を追加（⟳ ボタンが右端に移動）

---

### 画像モードの表示統一（cover → contain）+ サイズ表示

- `.image-card img` の `object-fit: cover` → `object-fit: contain` に変更（切り取りなし・レターボックス表示）
- `.image-card` に `position: relative` を追加
- `.image-size` スタイルを追加（右下に絶対配置、9px、半透明白文字）
- `renderImageGrid()` に `img.onload` を追加し、`naturalWidth × naturalHeight` を右下に表示

---

### 画像モードの背景色変更

- ダークモード：`.image-card` / `.image-card img` の `background` を `#999999` に設定
- ライトモード：`body.light .image-card` / `body.light .image-card img` を `#ffffff` に設定

---

### ヘッダーボタンのサイズ統一と間隔調整

- 📌（`#pin-filter-btn`）・⊞（`#view-toggle-btn`）・🖼（`#image-mode-btn`）の3ボタンを `font-size: 13px; padding: 1px 5px` に統一
- `#site-list-header` に `gap: 4px` を追加してボタン間に隙間を作成

---

### タイトルにグリッチエフェクト追加（ダークモード限定・ホバー時のみ）

- `<span id="logo">` に `data-text="Web Antenna"` を追加
- `::before`（シアン `#00c8ff`）と `::after`（黄色 `#f0c040`）で複製テキストを配置
- `clip-path: inset()` + `transform: translate()` でスキャンライン効果
- `ant-glitch1` / `ant-glitch2` キーフレーム（13段階・ノイジーなパターン）
- アニメーション速度：`0.6s steps(1) infinite`（`animation-delay` で位相をずらして同期を防止）
- `body:not(.light)` セレクタでダークモード限定に制御

---

## 2026-05-10

### コードレビュー指摘に基づく堅牢性修正

副作用が小さいと判断した項目のみ実装。

- `safeLoadJson()` を追加し、壊れた `localStorage` JSON でも起動できるよう修正
- `normalizeSite()` を追加し、起動時とインポート時にサイトデータを正規化
- `escapeHtml()` を非文字列入力でも落ちないよう `String(s ?? '')` ベースに変更
- URL 追加・インポート時に `sanitizeHttpUrl()` を通し、`http:` / `https:` のみ許可
- 画像モードの抽出画像 URL も `http:` / `https:` のみに制限
- `visibleSites()` を追加し、タグ/ピン絞り込み中の `j` / `k` 移動を表示中サイトに限定
- サイト追加・削除・ピン切替・タグ変更・監視設定変更・インポートで保存失敗時にメモリ変更を巻き戻すよう修正
- export に `pinned` を含めるよう変更
- export 後に `URL.revokeObjectURL()` で Blob URL を解放
