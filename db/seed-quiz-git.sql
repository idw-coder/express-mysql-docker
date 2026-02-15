-- Git基礎・エラー解決クイズ シードデータ（動的ID対応・選択肢シャッフル版）
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-git.sql

SET NAMES utf8mb4;

-- --------------------------------------------------------
-- 1. カテゴリIDを動的に決定して登録
-- --------------------------------------------------------

-- 既存の 'git-basic' があればそのIDを、なければ MAX(id)+1 を @cat_id にセット
SET @target_slug = 'git-basic';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;

-- まだ存在しない場合、新しいIDを発番
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

-- カテゴリを登録
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'Gitマスター', 1, 'バージョン管理システムGitの基本コマンドから、現場で頻発するエラーの解決方法までを網羅したクイズです。', @cat_id);


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
-- 1-10: Git Errors (よくあるエラー)
('git-error-detached-head', @cat_id, 1, '「You are in ''detached HEAD'' state」というメッセージが表示されました。これはどのような状態ですか？', '正解は「特定のブランチではなく、直接コミットを参照している状態」です。この状態でコミットを行うと、ブランチに属さない「孤立したコミット」になり、後で参照するのが難しくなります。解消するには `git checkout <branch-name>` や `git switch <branch-name>` で既存ブランチに戻るか、その場から新しいブランチを作成します。'),
('git-error-non-fast-forward', @cat_id, 1, 'プッシュ時に「error: failed to push some refs to ... (non-fast-forward)」というエラーが出ました。原因として最も可能性が高いのは？', '正解は「リモートリポジトリに、ローカルにはない新しいコミットが含まれている」ことです。他の人が先にプッシュした場合などに発生します。解決するには、まず `git pull` してリモートの変更を取り込む（マージまたはリベースする）必要があります。'),
('git-error-merge-conflict', @cat_id, 1, 'マージ中に「CONFLICT (content): Merge conflict in ...」と表示されました。Gitはどういう状態になりますか？', '正解は「マージ処理を中断し、ユーザーによる手動解決を待機する状態」になります。競合したファイルには `<<<<<<<`, `=======`, `>>>>>>>` というマーカーが挿入されます。ファイルを編集して競合を解消し、`git add` してから `git commit` することでマージを完了できます。'),
('git-error-unrelated-histories', @cat_id, 1, '「fatal: refusing to merge unrelated histories」というエラーは、どのような時に発生しやすいですか？', '正解は「履歴の繋がりが全くない2つのリポジトリをマージしようとした時」です。例えば、ローカルで新規作成したリポジトリと、GitHubで初期化（README作成など）したリポジトリをマージする場合などです。`--allow-unrelated-histories` オプションを付けることで強制的にマージできます。'),
('git-error-overwrite-checkout', @cat_id, 1, 'ブランチ切り替え時に「error: Your local changes to the following files would be overwritten by checkout」と出ました。どうすべきですか？', '正解は「変更をコミットするか、スタッシュ（退避）する」です。現在の作業ディレクトリにある未コミットの変更が、切り替え先のブランチの内容と衝突しています。作業を消したくない場合は `git stash` で一時的に退避するのが一般的です。'),
('git-error-pathspec-match', @cat_id, 1, '「error: pathspec ''filename'' did not match any file(s) known to git」というエラーが出ました。考えられる原因は？', '正解は「指定したファイルがGitの管理下にない（トラックされていない）か、ファイル名が間違っている」です。まだ `git add` していないファイルを操作しようとしたり、存在しないパスを指定したりした場合に発生します。'),
('git-error-remote-origin-exists', @cat_id, 1, '「fatal: remote origin already exists.」というエラーが出ました。これはどういう意味ですか？', '正解は「''origin'' という名前のリモートリポジトリが既に設定されている」という意味です。リポジトリのURLを変更したい場合は、`git remote add` ではなく `git remote set-url origin <new-url>` を使うか、一度 `git remote rm origin` で削除してから追加します。'),
('git-error-ssl-certificate', @cat_id, 1, '「SSL certificate problem: self signed certificate」などのSSLエラーが出た場合、一時的な回避策として使える設定は？', '正解は `git config http.sslVerify false` です。ただし、これはセキュリティ検証を無効にする設定であるため、信頼できるネットワーク内や一時的な解決策としてのみ使用し、恒久的には正しい証明書を配置するべきです。'),
('git-error-index-lock', @cat_id, 1, '「fatal: Unable to create ''.../.git/index.lock'': File exists.」というエラーが出ました。原因として考えられるのは？', '正解は「別のGitプロセスが実行中であるか、前のプロセスが異常終了してロックファイルが残っている」ことです。Gitの操作中は排他制御のために `index.lock` ファイルが作成されます。プロセスが動いていないことを確認してから、このロックファイルを手動で削除すれば解決します。'),
('git-error-permission-denied', @cat_id, 1, 'SSHでクローンしようとして「Permission denied (publickey).」と出ました。まず確認すべきことは？', '正解は「SSH公開鍵がリモート（GitHub等）に登録されているか、秘密鍵が手元にあるか」です。HTTPSのパスワード認証エラーとは異なり、SSHキーペアの設定不備が原因です。`ssh-keygen` で鍵を作成し、公開鍵をサービス側に登録する必要があります。'),

