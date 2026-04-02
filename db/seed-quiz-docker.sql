-- Docker クイズ シードデータ
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-docker.sql

SET NAMES utf8mb4;

-- 1. カテゴリ登録
SET @target_slug = 'docker';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'Docker', 1, 'Dockerの実践的なエラー解決やDockerfile・docker compose・ボリューム管理など頻出トピックに関するクイズです。', @cat_id);

-- 2. クイズデータ登録準備
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. クイズ本体の登録 (10問)
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES

-- Q1: Cannot connect to the Docker daemon
('docker-cannot-connect-daemon', @cat_id, 1,
 'Dockerコマンド実行時に「Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?」というエラーが発生しました。最も一般的な対処法は？',
 '正解は「Docker Desktop（またはDockerデーモン）を起動する」です。このエラーはDockerデーモン（dockerd）が起動していない場合に発生する最も一般的なエラーの一つです。macOS/WindowsではDocker Desktopアプリを起動、LinuxではsystemctlでDockerサービスを起動（sudo systemctl start docker）します。また、Linuxで一般ユーザーの場合はdockerグループへの追加（sudo usermod -aG docker $USER）が必要な場合もあります。それでも解決しない場合はソケットファイル /var/run/docker.sock のパーミッションや、Docker Desktopの再インストールを検討してください。'),

-- Q2: port is already allocated
('docker-port-already-allocated', @cat_id, 1,
 'docker runまたはdocker compose up実行時に「Bind for 0.0.0.0:3000 failed: port is already allocated」というエラーが発生しました。原因と対処法は？',
 '正解は「ホスト側のポート3000が既に別のプロセスで使用されている」です。Dockerコンテナのポートマッピング（-p 3000:3000）で指定したホスト側ポートが、別のコンテナやホスト上のプロセスに占有されている場合にこのエラーが発生します。対処法としては、lsof -i :3000（macOS/Linux）やnetstat -ano | findstr :3000（Windows）で使用中のプロセスを特定して停止するか、docker compose downで停止し忘れたコンテナを確認します。あるいはポートマッピングを-p 3001:3000のように別のホストポートに変更する方法もあります。'),

-- Q3: COPY failed
('docker-copy-failed-not-found', @cat_id, 1,
 'Dockerfileのビルド時に「COPY failed: file not found in build context」というエラーが発生しました。原因として正しいものは？',
 '正解は「COPYで指定したファイルがビルドコンテキスト内に存在しない」です。docker buildはビルドコンテキスト（通常はDockerfileがあるディレクトリ）をDockerデーモンに送信し、COPY命令はそのコンテキスト内のファイルのみコピーできます。よくある原因として、ファイルパスのtypo、.dockerignoreで対象ファイルが除外されている、ビルドコンテキスト外のファイルを指定している（COPY ../file . は不可）などがあります。docker build -f でDockerfileの場所を変えた場合もコンテキストのルートに注意が必要です。'),

-- Q4: no space left on device
('docker-no-space-left-on-device', @cat_id, 1,
 'Dockerで「no space left on device」というエラーが発生しました。ディスク容量を回復するための最も効果的なコマンドは？',
 '正解は「docker system prune -a」です。Dockerは停止したコンテナ、未使用のネットワーク、タグなしイメージ（dangling images）、ビルドキャッシュなどを自動削除しません。docker system prune -aは未使用のイメージ・コンテナ・ネットワーク・ビルドキャッシュをまとめて削除します。ボリュームも含めて削除する場合は--volumesオプションを追加します。事前にdocker system dfで使用状況を確認できます。本番環境では定期的なクリーンアップをcronなどで自動化するのがベストプラクティスです。'),

-- Q5: exited with code 137
('docker-exited-code-137', @cat_id, 1,
 'Dockerコンテナが「exited with code 137」で突然停止しました。最も疑わしい原因は？',
 '正解は「メモリ不足（OOM: Out Of Memory）によりコンテナがkillされた」です。終了コード137はシグナル9（SIGKILL）を受けたことを意味し（128 + 9 = 137）、Linuxカーネルの OOM Killer がメモリを大量消費したコンテナを強制終了した場合に発生します。対処法としては、docker run時に--memoryオプションでメモリ制限を適切に設定する、docker-compose.ymlのdeploy.resources.limits.memoryで制限を指定する、またはアプリケーション側のメモリ使用量を最適化します。docker inspect でOOMKilledフラグを確認することで原因の特定ができます。'),

