-- Next.js クイズ シードデータ
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-nextjs.sql

SET NAMES utf8mb4;

-- 1. カテゴリ登録
SET @target_slug = 'nextjs';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'Next.js', 1, 'Next.jsの実践的なエラー解決やApp Router・Server Componentsなど頻出トピックに関するクイズです。', @cat_id);

-- 2. クイズデータ登録準備
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. クイズ本体の登録 (10問)
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES

-- Q1: Hydration Error
('nextjs-hydration-mismatch', @cat_id, 1,
 'Next.jsで「Hydration failed because the initial UI does not match what was rendered on the server」というエラーが発生しました。最も一般的な原因はどれですか？',
 '正解は「サーバーとクライアントで異なるHTMLが生成されている」です。Next.jsはSSR/SSGで生成したHTMLをクライアント側でhydrate（再利用）しますが、サーバーで生成したHTMLとクライアントで生成されるHTMLが一致しない場合にこのエラーが発生します。よくある原因として、Date.now()やMath.random()の使用、typeof window !== "undefined" による条件分岐、ブラウザ拡張機能によるDOM変更、<p>タグの中に<div>を入れるなどの不正なHTML構造があります。useEffectで動的コンテンツをマウント後に描画する、suppressHydrationWarningを限定的に使用するなどの対処が有効です。'),

-- Q2: use client ディレクティブ
('nextjs-use-client-directive', @cat_id, 1,
 'Next.js App Routerで「You''re importing a component that needs useState. It only works in a Client Component but none of its parents are marked with "use client"」と表示されました。正しい対処法は？',
 '正解は「コンポーネントファイルの先頭に"use client"ディレクティブを追加する」です。Next.js 13以降のApp Routerではデフォルトで全コンポーネントがServer Componentとして扱われます。useState・useEffect・onClickなどのブラウザAPIやReactのクライアント専用フックを使うには、ファイル先頭に"use client"を宣言してClient Componentにする必要があります。ただし、"use client"の使用範囲は最小限に留め、インタラクティブな部分だけをClient Componentとして切り出すのがパフォーマンスのベストプラクティスです。'),

-- Q3: Module not found fs
('nextjs-module-not-found-fs', @cat_id, 1,
 'Next.jsで「Module not found: Can''t resolve ''fs''」というエラーが発生しました。原因として正しいものはどれですか？',
 '正解は「Node.js専用モジュール（fs）をクライアントサイドのコードで使用している」です。fsモジュールはNode.jsのファイルシステムAPIであり、ブラウザ環境では利用できません。Next.jsではgetServerSideProps・getStaticProps・API Routes・Server Componentなどサーバー側でのみ実行されるコード内でのみfsを使用できます。クライアントコンポーネント内やクライアントにバンドルされるコードでfsをimportすると、webpackがブラウザ用バンドルにfsを含めようとしてこのエラーが発生します。サーバー専用コードを明確に分離することが重要です。'),

-- Q4: NEXT_PUBLIC_ 環境変数
('nextjs-env-next-public', @cat_id, 1,
 'Next.jsでprocess.env.API_URLをクライアント側のコンポーネントで参照したところundefinedになりました。正しい対処法は？',
 '正解は「環境変数名をNEXT_PUBLIC_API_URLに変更する」です。Next.jsではセキュリティのため、デフォルトでサーバーサイドの環境変数はクライアントに公開されません。クライアント側（ブラウザ）で参照する環境変数には必ずNEXT_PUBLIC_プレフィックスを付ける必要があります。例えばNEXT_PUBLIC_API_URLと命名すれば、process.env.NEXT_PUBLIC_API_URLでクライアントからアクセス可能になります。ただし、APIキーなどの秘密情報にNEXT_PUBLIC_を付けるとブラウザに露出するため、公開して問題ない値のみに使用してください。環境変数の変更後はdev serverの再起動が必要です。'),

-- Q5: generateStaticParams
('nextjs-generate-static-params', @cat_id, 1,
 'Next.js App Routerで動的ルート（例: /blog/[slug]）を静的に生成（SSG）するために使用する関数はどれですか？',
 '正解は「generateStaticParams」です。App Router（app/ディレクトリ）ではgenerateStaticParams関数をexportすることで、ビルド時に動的ルートの全パターンを生成できます。Pages Router（pages/ディレクトリ）で使用していたgetStaticPathsに相当する機能です。generateStaticParamsはサーバーコンポーネント内でasync関数として定義し、パラメータオブジェクトの配列を返します。fetch結果やDB問い合わせからslug一覧を取得し、各ページを事前ビルドすることでパフォーマンスとSEOの両面で有利になります。'),