-- 11-50: General Git Questions
('git-init', @cat_id, 1, 'ディレクトリをGitリポジトリとして初期化するコマンドは？', '正解は `git init` です。これにより、カレントディレクトリに `.git` という隠しディレクトリが作成され、バージョン管理が可能になります。'),
('git-clone', @cat_id, 1, 'リモートリポジトリをローカルに複製するコマンドは？', '正解は `git clone` です。リポジトリの全履歴を含めてダウンロードし、自動的に `origin` というリモート名が設定されます。'),
('git-add-all', @cat_id, 1, '変更された全てのファイル（新規・削除含む）をステージングエリアに追加するコマンドは？', '正解は `git add .` または `git add -A` です。特定のファイルのみ追加したい場合はファイルパスを指定します。'),
('git-commit-message', @cat_id, 1, 'エディタを立ち上げずに、メッセージ付きでコミットするコマンドは？', '正解は `git commit -m "メッセージ"` です。簡潔な変更内容を記録する場合によく使われます。'),
('git-status', @cat_id, 1, '現在の作業ツリーの状態（変更されたファイルやステージング状況）を確認するコマンドは？', '正解は `git status` です。どのファイルが変更され、どのファイルがコミット準備完了（ステージ済み）かを確認できます。'),
('git-log-oneline', @cat_id, 1, 'コミット履歴を1行ずつ簡潔に表示するコマンドオプションは？', '正解は `git log --oneline` です。コミットハッシュ（短縮版）とメッセージのみが表示され、履歴の全体像を把握しやすくなります。'),
('git-diff-staged', @cat_id, 1, 'ステージングエリアに追加された変更（次回のコミットに含まれる変更）を確認するコマンドは？', '正解は `git diff --staged` または `git diff --cached` です。単なる `git diff` は、まだステージングされていない作業ディレクトリの変更を表示します。'),
('git-branch-create', @cat_id, 1, '新しいブランチを作成するだけ（切り替えはしない）のコマンドは？', '正解は `git branch <branch-name>` です。作成と同時に切り替えるには `git checkout -b <branch-name>` や `git switch -c <branch-name>` を使います。'),
('git-checkout-b', @cat_id, 1, 'ブランチを作成して、同時にそのブランチに切り替えるコマンドは？', '正解は `git checkout -b <new-branch>` です。Git 2.23以降では `git switch -c <new-branch>` も推奨されています。'),
('git-merge-no-ff', @cat_id, 1, 'マージコミットを必ず作成してマージの履歴を残す（ファストフォワードしない）オプションは？', '正解は `--no-ff` です。`git merge --no-ff <branch>` とすることで、マージしたという事実が履歴上のノードとして明示的に残ります。'),
('git-remote-v', @cat_id, 1, '登録されているリモートリポジトリの一覧とURLを確認するコマンドは？', '正解は `git remote -v` です。fetch用とpush用のURLが表示されます。'),
('git-fetch-vs-pull', @cat_id, 1, '`git fetch` と `git pull` の違いは？', '正解は「fetchはリモートの変更を取得するだけ、pullは取得して現在のブランチにマージする」ことです。`pull` は実質的に `fetch` + `merge` を行います。'),
('git-reset-soft', @cat_id, 1, '直前のコミットを取り消すが、変更内容はステージングエリアに残す（addされた状態にする）コマンドは？', '正解は `git reset --soft HEAD^` です。コミットメッセージを修正したい場合や、複数のコミットをまとめたい場合の前準備として使われます。'),
('git-reset-hard', @cat_id, 1, '作業ディレクトリの変更を含めて、全ての変更を破棄して特定のコミットの状態に戻すコマンドは？', '正解は `git reset --hard` です。未コミットの変更も完全に消えてしまうため、使用には注意が必要です。'),
('git-revert', @cat_id, 1, '過去のコミットを打ち消すような「新しいコミット」を作成して変更を元に戻すコマンドは？', '正解は `git revert` です。`reset` と異なり履歴を改変しないため、既に共有されているリモートブランチの変更を取り消す場合に安全です。'),
('git-stash', @cat_id, 1, '作業中の変更を一時的に退避させ、作業ディレクトリをクリーンにするコマンドは？', '正解は `git stash` です。別のブランチで急な修正が必要になった場合などに便利です。退避した変更を戻すには `git stash pop` を使います。'),
('git-gitignore', @cat_id, 1, 'Gitの管理対象から除外したいファイル指定する設定ファイルの名前は？', '正解は `.gitignore` です。ログファイル、ビルド生成物、OSの設定ファイル（.DS_Storeなど）を記述します。'),
('git-tag', @cat_id, 1, 'リリースポイントなど、特定のコミットに名前（タグ）を付けるコマンドは？', '正解は `git tag` です。注釈付きタグ（annotated tag）を作成する場合は `git tag -a v1.0 -m "message"` のようにします。'),
('git-rebase', @cat_id, 1, 'ブランチの派生元（ベース）を変更し、履歴を一直線に整えるコマンドは？', '正解は `git rebase` です。マージコミットを作らずに履歴を綺麗に保てますが、既にpush済みのコミットに対して行うと他人の環境を壊す恐れがあるため注意が必要です。'),
('git-cherry-pick', @cat_id, 1, '別のブランチにある「特定のコミットだけ」を現在のブランチに取り込むコマンドは？', '正解は `git cherry-pick <commit-hash>` です。バグ修正のコミットだけを別のブランチに適用したい場合などに使います。'),
('git-config-global', @cat_id, 1, 'ユーザー名やメールアドレスをPC全体（全リポジトリ共通）で設定するコマンドオプションは？', '正解は `--global` です。`git config --global user.name "Name"` のように使います。設定はホームディレクトリの `.gitconfig` ファイルに保存されます。'),
('git-blame', @cat_id, 1, 'ファイルの各行が「誰によって」「いつ」変更されたかを表示するコマンドは？', '正解は `git blame <filename>` です。バグの原因となった変更を特定したり、コードの意図を確認したりする際に役立ちます。'),
('git-show', @cat_id, 1, '特定のコミットの詳細情報（変更内容の差分など）を表示するコマンドは？', '正解は `git show <commit-hash>` です。引数を省略すると、最新のコミット（HEAD）の情報が表示されます。'),
('git-rm-cached', @cat_id, 1, 'ファイルを物理的に削除せず、Gitの管理対象からのみ外す（ステージングから削除する）コマンドは？', '正解は `git rm --cached <file>` です。誤ってコミットしてしまった設定ファイルなどを、ファイル自体は残したまま管理から外す場合に使います。'),
('git-clean', @cat_id, 1, '追跡されていない（untracked）ファイルを一括削除するコマンドは？', '正解は `git clean` です。`git clean -fd` （強制的にディレクトリも含めて削除）というオプションがよく使われます。取り消しが効かないため注意が必要です。'),
('git-reflog', @cat_id, 1, '`git log` には表示されない、リセットや誤操作で失われたコミット履歴も含めて操作ログを表示するコマンドは？', '正解は `git reflog` です。`git reset --hard` で消してしまったコミットを復元したい場合、ここからハッシュを探して戻すことができます。'),
('git-push-force', @cat_id, 1, 'リモートリポジトリの履歴をローカルの内容で強制的に上書きする（危険な）オプションは？', '正解は `--force` または `-f` です。rebaseなどで履歴を改変した後に使いますが、チーム開発では原則禁止または慎重に扱うべき操作です。より安全な `--force-with-lease` もあります。'),
('git-head-caret', @cat_id, 1, '「HEAD^」は何を指しますか？', '正解は「現在のコミットの1つ前のコミット（親コミット）」です。`HEAD^^` や `HEAD~2` は2つ前を指します。'),
('git-amend', @cat_id, 1, '直前のコミット内容やメッセージを修正して上書きするコマンドオプションは？', '正解は `git commit --amend` です。コミットし忘れたファイルを追加したり、タイプミスしたメッセージを直すのに便利です。'),
('git-restore', @cat_id, 1, 'Git 2.23で導入された、作業ディレクトリの変更を取り消したりステージングを解除したりするコマンドは？', '正解は `git restore` です。従来の `git checkout` や `git reset` の役割の一部を、より直感的な名前で分離したものです。'),
('git-switch', @cat_id, 1, 'Git 2.23で導入された、ブランチの切り替えに特化したコマンドは？', '正解は `git switch` です。`git checkout` は「ファイルの復元」と「ブランチ切り替え」の両方の機能を持っていたため、分離されました。'),
('git-submodule', @cat_id, 1, '別のGitリポジトリを、現在のリポジトリのサブディレクトリとして埋め込んで管理する機能は？', '正解はサブモジュール（Submodule）です。`git submodule add <url>` で追加します。外部ライブラリをプロジェクトに取り込む際などに利用されます。'),
('git-bisect', @cat_id, 1, 'バグが混入したコミットを特定するために、二分探索を行うコマンドは？', '正解は `git bisect` です。正常だったコミットとバグがあるコミットを指定すると、その間のコミットを順次チェックアウトし、効率的に問題箇所を特定できます。'),
('git-hooks', @cat_id, 1, 'コミットやプッシュなどの特定のアクションの前後に、スクリプトを自動実行する仕組みは？', '正解はGitフック（Hooks）です。`.git/hooks` ディレクトリ内のスクリプトにより、コミットメッセージのチェックやテストの自動実行などが可能です。'),
('git-alias', @cat_id, 1, '長いコマンドを短縮して呼び出せるように設定する機能は？', '正解はエイリアス（Alias）です。`git config --global alias.co checkout` と設定すれば、以降 `git co` でチェックアウトが可能になります。'),
('git-bare-repo', @cat_id, 1, '作業ディレクトリを持たず、管理情報（.gitの中身）のみを持つリポジトリを何と呼ぶか？', '正解はベアリポジトリ（Bare repository）です。慣例としてディレクトリ名に `.git` を付けます（例: `project.git`）。主にサーバー側の共有リポジトリとして使用されます。'),
('git-tree-ish', @cat_id, 1, 'Gitにおいて、コミット、タグ、ブランチ名など、特定の「状態」や「履歴」を指し示す識別子の総称は？', '正解はツリーイッシュ（Tree-ish）です。多くのGitコマンドは、引数としてコミットハッシュだけでなく、ブランチ名やタグ名、`HEAD~1` などを柔軟に受け取ることができます。'),
('git-upstream', @cat_id, 1, 'ローカルブランチが追跡しているリモートブランチのことを何と呼ぶか？', '正解はアップストリーム（Upstream）ブランチです。`git push -u origin main` の `-u` は `--set-upstream` の略で、次回以降引数なしで `git push` できるように紐付けを行います。'),
('git-lfs', @cat_id, 1, '画像や音声などの巨大なバイナリファイルを効率的にGitで管理するための拡張機能は？', '正解はGit LFS (Large File Storage) です。実体は別のストレージに保存し、Gitリポジトリにはポインタファイルのみを保存することで、リポジトリの肥大化を防ぎます。'),
('git-worktree', @cat_id, 1, '1つのリポジトリで、複数のブランチを同時に別のディレクトリにチェックアウトして作業できる機能は？', '正解は `git worktree` です。`git worktree add` を使うと、現在の作業ディレクトリを切り替えることなく、別のフォルダで別のブランチの作業やビルドを並行して行えます。');


