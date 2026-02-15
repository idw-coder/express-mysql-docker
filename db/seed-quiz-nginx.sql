-- Nginx基礎・実践クイズ シードデータ（動的ID対応・選択肢シャッフル版）
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-nginx.sql

SET NAMES utf8mb4;

-- --------------------------------------------------------
-- 1. カテゴリIDを動的に決定して登録
-- --------------------------------------------------------

-- 既存の 'nginx-basic' があればそのIDを、なければ MAX(id)+1 を @cat_id にセット
SET @target_slug = 'nginx-basic';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;

-- まだ存在しない場合、新しいIDを発番
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

-- カテゴリを登録
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'Nginx基礎・実践', 1, '高速なWebサーバー/リバースプロキシであるNginxのアーキテクチャ、設定、コマンドに関する問題です。', @cat_id);


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
('nginx-architecture', @cat_id, 1, 'Nginxが高い同時接続数を処理できる理由である、アーキテクチャの特徴は？', '正解は「イベント駆動型（ノンブロッキング）アーキテクチャ」です。Apache（preforkモードなど）が1リクエストにつき1プロセス/スレッドを割り当てるのに対し、Nginxは少数のワーカープロセスが非同期に多数の接続を処理するため、メモリ消費が少なく「C10K問題」の解決策として知られています。'),

('nginx-config-check', @cat_id, 1, 'Nginxの設定ファイル（nginx.conf）の構文エラーをチェックするコマンドは？', '正解は `nginx -t` です。再起動やリロードを行う前に、設定ファイルに記述ミスがないかを確認するために必ず実行すべきコマンドです。'),

('nginx-reload', @cat_id, 1, 'サーバーを停止させずに設定変更を反映させる（設定ファイルを再読み込みする）コマンドは？', '正解は `nginx -s reload` です。既存の接続が終了するのを待ってから新しい設定でプロセスを立ち上げるため、ダウンタイムなしで設定を反映できます。`restart` はプロセスを一度停止するため接続が切断されます。'),

('nginx-reverse-proxy', @cat_id, 1, 'Nginxをリバースプロキシとして動作させ、リクエストをバックエンドサーバーに転送するディレクティブは？', '正解は `proxy_pass` です。`location / { proxy_pass http://localhost:3000; }` のように記述し、Node.jsやPythonなどのアプリケーションサーバーへリクエストを中継します。'),

('nginx-semicolon', @cat_id, 1, 'Nginxの設定ファイル（nginx.conf）において、各行（ディレクティブ）の終わりに必須な文字は？', '正解はセミコロン `;` です。これを忘れると `nginx -t` で構文エラーとなり、サーバーが起動しません。ブロック `{}` の終わりには不要です。'),

('nginx-upstream', @cat_id, 1, 'ロードバランシングを行うために、複数のバックエンドサーバーをグループ定義するブロックは？', '正解は `upstream` ブロックです。`upstream backend { server app1; server app2; }` のように定義し、`proxy_pass` からこのグループ名を参照して負荷分散を行います。'),

('nginx-root-vs-alias', @cat_id, 1, '`root` ディレクティブと `alias` ディレクティブの違いとして正しいのは？', '正解は「`root` は指定したパスにリクエストURIをそのまま連結するのに対し、`alias` はlocation部分を置換する」ことです。`location /img/` に対して `root /var/www;` とすると `/var/www/img/` を探しますが、`alias /var/www;` とすると `/var/www/` 直下を探します。'),

('nginx-default-port', @cat_id, 1, 'Nginxのデフォルト設定において、HTTP通信を受け付ける標準のポート番号は？', '正解は80番ポートです。HTTPS（SSL/TLS）の場合は443番ポートが標準です。`listen 80;` のように設定ファイルで指定します。'),

('nginx-error-502', @cat_id, 1, 'リバースプロキシ環境で「502 Bad Gateway」エラーが発生しました。最も可能性が高い原因は？', '正解は「バックエンド（アップストリーム）サーバーがダウンしているか、応答していない」ことです。Nginx自体は動作していますが、転送先のアプリケーションサーバー（Node.jsやPHP-FPMなど）と通信できない場合に表示されます。'),

('nginx-location-priority', @cat_id, 1, '`location` ブロックのマッチング優先順位において、最も優先度が高い修飾子は？', '正解は完全一致を示す `=` です。`location = / { ... }` は、他の正規表現マッチよりも優先して評価されます。'),

('nginx-worker-processes', @cat_id, 1, '`worker_processes` ディレクティブを `auto` に設定した場合の挙動は？', '正解は「CPUコア数に合わせて自動的にプロセス数を設定する」です。マルチコアCPUの性能を最大限に引き出すための推奨設定です。'),

