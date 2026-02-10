-- JavaScript基礎クイズ シードデータ
-- 実行例（プロジェクトルートで）: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-javascript.sql
-- 実行順序不問（カテゴリ id=4、クイズ id は既存の次から自動採番）

SET NAMES utf8mb4;

-- カテゴリ（既存ならスキップ）
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (4, 'javascript-basic', 'JavaScript基礎・実践', 1, 'JavaScriptの基本文法、ES6+、非同期処理、DOM操作に関する問題です。', 4);

-- クイズ（category_id=4）。既存の quiz の最大 id の次から採番
SELECT @start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @start);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('js-variables-let-const', 4, 1,
 '再代入が不可能な変数を宣言するキーワードは？',
 '正解はconstです。constは再代入不可（定数）な変数を宣言します。letは再代入可能なブロックスコープの変数、varは再代入可能な関数スコープの変数です。現在のJavaScript開発では原則constを使用し、再代入が必要な場合のみletを使用することが推奨されます。'),

('js-strict-equality', 4, 1,
 '厳密等価演算子（===）と等価演算子（==）の違いは？',
 '正解は「===」は型変換を行わずに比較することです。「==」は比較の際に暗黙的な型変換を行いますが、「===」は値と型の両方が一致しているかを厳密にチェックします。予期せぬバグを防ぐため、常に「===」を使用することが推奨されます。'),

('js-data-types', 4, 1,
 'JavaScriptのプリミティブ型に含まれないものは？',
 '正解はObjectです。JavaScriptのプリミティブ型にはString, Number, Boolean, Undefined, Null, Symbol, BigIntがあります。Object（配列や関数も含む）は参照型であり、プリミティブ型ではありません。'),

('js-arrow-functions', 4, 1,
 'アロー関数の特徴として正しいのは？',
 '正解は独自に「this」を持たず、定義時の外側のスコープのthisを継承することです。これにより、コールバック関数内でのthisの扱いが容易になります。また、functionキーワードよりも簡潔に記述でき、コンストラクタとしては使用できないという特徴もあります。'),

('js-template-literals', 4, 1,
 'テンプレートリテラルの正しい構文は？',
 '正解はバッククォート（`）で囲み、${}で変数を埋め込む形式です。改行をそのまま保持できるほか、文字列内での動的な値の展開が直感的に行えます。'),

('js-destructuring-assignment', 4, 1,
 '分割代入（Destructuring）の利点は？',
 '正解はオブジェクトや配列から特定の値を簡潔に抽出して変数に代入できることです。例：const { name, age } = user; とすることで、user.nameやuser.ageを個別に変数へ取り出せます。コードの可読性を大幅に向上させます。'),

('js-spread-operator', 4, 1,
 'スプレッド構文（...）の主な用途は？',
 '正解は配列やオブジェクトの要素を展開することです。既存の配列を新しい配列にコピーしたり、複数のオブジェクトをマージしたりする際に使用します。非破壊的な操作（元のデータを変更しない操作）を簡単に行うために重要です。'),

('js-async-await', 4, 1,
 'async/awaitの目的として正しいのは？',
 '正解は非同期処理を同期処理に近い見た目で記述することです。Promiseをベースにしており、awaitキーワードを使うことで非同期処理の完了を待機し、処理結果を通常の変数のように扱えます。これにより「コールバック地獄」を回避できます。'),

('js-promise-states', 4, 1,
 'Promiseの状態（State）として存在しないものは？',
 '正解はwaitingです。Promiseには3つの状態があります。pending（初期状態）、fulfilled（成功）、rejected（失敗）です。一度成功または失敗の状態になると、そのPromiseの状態は二度と変わりません。'),

('js-array-map', 4, 1,
 'Array.prototype.map()の動作として正しいのは？',
 '正解は各要素に処理を適用した新しい配列を返すことです。元の配列（レシーバ）は変更されません。forEach()は単に各要素に対して実行するだけで新しい配列を返さない点が異なります。'),

