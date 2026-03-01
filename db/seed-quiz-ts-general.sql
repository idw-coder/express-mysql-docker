-- TypeScript全般クイズ シードデータ（エラー番号・指定問題対応版）
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-ts-general.sql

SET NAMES utf8mb4;

-- 1. カテゴリ登録
SET @target_slug = 'ts-general';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'TS全般', 1, 'TypeScriptの基本文法、型システム、Utility Types、およびよくあるコンパイルエラーに関する問題です。', @cat_id);

-- 2. クイズデータ登録準備
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. クイズ本体の登録
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
-- エラー関連 (5問: エラーコード付き)
('ts-error-ts2345', @cat_id, 1, '関数呼び出し時に「TS2345: Argument of type ''string'' is not assignable to parameter of type ''number''.」が出ました。原因は？', '正解は「関数が期待する引数の型と、実際に渡した値の型が一致していないため」です。定義では数値を求めている箇所に文字列を渡した場合などに発生します。'),
('ts-error-ts2531', @cat_id, 1, '「TS2531: Object is possibly ''null''.」というエラーの安全な解決策は？', '正解は「if文でnullチェックを行うか、オプショナルチェイニング(?.)を使用する」です。非ヌルアサーション(!)を使うとコンパイルは通りますが、実行時エラーのリスクが残ります。'),
('ts-error-ts2322', @cat_id, 1, '変数への代入時に「TS2322: Type ''X'' is not assignable to type ''Y''.」が出ました。どう対応すべきですか？', '正解は「変数Yの型定義を見直すか、代入する値Xを正しい型に変換する」です。TypeScriptにおける最も一般的な型不一致のエラーであり、型の互換性がないことを示しています。'),
('ts-error-ts2339', @cat_id, 1, 'オブジェクト操作時に「TS2339: Property ''...'' does not exist on type ''...''.」が出ました。原因として考えられるのは？', '正解は「型定義（インターフェース等）に存在しないプロパティへアクセスしようとしたため」です。タイポの修正や、必要であれば型定義へのプロパティ追加を行います。'),
('ts-error-ts2769', @cat_id, 1, '「TS2769: No overload matches this call.」というエラーが出ました。どのような時に発生しやすいですか？', '正解は「複数の引数パターン（オーバーロード）を持つ関数に対し、どれにも一致しない引数を渡した時」です。DOM操作APIや外部ライブラリの関数を呼び出す際によく遭遇します。'),

('ts-gen-unknown-cast', @cat_id, 1, '外部の型を自作型へ変換する際、`as unknown as User` と unknown を経由する理由と、any との違いは？', '正解は「意図的な型変換であることを明示し、相対的な安全性を保つため」です。anyは型チェックを完全に無効化する雑な変換ですが、unknownを経由することで互換性のない型同士でも安全に変換できます。'),

