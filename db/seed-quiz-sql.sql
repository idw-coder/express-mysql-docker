-- SQL基礎クイズ シードデータ
-- 実行例（プロジェクトルートで）: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-sql.sql
-- SQLカテゴリのクイズデータだけを入れ直します（author_id=1 を想定）

SET NAMES utf8mb4;

-- カテゴリIDを動的に決定して登録
SET @target_slug = 'sql-basic';
SET @cat_id = NULL;
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug LIMIT 1;
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'SQL基礎・実践', 1, 'SQLの基本文法、JOIN、集計、トランザクション、設計に関する問題です。', @cat_id);

-- 既存のSQLカテゴリのクイズだけ削除して再投入
DELETE qc
FROM quiz_choice qc
INNER JOIN quiz q ON q.id = qc.quiz_id
WHERE q.category_id = @cat_id;

DELETE FROM quiz
WHERE category_id = @cat_id;

-- クイズIDの採番開始位置を決定
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- クイズ本体
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('sql-select-basic', @cat_id, 1,
 'テーブルからデータを取得するために使用するSQL文は？',
 '正解はSELECTです。SELECT文はテーブルから列や行を取得するための基本的な命令です。INSERTは追加、UPDATEは更新、DELETEは削除に使用します。'),

('sql-where-filter', @cat_id, 1,
 '取得する行を条件で絞り込むために使用する句は？',
 '正解はWHERE句です。WHERE句はSELECT、UPDATE、DELETEなどで対象行を条件により絞り込みます。ORDER BYは並び替え、GROUP BYは集計単位の指定、JOINはテーブル結合に使用します。'),

('sql-order-by', @cat_id, 1,
 '検索結果を並び替えるために使用する句は？',
 '正解はORDER BY句です。ORDER BY column ASCで昇順、ORDER BY column DESCで降順に並び替えます。WHERE句は絞り込み、GROUP BY句はグループ化に使用します。'),

('sql-insert-basic', @cat_id, 1,
 'テーブルに新しい行を追加するSQL文は？',
 '正解はINSERTです。INSERT INTO table_name (column1, column2) VALUES (value1, value2) のように使用します。SELECTは取得、UPDATEは更新、DELETEは削除です。'),

('sql-update-basic', @cat_id, 1,
 '既存の行の値を変更するSQL文は？',
 '正解はUPDATEです。UPDATE table_name SET column = value WHERE condition のように使用します。WHERE句を忘れると全行が更新される可能性があるため注意が必要です。'),

('sql-delete-basic', @cat_id, 1,
 'テーブルから行を削除するSQL文は？',
 '正解はDELETEです。DELETE FROM table_name WHERE condition のように使用します。WHERE句を省略すると全行が削除対象になるため、実行前に条件を必ず確認します。'),

('sql-primary-key', @cat_id, 1,
 'テーブル内の各行を一意に識別するためのキーは？',
 '正解はPRIMARY KEYです。主キーは重複を許さず、通常はNULLも許可されません。行を一意に特定するため、外部キーから参照されることも多いです。'),

('sql-foreign-key', @cat_id, 1,
 '別テーブルの主キーなどを参照し、テーブル間の整合性を保つ制約は？',
 '正解はFOREIGN KEYです。外部キー制約により、存在しない親データを参照する行の登録を防ぎ、リレーションの整合性を保てます。'),

('sql-inner-join', @cat_id, 1,
 '2つのテーブルで条件に一致する行だけを結合して取得するJOINは？',
 '正解はINNER JOINです。INNER JOINは結合条件に一致する行のみを返します。一方、LEFT JOINは左側テーブルの行を基準に、一致しない場合もNULLを補って返します。'),

('sql-left-join', @cat_id, 1,
 '左側テーブルの行をすべて残し、右側に一致しない場合はNULLを返すJOINは？',
 '正解はLEFT JOINです。左側テーブルのデータを必ず表示したい場合に使用します。例えばユーザー一覧に、存在する場合だけ注文情報を付けるようなケースで便利です。'),

('sql-group-by', @cat_id, 1,
 '集計関数をカテゴリや日付などの単位ごとに計算するために使用する句は？',
 '正解はGROUP BY句です。COUNT、SUM、AVGなどの集計関数と組み合わせ、指定した列ごとに集計できます。WHERE句はグループ化前の行の絞り込みに使います。'),

('sql-having', @cat_id, 1,
 'GROUP BYで集計した結果に対して条件を指定する句は？',
 '正解はHAVING句です。WHERE句は集計前の行を絞り込み、HAVING句はCOUNTやSUMなどで集計した後の結果を絞り込みます。'),