('js-array-filter', 4, 1,
 'Array.prototype.filter()の用途として正しいのは？',
 '正解は条件に一致する要素のみを抽出した新しい配列を作成することです。コールバック関数がtrueを返した要素のみが新しい配列に含まれます。mapと同様に非破壊的な操作です。'),

('js-array-reduce', 4, 1,
 'Array.prototype.reduce()の主な目的は？',
 '正解は配列の要素を1つの値に集約することです。数値の合計を算出したり、配列から特定のオブジェクトを作成したりする場合に使用します。累積値（accumulator）と現在の値を用いて計算を繰り返します。'),

('js-nullish-coalescing', 4, 1,
 'Null合体演算子（??）の動作は？',
 '正解は左辺がnullまたはundefinedの場合のみ右辺を返すことです。論理OR演算子（||）は空文字列（""）や0などの「偽値（falsy）」でも右辺を返してしまいますが、??はnullとundefinedに限定してデフォルト値を設定できます。'),

('js-optional-chaining', 4, 1,
 'オプショナルチェイニング（?.）の利点は？',
 '正解は深い階層のプロパティを参照する際、途中の値がnull/undefinedでもエラーにならずにundefinedを返すことです。user?.profile?.nameのように記述することで、profileが存在しない場合のエラーを防ぎます。'),

('js-scope-block', 4, 1,
 'letやconstで宣言された変数のスコープは？',
 '正解はブロックスコープです。if文やfor文などの { } で囲まれた範囲内でのみ有効です。これに対し、varで宣言された変数は関数スコープ（またはグローバルスコープ）となります。'),

('js-hoisting', 4, 1,
 'JavaScriptにおける「巻き上げ（Hoisting）」とは？',
 '正解は変数や関数の宣言がスコープの先頭に移動したように振る舞う現象です。functionキーワードによる関数宣言は呼び出しより後に記述しても動作しますが、let/constで宣言された変数は宣言前にアクセスするとエラー（ReferenceError）になります。'),

('js-closure', 4, 1,
 '「クロージャ（Closure）」の定義として正しいのは？',
 '正解は関数とその関数が宣言されたレキシカル環境の組み合わせです。外側の関数のスコープにある変数に、内側の関数からアクセスし続けることができる仕組みを指します。データの隠蔽やプライベート変数の実現に使用されます。'),

('js-dom-queryselector', 4, 1,
 'DOM要素をCSSセレクタ形式で取得するメソッドは？',
 '正解はquerySelector()です。document.querySelector(".class-name")のように使用し、最初に見つかった1つの要素を返します。すべて取得したい場合はquerySelectorAll()を使用します。'),

('js-event-listener', 4, 1,
 '要素にイベントハンドラを登録する推奨される方法は？',
 '正解はaddEventListener()です。一つの要素に対して複数のイベントリスナーを登録でき、キャプチャ/バブリングの制御も可能です。onclick属性（インライン）やonclickプロパティへの代入は、上書きの危険があるため推奨されません。'),

('js-event-propagation', 4, 1,
 'イベントバブリング（Event Bubbling）の説明として正しいのは？',
 '正解はイベントが発生した要素から親要素へ向かってイベントが伝播することです。逆に親から子へ向かうのはキャプチャリングです。event.stopPropagation()を使用すると、この伝播を止めることができます。'),

('js-this-keyword', 4, 1,
 '通常の関数（functionキーワード）における「this」の決まり方は？',
 '正解は「関数の呼び出し方」によって動的に決まることです。オブジェクトのメソッドとして呼ばれればそのオブジェクトを指し、単独で呼ばれればグローバルオブジェクト（またはundefined）を指します。アロー関数はこの性質を持ちません。'),

('js-json-parse-stringify', 4, 1,
 'JSON文字列をJavaScriptのオブジェクトに変換するメソッドは？',
 '正解はJSON.parse()です。逆にオブジェクトをJSON文字列に変換するのはJSON.stringify()です。APIとのデータのやり取りで頻繁に使用されます。'),