-- --------------------------------------------------------
-- 4. 選択肢の登録（ランダムシャッフル版）
-- --------------------------------------------------------

INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: detached HEAD
(@quiz_start + 0, '特定のブランチではなく、直接コミットを参照している状態', 1, 1),
(@quiz_start + 0, 'リモートリポジトリとの接続が切断された状態', 0, 2),
(@quiz_start + 0, 'HEADポインタが破損している状態', 0, 3),
(@quiz_start + 0, 'まだ一度もコミットしていない初期状態', 0, 4),

-- Q2: non-fast-forward
(@quiz_start + 1, 'あなたの権限が不足しています', 0, 1),
(@quiz_start + 1, 'リモートリポジトリがダウンしています', 0, 2),
(@quiz_start + 1, 'リモートリポジトリに、ローカルにはない新しいコミットが含まれている', 1, 3),
(@quiz_start + 1, 'プッシュしようとしているファイルサイズが大きすぎます', 0, 4),

-- Q3: merge conflict
(@quiz_start + 2, 'マージが自動的に完了し、履歴が保存される', 0, 1),
(@quiz_start + 2, 'マージ処理を中断し、ユーザーによる手動解決を待機する状態', 1, 2),
(@quiz_start + 2, 'マージが失敗し、直前の状態に自動的にロールバックされる', 0, 3),
(@quiz_start + 2, '競合したファイルが自動的に削除される', 0, 4),