-- Q6: マルチステージビルド
('docker-multi-stage-build', @cat_id, 1,
 'Dockerのマルチステージビルドの主な目的は？',
 '正解は「最終イメージのサイズを削減すること」です。マルチステージビルドではDockerfile内で複数のFROM命令を使い、ビルド用ステージと実行用ステージを分離します。例えばNode.jsアプリでは、ビルドステージでnpm install && npm run buildを実行し、実行ステージではビルド成果物（distフォルダなど）だけをCOPY --from=builderでコピーします。これにより開発用依存パッケージやビルドツールが最終イメージに含まれず、イメージサイズが大幅に小さくなりセキュリティリスクも低減できます。'),

-- Q7: docker compose up vs docker-compose up
('docker-compose-v1-v2-difference', @cat_id, 1,
 '「docker-compose」コマンドと「docker compose」コマンドの違いは？',
 '正解は「docker-composeはV1（Python製の別バイナリ）、docker composeはV2（Docker CLIのプラグイン）」です。Docker Compose V1はPythonで書かれたスタンドアロンのバイナリ（docker-compose）でしたが、V2ではGoで書き直されDocker CLIのサブコマンド（docker compose）として統合されました。V1は2023年にサポート終了しており、現在はV2の使用が推奨されています。V2はdocker-compose.ymlとcompose.ymlの両方を認識し、profilesやwatchなどの新機能が追加されています。既存のCI/CDスクリプトを移行する際はハイフンをスペースに変更するだけで多くの場合対応できます。'),

-- Q8: .dockerignore
('docker-dockerignore-purpose', @cat_id, 1,
 'Dockerfileと同じディレクトリに.dockerignoreファイルを配置する主な目的は？',
 '正解は「ビルドコンテキストから不要なファイルを除外してビルドを高速化する」です。docker buildはビルドコンテキスト内の全ファイルをDockerデーモンに送信します。node_modules、.git、.envなどの大きいファイルや機密情報を.dockerignoreに記載することで、ビルドコンテキストの送信サイズが減りビルド速度が向上します。また、.envファイルや秘密鍵などが意図せずイメージに含まれることを防ぐセキュリティ上の効果もあります。.gitignoreと記法が同じなので直感的に使えます。'),

-- Q9: ENTRYPOINT vs CMD
('docker-entrypoint-vs-cmd', @cat_id, 1,
 'DockerfileのENTRYPOINTとCMDの違いについて正しいものは？',
 '正解は「ENTRYPOINTはコンテナ実行時に常に実行されるコマンド、CMDはデフォルト引数でdocker run時に上書き可能」です。ENTRYPOINTで指定したコマンドはdocker run時に引数を渡しても置き換わらず、CMDの値がデフォルト引数として使われます。例えばENTRYPOINT ["node"] CMD ["app.js"]と記述した場合、docker runの引数なしではnode app.jsが実行され、docker run myimage server.jsとするとnode server.jsが実行されます。両者を組み合わせることで柔軟なコンテナ設計が可能です。docker run --entrypointで上書きもできます。'),

-- Q10: ボリュームマウントのパーミッション
('docker-volume-permission-denied', @cat_id, 1,
 'Dockerでボリュームマウントしたディレクトリに書き込もうとしたところ「Permission denied」が発生しました。原因として正しいものは？',
 '正解は「コンテナ内のプロセスのUID/GIDとホスト側のファイル所有者が一致しない」です。Dockerコンテナはデフォルトでroot（UID 0）で実行されますが、セキュリティのためにDockerfileでUSER命令を使い非rootユーザーで実行するのがベストプラクティスです。その場合、マウントしたボリュームのファイル所有者がコンテナ内のユーザーと異なるとPermission deniedが発生します。対処法としては、Dockerfileでchownを実行する、docker run時に--user $(id -u):$(id -g)でホスト側のUID/GIDを指定する、またはentrypoint.shで起動時にパーミッションを調整する方法があります。');

