-- HTML基礎クイズ シードデータ
-- 実行例（プロジェクトルートで）: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-html.sql
-- 実行順序不問（カテゴリ id=2、クイズ id は既存の次から自動採番）

SET NAMES utf8mb4;

-- カテゴリ（既存ならスキップ）
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (2, 'html-basic', 'HTML基礎・実践', 1, 'HTMLの構造、セマンティクス、フォーム、アクセシビリティに関する問題です。', 2);

-- クイズ（category_id=2）。既存の quiz の最大 id の次から採番
SELECT @start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @start);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('html-doctype-purpose', 2, 1,
 '<!DOCTYPE html>の役割として正しいのは？',
 '正解はブラウザに文書タイプがHTML5であることを宣言することです。DOCTYPE宣言がないとブラウザが互換モード（Quirksモード）で動作し、レイアウトが意図通りに表示されない可能性があります。HTML5では<!DOCTYPE html>という簡潔な形式が採用されています。'),

('html-semantic-nav', 2, 1,
 'HTML5でページのナビゲーション領域を示すセマンティック要素は？',
 '正解は<nav>です。<nav>はサイトのメインナビゲーションリンクをグループ化するための要素です。<header>はヘッダー領域、<aside>はサイドバーなどの補足情報、<section>は汎用的なセクションを表します。セマンティック要素を正しく使うことでアクセシビリティとSEOが向上します。'),

('html-semantic-article', 2, 1,
 'HTML5で自己完結した独立コンテンツを表すセマンティック要素は？',
 '正解は<article>です。ブログ記事やニュース記事など、他から独立して配信・再利用可能なコンテンツに使用します。<section>は汎用的な区分け、<div>は意味を持たないコンテナ、<main>はページの主要コンテンツ領域を表します。'),

('html-semantic-aside', 2, 1,
 'HTML5でメインコンテンツとは間接的に関連する補足情報を示す要素は？',
 '正解は<aside>です。サイドバー、関連リンク、広告、引用などの補足的なコンテンツに使用します。<section>は汎用的なセクション、<footer>はフッター領域、<details>は折りたたみ可能な詳細情報を表す要素です。'),

('html-block-inline', 2, 1,
 'HTMLでブロック要素とインライン要素の違いとして正しいのは？',
 '正解はブロック要素は新しい行から始まり親要素の全幅を占めることです。<div>、<p>、<h1>〜<h6>などがブロック要素、<span>、<a>、<strong>などがインライン要素です。CSSのdisplayプロパティで表示方法を変更できます。'),

('html-meta-viewport', 2, 1,
 'レスポンシブデザインに必要なmeta要素の正しい記述は？',
 '正解は<meta name="viewport" content="width=device-width, initial-scale=1.0">です。この設定によりモバイルデバイスで適切な表示幅が設定されます。これがないとモバイルブラウザがデスクトップ幅で表示してしまいます。'),

('html-meta-charset', 2, 1,
 'HTMLで文字エンコーディングを指定するmeta要素の正しい記述は？',
 '正解は<meta charset="UTF-8">です。文字化けを防ぐためにHTML文書の<head>内のできるだけ先頭に記述します。UTF-8はほぼすべての言語の文字を扱える汎用的なエンコーディングです。'),

('html-heading-hierarchy', 2, 1,
 'HTML見出し要素の使い方として正しいのは？',
 '正解は<h1>から順番に階層構造を守って使用することです。<h1>はページに原則1つ、その配下に<h2>、さらにその配下に<h3>と階層的に使用します。見出しレベルを飛ばす（h1→h3）のはアクセシビリティ上推奨されません。見た目の調整はCSSで行います。'),

('html-form-method', 2, 1,
 'HTMLフォームのmethod属性でデータを安全に送信する方法は？',
 '正解はPOSTです。POSTはリクエストボディにデータを含めて送信するため、URLにデータが表示されません。GETはURLのクエリパラメータにデータが付加されるため、パスワードなどの機密情報の送信には不適切です。'),