('js-modules-import-export', 4, 1,
 'ES Modulesで他のファイルから機能を読み込むキーワードは？',
 '正解はimportです。exportで公開された関数や変数を、import { functionName } from "./module.js"のように読み込みます。コードのモジュール化により保守性が向上します。'),

('js-localstorage', 4, 1,
 'ブラウザを閉じてもデータを保持し続けるストレージ機能は？',
 '正解はlocalStorageです。数MBのデータを永続的に保存できます。sessionStorageはタブやウィンドウを閉じると消去されます。Cookieは主にサーバーとの通信や少量のデータ保持に使用されます。'),

('js-fetch-api', 4, 1,
 'ネットワークリクエストを行うためのモダンなAPIは？',
 '正解はFetch APIです。fetch(url)のように使用し、Promiseを返します。従来のXMLHttpRequestよりも簡潔で強力なインターフェースを提供します。'),

('js-classes-syntax', 4, 1,
 'JavaScriptのクラスでコンストラクタを定義するメソッド名は？',
 '正解はconstructor()です。クラスがインスタンス化される（newされる）際に一度だけ実行される初期化処理を記述します。'),

('js-rest-parameters', 4, 1,
 '関数の引数で「残りの引数すべて」を配列として受け取る構文は？',
 '正解は残余引数（Rest Parameters）です。function sum(...args) { ... } のように「...」を引数名の前に付けます。可変長引数の関数を定義する際に便利です。'),

('js-shorthand-property', 4, 1,
 'オブジェクトのプロパティ名と変数名が同じ場合に省略できる記法は？',
 '正解はプロパティ名の省略（Shorthand properties）です。const name = "John"; const obj = { name }; は { name: name } と同等です。コードを簡潔にするために広く使われます。'),

('js-try-catch-finally', 4, 1,
 'エラーの有無に関わらず、最後に必ず実行したい処理を書くブロックは？',
 '正解はfinallyです。tryブロックでエラーが発生しても、catchブロックでエラーが捕捉されても、その後にfinallyブロックが必ず実行されます。リソースの解放などに使用されます。'),

('js-truthy-falsy', 4, 1,
 'JavaScriptで「偽値（falsy）」と判定されないものは？',
 '正解は空の配列（[]）です。JavaScriptでは、false, 0, "" (空文字), null, undefined, NaN が偽値（falsy）であり、それ以外（空の配列 [] や空のオブジェクト {} を含む）はすべて真値（truthy）として扱われます。'),

('js-set-object', 4, 1,
 '重複した値を持たないコレクションを作成するオブジェクトは？',
 '正解はSetです。new Set([1, 1, 2]) とすると、重複が排除され {1, 2} という値のみを保持します。特定の要素が含まれているかのチェックも高速です。'),

('js-map-object', 4, 1,
 'キーと値のペアを保持し、キーに任意の型（オブジェクト等）を使えるオブジェクトは？',
 '正解はMapです。通常のObjectはキーが文字列かシンボルに限定されますが、Mapは関数やオブジェクトもキーにできます。また、要素の挿入順序が保持される特徴があります。'),

('js-settimeout-setinterval', 4, 1,
 '一定時間後に一度だけ処理を実行する関数は？',
 '正解はsetTimeout()です。setInterval()は一定時間ごとに繰り返し処理を実行します。どちらもタイマーIDを返し、clearTimeout()やclearInterval()で停止できます。'),

('js-strict-mode', 4, 1,
 'JavaScriptでエラーを厳格にチェックするモードを有効にする文字列は？',
 '正解は"use strict"です。スクリプトや関数の先頭に記述することで、不適切な構文（未宣言の変数への代入など）をエラーとして検出し、より安全なコード記述を強制します。ES Modules内ではデフォルトで有効です。'),

('js-dom-creation', 4, 1,
 'JavaScriptで新しいHTML要素をメモリ上に作成するメソッドは？',
 '正解はdocument.createElement()です。引数にタグ名（"div"など）を指定して要素を作成し、appendChild()やprepend()を使用して実際のDOMツリーに追加します。'),