-- 4. 選択肢の登録
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: Cannot connect to the Docker daemon
(@quiz_start + 0, 'Docker Desktop（またはDockerデーモン）を起動する', 1, 1),
(@quiz_start + 0, 'Dockerfileを修正して再ビルドする', 0, 2),
(@quiz_start + 0, 'docker.sockファイルを手動で作成する', 0, 3),
(@quiz_start + 0, 'コンテナを再起動する', 0, 4),
-- Q2: port is already allocated
(@quiz_start + 1, 'ホスト側のポートが既に別のプロセスで使用されている', 1, 1),
(@quiz_start + 1, 'コンテナ内部でポートが競合している', 0, 2),
(@quiz_start + 1, 'Dockerがネットワークを作成できない', 0, 3),
(@quiz_start + 1, 'ファイアウォールがポートをブロックしている', 0, 4),
-- Q3: COPY failed
(@quiz_start + 2, 'COPYで指定したファイルがビルドコンテキスト内に存在しない', 1, 1),
(@quiz_start + 2, 'コンテナ内のディスク容量が不足している', 0, 2),
(@quiz_start + 2, 'Dockerデーモンのバージョンが古い', 0, 3),
(@quiz_start + 2, 'COPYの代わりにADDを使う必要がある', 0, 4),
-- Q4: no space left on device
(@quiz_start + 3, 'docker system prune -a', 1, 1),
(@quiz_start + 3, 'docker restart', 0, 2),
(@quiz_start + 3, 'docker build --no-cache', 0, 3),
(@quiz_start + 3, 'docker compose down', 0, 4),
-- Q5: exited with code 137
(@quiz_start + 4, 'メモリ不足（OOM）によりコンテナがkillされた', 1, 1),
(@quiz_start + 4, 'プロセスが正常終了した', 0, 2),
(@quiz_start + 4, 'ネットワーク接続がタイムアウトした', 0, 3),
(@quiz_start + 4, 'Dockerfileの構文エラーが発生した', 0, 4),
-- Q6: マルチステージビルド
(@quiz_start + 5, '最終イメージのサイズを削減すること', 1, 1),
(@quiz_start + 5, 'ビルド速度を高速化すること', 0, 2),
(@quiz_start + 5, '複数のコンテナを同時にビルドすること', 0, 3),
(@quiz_start + 5, 'ビルドのセキュリティスキャンを実行すること', 0, 4),
-- Q7: docker compose V1 vs V2
(@quiz_start + 6, 'docker-composeはV1（Python製の別バイナリ）、docker composeはV2（CLIプラグイン）', 1, 1),
(@quiz_start + 6, '機能は同じだがdocker composeの方が新しいエイリアス', 0, 2),
(@quiz_start + 6, 'docker-composeはLinux用、docker composeはmacOS/Windows用', 0, 3),
(@quiz_start + 6, 'docker composeはDocker Swarmでのみ使用可能', 0, 4),
-- Q8: .dockerignore
(@quiz_start + 7, 'ビルドコンテキストから不要なファイルを除外してビルドを高速化する', 1, 1),
(@quiz_start + 7, 'コンテナ実行時に特定のファイルを非表示にする', 0, 2),
(@quiz_start + 7, 'Docker Hubへのプッシュ時に除外するファイルを指定する', 0, 3),
(@quiz_start + 7, 'docker composeで不要なサービスを無効化する', 0, 4),
-- Q9: ENTRYPOINT vs CMD
(@quiz_start + 8, 'ENTRYPOINTは常に実行、CMDはデフォルト引数でdocker run時に上書き可能', 1, 1),
(@quiz_start + 8, 'ENTRYPOINTはビルド時、CMDは実行時に使われる', 0, 2),
(@quiz_start + 8, 'ENTRYPOINTはLinux用、CMDはWindows用', 0, 3),
(@quiz_start + 8, '両者に違いはなく互換性がある', 0, 4),
-- Q10: Volume Permission denied
(@quiz_start + 9, 'コンテナ内プロセスのUID/GIDとホスト側のファイル所有者が一致しない', 1, 1),
(@quiz_start + 9, 'ボリュームのファイルシステムがDockerに対応していない', 0, 2),
(@quiz_start + 9, 'SELinuxまたはAppArmorのみが原因', 0, 3),
(@quiz_start + 9, 'docker runに--privilegedオプションが必須', 0, 4);
