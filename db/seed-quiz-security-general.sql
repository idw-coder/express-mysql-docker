-- セキュリティ全般クイズ シードデータ
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-security-general.sql

SET NAMES utf8mb4;

-- 1. カテゴリ登録
SET @target_slug = 'security-general';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'セキュリティ全般', 1, 'Webやネットワークの一般的なセキュリティ知識と、よく遭遇するエラーに関する問題です。', @cat_id);

-- 2. クイズデータ登録準備
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. クイズ本体の登録
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
-- エラー関連 (5問)
('sec-error-cors', @cat_id, 1, 'ブラウザで「Blocked by CORS policy: No ''Access-Control-Allow-Origin'' header」エラーが出ました。原因は？', '正解は「異なるオリジン（ドメイン等）からのAPIリクエストがサーバー側で許可されていないため」です。サーバー側で適切なCORSヘッダーを設定して許可リストに追加する必要があります。'),
('sec-error-ssl-protocol', @cat_id, 1, '「ERR_SSL_PROTOCOL_ERROR」が発生してWebサイトにアクセスできません。主な原因は？', '正解は「サーバーとクライアント間で安全な通信プロトコル（TLSバージョンなど）が一致していないため」です。古いブラウザの使用や、サーバー側の証明書設定不備などが考えられます。'),
('sec-error-mixed-content', @cat_id, 1, '「Mixed Content: The page was loaded over HTTPS, but requested an insecure...」エラーの解決策は？', '正解は「ページ内のすべてのリソース（画像やスクリプト）をHTTPS経由で読み込むように修正する」です。暗号化されたページ内で暗号化されていない通信を行うとブラウザにブロックされます。'),
('sec-error-403-forbidden', @cat_id, 1, '「403 Forbidden」エラーが返ってきました。セキュリティ上の観点から考えられる原因は？', '正解は「WAF（Web Application Firewall）によって不正なリクエストと判定されブロックされた」です。または、単にディレクトリやファイルに対するアクセス権限（パーミッション）が不足している場合にも発生します。'),
('sec-error-502-bad-gateway', @cat_id, 1, '「502 Bad Gateway」エラーが発生しました。ネットワーク構成上の原因として多いものは？', '正解は「リバースプロキシやロードバランサーが、バックエンドサーバーから無効な応答を受け取ったため」です。ファイアウォールの設定でバックエンドへの通信が遮断されている場合などによく見られます。'),

-- セキュリティ全般 (15問)
('sec-gen-sqli', @cat_id, 1, 'SQLインジェクション攻撃を防ぐための最も確実な対策は？', '正解は「プレースホルダ（バインド変数）を利用したパラメータ化クエリを使用する」です。入力値がSQLコマンドの一部として解釈されるのを防ぎ、単なるデータとして扱わせます。'),
('sec-gen-xss', @cat_id, 1, 'XSS（クロスサイトスクリプティング）攻撃の主な手口は？', '正解は「攻撃者が悪意のあるスクリプトを標的サイトに埋め込み、他のユーザーのブラウザ上で実行させる」ことです。出力時の適切なエスケープ（サニタイズ）処理で防ぎます。'),
('sec-gen-csrf', @cat_id, 1, 'CSRF（クロスサイトリクエストフォージェリ）攻撃を防ぐための有効な対策は？', '正解は「予測困難なワンタイムトークン（CSRFトークン）を発行し、リクエストごとに検証する」です。ユーザーが意図しない操作を強制されるのを防ぎます。'),
('sec-gen-password-hash', @cat_id, 1, 'ユーザーのパスワードをデータベースに保存する際の適切な処理は？', '正解は「ソルト（ランダムな文字列）を付与した上で、bcryptなどの強力なハッシュ関数でハッシュ化する」です。平文や単純な暗号化での保存は厳禁です。'),
('sec-gen-least-privilege', @cat_id, 1, 'セキュリティの基本原則である「最小特権の原則」とは？', '正解は「ユーザーやプログラムに対し、目的を達成するために必要な最小限の権限のみを与えること」です。被害発生時の影響範囲を最小限に抑えられます。'),
('sec-gen-social-engineering', @cat_id, 1, '技術的な手段ではなく、人間の心理的な隙を突いてパスワードなどを盗み出す手法は？', '正解は「ソーシャルエンジニアリング」です。関係者を装った電話での聞き出しや、偽サイトに誘導するフィッシング詐欺などが該当します。'),
('sec-gen-ddos', @cat_id, 1, '多数のコンピュータから一斉にアクセスを行い、サーバーをダウンさせる攻撃は？', '正解は「DDoS攻撃（分散型サービス拒否攻撃）」です。CDNの導入や、WAFによるトラフィック制限などで対策を行います。'),
('sec-gen-mfa', @cat_id, 1, 'パスワードだけでなく、SMS認証やワンタイムパスワードアプリなどを組み合わせる認証方式は？', '正解は「多要素認証（MFA / 2FA）」です。知識情報、所持情報、生体情報のうち2つ以上を組み合わせることでセキュリティを大幅に強化します。'),
('sec-gen-waf', @cat_id, 1, 'Webアプリケーションの脆弱性を突いた攻撃（SQLインジェクションやXSSなど）を検知・防御するシステムは？', '正解は「WAF（Web Application Firewall）」です。HTTP/HTTPSのトラフィックをアプリケーションレベルで解析し、不正な通信を遮断します。'),
('sec-gen-zero-trust', @cat_id, 1, '「社内ネットワークは安全である」という前提を捨て、すべての通信を検証するセキュリティモデルは？', '正解は「ゼロトラストアーキテクチャ」です。ネットワークの境界に依存せず、アクセスごとの厳密な認証と認可を要求します。'),
('sec-gen-directory-traversal', @cat_id, 1, 'ファイル名指定のパラメータに「../」などを混入させ、非公開のファイルに不正アクセスする攻撃は？', '正解は「ディレクトリトラバーサル（パストラバーサル）」です。ファイルパスを直接指定させる設計を避けるか、入力値から危険な文字を排除する必要があります。'),
('sec-gen-mitm', @cat_id, 1, '通信を行う二者の間に割り込み、通信内容を盗聴したり改ざんしたりする攻撃は？', '正解は「中間者攻撃（Man-in-the-Middle attack）」です。フリーWi-Fiなどでの盗聴を防ぐため、常にHTTPSなどの暗号化通信を利用することが重要です。'),
('sec-gen-ransomware', @cat_id, 1, 'コンピュータ内のデータを勝手に暗号化し、復号のための身代金を要求するマルウェアは？', '正解は「ランサムウェア」です。OSやソフトのアップデート、不審なメールを開かないこと、そして定期的なオフラインバックアップが有効な対策です。'),
('sec-gen-oauth', @cat_id, 1, 'パスワードを渡すことなく、あるサービスが別のサービスにあるユーザーのデータにアクセスする権限を与える仕組みは？', '正解は「OAuth（オーオース）」です。ユーザーの同意のもと、アクセストークンを用いて権限の委譲（認可）を安全に行います。'),
('sec-gen-jwt', @cat_id, 1, 'JWT（JSON Web Token）を扱う際のセキュリティ上の注意点は？', '正解は「ペイロード部分はBase64エンコードされているだけで暗号化されていないため、機密情報を含めないこと」です。署名検証を必ず行うことも必須です。');