('js-callback-function', 4, 1,
 '他の関数に引数として渡される関数の呼称は？',
 '正解はコールバック関数です。非同期処理の完了時や、イベント発生時の処理を定義するために多用されます。'),

('js-intersection-observer', 4, 1,
 '要素がビューポートに入ったことを検知するために使用するAPIは？',
 '正解はIntersection Observer APIです。画像の遅延読み込み（Lazy Loading）や、無限スクロール、スクロールアニメーションの発火条件として非常に有用なモダンなAPIです。'),

('js-type-of-operator', 4, 1,
 '値の型を文字列で返す演算子は？',
 '正解はtypeofです。typeof "hello" は "string"、typeof 123 は "number" を返します。ただし、typeof null が "object" を返すという有名な歴史的仕様があるため注意が必要です。'),

('js-debouncing-throttling', 4, 1,
 'スクロールやリサイズなどの頻繁なイベント実行を制限する手法は？',
 '正解はデバウンス（Debouncing）やスロットリング（Throttling）です。デバウンスは「最後に実行されてから一定時間待つ」、スロットリングは「一定時間ごとに一度だけ実行する」ことで、パフォーマンスの低下を防ぎます。');

-- 選択肢（@start 〜 @start+38 の順。各4択）
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q118: variables
(@start + 0, 'const', 1, 1),
(@start + 0, 'let', 0, 2),
(@start + 0, 'var', 0, 3),
(@start + 0, 'set', 0, 4),
-- Q119: equality
(@start + 1, '「===」は型変換を行わずに比較する', 1, 1),
(@start + 1, '「==」の方が処理速度が速い', 0, 2),
(@start + 1, '「===」は数値のみ比較できる', 0, 3),
(@start + 1, '両者に違いはない', 0, 4),
-- Q120: data types
(@start + 2, 'Object', 1, 1),
(@start + 2, 'String', 0, 2),
(@start + 2, 'Boolean', 0, 3),
(@start + 2, 'Undefined', 0, 4),
-- Q121: arrow functions
(@start + 3, '独自に「this」を持たず、外側のスコープを継承する', 1, 1),
(@start + 3, '常に独自の「this」を生成する', 0, 2),
(@start + 3, 'newキーワードでインスタンス化できる', 0, 3),
(@start + 3, '引数を1つしか取ることができない', 0, 4),
-- Q122: template literals
(@start + 4, '`Hello ${name}`', 1, 1),
(@start + 4, '"Hello ${name}"', 0, 2),
(@start + 4, '''Hello {name}''', 0, 3),
(@start + 4, '<Hello ${name}>', 0, 4),
-- Q123: destructuring
(@start + 5, 'オブジェクトや配列から特定の値を簡潔に抽出できる', 1, 1),
(@start + 5, '配列の要素を削除する', 0, 2),
(@start + 5, '複数の変数を1つにまとめる', 0, 3),
(@start + 5, '変数の型を変換する', 0, 4),
-- Q124: spread
(@start + 6, '配列やオブジェクトの要素を展開する', 1, 1),
(@start + 6, '配列の要素を反転させる', 0, 2),
(@start + 6, 'オブジェクトのメソッドを隠蔽する', 0, 3),
(@start + 6, '非同期処理を待機する', 0, 4),
-- Q125: async/await
(@start + 7, '非同期処理を同期処理に近い見た目で記述できる', 1, 1),
(@start + 7, '全ての処理を並列で実行する', 0, 2),
(@start + 7, 'CPUの負荷を大幅に下げる', 0, 3),
(@start + 7, 'JavaScriptをマルチスレッド化する', 0, 4),
-- Q126: promise states
(@start + 8, 'waiting', 1, 1),
(@start + 8, 'pending', 0, 2),
(@start + 8, 'fulfilled', 0, 3),
(@start + 8, 'rejected', 0, 4),
-- Q127: map
(@start + 9, '各要素に処理を適用した新しい配列を返す', 1, 1),
(@start + 9, '元の配列を直接書き換える', 0, 2),
(@start + 9, '要素の合計値を返す', 0, 3),
(@start + 9, '条件に合う最初の要素を返す', 0, 4),
-- Q128: filter
(@start + 10, '条件に一致する要素のみの新しい配列を作成する', 1, 1),
(@start + 10, '配列の順序を並べ替える', 0, 2),
(@start + 10, '配列の最初の要素を削除する', 0, 3),
(@start + 10, '全要素の型をチェックする', 0, 4),
-- Q129: reduce
(@start + 11, '配列の要素を1つの値に集約する', 1, 1),
(@start + 11, '配列のサイズを小さくする', 0, 2),
(@start + 11, '配列を2つに分割する', 0, 3),
(@start + 11, '配列の特定の要素を検索する', 0, 4),
-- Q130: nullish coalescing
(@start + 12, '左辺がnullまたはundefinedの場合に右辺を返す', 1, 1),
(@start + 12, '左辺がfalseの場合に右辺を返す', 0, 2),
(@start + 12, '左辺が0の場合に右辺を返す', 0, 3),
(@start + 12, '常に右辺を返す', 0, 4),
-- Q131: optional chaining
(@start + 13, '途中の値がnull/undefinedでもエラーにならずにundefinedを返す', 1, 1),
(@start + 13, 'プロパティの値を強制的に変更する', 0, 2),
(@start + 13, '存在しないプロパティにデフォルト値を設定する', 0, 3),
(@start + 13, 'すべてのプロパティをループで取得する', 0, 4),
-- Q132: scope
(@start + 14, 'ブロックスコープ', 1, 1),
(@start + 14, '関数スコープ', 0, 2),
(@start + 14, 'グローバルスコープ', 0, 3),
(@start + 14, 'スコープは存在しない', 0, 4),
-- Q133: hoisting
(@start + 15, '宣言がスコープの先頭に移動したように振る舞う現象', 1, 1),
(@start + 15, '変数の値を削除すること', 0, 2),
(@start + 15, '関数の実行を遅延させること', 0, 3),
(@start + 15, 'エラーを無視すること', 0, 4),
-- Q134: closure
(@start + 16, '関数とその宣言されたレキシカル環境の組み合わせ', 1, 1),
(@start + 16, '実行が完了した関数を削除する機能', 0, 2),
(@start + 16, 'グローバル変数のみを使用する関数', 0, 3),
(@start + 16, '引数を取らない関数', 0, 4),
-- Q135: querySelector
(@start + 17, 'querySelector()', 1, 1),
(@start + 17, 'getElementByCSS()', 0, 2),
(@start + 17, 'findSelector()', 0, 3),
(@start + 17, 'searchElement()', 0, 4),
-- Q136: addEventListener
(@start + 18, 'addEventListener()', 1, 1),
(@start + 18, 'attachHandler()', 0, 2),
(@start + 18, 'setEvent()', 0, 3),
(@start + 18, 'listen()', 0, 4),
-- Q137: bubbling
(@start + 19, 'イベントが子要素から親要素へ伝播すること', 1, 1),
(@start + 19, 'イベントが親要素から子要素へ伝播すること', 0, 2),
(@start + 19, 'イベントが兄弟要素へ伝播すること', 0, 3),
(@start + 19, 'イベントが停止すること', 0, 4),
-- Q138: this
(@start + 20, '関数の呼び出し方によって動的に決まる', 1, 1),
(@start + 20, '常にグローバルオブジェクトを指す', 0, 2),
(@start + 20, '関数が定義された場所で固定される', 0, 3),
(@start + 20, '読み取り専用のキーワードではない', 0, 4),
-- Q139: JSON.parse
(@start + 21, 'JSON.parse()', 1, 1),
(@start + 21, 'JSON.stringify()', 0, 2),
(@start + 21, 'JSON.toObject()', 0, 3),
(@start + 21, 'JSON.load()', 0, 4),
-- Q140: import
(@start + 22, 'import', 1, 1),
(@start + 22, 'require', 0, 2),
(@start + 22, 'load', 0, 3),
(@start + 22, 'include', 0, 4),
-- Q141: localStorage
(@start + 23, 'localStorage', 1, 1),
(@start + 23, 'sessionStorage', 0, 2),
(@start + 23, 'Cookie', 0, 3),
(@start + 23, 'CacheStorage', 0, 4),
-- Q142: fetch
(@start + 24, 'Fetch API', 1, 1),
(@start + 24, 'XMLHttpRequest', 0, 2),
(@start + 24, 'Axios API', 0, 3),
(@start + 24, 'Network API', 0, 4),
-- Q143: constructor
(@start + 25, 'constructor()', 1, 1),
(@start + 25, 'init()', 0, 2),
(@start + 25, 'new()', 0, 3),
(@start + 25, 'create()', 0, 4),
-- Q144: rest parameters
(@start + 26, '残余引数（Rest Parameters）', 1, 1),
(@start + 26, 'スプレッド引数', 0, 2),
(@start + 26, '配列引数', 0, 3),
(@start + 26, '可変引数', 0, 4),
-- Q145: property shorthand
(@start + 27, 'プロパティ名の省略（Shorthand properties）', 1, 1),
(@start + 27, 'デフォルトプロパティ', 0, 2),
(@start + 27, 'オートプロパティ', 0, 3),
(@start + 27, 'マージプロパティ', 0, 4),
-- Q146: finally
(@start + 28, 'finally', 1, 1),
(@start + 28, 'end', 0, 2),
(@start + 28, 'complete', 0, 3),
(@start + 28, 'always', 0, 4),
-- Q147: falsy
(@start + 29, '空の配列（[]）', 1, 1),
(@start + 29, '0', 0, 2),
(@start + 29, 'null', 0, 3),
(@start + 29, 'NaN', 0, 4),
-- Q148: Set
(@start + 30, 'Set', 1, 1),
(@start + 30, 'Map', 0, 2),
(@start + 30, 'Array', 0, 3),
(@start + 30, 'Collection', 0, 4),
-- Q149: Map
(@start + 31, 'Map', 1, 1),
(@start + 31, 'Dictionary', 0, 2),
(@start + 31, 'Object', 0, 3),
(@start + 31, 'HashMap', 0, 4),
-- Q150: setTimeout
(@start + 32, 'setTimeout()', 1, 1),
(@start + 32, 'setInterval()', 0, 2),
(@start + 32, 'wait()', 0, 3),
(@start + 32, 'delay()', 0, 4),
-- Q151: strict mode
(@start + 33, '"use strict"', 1, 1),
(@start + 33, '"strict mode"', 0, 2),
(@start + 33, '"check errors"', 0, 3),
(@start + 33, '"no sloppy"', 0, 4),
-- Q152: createElement
(@start + 34, 'document.createElement()', 1, 1),
(@start + 34, 'document.newElement()', 0, 2),
(@start + 34, 'document.addTag()', 0, 3),
(@start + 34, 'document.generate()', 0, 4),
-- Q153: callback
(@start + 35, 'コールバック関数', 1, 1),
(@start + 35, '再帰関数', 0, 2),
(@start + 35, '高階関数', 0, 3),
(@start + 35, '匿名関数', 0, 4),
-- Q154: intersection observer
(@start + 36, 'Intersection Observer API', 1, 1),
(@start + 36, 'Viewport Observer API', 0, 2),
(@start + 36, 'Scroll Spy API', 0, 3),
(@start + 36, 'Visibility API', 0, 4),
-- Q155: typeof
(@start + 37, 'typeof', 1, 1),
(@start + 37, 'instanceof', 0, 2),
(@start + 37, 'type()', 0, 3),
(@start + 37, 'kindof', 0, 4),
-- Q156: debounce/throttle
(@start + 38, 'デバウンスやスロットリング', 1, 1),
(@start + 38, 'バッチ処理', 0, 2),
(@start + 38, 'メモ化', 0, 3),
(@start + 38, '非同期レンダリング', 0, 4);