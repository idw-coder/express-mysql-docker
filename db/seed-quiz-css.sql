-- CSS基礎クイズ シードデータ
-- 実行例（プロジェクトルートで）: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-css.sql
-- 実行順序不問（カテゴリ id=3、クイズ id は既存の次から自動採番）

SET NAMES utf8mb4;

-- カテゴリ（既存ならスキップ）
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (3, 'css-basic', 'CSS基礎・実践', 1, 'CSSのレイアウト、セレクタ、アニメーション、レスポンシブデザインに関する問題です。', 3);

-- クイズ（category_id=3）。既存の quiz の最大 id の次から採番
SELECT @start := COALESCE(MAX(id), 0) + 1 FROM quiz;
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @start);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('css-specificity-order', 3, 1,
 'CSSの詳細度（specificity）が最も高いのは？',
 '正解はIDセレクタ（#id）です。詳細度の順序は、インラインスタイル > IDセレクタ > クラスセレクタ > 要素セレクタです。!importantは詳細度の計算とは別に最優先されますが、保守性が低下するため使用は推奨されません。'),

('css-box-model', 3, 1,
 'CSSボックスモデルの構成要素として正しい順序（内側から外側）は？',
 '正解はcontent → padding → border → marginです。contentは要素の内容領域、paddingは内容とborderの間の余白、borderは要素の枠線、marginは要素の外側の余白です。box-sizing: border-boxを指定するとwidthにpadding・borderが含まれます。'),

('css-box-sizing', 3, 1,
 'box-sizing: border-boxを指定した場合の動作は？',
 '正解はwidth/heightにpaddingとborderが含まれることです。デフォルトのcontent-boxではpaddingとborderがwidthに加算されますが、border-boxではwidthの中に含まれるため、レイアウト計算が直感的になります。'),

('css-flexbox-justify', 3, 1,
 'Flexboxで主軸方向の配置を制御するプロパティは？',
 '正解はjustify-contentです。center（中央寄せ）、space-between（均等配置）、flex-start（先頭寄せ）などの値を指定できます。align-itemsは交差軸方向の配置、flex-directionは主軸の方向、flex-wrapは折り返しを制御します。'),

('css-flexbox-center', 3, 1,
 'Flexboxで要素を水平・垂直の中央に配置する方法は？',
 '正解はdisplay: flex; justify-content: center; align-items: centerです。justify-contentで水平方向、align-itemsで垂直方向の中央寄せを実現します。親要素に高さを指定する必要がある点に注意してください。'),

('css-flexbox-direction', 3, 1,
 'Flexboxでアイテムの並び方向を変更するプロパティは？',
 '正解はflex-directionです。row（横並び・デフォルト）、column（縦並び）、row-reverse（横並び逆順）、column-reverse（縦並び逆順）を指定できます。flex-wrapで折り返し、flex-flowでdirectionとwrapを同時に指定できます。'),

('css-flexbox-grow', 3, 1,
 'Flexboxでアイテムの伸長割合を指定するプロパティは？',
 '正解はflex-growです。flex-grow: 1を指定すると余白を均等に分配し、flex-grow: 2は他のflex-grow: 1の要素の2倍の割合で伸長します。flex-shrinkは縮小割合、flex-basisは初期サイズを指定します。'),

('css-grid-template', 3, 1,
 'CSS Gridで3列のレイアウトを定義するプロパティは？',
 '正解はgrid-template-columns: repeat(3, 1fr)です。frは利用可能なスペースの比率を表す単位です。1fr 2fr 1frのように異なる比率も指定できます。grid-template-rowsは行の定義に使用します。'),

('css-grid-area', 3, 1,
 'CSS Gridで名前付きエリアを使ったレイアウトを定義するプロパティは？',
 '正解はgrid-template-areasです。grid-template-areas: "header header" "sidebar main" "footer footer"のように視覚的にレイアウトを定義できます。各子要素にgrid-area: headerのようにエリア名を指定します。'),

('css-grid-auto-fill', 3, 1,
 'CSS Gridで利用可能なスペースに応じて自動的に列数を調整する方法は？',
 '正解はgrid-template-columns: repeat(auto-fill, minmax(200px, 1fr))です。auto-fillは空のトラックも生成し、auto-fitは空のトラックを折りたたみます。minmax()で最小・最大サイズを指定できます。'),

