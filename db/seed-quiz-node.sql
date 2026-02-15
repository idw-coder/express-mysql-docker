-- Node.js基礎クイズ シードデータ（動的ID対応版）
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-nodejs.sql

SET NAMES utf8mb4;

-- --------------------------------------------------------
-- 1. カテゴリIDを動的に決定して登録
-- --------------------------------------------------------

-- 既存の 'nodejs-basic' があればそのIDを、なければ MAX(id)+1 を @cat_id にセット
SET @target_slug = 'nodejs-basic';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;

-- まだ存在しない場合、新しいIDを発番
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

-- カテゴリを登録（idには動的に決めた @cat_id を使用）
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'Node.js基礎・実践', 1, 'Node.jsのランタイム特性、非同期I/O、モジュールシステム、標準APIに関する問題です。', @cat_id);


-- --------------------------------------------------------
-- 2. クイズデータの登録準備
-- --------------------------------------------------------

-- 既存の quiz の最大 id の次から採番開始位置を決定
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;

-- AUTO_INCREMENT をリセット
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- --------------------------------------------------------
-- 3. クイズ本体の登録（category_id には @cat_id を使用）
-- --------------------------------------------------------

INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('nodejs-runtime-engine', @cat_id, 1,
 'Node.jsが基盤としているJavaScriptエンジンは？',
 '正解はV8エンジンです。Google Chromeで使用されているV8 JavaScriptエンジンを利用しており、JavaScriptコードをネイティブなマシンコードにコンパイルして高速に実行します。'),

('nodejs-event-loop-characteristics', @cat_id, 1,
 'Node.jsのアーキテクチャの最大の特徴である「シングルスレッド」と組み合わせられる仕組みは？',
 '正解はイベントループとノンブロッキングI/Oです。重い処理（ファイル読み込みや通信）をバックグラウンドに任せ、完了通知（コールバック）をイベントループで処理することで、シングルスレッドでも高い並行処理性能を実現します。'),

('nodejs-commonjs-export', @cat_id, 1,
 '従来のNode.js（CommonJS）で、モジュールから値を公開するためのキーワードは？',
 '正解はmodule.exportsです。const math = require("./math")のように読み込みます。ES Modules（import/export）もモダンなNode.jsではサポートされていますが、Node.jsの歴史的な標準はCommonJSです。'),

('nodejs-global-object', @cat_id, 1,
 'ブラウザの「window」オブジェクトに相当する、Node.jsのグローバルオブジェクトは？',
 '正解はglobalです。Node.jsにはDOMが存在しないためwindowやdocumentはありません。代わりにglobal、process、Bufferなどがグローバルスコープで利用可能です。'),

('nodejs-fs-sync-blocking', @cat_id, 1,
 'fs（ファイルシステム）モジュールにおいて、処理が完了するまで次の行に進まない（ブロッキングする）メソッドは？',
 '正解はreadFileSync()のように「Sync」がついているメソッドです。サーバーの起動時など一度きりの処理には便利ですが、リクエスト処理中などに使用するとイベントループを停止させてしまうため注意が必要です。'),

('nodejs-path-join', @cat_id, 1,
 'OSごとのパス区切り文字（/ や \）の違いを吸収してパスを結合するメソッドは？',
 '正解はpath.join()です。Windowsではバックスラッシュ、Linux/macOSではスラッシュという違いを自動で処理し、正しいパス文字列を生成します。単なる文字列結合はバグの原因になります。'),

('nodejs-process-env', @cat_id, 1,
 '環境変数（APIキーやポート番号など）にアクセスするためのプロパティは？',
 '正解はprocess.envです。process.env.PORTのようにアクセスします。開発環境や本番環境で異なる設定値を外部から注入する際によく使用されます。'),

('nodejs-buffer-class', @cat_id, 1,
 'バイナリデータ（画像やファイルストリームなど）を直接扱うためのクラスは？',
 '正解はBufferです。JavaScriptの文字列はUTF-16ですが、TCPストリームやファイルシステム操作などのために、固定長のバイト列を扱うBufferクラスが用意されています。'),

('nodejs-event-emitter', @cat_id, 1,
 'Node.jsの多くのコアモジュール（http, streamなど）が継承している、イベント駆動アーキテクチャの基底クラスは？',
 '正解はEventEmitterです。on()でリスナーを登録し、emit()でイベントを発火させる仕組みを提供します。これがNode.jsの非同期処理の根幹を支えています。'),

('nodejs-npm-package-json', @cat_id, 1,
 'プロジェクトの依存パッケージやスクリプトを管理する設定ファイルは？',
 '正解はpackage.jsonです。npm initコマンドで生成され、dependencies（本番用依存）やdevDependencies（開発用依存）などを管理します。'),