-- TypeScript全般 (14問)
('ts-gen-inference', @cat_id, 1, 'TypeScriptにおいて、変数の型をコンパイラが自動的に推測する機能を何と呼びますか？', '正解は「型推論（Type Inference）」です。明示的に型を書かなくても、初期値などから自動で型を決定してくれるため、コードの記述量を減らすことができます。'),
('ts-gen-interface-vs-type', @cat_id, 1, 'オブジェクトの構造を定義する際、「interface」と「type（型エイリアス）」のどちらを使うべきですか？', '正解は「基本的にはどちらでも良いが、拡張性を持たせたい場合はinterfaceが推奨されることが多い」です。interfaceは宣言のマージが可能ですが、typeはより複雑な型（ユニオン型など）を表現できます。'),
('ts-gen-union', @cat_id, 1, '複数の型のうち、いずれか1つの型であることを示す「string | number」のような書き方を何と呼びますか？', '正解は「ユニオン型（Union Types）」です。パイプ記号（|）で繋ぐことで、許容する複数の型を柔軟に定義できます。'),
('ts-gen-generics', @cat_id, 1, '型を引数として受け取り、汎用的なコンポーネントや関数を作るための仕組みは？', '正解は「ジェネリクス（Generics）」です。`<T>`のように型変数を定義することで、実行時に型を決定し、再利用性と型安全性を両立できます。'),
('ts-gen-partial', @cat_id, 1, '既存の型から、すべてのプロパティを「省略可能」にした新しい型を作るUtility Typeは？', '正解は「Partial<T>」です。オブジェクトの更新処理など、一部のプロパティだけを受け取りたい場合に非常に便利です。'),
('ts-gen-pick', @cat_id, 1, '既存の型から、特定のプロパティだけを抽出して新しい型を作るUtility Typeは？', '正解は「Pick<T, K>」です。例えば、ユーザー情報から名前とメールアドレスだけを抽出した型を作る際などに使用します。'),
('ts-gen-tuple', @cat_id, 1, '要素の数と、それぞれの要素の型が固定された配列（例：[string, number]）を何と呼びますか？', '正解は「タプル（Tuple）」です。関数の戻り値で複数の異なる型の値を返したい場合（ReactのuseStateなど）によく利用されます。'),
('ts-gen-keyof', @cat_id, 1, 'オブジェクトのキー名を文字列のリテラル型のユニオン（"name" | "age" など）として取得する演算子は？', '正解は「keyof」演算子です。特定のオブジェクトのプロパティ名だけを引数として許可したい場合などに使用し、タイポを防ぎます。'),
('ts-gen-typeof', @cat_id, 1, 'JavaScriptの値を元にして、TypeScriptの型を抽出する演算子は？', '正解は「typeof」演算子です。既存のオブジェクトや関数から型を生成できるため、型定義を二重に管理する手間を省けます。'),
('ts-gen-record', @cat_id, 1, 'プロパティのキーがstring、値がnumberのオブジェクト（連想配列）を定義するのに適したUtility Typeは？', '正解は「Record<string, number>」です。辞書型（ディクショナリ）のデータ構造を簡潔に定義する際によく使われます。'),
('ts-gen-never', @cat_id, 1, '絶対に値が返らない（例外を投げる、または無限ループする）関数の戻り値の型は？', '正解は「never」型です。どの型とも互換性がないため、switch文などで処理漏れ（ケースの追加忘れ）を防ぐ網羅性チェックにも利用されます。'),
('ts-gen-unknown-type', @cat_id, 1, '「any」型の代わりに、より安全な「なんでも入る型」として推奨される型は？', '正解は「unknown」型です。代入は自由ですが、プロパティへのアクセスやメソッドの呼び出しを行う前に、型アサーションや型ガードで型を特定する必要があります。'),
('ts-gen-readonly', @cat_id, 1, '変数の値が後から変更されないことを保証する、プロパティや配列に付与する修飾子は？', '正解は「readonly」です。意図しないデータの変更（ミューテーション）をコンパイル時に防ぐことができます。'),
('ts-gen-strict', @cat_id, 1, 'コンパイル時の厳格な型チェックを一括で有効にする、tsconfig.jsonの推奨設定は？', '正解は「"strict": true」です。これにより、暗黙のanyの禁止（noImplicitAny）や厳格なnullチェック（strictNullChecks）などがまとめて有効になります。');

-- 4. 選択肢の登録
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: ts-error-ts2345
(@quiz_start + 0, '期待する引数の型と、実際に渡した値の型が一致していないため', 1, 1),
(@quiz_start + 0, '関数が定義されていないため', 0, 2),
(@quiz_start + 0, '引数の数が多すぎるため', 0, 3),
(@quiz_start + 0, '非同期処理のawaitを忘れているため', 0, 4),
-- Q2: ts-error-ts2531
(@quiz_start + 1, 'if文でnullチェックを行うか、オプショナルチェイニングを使用する', 1, 1),
(@quiz_start + 1, '非ヌルアサーション(!)を使用してエラーを無視する', 0, 2),
(@quiz_start + 1, '変数の型をanyに変更する', 0, 3),
(@quiz_start + 1, 'tsconfig.jsonでstrictNullChecksをfalseにする', 0, 4),
-- Q3: ts-error-ts2322
(@quiz_start + 2, '代入先の型定義を見直すか、代入する値を正しい型に変換する', 1, 1),
(@quiz_start + 2, 'TypeScriptのバージョンをダウングレードする', 0, 2),
(@quiz_start + 2, 'パッケージを再インストールする', 0, 3),
(@quiz_start + 2, '無視してコンパイル（tsc）を実行する', 0, 4),
-- Q4: ts-error-ts2339
(@quiz_start + 3, '型定義（インターフェース等）に存在しないプロパティへアクセスしようとした', 1, 1),
(@quiz_start + 3, 'プロパティの値がundefinedになっている', 0, 2),
(@quiz_start + 3, 'オブジェクトがフリーズ（Object.freeze）されている', 0, 3),
(@quiz_start + 3, 'プロパティがprivateで宣言されている', 0, 4),
-- Q5: ts-error-ts2769
(@quiz_start + 4, '複数の引数パターンのどれにも一致しない引数を渡した時', 1, 1),
(@quiz_start + 4, '関数の戻り値を受け取る変数を定義していない時', 0, 2),
(@quiz_start + 4, '再帰呼び出しが深すぎる時', 0, 3),
(@quiz_start + 4, 'モジュールのインポートに失敗した時', 0, 4),