('nginx-static-files', @cat_id, 1, '画像やCSSなどの静的ファイルを配信する際、ブラウザキャッシュを有効にするためのディレクティブは？', '正解は `expires` です。`expires 30d;` のように設定することで、Cache-ControlヘッダーやExpiresヘッダーを自動的に付与し、クライアント側のキャッシュ利用を促進します。'),

('nginx-access-log', @cat_id, 1, 'アクセスログの出力先やフォーマットを定義するディレクティブは？', '正解は `access_log` です。`access_log /var/log/nginx/access.log main;` のように記述します。エラーログは `error_log` で設定します。'),

('nginx-listen-ssl', @cat_id, 1, 'HTTPS通信を有効にするために `listen` ディレクティブに追加するパラメータは？', '正解は `ssl` です。例：`listen 443 ssl;`。これに加え、`ssl_certificate` と `ssl_certificate_key` で証明書ファイルのパスを指定する必要があります。'),

('nginx-try-files', @cat_id, 1, 'ファイルが存在しない場合に、別のファイルや名前付きlocationに内部リダイレクトさせるディレクティブは？', '正解は `try_files` です。SPA（シングルページアプリケーション）のルーティングでよく使用され、`try_files $uri $uri/ /index.html;` と記述することで、実ファイルがないリクエストを全てindex.htmlに集約できます。'),

('nginx-gzip', @cat_id, 1, 'レスポンスデータを圧縮して転送量を減らす機能を有効にするディレクティブは？', '正解は `gzip on;` です。テキストファイル（HTML, CSS, JS）の転送速度を向上させるために非常に有効です。'),

('nginx-server-name', @cat_id, 1, 'バーチャルホストの設定において、どのドメインへのリクエストを処理するかを指定するディレクティブは？', '正解は `server_name` です。`server_name example.com www.example.com;` のように記述し、Hostヘッダーに基づいて適切な `server` ブロックが選択されます。'),

('nginx-client-max-body-size', @cat_id, 1, 'ファイルアップロード時などに「413 Request Entity Too Large」エラーが出た場合、変更すべき設定は？', '正解は `client_max_body_size` です。デフォルトは1MBに制限されていることが多く、大きなファイルをアップロードする場合は `client_max_body_size 10M;` のように値を増やす必要があります。'),

('nginx-return-redirect', @cat_id, 1, 'HTTPからHTTPSへのリダイレクトなど、特定のステータスコードと共にURLを転送するディレクティブは？', '正解は `return` です。`return 301 https://$host$request_uri;` と記述するのが、最も高速で推奨されるリダイレクト方法です。古い `rewrite` よりも処理が軽量です。'),

('nginx-keepalive', @cat_id, 1, '1つのTCP接続を維持して複数のリクエストを処理させる設定は？', '正解は `keepalive_timeout` です。接続の確立・切断にかかるオーバーヘッドを減らし、パフォーマンスを向上させます。');


-- --------------------------------------------------------
-- 4. 選択肢の登録（ランダムシャッフル版）
-- --------------------------------------------------------

INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: Architecture
(@quiz_start + 0, 'プロセス駆動型アーキテクチャ', 0, 1),
(@quiz_start + 0, 'イベント駆動型（ノンブロッキング）アーキテクチャ', 1, 2),
(@quiz_start + 0, 'スレッドプール型アーキテクチャ', 0, 3),
(@quiz_start + 0, 'ブロックチェーンアーキテクチャ', 0, 4),

-- Q2: Config Check
(@quiz_start + 1, 'nginx -c', 0, 1),
(@quiz_start + 1, 'nginx -t', 1, 2),
(@quiz_start + 1, 'nginx --check', 0, 3),
(@quiz_start + 1, 'nginx --validate', 0, 4),

-- Q3: Reload
(@quiz_start + 2, 'nginx -s restart', 0, 1),
(@quiz_start + 2, 'systemctl stop nginx', 0, 2),
(@quiz_start + 2, 'nginx -s reload', 1, 3),
(@quiz_start + 2, 'nginx --update', 0, 4),

-- Q4: Reverse Proxy
(@quiz_start + 3, 'forward_to', 0, 1),
(@quiz_start + 3, 'remote_addr', 0, 2),
(@quiz_start + 3, 'proxy_pass', 1, 3),
(@quiz_start + 3, 'backend_url', 0, 4),

-- Q5: Semicolon
(@quiz_start + 4, 'カンマ (,)', 0, 1),
(@quiz_start + 4, 'ピリオド (.)', 0, 2),
(@quiz_start + 4, 'コロン (:)', 0, 3),
(@quiz_start + 4, 'セミコロン (;)', 1, 4),