-- Q4: unrelated histories
(@quiz_start + 3, '履歴の繋がりが全くない2つのリポジトリをマージしようとした時', 1, 1),
(@quiz_start + 3, '同じファイルを同時に編集した時', 0, 2),
(@quiz_start + 3, 'リモートリポジトリが見つからない時', 0, 3),
(@quiz_start + 3, 'バイナリファイルをマージしようとした時', 0, 4),

-- Q5: overwrite checkout
(@quiz_start + 4, '強制的にブランチを切り替える', 0, 1),
(@quiz_start + 4, 'Gitを再インストールする', 0, 2),
(@quiz_start + 4, 'リモートリポジトリを削除する', 0, 3),
(@quiz_start + 4, '変更をコミットするか、スタッシュ（退避）する', 1, 4),

-- Q6: pathspec error
(@quiz_start + 5, '指定したファイルがGitの管理下にないか、ファイル名が間違っている', 1, 1),
(@quiz_start + 5, 'ファイルがロックされている', 0, 2),
(@quiz_start + 5, 'ディスク容量が不足している', 0, 3),
(@quiz_start + 5, 'ファイルパスが長すぎる', 0, 4),

-- Q7: remote origin exists
(@quiz_start + 6, 'リモートリポジトリが削除された', 0, 1),
(@quiz_start + 6, 'インターネット接続がない', 0, 2),
(@quiz_start + 6, 'origin という名前のリモートリポジトリが既に設定されている', 1, 3),
(@quiz_start + 6, 'GitHubのサーバーが混雑している', 0, 4),