('nodejs-stream-pipe', @cat_id, 1,
 '読み込みストリームから書き込みストリームへデータを効率的に流し込むメソッドは？',
 '正解はpipe()です。readStream.pipe(writeStream)のように使用します。全てのデータをメモリに展開せず、少しずつ読み込んで書き込むため、巨大なファイルのコピーやHTTPレスポンスの送信においてメモリ効率が非常に良くなります。'),

('nodejs-dirname-filename', @cat_id, 1,
 '現在実行中のファイルが存在するディレクトリの絶対パスを保持する変数は？',
 '正解は__dirnameです。ファイル自体のパスは__filenameです。これらはCommonJSモジュールスコープの変数であり、グローバル変数のように見えますが、実は各モジュールごとに値が異なります。'),

('nodejs-util-promisify', @cat_id, 1,
 'コールバック形式の関数（エラー第一コールバック）をPromiseを返す関数に変換するユーティリティは？',
 '正解はutil.promisify()です。古いライブラリやfsモジュールのコールバック形式のメソッドを、async/awaitで扱えるように変換するために使用されます。'),

('nodejs-process-nexttick', @cat_id, 1,
 '現在の操作が完了した後、イベントループの次のフェーズに進む前に即座にコールバックを実行するメソッドは？',
 '正解はprocess.nextTick()です。setTimeout(fn, 0)やsetImmediate()よりも優先度が高く、現在の同期処理が終わった直後に割り込んで実行されます。再帰的に呼ぶとI/Oを餓死させる危険があります。'),

('nodejs-child-process', @cat_id, 1,
 '外部コマンド（lsやgitなど）を実行したり、別プロセスを生成したりするためのモジュールは？',
 '正解はchild_processです。exec()やspawn()メソッドを使用して、OSのシェルコマンドを実行したり、CPU負荷の高い処理を別のNode.jsプロセスに逃がしたりすることができます。'),

('nodejs-worker-threads', @cat_id, 1,
 'Node.jsでCPU集約的な処理（画像処理や暗号化計算など）を並列化するための機能は？',
 '正解はWorker Threadsです。Node.jsは基本的にシングルスレッドですが、Worker Threadsを使うことで複数のスレッドを生成し、メモリを共有しながらCPU負荷の高い計算をメインスレッドから分離して実行できます。'),

('nodejs-http-create-server', @cat_id, 1,
 '標準モジュールのみでWebサーバーを作成するメソッドは？',
 '正解はhttp.createServer()です。Expressなどのフレームワークも内部ではこのメソッドを使用しています。リクエスト（req）とレスポンス（res）を受け取るコールバック関数を引数に取ります。'),

('nodejs-semver', @cat_id, 1,
 'npmパッケージのバージョン管理で採用されている「メジャー.マイナー.パッチ」という規則の名称は？',
 '正解はセマンティックバージョニング（SemVer）です。「^1.0.0」のような指定（キャレット）は、左端の0以外の数字が変わらない範囲（互換性がある範囲）でのアップデートを許容するという意味になります。'),

('nodejs-cluster-module', @cat_id, 1,
 'マルチコアシステムの性能を活かすため、複数のNode.jsプロセスを立ち上げてポートを共有させるモジュールは？',
 '正解はclusterモジュールです。親プロセスが子プロセス（ワーカー）をフォークし、着信接続を分散させることで、CPUコア数に応じたスケーリングが可能になります。PM2などのツールもこの仕組みを利用しています。'),

('nodejs-uncaught-exception', @cat_id, 1,
 '予期せぬエラーでプロセスがクラッシュする直前に発火するイベントは？',
 '正解はuncaughtExceptionです。process.on("uncaughtException", ...)で捕捉できますが、アプリケーションの状態が不安定になっている可能性があるため、ログを出力してプロセスを安全に終了（再起動）させることが推奨されます。');


-- --------------------------------------------------------
-- 4. 選択肢の登録（@quiz_start からの相対位置で紐付け）
-- --------------------------------------------------------

INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: Runtime
(@quiz_start + 0, 'V8エンジン', 1, 1),
(@quiz_start + 0, 'SpiderMonkey', 0, 2),
(@quiz_start + 0, 'JavaScriptCore', 0, 3),
(@quiz_start + 0, 'Chakra', 0, 4),

-- Q2: Event Loop
(@quiz_start + 1, 'イベントループとノンブロッキングI/O', 1, 1),
(@quiz_start + 1, 'マルチスレッドとブロッキングI/O', 0, 2),
(@quiz_start + 1, 'コンパイラ最適化', 0, 3),
(@quiz_start + 1, 'DOMツリーの操作', 0, 4),

-- Q3: CommonJS Export
(@quiz_start + 2, 'module.exports', 1, 1),
(@quiz_start + 2, 'export default', 0, 2),
(@quiz_start + 2, 'public static', 0, 3),
(@quiz_start + 2, 'include', 0, 4),