-- 4. 選択肢の登録
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: sec-error-cors
(@quiz_start + 0, '異なるオリジンからのAPIリクエストがサーバー側で許可されていないため', 1, 1),
(@quiz_start + 0, 'ブラウザのJavaScriptが無効になっているため', 0, 2),
(@quiz_start + 0, 'APIのレスポンス形式がJSONではないため', 0, 3),
(@quiz_start + 0, 'ネットワークの帯域幅が不足しているため', 0, 4),
-- Q2: sec-error-ssl-protocol
(@quiz_start + 1, '安全な通信プロトコル（TLSバージョンなど）が一致していないため', 1, 1),
(@quiz_start + 1, 'ドメインの有効期限が切れているため', 0, 2),
(@quiz_start + 1, 'DNSサーバーがダウンしているため', 0, 3),
(@quiz_start + 1, 'パスワードが間違っているため', 0, 4),
-- Q3: sec-error-mixed-content
(@quiz_start + 2, 'すべてのリソースをHTTPS経由で読み込むように修正する', 1, 1),
(@quiz_start + 2, 'サーバーのポートを80番に変更する', 0, 2),
(@quiz_start + 2, 'ブラウザのセキュリティ設定を下げる', 0, 3),
(@quiz_start + 2, 'JavaScriptをすべて削除する', 0, 4),
-- Q4: sec-error-403-forbidden
(@quiz_start + 3, 'WAFにブロックされたか、アクセス権限（パーミッション）が不足している', 1, 1),
(@quiz_start + 3, 'サーバーのメモリが不足している', 0, 2),
(@quiz_start + 3, '指定されたURLが存在しない', 0, 3),
(@quiz_start + 3, 'データベースが破損している', 0, 4),
-- Q5: sec-error-502-bad-gateway
(@quiz_start + 4, 'プロキシやロードバランサーがバックエンドから無効な応答を受け取った', 1, 1),
(@quiz_start + 4, 'クライアントのキャッシュが古くなっている', 0, 2),
(@quiz_start + 4, 'APIのレート制限に引っかかった', 0, 3),
(@quiz_start + 4, 'SSL証明書がインストールされていない', 0, 4),
-- Q6: sec-gen-sqli
(@quiz_start + 5, 'プレースホルダを利用したパラメータ化クエリを使用する', 1, 1),
(@quiz_start + 5, 'すべての入力文字を大文字に変換する', 0, 2),
(@quiz_start + 5, 'データベースのポート番号を隠蔽する', 0, 3),
(@quiz_start + 5, '通信をHTTPSに限定する', 0, 4),
-- Q7: sec-gen-xss
(@quiz_start + 6, '悪意のあるスクリプトを埋め込み、他のユーザーのブラウザ上で実行させる', 1, 1),
(@quiz_start + 6, 'サーバーに大量のデータを送りつけダウンさせる', 0, 2),
(@quiz_start + 6, 'データベースのテーブルを直接削除する', 0, 3),
(@quiz_start + 6, '暗号化されたパスワードを総当たりで解読する', 0, 4),
-- Q8: sec-gen-csrf
(@quiz_start + 7, '予測困難なワンタイムトークンを発行し、リクエストごとに検証する', 1, 1),
(@quiz_start + 7, 'すべての通信を暗号化する', 0, 2),
(@quiz_start + 7, '複雑なパスワードを強制する', 0, 3),
(@quiz_start + 7, 'データベースのバックアップを暗号化する', 0, 4),
-- Q9: sec-gen-password-hash
(@quiz_start + 8, 'ソルトを付与し、bcryptなどの強力なハッシュ関数でハッシュ化する', 1, 1),
(@quiz_start + 8, 'Base64でエンコードして保存する', 0, 2),
(@quiz_start + 8, 'Zipファイルに圧縮してパスワードをかける', 0, 3),
(@quiz_start + 8, '平文のまま保存し、データベース自体をファイアウォールで守る', 0, 4),
-- Q10: sec-gen-least-privilege
(@quiz_start + 9, '目的を達成するために必要な最小限の権限のみを与えること', 1, 1),
(@quiz_start + 9, 'パスワードを最小文字数に設定すること', 0, 2),
(@quiz_start + 9, 'セキュリティソフトの機能を最小限に絞ること', 0, 3),
(@quiz_start + 9, 'ユーザーの数を最小限に制限すること', 0, 4),
-- Q11: sec-gen-social-engineering
(@quiz_start + 10, 'ソーシャルエンジニアリング', 1, 1),
(@quiz_start + 10, 'ブルートフォース攻撃', 0, 2),
(@quiz_start + 10, 'マルウェア感染', 0, 3),
(@quiz_start + 10, 'ゼロデイ攻撃', 0, 4),
-- Q12: sec-gen-ddos
(@quiz_start + 11, 'DDoS攻撃（分散型サービス拒否攻撃）', 1, 1),
(@quiz_start + 11, '標的型攻撃', 0, 2),
(@quiz_start + 11, '水飲み場型攻撃', 0, 3),
(@quiz_start + 11, 'バッファオーバーフロー攻撃', 0, 4),
-- Q13: sec-gen-mfa
(@quiz_start + 12, '多要素認証（MFA / 2FA）', 1, 1),
(@quiz_start + 12, 'シングルサインオン（SSO）', 0, 2),
(@quiz_start + 12, '生体認証', 0, 3),
(@quiz_start + 12, 'CAPTCHA認証', 0, 4),
-- Q14: sec-gen-waf
(@quiz_start + 13, 'WAF（Web Application Firewall）', 1, 1),
(@quiz_start + 13, 'IDS（侵入検知システム）', 0, 2),
(@quiz_start + 13, 'IPS（侵入防止システム）', 0, 3),
(@quiz_start + 13, 'アンチウイルスソフト', 0, 4),
-- Q15: sec-gen-zero-trust
(@quiz_start + 14, 'ゼロトラストアーキテクチャ', 1, 1),
(@quiz_start + 14, 'ペリメタ（境界）防御', 0, 2),
(@quiz_start + 14, 'VPNネットワーク', 0, 3),
(@quiz_start + 14, 'クローズドネットワーク', 0, 4),
-- Q16: sec-gen-directory-traversal
(@quiz_start + 15, 'ディレクトリトラバーサル（パストラバーサル）', 1, 1),
(@quiz_start + 15, 'SQLインジェクション', 0, 2),
(@quiz_start + 15, 'OSコマンドインジェクション', 0, 3),
(@quiz_start + 15, 'クロスサイトリクエストフォージェリ', 0, 4),
-- Q17: sec-gen-mitm
(@quiz_start + 16, '中間者攻撃（Man-in-the-Middle attack）', 1, 1),
(@quiz_start + 16, 'サイドチャネル攻撃', 0, 2),
(@quiz_start + 16, '辞書攻撃', 0, 3),
(@quiz_start + 16, 'フィッシング攻撃', 0, 4),
-- Q18: sec-gen-ransomware
(@quiz_start + 17, 'ランサムウェア', 1, 1),
(@quiz_start + 17, 'スパイウェア', 0, 2),
(@quiz_start + 17, 'キーロガー', 0, 3),
(@quiz_start + 17, 'トロイの木馬', 0, 4),
-- Q19: sec-gen-oauth
(@quiz_start + 18, 'OAuth（オーオース）', 1, 1),
(@quiz_start + 18, 'SAML', 0, 2),
(@quiz_start + 18, 'OpenID Connect', 0, 3),
(@quiz_start + 18, 'Kerberos', 0, 4),
-- Q20: sec-gen-jwt
(@quiz_start + 19, 'ペイロードは暗号化されていないため、機密情報を含めないこと', 1, 1),
(@quiz_start + 19, '通信は必ずHTTPで行うこと', 0, 2),
(@quiz_start + 19, 'データベースに永続化して保存すること', 0, 3),
(@quiz_start + 19, 'トークンはURLパラメータに付与して送信すること', 0, 4);