('html-form-action', 2, 1,
 'HTMLの<form>要素のaction属性の役割は？',
 '正解はフォームデータの送信先URLを指定することです。action="/api/submit"のように記述し、送信ボタンが押された時にそのURLへデータが送られます。method属性と組み合わせて、GETまたはPOSTで送信方法を指定します。'),

('html-input-types-html5', 2, 1,
 'HTML5で追加された入力タイプとして正しいのは？',
 '正解はemail、date、rangeなどです。type="email"はメール形式のバリデーション、type="date"はカレンダーUI、type="range"はスライダーUIを提供します。text、password、submitはHTML5以前から存在する入力タイプです。'),

('html-input-required', 2, 1,
 'HTMLでフォームの入力フィールドを必須にする属性は？',
 '正解はrequired属性です。<input type="text" required>のように指定すると、ブラウザが送信時に空欄チェックを行います。JavaScriptなしでバリデーションが可能で、patternやmin/max属性と組み合わせてさらに詳細な検証もできます。'),

('html-label-for', 2, 1,
 'HTMLの<label>要素のfor属性の正しい使い方は？',
 '正解は対応する入力要素のid属性と一致させることです。<label for="email">メール</label><input id="email">のように使用します。ラベルをクリックすると対応する入力要素にフォーカスが移り、アクセシビリティも向上します。'),

('html-alt-attribute', 2, 1,
 '<img>要素のalt属性の主な目的は？',
 '正解はアクセシビリティと画像が表示できない場合の代替テキストを提供することです。スクリーンリーダーがalt属性を読み上げることで視覚障害者がコンテンツを理解できます。SEOにも影響し、画像検索のインデックスにも使用されます。'),

('html-data-attribute', 2, 1,
 'HTMLでカスタムデータを要素に保存するための属性は？',
 '正解はdata-*属性です。data-user-id="123"のように使用し、JavaScriptからelement.dataset.userIdでアクセスできます。HTMLの仕様に準拠した方法でカスタムデータを要素に関連付けることができます。'),

('html-aria-role', 2, 1,
 'WAI-ARIAのrole属性の主な目的は？',
 '正解はアクセシビリティのために要素の役割を明示することです。role="button"、role="navigation"のように使用し、スクリーンリーダーが要素の目的を理解できるようにします。セマンティックHTMLを使っている場合は暗黙のroleが設定されるため重複指定は不要です。'),

('html-aria-label', 2, 1,
 'aria-label属性の用途として正しいのは？',
 '正解はスクリーンリーダー向けにテキストラベルを提供することです。視覚的にラベルが不要だがアクセシビリティ上必要な場合に使用します。例：<button aria-label="メニューを閉じる">×</button>。aria-labelledbyは既存要素のテキストを参照する場合に使用します。'),

('html-table-structure', 2, 1,
 'HTMLテーブルの正しい構造として適切なのは？',
 '正解は<table>内に<thead>、<tbody>、<tfoot>を使用することです。<thead>にはヘッダー行、<tbody>にはデータ行、<tfoot>にはフッター行を配置します。<th>はヘッダーセル、<td>はデータセルに使用し、アクセシビリティの向上に役立ちます。'),

('html-link-rel-stylesheet', 2, 1,
 'HTMLで外部CSSファイルを読み込む正しい記述は？',
 '正解は<link rel="stylesheet" href="style.css">です。<head>内に記述し、rel="stylesheet"でCSSファイルであることを指定します。<style>要素はHTML内に直接CSSを記述する場合に使用し、外部ファイルの読み込みには<link>を使用します。'),

('html-script-defer-async', 2, 1,
 '<script>要素のdefer属性の効果は？',
 '正解はHTMLの解析を止めずにスクリプトをダウンロードし、解析完了後に実行することです。asyncはダウンロード完了後すぐに実行（解析を一時停止）します。deferはDOMContentLoadedイベント前に順序通り実行されるため、DOM操作を含むスクリプトに適しています。'),