-- Q4: Global Object
(@quiz_start + 3, 'global', 1, 1),
(@quiz_start + 3, 'window', 0, 2),
(@quiz_start + 3, 'document', 0, 3),
(@quiz_start + 3, 'navigator', 0, 4),

-- Q5: fs blocking
(@quiz_start + 4, 'fs.readFileSync()', 1, 1),
(@quiz_start + 4, 'fs.readFile()', 0, 2),
(@quiz_start + 4, 'fs.read()', 0, 3),
(@quiz_start + 4, 'fs.promises.readFile()', 0, 4),

-- Q6: Path join
(@quiz_start + 5, 'path.join()', 1, 1),
(@quiz_start + 5, 'path.concat()', 0, 2),
(@quiz_start + 5, 'string.append()', 0, 3),
(@quiz_start + 5, 'os.path()', 0, 4),

-- Q7: process.env
(@quiz_start + 6, 'process.env', 1, 1),
(@quiz_start + 6, 'process.config', 0, 2),
(@quiz_start + 6, 'global.env', 0, 3),
(@quiz_start + 6, 'npm.config', 0, 4),

-- Q8: Buffer
(@quiz_start + 7, 'Buffer', 1, 1),
(@quiz_start + 7, 'BinaryArray', 0, 2),
(@quiz_start + 7, 'ByteStream', 0, 3),
(@quiz_start + 7, 'Memory', 0, 4),

-- Q9: EventEmitter
(@quiz_start + 8, 'EventEmitter', 1, 1),
(@quiz_start + 8, 'EventDispatcher', 0, 2),
(@quiz_start + 8, 'EventTarget', 0, 3),
(@quiz_start + 8, 'Observable', 0, 4),

-- Q10: package.json
(@quiz_start + 9, 'package.json', 1, 1),
(@quiz_start + 9, 'npm.xml', 0, 2),
(@quiz_start + 9, 'node_modules', 0, 3),
(@quiz_start + 9, 'config.js', 0, 4),

-- Q11: Stream pipe
(@quiz_start + 10, 'pipe()', 1, 1),
(@quiz_start + 10, 'connect()', 0, 2),
(@quiz_start + 10, 'send()', 0, 3),
(@quiz_start + 10, 'transfer()', 0, 4),

-- Q12: __dirname
(@quiz_start + 11, '__dirname', 1, 1),
(@quiz_start + 11, '__filename', 0, 2),
(@quiz_start + 11, 'process.cwd()', 0, 3),
(@quiz_start + 11, 'path.current', 0, 4),

-- Q13: util.promisify
(@quiz_start + 12, 'util.promisify()', 1, 1),
(@quiz_start + 12, 'Promise.all()', 0, 2),
(@quiz_start + 12, 'async.convert()', 0, 3),
(@quiz_start + 12, 'new Promise()', 0, 4),

-- Q14: process.nextTick
(@quiz_start + 13, 'process.nextTick()', 1, 1),
(@quiz_start + 13, 'setImmediate()', 0, 2),
(@quiz_start + 13, 'setTimeout()', 0, 3),
(@quiz_start + 13, 'process.yield()', 0, 4),

-- Q15: child_process
(@quiz_start + 14, 'child_process', 1, 1),
(@quiz_start + 14, 'os_process', 0, 2),
(@quiz_start + 14, 'system', 0, 3),
(@quiz_start + 14, 'subprocess', 0, 4),

-- Q16: Worker Threads
(@quiz_start + 15, 'Worker Threads', 1, 1),
(@quiz_start + 15, 'Child Process', 0, 2),
(@quiz_start + 15, 'Multi Threading', 0, 3),
(@quiz_start + 15, 'Parallel.js', 0, 4),

-- Q17: http.createServer
(@quiz_start + 16, 'http.createServer()', 1, 1),
(@quiz_start + 16, 'http.newServer()', 0, 2),
(@quiz_start + 16, 'server.listen()', 0, 3),
(@quiz_start + 16, 'net.createConnection()', 0, 4),

-- Q18: SemVer
(@quiz_start + 17, 'SemVer (Semantic Versioning)', 1, 1),
(@quiz_start + 17, 'GitVer', 0, 2),
(@quiz_start + 17, 'NodeVer', 0, 3),
(@quiz_start + 17, 'PackageVer', 0, 4),

-- Q19: Cluster Module
(@quiz_start + 18, 'cluster', 1, 1),
(@quiz_start + 18, 'fork', 0, 2),
(@quiz_start + 18, 'threads', 0, 3),
(@quiz_start + 18, 'cpu-manager', 0, 4),

-- Q20: uncaughtException
(@quiz_start + 19, 'uncaughtException', 1, 1),
(@quiz_start + 19, 'error', 0, 2),
(@quiz_start + 19, 'processCrash', 0, 3),
(@quiz_start + 19, 'shutdown', 0, 4);