-- Q6: Dynamic server usage
('nextjs-dynamic-server-usage', @cat_id, 1,
 'Next.jsで「Error: Dynamic server usage: headers」というエラーが発生し、ビルドが失敗しました。原因と対処法は？',
 '正解は「静的レンダリングされるページでheaders()やcookies()などの動的APIを使用している」です。Next.js App Routerではデフォルトで可能な限り静的レンダリング（SSG）が行われます。しかしheaders()・cookies()・searchParamsなどリクエスト時にしか取得できないデータを使うと、静的生成が不可能になりこのエラーが発生します。対処法としては、該当のlayout.tsxやpage.tsxに export const dynamic = "force-dynamic" を追加して動的レンダリング（SSR）に切り替えるか、動的APIの使用箇所をSuspenseで囲んで部分的にストリーミングレンダリングさせる方法があります。'),

-- Q7: next/image
('nextjs-image-optimization-error', @cat_id, 1,
 'Next.jsのnext/imageコンポーネントで外部URLの画像を表示しようとしたところ「Error: Invalid src prop」が発生しました。対処法は？',
 '正解は「next.config.jsのimages.remotePatterns（またはdomains）に外部ホストを追加する」です。next/imageはNext.jsの画像最適化機能を提供しますが、セキュリティ上の理由からデフォルトでは外部URLの画像を最適化しません。外部の画像を使用するにはnext.config.jsで許可するドメインを明示的に設定する必要があります。Next.js 14以降ではremotePatternsの使用が推奨されており、protocol・hostname・port・pathnameの組み合わせで柔軟に制御できます。非推奨のdomains設定より細かいアクセス制御が可能です。'),

-- Q8: Server Actions
('nextjs-server-actions-use-server', @cat_id, 1,
 'Next.js App Routerで「Functions cannot be passed directly to Client Components unless you explicitly expose it by marking it with "use server"」というエラーが表示されました。このエラーの意味は？',
 '正解は「Server Actionとして"use server"を宣言せずに、関数をClient Componentに渡している」です。App Routerでは、Server ComponentからClient Componentにpropsとして関数を渡すことはデフォルトでできません。フォーム送信やデータ変更などサーバー側で実行する関数は"use server"ディレクティブを付けてServer Actionとして定義する必要があります。Server Actionsはasync関数の先頭に"use server"を記述するか、別ファイルの先頭に"use server"を宣言してその中の全関数をServer Actionにする方法があります。これによりクライアントから安全にサーバー側の処理を呼び出せます。'),

-- Q9: middleware
('nextjs-middleware-matcher', @cat_id, 1,
 'Next.jsのmiddleware.tsが全ルートに適用されてしまい、静的アセット（CSS・画像など）のリクエストにも影響を与えています。正しい対処法は？',
 '正解は「config.matcherで適用するパスパターンを指定する」です。Next.jsのMiddlewareはデフォルトで全リクエストに対して実行されます。_next/staticや_next/imageなどの静的アセットにまでMiddlewareが適用されると、パフォーマンスの低下や意図しないリダイレクトが発生します。middleware.tsにexport const config = { matcher: ["/dashboard/:path*", "/api/:path*"] }のようにmatcherを設定することで、Middlewareを特定のパスのみに限定できます。また、matcher内では正規表現も使用可能で、/((?!api|_next/static|_next/image|favicon.ico).*)のように除外パターンも記述できます。'),

-- Q10: fetch cache
('nextjs-fetch-cache-revalidate', @cat_id, 1,
 'Next.js App Routerでfetch()したデータが更新されず古い情報が表示され続けます。データを定期的に再取得するための正しい方法は？',
 '正解は「fetchのオプションにnext: { revalidate: 秒数 }を指定する」です。Next.js App Routerではデフォルトでfetchの結果がキャッシュされ、一度取得したデータはビルド時またはリクエスト時の結果が再利用されます。データを定期的に更新するにはISR（Incremental Static Regeneration）の仕組みを使い、fetch("https://...", { next: { revalidate: 3600 } })のように再検証間隔を秒単位で指定します。revalidate: 0は毎回サーバーで再取得、cache: "no-store"はキャッシュ完全無効化を意味します。また、revalidatePath()やrevalidateTag()を使ったオンデマンド再検証も可能で、CMSの更新時などに即座にキャッシュを無効化できます。');