('sql-count-function', @cat_id, 1,
 '行数を数えるために使用する集計関数は？',
 '正解はCOUNTです。COUNT(*)は条件に一致した行数を数え、COUNT(column)は指定列がNULLでない行数を数えます。SUMは合計、AVGは平均を求めます。'),

('sql-distinct', @cat_id, 1,
 'SELECT結果から重複する行を取り除くために使用するキーワードは？',
 '正解はDISTINCTです。SELECT DISTINCT column FROM table のように使用し、指定した列の組み合わせが重複する行を1つにまとめます。'),

('sql-like', @cat_id, 1,
 '文字列の部分一致検索で使用する演算子は？',
 '正解はLIKEです。LIKE "%abc%" はabcを含む文字列、LIKE "abc%" はabcで始まる文字列を検索します。ワイルドカードには%や_を使用します。'),

('sql-null-check', @cat_id, 1,
 'NULLの値を判定する正しい条件式は？',
 '正解はIS NULLです。NULLは値が存在しないことを表すため、= NULLでは正しく判定できません。NULLでないことを確認する場合はIS NOT NULLを使用します。'),

('sql-index-purpose', @cat_id, 1,
 'インデックスを作成する主な目的は？',
 '正解は検索や結合の高速化です。インデックスは条件検索やJOIN、ORDER BYを効率化できます。ただし、INSERTやUPDATE時にはインデックス更新のコストが増えるため、必要な列に絞って作成します。'),

('sql-transaction', @cat_id, 1,
 '複数のSQL操作をひとまとまりとして扱い、成功時だけ確定する仕組みは？',
 '正解はトランザクションです。BEGINやSTART TRANSACTIONで開始し、COMMITで確定、ROLLBACKで取り消します。送金処理のように複数操作の整合性が重要な場面で使います。'),

('sql-commit', @cat_id, 1,
 'トランザクション中の変更を確定する命令は？',
 '正解はCOMMITです。COMMITを実行すると、それまでの変更がデータベースに確定されます。ROLLBACKは変更を取り消し、BEGINはトランザクションを開始します。'),

('sql-rollback', @cat_id, 1,
 'トランザクション中の変更を取り消す命令は？',
 '正解はROLLBACKです。エラーが発生した場合などにROLLBACKすることで、トランザクション開始前の状態へ戻せます。データ整合性を守るために重要です。'),

('sql-normalization', @cat_id, 1,
 'データの重複や更新時の不整合を減らすためにテーブルを整理する設計手法は？',
 '正解は正規化です。正規化によりデータの重複を減らし、更新漏れや矛盾を防ぎやすくなります。ただし、読み取り性能や実装の単純さを考慮して、必要に応じて非正規化する場合もあります。'),

('sql-one-to-many', @cat_id, 1,
 '1人のユーザーが複数の注文を持つような関係は？',
 '正解は1対多です。ユーザー1件に対して注文が複数件紐づく関係で、通常は注文テーブルにuser_idのような外部キーを持たせて表現します。'),

('sql-many-to-many', @cat_id, 1,
 '学生と授業のように、互いに複数件ずつ関連する関係を表す一般的な方法は？',
 '正解は中間テーブルを使うことです。多対多の関係は、student_coursesのような中間テーブルにstudent_idとcourse_idを持たせて、2つの1対多の関係として表現します。'),

('sql-unique-constraint', @cat_id, 1,
 'メールアドレスのように、同じ値の重複登録を防ぐ制約は？',
 '正解はUNIQUE制約です。UNIQUE制約は指定した列、または列の組み合わせの重複を防ぎます。ログインIDやメールアドレスなど、一意であるべき値に使用します。'),

('sql-limit', @cat_id, 1,
 '取得する行数を制限するために使用する句は？',
 '正解はLIMIT句です。LIMIT 10のように指定すると最大10行だけ取得できます。ページネーションではORDER BYと組み合わせて、結果の順序を安定させることが重要です。'),

('sql-subquery', @cat_id, 1,
 'SQL文の中に入れ子で書かれたSELECT文を何と呼ぶ？',
 '正解はサブクエリです。WHERE句、FROM句、SELECT句などで使用でき、別の問い合わせ結果を条件や一時的な表として利用できます。'),

('sql-union', @cat_id, 1,
 '複数のSELECT結果を縦に結合する演算子は？',
 '正解はUNIONです。UNIONは複数のSELECT結果を1つの結果セットにまとめます。通常は重複行を取り除き、UNION ALLは重複を残します。'),

('sql-acid', @cat_id, 1,
 'トランザクションが満たすべき性質として知られるACIDのAは何を表す？',
 '正解はAtomicityです。Atomicityは原子性を意味し、トランザクション内の処理がすべて成功するか、すべて取り消されるかのどちらかになる性質です。'),