('html-picture-element', 2, 1,
 'HTML5の<picture>要素の主な用途は？',
 '正解はレスポンシブイメージの提供です。<source>要素でメディアクエリや画像形式に応じた画像を指定でき、WebPなどの新しい画像形式のフォールバックも実現できます。<img>のsrcset属性でも類似の機能がありますが<picture>はより細かい制御が可能です。'),

('html-loading-lazy', 2, 1,
 'HTMLで<img>要素の遅延読み込みを実装する方法は？',
 '正解はloading="lazy"属性です。<img src="image.jpg" loading="lazy" alt="説明">のように使用し、画像がビューポートに近づいた時に読み込みを開始します。JavaScriptなしでネイティブに遅延読み込みが可能で、パフォーマンス向上に効果的です。'),

('html-dialog-element', 2, 1,
 'HTML5の<dialog>要素の主な特徴は？',
 '正解はネイティブなモーダルダイアログ機能を提供することです。showModal()メソッドでモーダル表示し、::backdrop擬似要素でオーバーレイをスタイリングできます。JavaScriptライブラリなしでフォーカストラップやEscキーでの閉じる機能が組み込まれています。'),

('html-details-summary', 2, 1,
 'HTMLでJavaScriptなしに折りたたみ可能なコンテンツを実装する方法は？',
 '正解は<details>と<summary>要素を使用することです。<summary>がクリック可能な見出し部分、<details>内のその他のコンテンツが折りたたみ対象になります。open属性で初期状態を開いた状態にすることもできます。'),

('html-datalist-element', 2, 1,
 'HTMLの<datalist>要素の用途は？',
 '正解は入力フィールドに候補リストを提供することです。<input list="fruits"><datalist id="fruits"><option value="りんご"></datalist>のように使用し、オートコンプリート機能を実現します。<select>と異なり、自由入力も可能です。'),

('html-output-element', 2, 1,
 'HTMLの<output>要素の用途は？',
 '正解は計算結果やユーザー操作の結果を表示することです。<output name="result" for="a b">のように使用します。フォーム内の計算結果の表示に適しており、for属性で関連する入力要素を指定できます。<span>で代用できますが<output>の方がセマンティックです。'),

('html-template-element', 2, 1,
 'HTMLの<template>要素の特徴は？',
 '正解は描画されないHTMLの雛形を定義できることです。<template>内のコンテンツはページ読み込み時に描画されず、JavaScriptでcloneNode()を使用して必要な時にDOMに追加します。Web Componentsのシャドウでも活用されます。'),

('html-iframe-sandbox', 2, 1,
 '<iframe>のsandbox属性の目的は？',
 '正解は埋め込みコンテンツのセキュリティ制限を設定することです。sandbox属性を付けるとスクリプト実行やフォーム送信などがデフォルトで禁止されます。sandbox="allow-scripts"のように個別に許可を追加できます。XSSなどの攻撃を防ぐために重要です。'),

('html-srcset-attribute', 2, 1,
 '<img>のsrcset属性の用途は？',
 '正解は画面解像度やビューポートに応じた画像を指定することです。srcset="image-1x.jpg 1x, image-2x.jpg 2x"で解像度別、srcset="small.jpg 480w, large.jpg 1024w"でサイズ別に画像を指定できます。ブラウザが最適な画像を自動選択します。'),

('html-preload-prefetch', 2, 1,
 '<link rel="preload">と<link rel="prefetch">の違いは？',
 '正解はpreloadは現在のページで必要なリソースを優先読み込み、prefetchは次のページで必要なリソースを事前読み込みすることです。preloadは高優先度で即時ダウンロード、prefetchは低優先度でアイドル時にダウンロードされます。'),