('css-position-fixed', 3, 1,
 'CSSで要素をスクロールしても固定位置に表示するposition値は？',
 '正解はfixedです。position: fixedはビューポートに対して固定され、スクロールしても位置が変わりません。stickyはスクロール位置に応じて固定/通常が切り替わります。absoluteは最も近い位置指定された祖先要素に対して配置されます。'),

('css-position-sticky', 3, 1,
 'position: stickyの動作として正しいのは？',
 '正解はスクロール時に指定した位置に到達すると固定されることです。top: 0を指定すると、要素がビューポート上端に到達した時点で固定表示になります。通常のフローに配置されつつ、スクロール時にfixedのように振る舞う特徴があります。'),

('css-media-query', 3, 1,
 'CSSメディアクエリでスマートフォン向けのスタイルを記述する正しい構文は？',
 '正解は@media (max-width: 768px) { ... }です。メディアクエリを使用してビューポートの幅に応じたスタイルを適用できます。モバイルファーストの場合はmin-width、デスクトップファーストの場合はmax-widthを使用します。'),

('css-pseudo-class-hover', 3, 1,
 'CSSでリンクにホバーした時のスタイルを指定する擬似クラスは？',
 '正解は:hoverです。a:hover { color: red; }のように使用し、マウスが要素の上にある時のスタイルを定義します。:activeはクリック中、:visitedは訪問済み、:focusはフォーカス時のスタイルを指定します。'),

('css-pseudo-element-before', 3, 1,
 'CSSで要素の前にコンテンツを挿入する擬似要素は？',
 '正解は::beforeです。p::before { content: "→ "; }のように使用し、要素の前にコンテンツを追加できます。::afterは要素の後に追加します。contentプロパティの指定が必須で、省略すると表示されません。'),

('css-pseudo-class-nth-child', 3, 1,
 'CSSでリストの奇数番目の要素にスタイルを適用するセレクタは？',
 '正解は:nth-child(odd)または:nth-child(2n+1)です。:nth-child(even)は偶数番目、:nth-child(3n)は3の倍数番目を選択します。:first-childは最初、:last-childは最後の要素を選択します。'),

('css-selector-child', 3, 1,
 'CSSで直接の子要素のみを選択するセレクタは？',
 '正解は>（子セレクタ）です。div > pはdivの直接の子要素であるpのみを選択します。div p（半角スペース）は子孫セレクタで、divの中のすべてのpを選択します。~は一般兄弟セレクタ、+は隣接兄弟セレクタです。'),

('css-selector-attribute', 3, 1,
 'CSSで特定の属性を持つ要素を選択するセレクタの構文は？',
 '正解は[属性名]または[属性名="値"]です。[type="text"]でtype属性がtextの要素、[href^="https"]でhrefがhttpsで始まる要素を選択できます。^=は前方一致、$=は後方一致、*=は部分一致です。'),

('css-variable-syntax', 3, 1,
 'CSSカスタムプロパティ（CSS変数）の正しい構文は？',
 '正解は--main-color: #333で定義しvar(--main-color)で参照することです。:rootで定義するとグローバルに使用でき、各要素で上書きも可能です。var()の第2引数でフォールバック値を指定できます。'),

('css-transition', 3, 1,
 'CSSでプロパティの変化をスムーズにアニメーション化するプロパティは？',
 '正解はtransitionです。transition: all 0.3s easeのように指定し、プロパティ名・時間・イージング・遅延を設定します。:hoverなどの状態変化時に滑らかなアニメーションを実現します。animationはキーフレームベースのアニメーション用です。'),

('css-animation-keyframe', 3, 1,
 'CSSでキーフレームアニメーションを定義する正しい構文は？',
 '正解は@keyframes アニメーション名 { from { } to { } }です。0%〜100%で中間のステップも定義できます。animationプロパティでアニメーション名、時間、イージング、繰り返し回数などを指定します。'),

('css-transform', 3, 1,
 'CSSで要素を回転・拡大・移動させるプロパティは？',
 '正解はtransformです。rotate(45deg)で回転、scale(1.5)で拡大、translateX(20px)で移動、skew(10deg)で傾斜を適用します。複数の変形を同時に適用でき、transitionと組み合わせてアニメーション化できます。'),

('css-z-index', 3, 1,
 'CSSで要素の重なり順を制御するプロパティは？',
 '正解はz-indexです。値が大きいほど前面に表示されます。z-indexはposition: static以外（relative、absolute、fixed、sticky）の要素にのみ有効です。スタッキングコンテキストの理解も重要です。'),