-- Q6: ts-gen-unknown-cast
(@quiz_start + 5, '意図的な型変換であることを明示し、相対的な安全性を保つため', 1, 1),
(@quiz_start + 5, 'パフォーマンスを向上させるため', 0, 2),
(@quiz_start + 5, 'anyを使用すると必ず実行時エラーになるため', 0, 3),
(@quiz_start + 5, 'TypeScriptの仕様上、anyが非推奨になったため', 0, 4),

-- Q7: ts-gen-inference
(@quiz_start + 6, '型推論（Type Inference）', 1, 1),
(@quiz_start + 6, 'ダックタイピング（Duck Typing）', 0, 2),
(@quiz_start + 6, '動的型付け（Dynamic Typing）', 0, 3),
(@quiz_start + 6, '型アサーション（Type Assertion）', 0, 4),
-- Q8: ts-gen-interface-vs-type
(@quiz_start + 7, '拡張性を持たせたい場合はinterfaceが推奨される', 1, 1),
(@quiz_start + 7, 'typeはパフォーマンスが良いため常に推奨される', 0, 2),
(@quiz_start + 7, 'interfaceはクラスでのみ使用可能である', 0, 3),
(@quiz_start + 7, '両者は完全に同じであり、違いはない', 0, 4),
-- Q9: ts-gen-union
(@quiz_start + 8, 'ユニオン型（Union Types）', 1, 1),
(@quiz_start + 8, '交差型（Intersection Types）', 0, 2),
(@quiz_start + 8, 'ジェネリクス（Generics）', 0, 3),
(@quiz_start + 8, '列挙型（Enums）', 0, 4),
-- Q10: ts-gen-generics
(@quiz_start + 9, 'ジェネリクス（Generics）', 1, 1),
(@quiz_start + 9, 'ポリモーフィズム（Polymorphism）', 0, 2),
(@quiz_start + 9, 'プロミス（Promises）', 0, 3),
(@quiz_start + 9, 'インターフェース（Interfaces）', 0, 4),
-- Q11: ts-gen-partial
(@quiz_start + 10, 'Partial<T>', 1, 1),
(@quiz_start + 10, 'Required<T>', 0, 2),
(@quiz_start + 10, 'Readonly<T>', 0, 3),
(@quiz_start + 10, 'Omit<T, K>', 0, 4),
-- Q12: ts-gen-pick
(@quiz_start + 11, 'Pick<T, K>', 1, 1),
(@quiz_start + 11, 'Exclude<T, U>', 0, 2),
(@quiz_start + 11, 'Extract<T, U>', 0, 3),
(@quiz_start + 11, 'Record<K, T>', 0, 4),
-- Q13: ts-gen-tuple
(@quiz_start + 12, 'タプル（Tuple）', 1, 1),
(@quiz_start + 12, 'リスト（List）', 0, 2),
(@quiz_start + 12, 'セット（Set）', 0, 3),
(@quiz_start + 12, 'マップ（Map）', 0, 4),
-- Q14: ts-gen-keyof
(@quiz_start + 13, 'keyof', 1, 1),
(@quiz_start + 13, 'typeof', 0, 2),
(@quiz_start + 13, 'instanceof', 0, 3),
(@quiz_start + 13, 'in', 0, 4),
-- Q15: ts-gen-typeof
(@quiz_start + 14, 'typeof', 1, 1),
(@quiz_start + 14, 'keyof', 0, 2),
(@quiz_start + 14, 'infer', 0, 3),
(@quiz_start + 14, 'as', 0, 4),
-- Q16: ts-gen-record
(@quiz_start + 15, 'Record<string, number>', 1, 1),
(@quiz_start + 15, 'Map<string, number>', 0, 2),
(@quiz_start + 15, 'Object<string, number>', 0, 3),
(@quiz_start + 15, 'Dictionary<string, number>', 0, 4),
-- Q17: ts-gen-never
(@quiz_start + 16, 'never', 1, 1),
(@quiz_start + 16, 'void', 0, 2),
(@quiz_start + 16, 'unknown', 0, 3),
(@quiz_start + 16, 'any', 0, 4),
-- Q18: ts-gen-unknown-type
(@quiz_start + 17, 'unknown', 1, 1),
(@quiz_start + 17, 'object', 0, 2),
(@quiz_start + 17, 'void', 0, 3),
(@quiz_start + 17, 'never', 0, 4),
-- Q19: ts-gen-readonly
(@quiz_start + 18, 'readonly', 1, 1),
(@quiz_start + 18, 'const', 0, 2),
(@quiz_start + 18, 'static', 0, 3),
(@quiz_start + 18, 'final', 0, 4),
-- Q20: ts-gen-strict
(@quiz_start + 19, '"strict": true', 1, 1),
(@quiz_start + 19, '"strictNullChecks": true', 0, 2),
(@quiz_start + 19, '"noImplicitAny": true', 0, 3),
(@quiz_start + 19, '"alwaysStrict": true', 0, 4);