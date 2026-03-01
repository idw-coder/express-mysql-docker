-- コンピュータサイエンス基礎クイズ シードデータ
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-cs-basic.sql

SET NAMES utf8mb4;

-- 1. カテゴリ登録
SET @target_slug = 'cs-basic';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'CS基礎', 1, 'コンピュータサイエンスの基礎知識とよくあるエラーに関する問題です。', @cat_id);

-- 2. クイズデータ登録準備
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. クイズ本体の登録
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
-- エラー関連 (5問)
('cs-error-segfault', @cat_id, 1, 'プログラム実行中に「Segmentation fault (core dumped)」が発生しました。主な原因は何ですか？', '正解は「許可されていないメモリ領域へのアクセス」です。初期化されていないポインタの参照や、配列の範囲外アクセスなどが原因でOSがプロセスを強制終了させた状態です。'),
('cs-error-stackoverflow', @cat_id, 1, '「StackOverflowError」が発生しました。最も疑わしい原因はどれですか？', '正解は「終了条件のない無限の再帰呼び出し」です。関数呼び出しのたびにスタックメモリが消費され、上限に達するとこのエラーが発生します。'),
('cs-error-oom', @cat_id, 1, '「Out of Memory (OOM)」エラーが発生しました。解決策として適切でないものは？', '正解は「CPUのクロック周波数を上げる」です。OOMはメモリの枯渇によるものなので、メモリリークの解消やデータ構造の見直し、物理メモリの増設が必要です。'),
('cs-error-deadlock', @cat_id, 1, 'マルチスレッド環境で「Deadlock」が発生しました。どのような状態ですか？', '正解は「複数のプロセスが互いのリソース解放を待ち合い、永遠に処理が進まない状態」です。ロックの順序を統一するなどの設計で回避する必要があります。'),
('cs-error-connection-refused', @cat_id, 1, '「Connection refused」というネットワークエラーが発生しました。原因として考えられるのは？', '正解は「接続先サーバーで該当ポートをリッスンしているプロセスがない」です。サーバーが起動していないか、ファイアウォールでブロックされている可能性があります。'),

-- 通常問題 (15問)
('cs-ds-stack', @cat_id, 1, '最後に追加されたデータが最初に取り出される（LIFO）データ構造はどれですか？', '正解は「スタック」です。関数呼び出しの管理や、「元に戻す」機能の実装などに利用されます。'),
('cs-ds-queue', @cat_id, 1, '最初に追加されたデータが最初に取り出される（FIFO）データ構造はどれですか？', '正解は「キュー」です。プリンタの印刷待ちや、非同期処理のタスク管理などに利用されます。'),
('cs-ds-array-vs-list', @cat_id, 1, '配列と比較したときの「リンクリスト（連結リスト）」のメリットは？', '正解は「要素の挿入・削除が容易であること」です。配列はメモリ上で連続していますが、リンクリストはポインタで繋がっているため、メモリの再確保なしで要素を追加できます。'),
('cs-ds-hash-collision', @cat_id, 1, 'ハッシュテーブルで異なるキーが同じハッシュ値になることを何と呼びますか？', '正解は「衝突（コリジョン）」です。チェイン法やオープンアドレス法などを用いて解決します。'),
('cs-algo-binary-search', @cat_id, 1, 'ソート済みの配列に対する「二分探索」の最悪計算量はどれですか？', '正解は「O(log n)」です。探索範囲を毎回半分にしていくため、要素が増えても探索回数は緩やかにしか増加しません。'),
('cs-algo-quicksort', @cat_id, 1, 'クイックソートの最悪計算量はどれですか？', '正解は「O(n^2)」です。ピボットの選び方が偏った場合に発生しますが、平均計算量はO(n log n)で非常に高速です。'),
('cs-os-process-thread', @cat_id, 1, '「プロセス」と「スレッド」の違いについて正しいものは？', '正解は「プロセスは独立したメモリ空間を持つが、スレッドは同じプロセス内でメモリ空間を共有する」です。'),
('cs-os-virtual-memory', @cat_id, 1, 'OSの「仮想メモリ」の主な目的は何ですか？', '正解は「物理メモリ以上の容量をプログラムに提供し、メモリ管理を抽象化すること」です。ハードディスクの一部をメモリのように扱います。'),
('cs-os-cache', @cat_id, 1, 'コンピュータの記憶装置の階層で、最もアクセス速度が速いものは？', '正解は「CPUレジスタ」です。次いでL1/L2キャッシュメモリ、メインメモリ、ストレージの順になります。'),
('cs-net-tcp-udp', @cat_id, 1, 'TCPとUDPの違いについて正しいものは？', '正解は「TCPは信頼性重視、UDPは速度重視」です。TCPはデータの到達確認を行いますが、UDPは行わずに動画配信などで使われます。'),
('cs-net-http-404', @cat_id, 1, 'HTTPステータスコード「404」の意味は？', '正解は「Not Found（未検出）」です。リクエストされたリソースがサーバー上に見つからないことを示します。'),
('cs-net-mac-ip', @cat_id, 1, 'IPアドレスとMACアドレスの違いは？', '正解は「IPは論理的なアドレス、MACはハードウェアに割り当てられた物理的なアドレス」です。'),
('cs-net-dns', @cat_id, 1, 'DNS（Domain Name System）の主な役割は？', '正解は「ドメイン名とIPアドレスを変換（名前解決）すること」です。'),
('cs-sec-public-key', @cat_id, 1, '公開鍵暗号方式における暗号化と復号のルールは？', '正解は「公開鍵で暗号化し、秘密鍵で復号する」です。第三者に公開鍵を渡すことで、安全にメッセージを受け取れます。'),
('cs-sec-digital-signature', @cat_id, 1, 'デジタル署名で「送信者の本人確認と改ざん検知」を行うための方法は？', '正解は「送信者の秘密鍵で暗号化（署名）し、送信者の公開鍵で復号（検証）する」です。');