('html-open-graph', 2, 1,
 'OGP（Open Graph Protocol）のmeta要素の役割は？',
 '正解はSNSでシェアされた際のタイトル・画像・説明文を指定することです。<meta property="og:title" content="タイトル">のように記述します。Twitter、Facebook、LINEなどのSNSがこの情報を使用してリンクプレビューを生成します。'),

('html-favicon', 2, 1,
 'ブラウザのタブに表示されるアイコン（ファビコン）を設定する方法は？',
 '正解は<link rel="icon" href="favicon.ico">です。<head>内に記述し、PNG形式やSVG形式も使用できます。apple-touch-iconでiOSのホーム画面アイコンも別途指定できます。サイズは16×16や32×32が一般的です。'),

('html-noscript-element', 2, 1,
 'HTMLの<noscript>要素の用途は？',
 '正解はJavaScriptが無効な環境で代替コンテンツを表示することです。<noscript>このサイトにはJavaScriptが必要です</noscript>のように使用します。スクリーンリーダーやSEOクローラーへの対応にも活用できます。'),

('html-content-model', 2, 1,
 'HTML5のコンテンツモデルでフレージングコンテンツに分類される要素は？',
 '正解は<span>、<a>、<strong>、<em>などです。フレージングコンテンツは段落内で使用されるインライン的な要素で、テキストレベルのセマンティクスを提供します。<div>、<p>、<section>はフローコンテンツに分類されます。'),

('html-custom-element', 2, 1,
 'Web Componentsのカスタム要素の命名規則として正しいのは？',
 '正解は名前にハイフンを含む必要があることです。<my-component>、<user-card>のようにハイフン区切りで命名します。これはHTML標準要素との名前の衝突を防ぐためです。<mycomponent>のようにハイフンなしは無効です。'),

('html-tabindex', 2, 1,
 'tabindex属性の値として0を指定した場合の動作は？',
 '正解は通常のタブ順序に要素を追加することです。tabindex="0"はDOM順でフォーカス可能にし、tabindex="-1"はプログラム的にのみフォーカス可能にします。tabindex="1"以上は特定の順序を強制しますが、使用は推奨されません。'),

('html-lang-attribute', 2, 1,
 '<html>要素のlang属性の役割は？',
 '正解はページの主要言語を指定することです。<html lang="ja">で日本語を指定します。スクリーンリーダーの発音、検索エンジンの言語判定、ブラウザの翻訳機能などに影響します。部分的に異なる言語がある場合はその要素にもlang属性を指定できます。'),

('html-fieldset-legend', 2, 1,
 'フォームで関連する入力要素をグループ化する要素の組み合わせは？',
 '正解は<fieldset>と<legend>です。<fieldset>でグループ化し、<legend>でグループのタイトルを表示します。ラジオボタンやチェックボックスのグループに特に有用で、アクセシビリティの向上に貢献します。'),

('html-anchor-target', 2, 1,
 '<a>要素のtarget="_blank"を使用する際のセキュリティ対策は？',
 '正解はrel="noopener noreferrer"を付与することです。target="_blank"で新しいタブを開く際、noopenerがないと開いた先のページからwindow.openerで元ページを操作される危険があります。現在の主要ブラウザではデフォルトでnoopenerが適用されますが、明示的に指定することが推奨されます。');