-- Q8: SSL error
(@quiz_start + 7, 'git config http.sslVerify false', 1, 1),
(@quiz_start + 7, 'git config --global user.name "admin"', 0, 2),
(@quiz_start + 7, 'git remote set-url origin https://...', 0, 3),
(@quiz_start + 7, 'git clean -fd', 0, 4),

-- Q9: index.lock
(@quiz_start + 8, 'リポジトリが読み取り専用になっている', 0, 1),
(@quiz_start + 8, '別のGitプロセスが実行中か、ロックファイルが残っている', 1, 2),
(@quiz_start + 8, 'ファイルシステムが破損している', 0, 3),
(@quiz_start + 8, 'Gitのバージョンが古い', 0, 4),

-- Q10: permission denied
(@quiz_start + 9, 'パスワードが間違っている', 0, 1),
(@quiz_start + 9, 'SSH公開鍵がリモートに登録されているか、秘密鍵があるか確認する', 1, 2),
(@quiz_start + 9, 'リポジトリのURLをHTTPSに変更する', 0, 3),
(@quiz_start + 9, 'ファイアウォールの設定を確認する', 0, 4),

-- Q11: init
(@quiz_start + 10, 'git start', 0, 1),
(@quiz_start + 10, 'git create', 0, 2),
(@quiz_start + 10, 'git new', 0, 3),
(@quiz_start + 10, 'git init', 1, 4),