('sql-explain', @cat_id, 1,
 'SQLの実行計画を確認し、インデックス利用などを調べるために使う命令は？',
 '正解はEXPLAINです。EXPLAINを使うと、データベースがどのようにテーブルを読み、どのインデックスを使うかなどを確認できます。パフォーマンス改善の調査に役立ちます。'),

('sql-sql-injection', @cat_id, 1,
 'ユーザー入力をSQL文字列へ直接連結することで起こりやすい脆弱性は？',
 '正解はSQLインジェクションです。攻撃者が入力値を通じて意図しないSQLを実行できる可能性があります。対策としてプレースホルダやプリペアドステートメントを使用します。');

-- 選択肢（各4択）
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1
(@quiz_start + 0, 'SELECT', 1, 1),
(@quiz_start + 0, 'INSERT', 0, 2),
(@quiz_start + 0, 'UPDATE', 0, 3),
(@quiz_start + 0, 'DELETE', 0, 4),
-- Q2
(@quiz_start + 1, 'WHERE', 1, 1),
(@quiz_start + 1, 'ORDER BY', 0, 2),
(@quiz_start + 1, 'GROUP BY', 0, 3),
(@quiz_start + 1, 'JOIN', 0, 4),
-- Q3
(@quiz_start + 2, 'ORDER BY', 1, 1),
(@quiz_start + 2, 'WHERE', 0, 2),
(@quiz_start + 2, 'GROUP BY', 0, 3),
(@quiz_start + 2, 'HAVING', 0, 4),
-- Q4
(@quiz_start + 3, 'INSERT', 1, 1),
(@quiz_start + 3, 'SELECT', 0, 2),
(@quiz_start + 3, 'UPDATE', 0, 3),
(@quiz_start + 3, 'ALTER', 0, 4),
-- Q5
(@quiz_start + 4, 'UPDATE', 1, 1),
(@quiz_start + 4, 'INSERT', 0, 2),
(@quiz_start + 4, 'DROP', 0, 3),
(@quiz_start + 4, 'SELECT', 0, 4),
-- Q6
(@quiz_start + 5, 'DELETE', 1, 1),
(@quiz_start + 5, 'REMOVE', 0, 2),
(@quiz_start + 5, 'CLEAR', 0, 3),
(@quiz_start + 5, 'UPDATE', 0, 4),
-- Q7
(@quiz_start + 6, 'PRIMARY KEY', 1, 1),
(@quiz_start + 6, 'FOREIGN KEY', 0, 2),
(@quiz_start + 6, 'INDEX', 0, 3),
(@quiz_start + 6, 'CHECK', 0, 4),
-- Q8
(@quiz_start + 7, 'FOREIGN KEY', 1, 1),
(@quiz_start + 7, 'PRIMARY KEY', 0, 2),
(@quiz_start + 7, 'UNIQUE', 0, 3),
(@quiz_start + 7, 'DEFAULT', 0, 4),
-- Q9
(@quiz_start + 8, 'INNER JOIN', 1, 1),
(@quiz_start + 8, 'LEFT JOIN', 0, 2),
(@quiz_start + 8, 'FULL JOIN', 0, 3),
(@quiz_start + 8, 'CROSS JOIN', 0, 4),
-- Q10
(@quiz_start + 9, 'LEFT JOIN', 1, 1),
(@quiz_start + 9, 'INNER JOIN', 0, 2),
(@quiz_start + 9, 'CROSS JOIN', 0, 3),
(@quiz_start + 9, 'SELF JOIN', 0, 4),
-- Q11
(@quiz_start + 10, 'GROUP BY', 1, 1),
(@quiz_start + 10, 'ORDER BY', 0, 2),
(@quiz_start + 10, 'WHERE', 0, 3),
(@quiz_start + 10, 'LIMIT', 0, 4),
-- Q12
(@quiz_start + 11, 'HAVING', 1, 1),
(@quiz_start + 11, 'WHERE', 0, 2),
(@quiz_start + 11, 'ON', 0, 3),
(@quiz_start + 11, 'DISTINCT', 0, 4),
-- Q13
(@quiz_start + 12, 'COUNT', 1, 1),
(@quiz_start + 12, 'SUM', 0, 2),
(@quiz_start + 12, 'AVG', 0, 3),
(@quiz_start + 12, 'MAX', 0, 4),
-- Q14
(@quiz_start + 13, 'DISTINCT', 1, 1),
(@quiz_start + 13, 'UNIQUE', 0, 2),
(@quiz_start + 13, 'ONLY', 0, 3),
(@quiz_start + 13, 'GROUP', 0, 4),
-- Q15
(@quiz_start + 14, 'LIKE', 1, 1),
(@quiz_start + 14, 'IN', 0, 2),
(@quiz_start + 14, 'BETWEEN', 0, 3),
(@quiz_start + 14, 'MATCH', 0, 4),
-- Q16
(@quiz_start + 15, 'IS NULL', 1, 1),
(@quiz_start + 15, '= NULL', 0, 2),
(@quiz_start + 15, '== NULL', 0, 3),
(@quiz_start + 15, 'NULL()', 0, 4),
-- Q17
(@quiz_start + 16, '検索や結合の高速化', 1, 1),
(@quiz_start + 16, 'データを暗号化すること', 0, 2),
(@quiz_start + 16, 'テーブル名を変更すること', 0, 3),
(@quiz_start + 16, '必ず容量を削減すること', 0, 4),
-- Q18
(@quiz_start + 17, 'トランザクション', 1, 1),
(@quiz_start + 17, 'インデックス', 0, 2),
(@quiz_start + 17, 'ビュー', 0, 3),
(@quiz_start + 17, 'カーソル', 0, 4),
-- Q19
(@quiz_start + 18, 'COMMIT', 1, 1),
(@quiz_start + 18, 'ROLLBACK', 0, 2),
(@quiz_start + 18, 'BEGIN', 0, 3),
(@quiz_start + 18, 'SAVEPOINT', 0, 4),
-- Q20
(@quiz_start + 19, 'ROLLBACK', 1, 1),
(@quiz_start + 19, 'COMMIT', 0, 2),
(@quiz_start + 19, 'GRANT', 0, 3),
(@quiz_start + 19, 'LOCK', 0, 4),
-- Q21
(@quiz_start + 20, '正規化', 1, 1),
(@quiz_start + 20, '暗号化', 0, 2),
(@quiz_start + 20, 'インデックス化', 0, 3),
(@quiz_start + 20, 'バックアップ', 0, 4),
-- Q22
(@quiz_start + 21, '1対多', 1, 1),
(@quiz_start + 21, '1対1', 0, 2),
(@quiz_start + 21, '多対多', 0, 3),
(@quiz_start + 21, '自己参照', 0, 4),
-- Q23
(@quiz_start + 22, '中間テーブルを使う', 1, 1),
(@quiz_start + 22, '片方のテーブルに全IDをカンマ区切りで保存する', 0, 2),
(@quiz_start + 22, 'ビューだけで表現する', 0, 3),
(@quiz_start + 22, '主キーを削除する', 0, 4),
-- Q24
(@quiz_start + 23, 'UNIQUE制約', 1, 1),
(@quiz_start + 23, 'DEFAULT制約', 0, 2),
(@quiz_start + 23, 'NOT NULL制約', 0, 3),
(@quiz_start + 23, 'FOREIGN KEY制約', 0, 4),
-- Q25
(@quiz_start + 24, 'LIMIT', 1, 1),
(@quiz_start + 24, 'OFFSET ONLY', 0, 2),
(@quiz_start + 24, 'TAKE', 0, 3),
(@quiz_start + 24, 'ROWS', 0, 4),
-- Q26
(@quiz_start + 25, 'サブクエリ', 1, 1),
(@quiz_start + 25, 'インデックス', 0, 2),
(@quiz_start + 25, 'トリガー', 0, 3),
(@quiz_start + 25, '制約', 0, 4),
-- Q27
(@quiz_start + 26, 'UNION', 1, 1),
(@quiz_start + 26, 'JOIN', 0, 2),
(@quiz_start + 26, 'MERGE', 0, 3),
(@quiz_start + 26, 'GROUP BY', 0, 4),
-- Q28
(@quiz_start + 27, 'Atomicity', 1, 1),
(@quiz_start + 27, 'Availability', 0, 2),
(@quiz_start + 27, 'Authorization', 0, 3),
(@quiz_start + 27, 'Aggregation', 0, 4),
-- Q29
(@quiz_start + 28, 'EXPLAIN', 1, 1),
(@quiz_start + 28, 'DESCRIBE DATA', 0, 2),
(@quiz_start + 28, 'ANALYZE ONLY', 0, 3),
(@quiz_start + 28, 'SHOW PLAN', 0, 4),
-- Q30
(@quiz_start + 29, 'SQLインジェクション', 1, 1),
(@quiz_start + 29, 'クロスサイトスクリプティング', 0, 2),
(@quiz_start + 29, 'CSRF', 0, 3),
(@quiz_start + 29, 'ブルートフォース攻撃', 0, 4);