('css-display-none-visibility', 3, 1,
 'display: noneとvisibility: hiddenの違いは？',
 '正解はdisplay: noneは要素がレイアウトから完全に消え、visibility: hiddenは見えないがスペースを占有することです。display: noneはDOMには存在しますがレンダリングされず周囲の要素が詰まります。opacity: 0も見えなくなりますがスペースは占有します。'),

('css-rem-em', 3, 1,
 'CSSのrem単位とem単位の違いは？',
 '正解はremはルート要素のフォントサイズ基準、emは親要素のフォントサイズ基準であることです。remは常にhtml要素のfont-sizeを基準にするため予測しやすく、emはネストすると計算が複雑になります。レスポンシブデザインではremの使用が推奨されます。'),

('css-overflow', 3, 1,
 'CSSで要素のコンテンツがはみ出した時の処理を指定するプロパティは？',
 '正解はoverflowです。hiddenではみ出し部分を非表示、scrollでスクロールバーを常に表示、autoで必要な時のみスクロールバーを表示します。overflow-xとoverflow-yで水平・垂直を個別に設定できます。'),

('css-object-fit', 3, 1,
 'CSSで画像のアスペクト比を保持しながらコンテナにフィットさせるプロパティは？',
 '正解はobject-fitです。coverでアスペクト比を保ちながらコンテナ全体を覆い、containでコンテナ内に収まるように表示します。fillは引き伸ばし、noneは元サイズで表示します。background-sizeは背景画像用です。'),

('css-gap', 3, 1,
 'FlexboxやGridで要素間の余白を設定するプロパティは？',
 '正解はgapです。gap: 16pxで行と列の両方に余白を設定でき、row-gapとcolumn-gapで個別に指定もできます。以前はgrid-gapでしたが現在はgapに統一され、FlexboxとGridの両方で使用できます。'),

('css-clamp-function', 3, 1,
 'CSSのclamp()関数の正しい使い方は？',
 '正解はclamp(最小値, 推奨値, 最大値)です。例：font-size: clamp(1rem, 2.5vw, 2rem)で、フォントサイズが最小1rem、最大2remの範囲でビューポート幅に応じて変化します。メディアクエリなしにレスポンシブなサイズ調整ができます。'),

('css-aspect-ratio', 3, 1,
 'CSSで要素のアスペクト比を指定するプロパティは？',
 '正解はaspect-ratioです。aspect-ratio: 16 / 9のように指定すると要素が常に16:9の比率を維持します。以前はpadding-topハック（padding-top: 56.25%）で実現していましたが、aspect-ratioプロパティで簡潔に記述できます。'),

('css-backdrop-filter', 3, 1,
 'CSSで要素の背後にぼかし効果を適用するプロパティは？',
 '正解はbackdrop-filterです。backdrop-filter: blur(10px)で背景にすりガラスのようなぼかし効果を適用できます。filterは要素自体に効果を適用しますがbackdrop-filterは要素の背後のコンテンツに適用されます。'),

('css-container-query', 3, 1,
 'CSSコンテナクエリの主な利点は？',
 '正解は親コンテナのサイズに応じてスタイルを変更できることです。メディアクエリがビューポートサイズに基づくのに対し、コンテナクエリは要素の親コンテナのサイズに基づいてスタイルを適用します。container-typeで設定し@containerで条件を指定します。'),

('css-will-change', 3, 1,
 'CSSのwill-changeプロパティの目的は？',
 '正解はブラウザに要素の変更予定を事前に通知してパフォーマンスを最適化することです。will-change: transformのように指定するとブラウザがGPUレイヤーを事前に作成するなどの最適化を行います。過度な使用はメモリ消費が増えるため注意が必要です。'),

('css-scroll-snap', 3, 1,
 'CSSでスクロール時にスナップ効果を実装するプロパティは？',
 '正解はscroll-snap-typeです。親要素にscroll-snap-type: x mandatoryを設定し、子要素にscroll-snap-align: startを指定します。カルーセルやセクション単位のスクロールをJavaScriptなしで実装できます。'),

('css-logical-properties', 3, 1,
 'CSS論理プロパティの利点は？',
 '正解は書字方向（writing-mode）に応じて自動的に適用方向が変わることです。margin-inline-startはLTR言語ではmargin-left、RTL言語ではmargin-rightに対応します。国際化対応のサイトで特に有用です。'),