-- Q12: clone
(@quiz_start + 11, 'git copy', 0, 1),
(@quiz_start + 11, 'git clone', 1, 2),
(@quiz_start + 11, 'git download', 0, 3),
(@quiz_start + 11, 'git mirror', 0, 4),

-- Q13: add all
(@quiz_start + 12, 'git add .', 1, 1),
(@quiz_start + 12, 'git commit -a', 0, 2),
(@quiz_start + 12, 'git stage all', 0, 3),
(@quiz_start + 12, 'git include *', 0, 4),

-- Q14: commit -m
(@quiz_start + 13, 'git commit -m "..."', 1, 1),
(@quiz_start + 13, 'git save "..."', 0, 2),
(@quiz_start + 13, 'git log "..."', 0, 3),
(@quiz_start + 13, 'git push "..."', 0, 4),

-- Q15: status
(@quiz_start + 14, 'git info', 0, 1),
(@quiz_start + 14, 'git check', 0, 2),
(@quiz_start + 14, 'git status', 1, 3),
(@quiz_start + 14, 'git state', 0, 4),

-- Q16: log oneline
(@quiz_start + 15, 'git history --short', 0, 1),
(@quiz_start + 15, 'git log --oneline', 1, 2),
(@quiz_start + 15, 'git show --summary', 0, 3),
(@quiz_start + 15, 'git list --simple', 0, 4),

-- Q17: diff staged
(@quiz_start + 16, 'git diff --staged', 1, 1),
(@quiz_start + 16, 'git diff --all', 0, 2),
(@quiz_start + 16, 'git status --diff', 0, 3),
(@quiz_start + 16, 'git show --staged', 0, 4),

-- Q18: branch create
(@quiz_start + 17, 'git checkout <name>', 0, 1),
(@quiz_start + 17, 'git new-branch <name>', 0, 2),
(@quiz_start + 17, 'git branch <name>', 1, 3),
(@quiz_start + 17, 'git add <name>', 0, 4),

-- Q19: checkout -b
(@quiz_start + 18, 'git branch -c', 0, 1),
(@quiz_start + 18, 'git checkout -b', 1, 2),
(@quiz_start + 18, 'git switch -b', 0, 3),
(@quiz_start + 18, 'git create -b', 0, 4),

-- Q20: merge no-ff
(@quiz_start + 19, '--no-commit', 0, 1),
(@quiz_start + 19, '--squash', 0, 2),
(@quiz_start + 19, '--rebase', 0, 3),
(@quiz_start + 19, '--no-ff', 1, 4),

-- Q21: remote -v
(@quiz_start + 20, 'git remote -v', 1, 1),
(@quiz_start + 20, 'git remote list', 0, 2),
(@quiz_start + 20, 'git config --list', 0, 3),
(@quiz_start + 20, 'git remote show', 0, 4),

-- Q22: fetch vs pull
(@quiz_start + 21, 'fetchはローカルを変更し、pullはリモートを変更する', 0, 1),
(@quiz_start + 21, 'fetchは取得のみ、pullは取得してマージする', 1, 2),
(@quiz_start + 21, '全く同じ機能の別名である', 0, 3),
(@quiz_start + 21, 'pullはSVN用のコマンドである', 0, 4),