-- 4. 選択肢の登録
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: Hydration Error
(@quiz_start + 0, 'サーバーとクライアントで異なるHTMLが生成されている', 1, 1),
(@quiz_start + 0, 'Node.jsのバージョンが古い', 0, 2),
(@quiz_start + 0, 'next.config.jsの設定が不足している', 0, 3),
(@quiz_start + 0, 'package.jsonのdependenciesが壊れている', 0, 4),
-- Q2: use client
(@quiz_start + 1, 'コンポーネントファイルの先頭に"use client"を追加する', 1, 1),
(@quiz_start + 1, 'next.config.jsでclientMode: trueを設定する', 0, 2),
(@quiz_start + 1, 'useStateの代わりにuseRefを使う', 0, 3),
(@quiz_start + 1, 'コンポーネントをpages/ディレクトリに移動する', 0, 4),
-- Q3: Module not found fs
(@quiz_start + 2, 'Node.js専用モジュールをクライアント側で使用している', 1, 1),
(@quiz_start + 2, 'fsパッケージをnpm installしていない', 0, 2),
(@quiz_start + 2, 'TypeScriptの型定義が不足している', 0, 3),
(@quiz_start + 2, 'Next.jsのバージョンがfsに対応していない', 0, 4),
-- Q4: NEXT_PUBLIC_
(@quiz_start + 3, '環境変数名をNEXT_PUBLIC_API_URLに変更する', 1, 1),
(@quiz_start + 3, '.envファイルをpublicフォルダに移動する', 0, 2),
(@quiz_start + 3, 'next.config.jsでenv: { API_URL }を設定する', 0, 3),
(@quiz_start + 3, 'process.envの代わりにwindow.envを使用する', 0, 4),
-- Q5: generateStaticParams
(@quiz_start + 4, 'generateStaticParams', 1, 1),
(@quiz_start + 4, 'getStaticPaths', 0, 2),
(@quiz_start + 4, 'getServerSideProps', 0, 3),
(@quiz_start + 4, 'generateMetadata', 0, 4),
-- Q6: Dynamic server usage
(@quiz_start + 5, '静的レンダリングのページで動的API（headers等）を使用している', 1, 1),
(@quiz_start + 5, 'サーバーのメモリが不足している', 0, 2),
(@quiz_start + 5, 'middleware.tsの設定が競合している', 0, 3),
(@quiz_start + 5, 'TypeScriptのコンパイルエラーが発生している', 0, 4),
-- Q7: next/image
(@quiz_start + 6, 'next.config.jsのimages.remotePatternsに外部ホストを追加する', 1, 1),
(@quiz_start + 6, '画像URLをBase64エンコードして埋め込む', 0, 2),
(@quiz_start + 6, 'next/imageの代わりに通常の<img>タグを使う', 0, 3),
(@quiz_start + 6, 'publicフォルダに画像をダウンロードして配置する', 0, 4),
-- Q8: Server Actions
(@quiz_start + 7, 'Server Actionとして"use server"を宣言せず関数を渡している', 1, 1),
(@quiz_start + 7, 'Client Componentで非同期関数が使えない', 0, 2),
(@quiz_start + 7, 'Server ComponentでonClickイベントを使用している', 0, 3),
(@quiz_start + 7, 'API Routeの代わりに直接関数を呼び出している', 0, 4),
-- Q9: middleware matcher
(@quiz_start + 8, 'config.matcherで適用するパスパターンを指定する', 1, 1),
(@quiz_start + 8, 'middleware.tsのファイル名をmiddleware.client.tsに変更する', 0, 2),
(@quiz_start + 8, '静的アセットをCDNから配信するように変更する', 0, 3),
(@quiz_start + 8, 'next.config.jsでmiddleware: falseを設定する', 0, 4),
-- Q10: fetch cache revalidate
(@quiz_start + 9, 'fetchにnext: { revalidate: 秒数 }を指定する', 1, 1),
(@quiz_start + 9, 'fetchの代わりにaxiosを使用する', 0, 2),
(@quiz_start + 9, 'useEffectでsetIntervalを使って定期取得する', 0, 3),
(@quiz_start + 9, 'next.config.jsでcache: falseをグローバルに設定する', 0, 4);