('css-has-selector', 3, 1,
 'CSSの:has()セレクタの用途は？',
 '正解は特定の子要素や状態を持つ親要素を選択できることです。div:has(> img)は直接の子にimgを持つdivを選択します。従来CSSでは親要素の選択ができませんでしたが:has()により「親セレクタ」が実現しました。'),

('css-is-where-selector', 3, 1,
 'CSSの:is()と:where()の違いは？',
 '正解は:is()は内部セレクタの詳細度を持ち、:where()は詳細度が常に0であることです。:is(h1, h2, h3)はh1, h2, h3をまとめて選択でき、:where()も同じですが詳細度に影響しません。:where()は上書きしやすいベーススタイルに適しています。'),

('css-nesting', 3, 1,
 'CSSネイティブネスティングの正しい構文は？',
 '正解は.parent { & .child { color: red; } }です。Sass/LESSのようなネスト記述がCSS標準で可能になりました。&は親セレクタを参照し、.parent .childと同等になります。コードの可読性と保守性が向上します。'),

('css-color-function', 3, 1,
 'CSSで透明度を含む色を指定する現在推奨される関数は？',
 '正解はrgb()またはhsl()でスラッシュ区切りで透明度を指定する方法です。rgb(255 0 0 / 0.5)やhsl(0 100% 50% / 0.5)のように記述します。rgba()やhsla()も使用可能ですが、現在はrgb()とhsl()が透明度もサポートしており推奨されています。');