-- Q23: reset soft
(@quiz_start + 22, 'git reset --soft', 1, 1),
(@quiz_start + 22, 'git reset --mixed', 0, 2),
(@quiz_start + 22, 'git reset --hard', 0, 3),
(@quiz_start + 22, 'git revert', 0, 4),

-- Q24: reset hard
(@quiz_start + 23, 'git clean -f', 0, 1),
(@quiz_start + 23, 'git checkout .', 0, 2),
(@quiz_start + 23, 'git reset --hard', 1, 3),
(@quiz_start + 23, 'git rm -rf', 0, 4),

-- Q25: revert
(@quiz_start + 24, 'git revert', 1, 1),
(@quiz_start + 24, 'git undo', 0, 2),
(@quiz_start + 24, 'git rollback', 0, 3),
(@quiz_start + 24, 'git return', 0, 4),

-- Q26: stash
(@quiz_start + 25, 'git stash', 1, 1),
(@quiz_start + 25, 'git hide', 0, 2),
(@quiz_start + 25, 'git archive', 0, 3),
(@quiz_start + 25, 'git store', 0, 4),

-- Q27: gitignore
(@quiz_start + 26, '.gitconfig', 0, 1),
(@quiz_start + 26, '.gitignore', 1, 2),
(@quiz_start + 26, '.gitmodules', 0, 3),
(@quiz_start + 26, '.gitkeep', 0, 4),

-- Q28: tag
(@quiz_start + 27, 'git label', 0, 1),
(@quiz_start + 27, 'git mark', 0, 2),
(@quiz_start + 27, 'git tag', 1, 3),
(@quiz_start + 27, 'git version', 0, 4),

-- Q29: rebase
(@quiz_start + 28, 'git rebase', 1, 1),
(@quiz_start + 28, 'git align', 0, 2),
(@quiz_start + 28, 'git organize', 0, 3),
(@quiz_start + 28, 'git restructure', 0, 4),

-- Q30: cherry-pick
(@quiz_start + 29, 'git cherry-pick', 1, 1),
(@quiz_start + 29, 'git pick', 0, 2),
(@quiz_start + 29, 'git select', 0, 3),
(@quiz_start + 29, 'git grab', 0, 4),

-- Q31: config global
(@quiz_start + 30, '--local', 0, 1),
(@quiz_start + 30, '--system', 0, 2),
(@quiz_start + 30, '--global', 1, 3),
(@quiz_start + 30, '--root', 0, 4),

-- Q32: blame
(@quiz_start + 31, 'git who', 0, 1),
(@quiz_start + 31, 'git blame', 1, 2),
(@quiz_start + 31, 'git author', 0, 3),
(@quiz_start + 31, 'git investigate', 0, 4),

-- Q33: show
(@quiz_start + 32, 'git show', 1, 1),
(@quiz_start + 32, 'git detail', 0, 2),
(@quiz_start + 32, 'git display', 0, 3),
(@quiz_start + 32, 'git view', 0, 4),

-- Q34: rm cached
(@quiz_start + 33, 'git rm --cached', 1, 1),
(@quiz_start + 33, 'git delete --soft', 0, 2),
(@quiz_start + 33, 'git remove --keep', 0, 3),
(@quiz_start + 33, 'git untrack', 0, 4),

-- Q35: clean
(@quiz_start + 34, 'git clean', 1, 1),
(@quiz_start + 34, 'git purge', 0, 2),
(@quiz_start + 34, 'git sweep', 0, 3),
(@quiz_start + 34, 'git clear', 0, 4),

-- Q36: reflog
(@quiz_start + 35, 'git log --all', 0, 1),
(@quiz_start + 35, 'git history', 0, 2),
(@quiz_start + 35, 'git reflog', 1, 3),
(@quiz_start + 35, 'git operations', 0, 4),