-- Q6: Upstream
(@quiz_start + 5, 'upstream', 1, 1),
(@quiz_start + 5, 'loadbalancer', 0, 2),
(@quiz_start + 5, 'backend_group', 0, 3),
(@quiz_start + 5, 'cluster', 0, 4),

-- Q7: Root vs Alias
(@quiz_start + 6, '両者は全く同じ機能の別名である', 0, 1),
(@quiz_start + 6, 'rootはLinux用、aliasはWindows用', 0, 2),
(@quiz_start + 6, 'rootはパスを連結し、aliasはパスを置換する', 1, 3),
(@quiz_start + 6, 'aliasはパスを連結し、rootはパスを置換する', 0, 4),

-- Q8: Default Port
(@quiz_start + 7, '8080', 0, 1),
(@quiz_start + 7, '80', 1, 2),
(@quiz_start + 7, '22', 0, 3),
(@quiz_start + 7, '443', 0, 4),

-- Q9: 502 Error
(@quiz_start + 8, '設定ファイルの構文エラー', 0, 1),
(@quiz_start + 8, 'リクエストされたファイルが見つからない', 0, 2),
(@quiz_start + 8, 'アクセス権限がない', 0, 3),
(@quiz_start + 8, 'バックエンドサーバーがダウンしている', 1, 4),

-- Q10: Location Priority
(@quiz_start + 9, '通常のマッチ (location /)', 0, 1),
(@quiz_start + 9, '正規表現マッチ (~)', 0, 2),
(@quiz_start + 9, '完全一致 (=)', 1, 3),
(@quiz_start + 9, '前方一致 (^~)', 0, 4),

-- Q11: Worker Processes Auto
(@quiz_start + 10, '常に1つのプロセスを使用する', 0, 1),
(@quiz_start + 10, 'CPUコア数に合わせて自動設定する', 1, 2),
(@quiz_start + 10, '可能な限り多くのプロセスを生成する', 0, 3),
(@quiz_start + 10, 'ランダムな数を設定する', 0, 4),

-- Q12: Static Files Cache
(@quiz_start + 11, 'cache_control', 0, 1),
(@quiz_start + 11, 'keepalive', 0, 2),
(@quiz_start + 11, 'expires', 1, 3),
(@quiz_start + 11, 'static_cache', 0, 4),

-- Q13: Access Log
(@quiz_start + 12, 'access_log', 1, 1),
(@quiz_start + 12, 'request_log', 0, 2),
(@quiz_start + 12, 'http_log', 0, 3),
(@quiz_start + 12, 'traffic_log', 0, 4),

-- Q14: SSL Listen
(@quiz_start + 13, 'secure', 0, 1),
(@quiz_start + 13, 'https', 0, 2),
(@quiz_start + 13, 'tls', 0, 3),
(@quiz_start + 13, 'ssl', 1, 4),

-- Q15: Try Files
(@quiz_start + 14, 'fallback_url', 0, 1),
(@quiz_start + 14, 'try_files', 1, 2),
(@quiz_start + 14, 'check_file', 0, 3),
(@quiz_start + 14, 'error_page', 0, 4),

-- Q16: Gzip
(@quiz_start + 15, 'gzip on;', 1, 1),
(@quiz_start + 15, 'compress on;', 0, 2),
(@quiz_start + 15, 'zip enable;', 0, 3),
(@quiz_start + 15, 'deflate on;', 0, 4),

-- Q17: Server Name
(@quiz_start + 16, 'host_name', 0, 1),
(@quiz_start + 16, 'domain', 0, 2),
(@quiz_start + 16, 'virtual_host', 0, 3),
(@quiz_start + 16, 'server_name', 1, 4),

-- Q18: Max Body Size
(@quiz_start + 17, 'upload_max_filesize', 0, 1),
(@quiz_start + 17, 'client_max_body_size', 1, 2),
(@quiz_start + 17, 'max_request_size', 0, 3),
(@quiz_start + 17, 'post_max_size', 0, 4),

-- Q19: Redirect
(@quiz_start + 18, 'rewrite', 0, 1),
(@quiz_start + 18, 'redirect', 0, 2),
(@quiz_start + 18, 'return', 1, 3),
(@quiz_start + 18, 'move', 0, 4),

-- Q20: Keepalive
(@quiz_start + 19, 'keepalive_timeout', 1, 1),
(@quiz_start + 19, 'connection_persist', 0, 2),
(@quiz_start + 19, 'persistent_timeout', 0, 3),
(@quiz_start + 19, 'http_alive', 0, 4);