-- 4. 選択肢の登録
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: Segfault
(@quiz_start + 0, '許可されていないメモリ領域へのアクセス', 1, 1),
(@quiz_start + 0, 'ハードディスクの物理的な破損', 0, 2),
(@quiz_start + 0, 'ネットワーク回線の切断', 0, 3),
(@quiz_start + 0, 'データベースのクエリ構文エラー', 0, 4),
-- Q2: StackOverflow
(@quiz_start + 1, '終了条件のない無限の再帰呼び出し', 1, 1),
(@quiz_start + 1, '巨大なファイルの読み込み', 0, 2),
(@quiz_start + 1, '無限ループによるCPU使用率100%', 0, 3),
(@quiz_start + 1, '不要な変数の宣言', 0, 4),
-- Q3: OOM
(@quiz_start + 2, 'CPUのクロック周波数を上げる', 1, 1),
(@quiz_start + 2, 'メモリリークの解消', 0, 2),
(@quiz_start + 2, 'データ構造の見直し', 0, 3),
(@quiz_start + 2, '物理メモリの増設', 0, 4),
-- Q4: Deadlock
(@quiz_start + 3, '複数のプロセスが互いのリソース解放を待ち合う状態', 1, 1),
(@quiz_start + 3, 'サーバーが高負荷で応答しない状態', 0, 2),
(@quiz_start + 3, 'ルーターのルーティングがループしている状態', 0, 3),
(@quiz_start + 3, 'データベースが破損している状態', 0, 4),
-- Q5: Connection refused
(@quiz_start + 4, '接続先で該当ポートをリッスンしているプロセスがない', 1, 1),
(@quiz_start + 4, 'DNSの名前解決に失敗した', 0, 2),
(@quiz_start + 4, 'パスワードが間違っている', 0, 3),
(@quiz_start + 4, 'SSL証明書の期限が切れている', 0, 4),
-- Q6: Stack
(@quiz_start + 5, 'スタック', 1, 1),
(@quiz_start + 5, 'キュー', 0, 2),
(@quiz_start + 5, 'ヒープ', 0, 3),
(@quiz_start + 5, 'ツリー', 0, 4),
-- Q7: Queue
(@quiz_start + 6, 'キュー', 1, 1),
(@quiz_start + 6, 'スタック', 0, 2),
(@quiz_start + 6, 'グラフ', 0, 3),
(@quiz_start + 6, 'ハッシュ', 0, 4),
-- Q8: Array vs List
(@quiz_start + 7, '要素の挿入・削除が容易であること', 1, 1),
(@quiz_start + 7, 'ランダムアクセスが速いこと', 0, 2),
(@quiz_start + 7, 'メモリ消費が少ないこと', 0, 3),
(@quiz_start + 7, '常にソートされていること', 0, 4),
-- Q9: Hash collision
(@quiz_start + 8, '衝突（コリジョン）', 1, 1),
(@quiz_start + 8, 'フラグメンテーション', 0, 2),
(@quiz_start + 8, 'オーバーフロー', 0, 3),
(@quiz_start + 8, 'デッドロック', 0, 4),
-- Q10: Binary search
(@quiz_start + 9, 'O(log n)', 1, 1),
(@quiz_start + 9, 'O(1)', 0, 2),
(@quiz_start + 9, 'O(n)', 0, 3),
(@quiz_start + 9, 'O(n^2)', 0, 4),
-- Q11: Quicksort
(@quiz_start + 10, 'O(n^2)', 1, 1),
(@quiz_start + 10, 'O(n log n)', 0, 2),
(@quiz_start + 10, 'O(n)', 0, 3),
(@quiz_start + 10, 'O(log n)', 0, 4),
-- Q12: Process Thread
(@quiz_start + 11, 'スレッドは同じプロセス内でメモリ空間を共有する', 1, 1),
(@quiz_start + 11, 'プロセスは同じメモリ空間を共有する', 0, 2),
(@quiz_start + 11, 'スレッドはOSの最小実行単位ではない', 0, 3),
(@quiz_start + 11, '両者に違いはない', 0, 4),
-- Q13: Virtual memory
(@quiz_start + 12, '物理メモリ以上の容量をプログラムに提供する', 1, 1),
(@quiz_start + 12, 'CPUのキャッシュを最適化する', 0, 2),
(@quiz_start + 12, 'GPUのリソースを管理する', 0, 3),
(@quiz_start + 12, 'ネットワーク帯域を制限する', 0, 4),
-- Q14: Cache
(@quiz_start + 13, 'CPUレジスタ', 1, 1),
(@quiz_start + 13, 'L1キャッシュ', 0, 2),
(@quiz_start + 13, 'メインメモリ', 0, 3),
(@quiz_start + 13, 'SSD', 0, 4),
-- Q15: TCP UDP
(@quiz_start + 14, 'TCPは信頼性重視、UDPは速度重視', 1, 1),
(@quiz_start + 14, 'TCPは速度重視、UDPは信頼性重視', 0, 2),
(@quiz_start + 14, 'TCPは暗号化通信、UDPは平文通信', 0, 3),
(@quiz_start + 14, 'TCPはローカル用、UDPはインターネット用', 0, 4),
-- Q16: 404
(@quiz_start + 15, 'Not Found', 1, 1),
(@quiz_start + 15, 'Internal Server Error', 0, 2),
(@quiz_start + 15, 'Forbidden', 0, 3),
(@quiz_start + 15, 'Bad Request', 0, 4),
-- Q17: MAC IP
(@quiz_start + 16, 'IPは論理的、MACは物理的なアドレス', 1, 1),
(@quiz_start + 16, 'IPは外部向け、MACは内部向けアドレス', 0, 2),
(@quiz_start + 16, 'IPはIPv6のみ、MACはIPv4用', 0, 3),
(@quiz_start + 16, '両方ともハードウェアに固定されている', 0, 4),
-- Q18: DNS
(@quiz_start + 17, 'ドメイン名とIPアドレスの変換', 1, 1),
(@quiz_start + 17, 'パケットのルーティング', 0, 2),
(@quiz_start + 17, '通信の暗号化', 0, 3),
(@quiz_start + 17, 'IPアドレスの自動割り当て', 0, 4),
-- Q19: Public key
(@quiz_start + 18, '公開鍵で暗号化し、秘密鍵で復号する', 1, 1),
(@quiz_start + 18, '秘密鍵で暗号化し、公開鍵で復号する', 0, 2),
(@quiz_start + 18, '公開鍵で暗号化し、公開鍵で復号する', 0, 3),
(@quiz_start + 18, '秘密鍵で暗号化し、秘密鍵で復号する', 0, 4),
-- Q20: Digital signature
(@quiz_start + 19, '送信者の秘密鍵で暗号化し、公開鍵で復号する', 1, 1),
(@quiz_start + 19, '送信者の公開鍵で暗号化し、秘密鍵で復号する', 0, 2),
(@quiz_start + 19, '受信者の秘密鍵で暗号化し、公開鍵で復号する', 0, 3),
(@quiz_start + 19, '受信者の公開鍵で暗号化し、秘密鍵で復号する', 0, 4);