-- Q37: push force
(@quiz_start + 36, '--hard', 0, 1),
(@quiz_start + 36, '--overwrite', 0, 2),
(@quiz_start + 36, '--force', 1, 3),
(@quiz_start + 36, '--danger', 0, 4),

-- Q38: HEAD caret
(@quiz_start + 37, '現在のコミットの1つ前', 1, 1),
(@quiz_start + 37, '現在のコミットの1つ後', 0, 2),
(@quiz_start + 37, '最初のコミット', 0, 3),
(@quiz_start + 37, 'リモートの最新コミット', 0, 4),

-- Q39: amend
(@quiz_start + 38, 'git commit --amend', 1, 1),
(@quiz_start + 38, 'git commit --fix', 0, 2),
(@quiz_start + 38, 'git commit --retry', 0, 3),
(@quiz_start + 38, 'git commit --update', 0, 4),

-- Q40: restore
(@quiz_start + 39, 'git restore', 1, 1),
(@quiz_start + 39, 'git undo-change', 0, 2),
(@quiz_start + 39, 'git recover', 0, 3),
(@quiz_start + 39, 'git back', 0, 4),

-- Q41: switch
(@quiz_start + 40, 'git change', 0, 1),
(@quiz_start + 40, 'git move', 0, 2),
(@quiz_start + 40, 'git switch', 1, 3),
(@quiz_start + 40, 'git jump', 0, 4),

-- Q42: submodule
(@quiz_start + 41, 'サブモジュール', 1, 1),
(@quiz_start + 41, 'サブパッケージ', 0, 2),
(@quiz_start + 41, 'マイクロサービス', 0, 3),
(@quiz_start + 41, 'コンポーネント', 0, 4),

-- Q43: bisect
(@quiz_start + 42, 'git search', 0, 1),
(@quiz_start + 42, 'git debug', 0, 2),
(@quiz_start + 42, 'git bisect', 1, 3),
(@quiz_start + 42, 'git find', 0, 4),

-- Q44: hooks
(@quiz_start + 43, 'Triggers', 0, 1),
(@quiz_start + 43, 'Hooks', 1, 2),
(@quiz_start + 43, 'Actions', 0, 3),
(@quiz_start + 43, 'Events', 0, 4),

-- Q45: alias
(@quiz_start + 44, 'ショートカット', 0, 1),
(@quiz_start + 44, 'リンク', 0, 2),
(@quiz_start + 44, 'エイリアス', 1, 3),
(@quiz_start + 44, 'スニペット', 0, 4),

-- Q46: bare repo
(@quiz_start + 45, 'エンプティリポジトリ', 0, 1),
(@quiz_start + 45, 'ベアリポジトリ', 1, 2),
(@quiz_start + 45, 'ネイキッドリポジトリ', 0, 3),
(@quiz_start + 45, 'コアリポジトリ', 0, 4),

-- Q47: tree-ish
(@quiz_start + 46, 'コミットイッシュ', 0, 1),
(@quiz_start + 46, 'リファレンス', 0, 2),
(@quiz_start + 46, 'ツリーイッシュ', 1, 3),
(@quiz_start + 46, 'ポインタ', 0, 4),

-- Q48: upstream
(@quiz_start + 47, 'ダウンストリーム', 0, 1),
(@quiz_start + 47, 'アップストリーム', 1, 2),
(@quiz_start + 47, 'オリジンブランチ', 0, 3),
(@quiz_start + 47, 'マスターストリーム', 0, 4),

-- Q49: lfs
(@quiz_start + 48, 'Git Large File Storage (LFS)', 1, 1),
(@quiz_start + 48, 'Git Big Data', 0, 2),
(@quiz_start + 48, 'Git Binary Store', 0, 3),
(@quiz_start + 48, 'Git Media Extension', 0, 4),

-- Q50: worktree
(@quiz_start + 49, 'git workspace', 0, 1),
(@quiz_start + 49, 'git multitask', 0, 2),
(@quiz_start + 49, 'git worktree', 1, 3),
(@quiz_start + 49, 'git parallel', 0, 4);