-- 選択肢（@start 〜 @start+38 の順。各4択）
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q40: DOCTYPE
(@start + 0, 'ブラウザに文書タイプがHTML5であることを宣言する', 1, 1),
(@start + 0, 'CSSファイルを読み込むために必要', 0, 2),
(@start + 0, 'JavaScriptを有効にする', 0, 3),
(@start + 0, '文字エンコーディングを設定する', 0, 4),
-- Q41: nav
(@start + 1, '<nav>', 1, 1),
(@start + 1, '<header>', 0, 2),
(@start + 1, '<aside>', 0, 3),
(@start + 1, '<section>', 0, 4),
-- Q42: article
(@start + 2, '<article>', 1, 1),
(@start + 2, '<section>', 0, 2),
(@start + 2, '<div>', 0, 3),
(@start + 2, '<main>', 0, 4),
-- Q43: aside
(@start + 3, '<aside>', 1, 1),
(@start + 3, '<section>', 0, 2),
(@start + 3, '<footer>', 0, 3),
(@start + 3, '<details>', 0, 4),
-- Q44: block vs inline
(@start + 4, 'ブロック要素は新しい行から始まり、親要素の全幅を占める', 1, 1),
(@start + 4, 'インライン要素は新しい行から始まる', 0, 2),
(@start + 4, 'ブロック要素はテキストの一部として表示される', 0, 3),
(@start + 4, '両者に違いはない', 0, 4),
-- Q45: meta viewport
(@start + 5, '<meta name="viewport" content="width=device-width, initial-scale=1.0">', 1, 1),
(@start + 5, '<meta name="responsive" content="true">', 0, 2),
(@start + 5, '<meta name="mobile" content="width=auto">', 0, 3),
(@start + 5, '<meta name="screen" content="adaptive">', 0, 4),
-- Q46: meta charset
(@start + 6, '<meta charset="UTF-8">', 1, 1),
(@start + 6, '<meta encoding="UTF-8">', 0, 2),
(@start + 6, '<meta type="charset/utf-8">', 0, 3),
(@start + 6, '<meta lang="UTF-8">', 0, 4),
-- Q47: heading hierarchy
(@start + 7, '<h1>から順番に階層構造を守って使用する', 1, 1),
(@start + 7, '見た目の大きさで自由に選ぶ', 0, 2),
(@start + 7, '<h1>は1ページに何個使っても良い', 0, 3),
(@start + 7, '<h3>から始めても問題ない', 0, 4),
-- Q48: form method
(@start + 8, 'POST', 1, 1),
(@start + 8, 'GET', 0, 2),
(@start + 8, 'PUT', 0, 3),
(@start + 8, 'SEND', 0, 4),
-- Q49: form action
(@start + 9, 'フォームデータの送信先URLを指定する', 1, 1),
(@start + 9, 'フォームのスタイルを指定する', 0, 2),
(@start + 9, 'フォームのバリデーションルールを指定する', 0, 3),
(@start + 9, 'フォームの表示方法を指定する', 0, 4),
-- Q50: input types HTML5
(@start + 10, 'email、date、rangeなど', 1, 1),
(@start + 10, 'text、password、submit', 0, 2),
(@start + 10, 'file、hidden、checkbox', 0, 3),
(@start + 10, 'image、button、reset', 0, 4),
-- Q51: required
(@start + 11, 'required属性', 1, 1),
(@start + 11, 'validate属性', 0, 2),
(@start + 11, 'mandatory属性', 0, 3),
(@start + 11, 'necessary属性', 0, 4),
-- Q52: label for
(@start + 12, '対応する入力要素のid属性と一致させる', 1, 1),
(@start + 12, '対応する入力要素のname属性と一致させる', 0, 2),
(@start + 12, '対応する入力要素のclass属性と一致させる', 0, 3),
(@start + 12, '対応する入力要素のtype属性と一致させる', 0, 4),
-- Q53: alt
(@start + 13, 'アクセシビリティと代替テキストの提供', 1, 1),
(@start + 13, '画像のサイズを指定する', 0, 2),
(@start + 13, '画像のファイル名を表示する', 0, 3),
(@start + 13, '画像のリンク先を指定する', 0, 4),
-- Q54: data-*
(@start + 14, 'data-*属性', 1, 1),
(@start + 14, 'custom-*属性', 0, 2),
(@start + 14, 'user-*属性', 0, 3),
(@start + 14, 'info-*属性', 0, 4),
-- Q55: aria role
(@start + 15, 'アクセシビリティのために要素の役割を明示する', 1, 1),
(@start + 15, 'CSSのスタイルを指定する', 0, 2),
(@start + 15, 'JavaScriptのイベントを設定する', 0, 3),
(@start + 15, 'SEOのために要素を分類する', 0, 4),
-- Q56: aria-label
(@start + 16, 'スクリーンリーダー向けにテキストラベルを提供する', 1, 1),
(@start + 16, '要素の表示テキストを変更する', 0, 2),
(@start + 16, 'CSSのクラス名を動的に設定する', 0, 3),
(@start + 16, '要素のツールチップを表示する', 0, 4),
-- Q57: table structure
(@start + 17, '<table>内に<thead>、<tbody>、<tfoot>を使用する', 1, 1),
(@start + 17, '<table>内に<div>でレイアウトする', 0, 2),
(@start + 17, '<table>内に<tr>のみを使用する', 0, 3),
(@start + 17, '<table>の代わりに<grid>を使用する', 0, 4),
-- Q58: link stylesheet
(@start + 18, '<link rel="stylesheet" href="style.css">', 1, 1),
(@start + 18, '<style src="style.css">', 0, 2),
(@start + 18, '<css href="style.css">', 0, 3),
(@start + 18, '<import url="style.css">', 0, 4),
-- Q59: script defer
(@start + 19, 'HTMLの解析を止めずにダウンロードし、解析完了後に実行する', 1, 1),
(@start + 19, 'スクリプトを即座に実行する', 0, 2),
(@start + 19, 'スクリプトのダウンロードを遅延させる', 0, 3),
(@start + 19, 'スクリプトを非同期で実行しDOMの順序を無視する', 0, 4),
-- Q60: picture
(@start + 20, 'レスポンシブイメージの提供', 1, 1),
(@start + 20, '画像のフィルター効果', 0, 2),
(@start + 20, '画像の遅延読み込み', 0, 3),
(@start + 20, '画像のキャッシュ管理', 0, 4),
-- Q61: loading lazy
(@start + 21, 'loading="lazy"属性', 1, 1),
(@start + 21, 'defer="true"属性', 0, 2),
(@start + 21, 'async="load"属性', 0, 3),
(@start + 21, 'load="onscroll"属性', 0, 4),
-- Q62: dialog
(@start + 22, 'ネイティブなモーダルダイアログ機能を提供する', 1, 1),
(@start + 22, '確認メッセージをalertで表示する', 0, 2),
(@start + 22, 'ツールチップを表示する', 0, 3),
(@start + 22, 'ポップアップウィンドウを開く', 0, 4),
-- Q63: details/summary
(@start + 23, '<details>と<summary>要素を使用する', 1, 1),
(@start + 23, '<collapse>と<toggle>要素を使用する', 0, 2),
(@start + 23, '<accordion>と<panel>要素を使用する', 0, 3),
(@start + 23, '<hide>と<show>要素を使用する', 0, 4),
-- Q64: datalist
(@start + 24, '入力フィールドに候補リストを提供する', 1, 1),
(@start + 24, 'データベースに接続する', 0, 2),
(@start + 24, 'テーブルのデータを表示する', 0, 3),
(@start + 24, 'JSON形式のデータを定義する', 0, 4),
-- Q65: output
(@start + 25, '計算結果やユーザー操作の結果を表示する', 1, 1),
(@start + 25, 'コンソールにログを出力する', 0, 2),
(@start + 25, 'ファイルを出力する', 0, 3),
(@start + 25, 'デバッグ情報を表示する', 0, 4),
-- Q66: template
(@start + 26, '描画されないHTMLの雛形を定義できる', 1, 1),
(@start + 26, 'CSSテンプレートを定義する', 0, 2),
(@start + 26, 'JavaScriptのテンプレートリテラルと同じ機能', 0, 3),
(@start + 26, 'サーバーサイドのテンプレートエンジンを呼び出す', 0, 4),
-- Q67: iframe sandbox
(@start + 27, '埋め込みコンテンツのセキュリティ制限を設定する', 1, 1),
(@start + 27, 'iframe内のCSSを分離する', 0, 2),
(@start + 27, 'iframeのサイズを自動調整する', 0, 3),
(@start + 27, 'iframeのキャッシュを制御する', 0, 4),
-- Q68: srcset
(@start + 28, '画面解像度やビューポートに応じた画像を指定する', 1, 1),
(@start + 28, '画像のソースコードを指定する', 0, 2),
(@start + 28, '複数の画像を重ねて表示する', 0, 3),
(@start + 28, '画像のアニメーションフレームを指定する', 0, 4),
-- Q69: preload/prefetch
(@start + 29, 'preloadは現在のページ用、prefetchは次のページ用の事前読み込み', 1, 1),
(@start + 29, '両者に違いはない', 0, 2),
(@start + 29, 'preloadはCSS用、prefetchはJS用', 0, 3),
(@start + 29, 'preloadは画像用、prefetchはフォント用', 0, 4),
-- Q70: OGP
(@start + 30, 'SNSでシェアされた際のタイトル・画像・説明文を指定する', 1, 1),
(@start + 30, 'ページの表示速度を最適化する', 0, 2),
(@start + 30, 'ブラウザのブックマーク表示を制御する', 0, 3),
(@start + 30, '検索エンジンのインデックスを制御する', 0, 4),
-- Q71: favicon
(@start + 31, '<link rel="icon" href="favicon.ico">', 1, 1),
(@start + 31, '<meta name="icon" content="favicon.ico">', 0, 2),
(@start + 31, '<favicon src="favicon.ico">', 0, 3),
(@start + 31, '<img rel="icon" src="favicon.ico">', 0, 4),
-- Q72: noscript
(@start + 32, 'JavaScriptが無効な環境で代替コンテンツを表示する', 1, 1),
(@start + 32, 'スクリプトのエラーメッセージを表示する', 0, 2),
(@start + 32, 'スクリプトの実行を禁止する', 0, 3),
(@start + 32, 'スクリプトを無効化する', 0, 4),
-- Q73: phrasing content
(@start + 33, '<span>、<a>、<strong>、<em>など', 1, 1),
(@start + 33, '<div>、<p>、<section>', 0, 2),
(@start + 33, '<table>、<form>、<ul>', 0, 3),
(@start + 33, '<head>、<body>、<html>', 0, 4),
-- Q74: custom element naming
(@start + 34, '名前にハイフンを含む必要がある', 1, 1),
(@start + 34, '名前を大文字で始める必要がある', 0, 2),
(@start + 34, '名前にアンダースコアを含む必要がある', 0, 3),
(@start + 34, '特に命名規則はない', 0, 4),
-- Q75: tabindex 0
(@start + 35, '通常のタブ順序に要素を追加する', 1, 1),
(@start + 35, 'タブ順序から要素を除外する', 0, 2),
(@start + 35, '最初にフォーカスされるようにする', 0, 3),
(@start + 35, 'フォーカスを無効にする', 0, 4),
-- Q76: lang attribute
(@start + 36, 'ページの主要言語を指定する', 1, 1),
(@start + 36, 'ページの文字エンコーディングを設定する', 0, 2),
(@start + 36, 'ページの翻訳を禁止する', 0, 3),
(@start + 36, 'ページのフォントを指定する', 0, 4),
-- Q77: fieldset/legend
(@start + 37, '<fieldset>と<legend>', 1, 1),
(@start + 37, '<group>と<title>', 0, 2),
(@start + 37, '<div>と<label>', 0, 3),
(@start + 37, '<section>と<heading>', 0, 4),
-- Q78: anchor target="_blank" security
(@start + 38, 'rel="noopener noreferrer"を付与する', 1, 1),
(@start + 38, 'rel="safe"を付与する', 0, 2),
(@start + 38, 'sandbox属性を付与する', 0, 3),
(@start + 38, 'target="_blank"は安全なので対策不要', 0, 4);
-- ここまで Q40〜78（39問）