-- 選択肢（@start 〜 @start+38 の順。各4択）
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q79: specificity
(@start + 0, 'IDセレクタ（#id）', 1, 1),
(@start + 0, 'クラスセレクタ（.class）', 0, 2),
(@start + 0, '要素セレクタ（div）', 0, 3),
(@start + 0, '属性セレクタ（[attr]）', 0, 4),
-- Q80: box model
(@start + 1, 'content → padding → border → margin', 1, 1),
(@start + 1, 'margin → border → padding → content', 0, 2),
(@start + 1, 'content → border → padding → margin', 0, 3),
(@start + 1, 'padding → content → border → margin', 0, 4),
-- Q81: box-sizing
(@start + 2, 'width/heightにpaddingとborderが含まれる', 1, 1),
(@start + 2, 'width/heightにmarginが含まれる', 0, 2),
(@start + 2, 'paddingが無効になる', 0, 3),
(@start + 2, 'borderが外側に描画される', 0, 4),
-- Q82: justify-content
(@start + 3, 'justify-content', 1, 1),
(@start + 3, 'align-items', 0, 2),
(@start + 3, 'flex-direction', 0, 3),
(@start + 3, 'flex-wrap', 0, 4),
-- Q83: flexbox center
(@start + 4, 'display: flex; justify-content: center; align-items: center', 1, 1),
(@start + 4, 'display: flex; text-align: center; vertical-align: middle', 0, 2),
(@start + 4, 'display: flex; margin: 0 auto; align: center', 0, 3),
(@start + 4, 'display: flex; position: center; alignment: center', 0, 4),
-- Q84: flex-direction
(@start + 5, 'flex-direction', 1, 1),
(@start + 5, 'flex-flow', 0, 2),
(@start + 5, 'flex-order', 0, 3),
(@start + 5, 'flex-align', 0, 4),
-- Q85: flex-grow
(@start + 6, 'flex-grow', 1, 1),
(@start + 6, 'flex-expand', 0, 2),
(@start + 6, 'flex-fill', 0, 3),
(@start + 6, 'flex-stretch', 0, 4),
-- Q86: grid-template-columns
(@start + 7, 'grid-template-columns: repeat(3, 1fr)', 1, 1),
(@start + 7, 'grid-columns: 3', 0, 2),
(@start + 7, 'grid-layout: three-columns', 0, 3),
(@start + 7, 'columns: 3', 0, 4),
-- Q87: grid-template-areas
(@start + 8, 'grid-template-areas', 1, 1),
(@start + 8, 'grid-layout-areas', 0, 2),
(@start + 8, 'grid-named-regions', 0, 3),
(@start + 8, 'grid-area-template', 0, 4),
-- Q88: auto-fill
(@start + 9, 'repeat(auto-fill, minmax(200px, 1fr))', 1, 1),
(@start + 9, 'repeat(auto, 200px)', 0, 2),
(@start + 9, 'grid-auto-columns: 200px', 0, 3),
(@start + 9, 'columns: auto 200px', 0, 4),
-- Q89: position fixed
(@start + 10, 'fixed', 1, 1),
(@start + 10, 'absolute', 0, 2),
(@start + 10, 'sticky', 0, 3),
(@start + 10, 'relative', 0, 4),
-- Q90: position sticky
(@start + 11, 'スクロール時に指定した位置に到達すると固定される', 1, 1),
(@start + 11, '常にビューポートに対して固定される', 0, 2),
(@start + 11, '親要素に対して相対的に配置される', 0, 3),
(@start + 11, '通常のフローから完全に外れる', 0, 4),
-- Q91: media query
(@start + 12, '@media (max-width: 768px) { ... }', 1, 1),
(@start + 12, '@screen (width < 768px) { ... }', 0, 2),
(@start + 12, '@responsive (mobile) { ... }', 0, 3),
(@start + 12, '@device (smartphone) { ... }', 0, 4),
-- Q92: hover
(@start + 13, ':hover', 1, 1),
(@start + 13, ':active', 0, 2),
(@start + 13, ':visited', 0, 3),
(@start + 13, ':focus', 0, 4),
-- Q93: ::before
(@start + 14, '::before', 1, 1),
(@start + 14, '::after', 0, 2),
(@start + 14, ':first-child', 0, 3),
(@start + 14, ':before-content', 0, 4),
-- Q94: nth-child
(@start + 15, ':nth-child(odd)または:nth-child(2n+1)', 1, 1),
(@start + 15, ':nth-child(even)', 0, 2),
(@start + 15, ':first-child', 0, 3),
(@start + 15, ':only-child', 0, 4),
-- Q95: child selector
(@start + 16, '>（子セレクタ）', 1, 1),
(@start + 16, ' （半角スペース・子孫セレクタ）', 0, 2),
(@start + 16, '~（一般兄弟セレクタ）', 0, 3),
(@start + 16, '+（隣接兄弟セレクタ）', 0, 4),
-- Q96: attribute selector
(@start + 17, '[属性名]または[属性名="値"]', 1, 1),
(@start + 17, '{属性名="値"}', 0, 2),
(@start + 17, '(属性名="値")', 0, 3),
(@start + 17, '#属性名="値"', 0, 4),
-- Q97: CSS variables
(@start + 18, '--main-color: #333で定義しvar(--main-color)で参照', 1, 1),
(@start + 18, '$main-color: #333で定義し$main-colorで参照', 0, 2),
(@start + 18, '@main-color: #333で定義し@main-colorで参照', 0, 3),
(@start + 18, 'const main-color = #333で定義', 0, 4),
-- Q98: transition
(@start + 19, 'transition', 1, 1),
(@start + 19, 'animation', 0, 2),
(@start + 19, 'transform', 0, 3),
(@start + 19, 'effect', 0, 4),
-- Q99: keyframes
(@start + 20, '@keyframes アニメーション名 { from { } to { } }', 1, 1),
(@start + 20, '@animation { start { } end { } }', 0, 2),
(@start + 20, '@transition { 0% { } 100% { } }', 0, 3),
(@start + 20, '@frames { begin { } finish { } }', 0, 4),
-- Q100: transform
(@start + 21, 'transform', 1, 1),
(@start + 21, 'translate', 0, 2),
(@start + 21, 'modify', 0, 3),
(@start + 21, 'deform', 0, 4),
-- Q101: z-index
(@start + 22, 'z-index', 1, 1),
(@start + 22, 'layer', 0, 2),
(@start + 22, 'stack-order', 0, 3),
(@start + 22, 'depth', 0, 4),
-- Q102: display none vs visibility hidden
(@start + 23, 'display: noneは要素がレイアウトから消え、visibility: hiddenはスペースを占有する', 1, 1),
(@start + 23, '両者に違いはない', 0, 2),
(@start + 23, 'display: noneはスペースを占有し、visibility: hiddenは消える', 0, 3),
(@start + 23, 'display: noneはCSSのみ、visibility: hiddenはHTMLの属性', 0, 4),
-- Q103: rem vs em
(@start + 24, 'remはルート要素基準、emは親要素基準', 1, 1),
(@start + 24, 'remは親要素基準、emはルート要素基準', 0, 2),
(@start + 24, '両者に違いはない', 0, 3),
(@start + 24, 'remはピクセル基準、emはパーセント基準', 0, 4),
-- Q104: overflow
(@start + 25, 'overflow', 1, 1),
(@start + 25, 'clip', 0, 2),
(@start + 25, 'text-overflow', 0, 3),
(@start + 25, 'content-fit', 0, 4),
-- Q105: object-fit
(@start + 26, 'object-fit', 1, 1),
(@start + 26, 'background-size', 0, 2),
(@start + 26, 'image-fit', 0, 3),
(@start + 26, 'contain-fit', 0, 4),
-- Q106: gap
(@start + 27, 'gap', 1, 1),
(@start + 27, 'spacing', 0, 2),
(@start + 27, 'gutter', 0, 3),
(@start + 27, 'margin-between', 0, 4),
-- Q107: clamp
(@start + 28, 'clamp(最小値, 推奨値, 最大値)', 1, 1),
(@start + 28, 'clamp(推奨値, 最小値, 最大値)', 0, 2),
(@start + 28, 'clamp(最大値, 推奨値, 最小値)', 0, 3),
(@start + 28, 'clamp(最小値, 最大値)', 0, 4),
-- Q108: aspect-ratio
(@start + 29, 'aspect-ratio', 1, 1),
(@start + 29, 'ratio', 0, 2),
(@start + 29, 'size-ratio', 0, 3),
(@start + 29, 'proportion', 0, 4),
-- Q109: backdrop-filter
(@start + 30, 'backdrop-filter', 1, 1),
(@start + 30, 'filter', 0, 2),
(@start + 30, 'background-filter', 0, 3),
(@start + 30, 'blur-behind', 0, 4),
-- Q110: container query
(@start + 31, '親コンテナのサイズに応じてスタイルを変更できる', 1, 1),
(@start + 31, 'ビューポートのサイズに応じてスタイルを変更する', 0, 2),
(@start + 31, '要素自身のサイズに応じてスタイルを変更する', 0, 3),
(@start + 31, 'コンテナの色に応じてスタイルを変更する', 0, 4),
-- Q111: will-change
(@start + 32, 'ブラウザに要素の変更予定を通知してパフォーマンスを最適化する', 1, 1),
(@start + 32, '要素の変更を禁止する', 0, 2),
(@start + 32, '要素の変更を検知してイベントを発火する', 0, 3),
(@start + 32, '要素の変更履歴を記録する', 0, 4),
-- Q112: scroll-snap
(@start + 33, 'scroll-snap-type', 1, 1),
(@start + 33, 'scroll-behavior', 0, 2),
(@start + 33, 'scroll-align', 0, 3),
(@start + 33, 'scroll-lock', 0, 4),
-- Q113: logical properties
(@start + 34, '書字方向に応じて自動的に適用方向が変わる', 1, 1),
(@start + 34, 'プロパティの計算を自動化する', 0, 2),
(@start + 34, '条件分岐でスタイルを適用する', 0, 3),
(@start + 34, 'プログラミング的にスタイルを記述する', 0, 4),
-- Q114: :has()
(@start + 35, '特定の子要素や状態を持つ親要素を選択できる', 1, 1),
(@start + 35, '要素の属性値を判定する', 0, 2),
(@start + 35, '要素の存在を確認する', 0, 3),
(@start + 35, '要素の兄弟関係を判定する', 0, 4),
-- Q115: :is() vs :where()
(@start + 36, ':is()は内部セレクタの詳細度を持ち、:where()は詳細度が常に0', 1, 1),
(@start + 36, ':is()はIDセレクタ用、:where()はクラスセレクタ用', 0, 2),
(@start + 36, '両者に違いはない', 0, 3),
(@start + 36, ':is()はグループ化用、:where()は条件分岐用', 0, 4),
-- Q116: nesting
(@start + 37, '.parent { & .child { color: red; } }', 1, 1),
(@start + 37, '.parent { .child { color: red; } }のみ（&不要）', 0, 2),
(@start + 37, '.parent >> .child { color: red; }', 0, 3),
(@start + 37, '.parent @nest .child { color: red; }', 0, 4),
-- Q117: color function
(@start + 38, 'rgb()またはhsl()でスラッシュ区切りで透明度を指定', 1, 1),
(@start + 38, 'color()関数のみ使用可能', 0, 2),
(@start + 38, 'opacity()関数で色の透明度を指定', 0, 3),
(@start + 38, 'transparent()関数で透明色を作成', 0, 4);