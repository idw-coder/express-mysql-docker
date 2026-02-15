-- Vue.js基礎クイズ シードデータ（動的ID対応版）
-- 実行例: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-vue.sql

SET NAMES utf8mb4;

-- --------------------------------------------------------
-- 1. カテゴリIDを動的に決定して登録
-- --------------------------------------------------------

-- 既存の 'vue-basic' があればそのIDを、なければ MAX(id)+1 を @cat_id にセット
SET @target_slug = 'vue-basic';
SELECT @cat_id := id FROM quiz_category WHERE slug = @target_slug;

-- まだ存在しない場合、新しいIDを発番
SET @cat_id = COALESCE(@cat_id, (SELECT COALESCE(MAX(id), 0) + 1 FROM quiz_category));

-- カテゴリを登録（idには動的に決めた @cat_id を使用）
INSERT IGNORE INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (@cat_id, @target_slug, 'Vue.js基礎・実践', 1, 'Vue 2/3の基本概念、Options/Composition API、ディレクティブ、ライフサイクルに関する問題です。', @cat_id);


-- --------------------------------------------------------
-- 2. クイズデータの登録準備
-- --------------------------------------------------------

-- 既存の quiz の最大 id の次から採番開始位置を決定
SELECT @quiz_start := COALESCE(MAX(id), 0) + 1 FROM quiz;

-- AUTO_INCREMENT をリセット（オプション：連番を綺麗に保ちたい場合）
SET @alter_sql = CONCAT('ALTER TABLE quiz AUTO_INCREMENT = ', @quiz_start);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- --------------------------------------------------------
-- 3. クイズ本体の登録（category_id には @cat_id を使用）
-- --------------------------------------------------------

INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('vue-v-if-vs-v-show', @cat_id, 1,
 '「v-if」と「v-show」の決定的な違いは？',
 '正解は「v-if」は条件が偽の場合DOM自体を削除・生成するのに対し、「v-show」はCSSのdisplayプロパティで表示・非表示を切り替える点です。頻繁に切り替える要素には「v-show」、初期描画コストを下げたい場合や切り替え頻度が低い場合は「v-if」が推奨されます。'),

('vue-data-binding-syntax', @cat_id, 1,
 'テキスト補間（Interpolation）に使用される構文は？',
 '正解はMustache構文（二重中括弧 {{ }}）です。{{ message }} のように記述することで、dataやsetup内で定義された変数の値をHTMLにレンダリングできます。属性へのバインドにはv-bindを使用します。'),

('vue-composition-api-setup', @cat_id, 1,
 'Vue 3のComposition APIにおいて、コンポーネントのロジックを記述するエントリーポイントとなる関数は？',
 '正解はsetup()です。この関数内でリアクティブなデータやメソッドを定義し、returnすることでテンプレートから使用可能になります。また、<script setup>構文を使うことでより簡潔に記述できます。'),

('vue-reactivity-ref-reactive', @cat_id, 1,
 'Vue 3でプリミティブな値（数値や文字列）をリアクティブにするために推奨される関数は？',
 '正解はref()です。const count = ref(0)のように定義し、スクリプト内では.valueでアクセスします。一方、reactive()は主にオブジェクトや配列などの参照型に使用されますが、Vue 3開発ではrefで統一するスタイルも一般的です。'),

('vue-lifecycle-mounted', @cat_id, 1,
 'DOM要素にアクセス可能になるライフサイクルフックは？',
 '正解はmounted（Vue 3のComposition APIではonMounted）です。createdの時点ではDOMはまだ生成されていません。DOM操作や外部ライブラリの初期化はmountedで行うのが基本です。'),

('vue-computed-vs-methods', @cat_id, 1,
 '算出プロパティ（computed）とメソッド（methods）の主な違いは？',
 '正解はcomputedはリアクティブな依存関係に基づいてキャッシュされる点です。依存しているデータが変化しない限り、何度アクセスしても再計算されずキャッシュされた値を返します。methodsは呼び出されるたびに毎回実行されます。'),

('vue-list-rendering-key', @cat_id, 1,
 'v-forディレクティブを使用する際、必須で指定すべき属性は？',
 '正解はkey属性です。<li v-for="item in items" :key="item.id">のように、各要素を一意に識別できる値を指定することで、VueはDOMの更新を効率的かつ正確に行うことができます。indexをkeyにすることは、リストの並び替えなどでバグの原因になるため非推奨です。'),

('vue-event-handling-modifier', @cat_id, 1,
 'イベントの伝播（バブリング）を止めるためのイベント修飾子は？',
 '正解は.stopです。@click.stop="doSomething"のように記述すると、event.stopPropagation()と同様の効果を得られます。他にも.prevent（デフォルト挙動の抑止）や.once（一度だけ実行）などがあります。'),

('vue-two-way-binding', @cat_id, 1,
 'フォーム入力とデータを双方向バインディングするためのディレクティブは？',
 '正解はv-modelです。<input v-model="message">とすることで、入力値の変更が即座にデータに反映され、データの変更も入力欄に反映されます。内部的にはvalue属性とinputイベントの糖衣構文です。'),

('vue-3-fragments', @cat_id, 1,
 'Vue 3で導入された、コンポーネントが複数のルートノードを持つことができる機能は？',
 '正解はFragmentsです。Vue 2ではテンプレートの直下に単一のルート要素（通常はdiv）が必要でしたが、Vue 3では不要となり、<div> <header>...</header> <main>...</main> </div>のようにラップせずに記述できます。'),

('vue-props-one-way', @cat_id, 1,
 '親コンポーネントから子コンポーネントへデータを受け渡す仕組みは？',
 '正解はpropsです。データの流れは「単方向（親から子）」であり、子コンポーネント内でpropsの値を直接変更することはVueの警告対象となります。子から親へデータを送る場合はemitを使用します。'),

('vue-3-teleport', @cat_id, 1,
 'コンポーネントのHTMLを、DOMツリーの別の場所（body直下など）にレンダリングするVue 3の機能は？',
 '正解はTeleportです。<Teleport to="body">...</Teleport>のように使用し、モーダルウィンドウや通知など、CSSのz-index管理や親要素のoverflow設定の影響を受けたくないUI要素の実装に便利です。'),

('vue-lifecycle-rename', @cat_id, 1,
 'Vue 2の「destroyed」ライフサイクルは、Vue 3で何という名前に変更されたか？',
 '正解はunmountedです。同様に「beforeDestroy」は「beforeUnmount」に変更されました。これはコンポーネントがマウント（mount）されるという用語との対比を明確にするためです。'),

('vue-slot-content', @cat_id, 1,
 '親コンポーネントから子コンポーネントのテンプレートの一部を差し込む機能は？',
 '正解はslot（スロット）です。子コンポーネントに<slot></slot>を配置すると、親コンポーネントのタグで囲まれたコンテンツがその場所に展開されます。名前付きスロットやスコープ付きスロットで柔軟な構成が可能です。'),

('vue-state-management', @cat_id, 1,
 'Vueの公式状態管理ライブラリとして、Vuexの後継として推奨されているものは？',
 '正解はPiniaです。Vuexと比較して、よりシンプルで型推論（TypeScript）に強く、モジュール構造も直感的になっています。Vue 3のエコシステムではPiniaが標準となっています。'),

('vue-next-tick', @cat_id, 1,
 'データの変更後、DOMの更新が完了するのを待ってから処理を実行するメソッドは？',
 '正解はnextTick()です。VueのDOM更新は非同期で行われるため、データを変更した直後にDOM要素の幅や高さを取得しようとしても古い値のままの場合があります。await nextTick()を使うことで更新後を待機できます。'),

('vue-style-scoped', @cat_id, 1,
 'コンポーネント内のCSSをそのコンポーネントだけに適用させるための属性は？',
 '正解はscopedです。<style scoped>と記述すると、Vueは要素に一意のデータ属性（data-v-xxxx）を付与し、CSSセレクタを変換してスタイルのカプセル化を実現します。'),

('vue-router-link', @cat_id, 1,
 'Vue Routerにおいて、ページ遷移のためのリンクを作成するコンポーネントは？',
 '正解は<router-link>です。通常の<a>タグと異なり、ブラウザのリロードを発生させずにURLを変更し、ビューを切り替える（SPA動作）ことができます。レンダリング時は<a>タグに変換されます。'),

('vue-watch-vs-watcheffect', @cat_id, 1,
 'Vue 3において、特定のデータの変更を監視する「watch」と、依存関係を自動収集する「watchEffect」の違いは？',
 '正解は「watch」は監視対象を明示し、新旧の値を受け取れるのに対し、「watchEffect」は関数内で使用されたリアクティブな値を自動的に追跡し、即座に一度実行される点です。細かい制御にはwatch、手軽な副作用処理にはwatchEffectが適しています。'),

('vue-options-vs-composition', @cat_id, 1,
 'Options APIと比較した際のComposition APIの主なメリットは？',
 '正解は「論理的な関心事ごとのコードの整理と再利用」です。Options API（data, methods, mounted等が分散）では機能ごとのコードが離れがちですが、Composition APIでは特定の機能に関連するロジックをまとめて記述でき、「Composables」として切り出して再利用することが容易になります。');


-- --------------------------------------------------------
-- 4. 選択肢の登録（@quiz_start からの相対位置で紐付け）
-- --------------------------------------------------------

INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
-- Q1: v-if vs v-show
(@quiz_start + 0, 'v-ifはDOMを削除・生成し、v-showはCSSで表示切替を行う', 1, 1),
(@quiz_start + 0, 'v-ifはCSSで表示切替を行い、v-showはDOMを削除・生成する', 0, 2),
(@quiz_start + 0, 'v-showはVue 3で廃止された', 0, 3),
(@quiz_start + 0, '両者に動作の違いはない', 0, 4),

-- Q2: Interpolation
(@quiz_start + 1, '{{ message }}', 1, 1),
(@quiz_start + 1, '{ message }', 0, 2),
(@quiz_start + 1, '${ message }', 0, 3),
(@quiz_start + 1, '[[ message ]]', 0, 4),

-- Q3: setup()
(@quiz_start + 2, 'setup()', 1, 1),
(@quiz_start + 2, 'created()', 0, 2),
(@quiz_start + 2, 'init()', 0, 3),
(@quiz_start + 2, 'data()', 0, 4),

-- Q4: ref vs reactive
(@quiz_start + 3, 'ref()', 1, 1),
(@quiz_start + 3, 'reactive()', 0, 2),
(@quiz_start + 3, 'state()', 0, 3),
(@quiz_start + 3, 'computed()', 0, 4),

-- Q5: lifecycle mounted
(@quiz_start + 4, 'mounted / onMounted', 1, 1),
(@quiz_start + 4, 'created / onCreated', 0, 2),
(@quiz_start + 4, 'setup', 0, 3),
(@quiz_start + 4, 'beforeMount', 0, 4),

-- Q6: computed vs methods
(@quiz_start + 5, 'computedは結果がキャッシュされる', 1, 1),
(@quiz_start + 5, 'methodsは結果がキャッシュされる', 0, 2),
(@quiz_start + 5, 'computedは引数を取ることができる', 0, 3),
(@quiz_start + 5, 'methodsはリアクティブではない', 0, 4),

-- Q7: v-for key
(@quiz_start + 6, 'key', 1, 1),
(@quiz_start + 6, 'id', 0, 2),
(@quiz_start + 6, 'index', 0, 3),
(@quiz_start + 6, 'name', 0, 4),

-- Q8: Event modifiers
(@quiz_start + 7, '.stop', 1, 1),
(@quiz_start + 7, '.prevent', 0, 2),
(@quiz_start + 7, '.halt', 0, 3),
(@quiz_start + 7, '.block', 0, 4),

-- Q9: v-model
(@quiz_start + 8, 'v-model', 1, 1),
(@quiz_start + 8, 'v-bind', 0, 2),
(@quiz_start + 8, 'v-input', 0, 3),
(@quiz_start + 8, 'v-sync', 0, 4),

-- Q10: Fragments
(@quiz_start + 9, 'Fragments', 1, 1),
(@quiz_start + 9, 'Portals', 0, 2),
(@quiz_start + 9, 'Blocks', 0, 3),
(@quiz_start + 9, 'Sections', 0, 4),

-- Q11: Props
(@quiz_start + 10, 'props', 1, 1),
(@quiz_start + 10, 'emit', 0, 2),
(@quiz_start + 10, 'state', 0, 3),
(@quiz_start + 10, 'refs', 0, 4),

-- Q12: Teleport
(@quiz_start + 11, 'Teleport', 1, 1),
(@quiz_start + 11, 'Portal', 0, 2),
(@quiz_start + 11, 'Transport', 0, 3),
(@quiz_start + 11, 'Move', 0, 4),

-- Q13: Lifecycle rename
(@quiz_start + 12, 'unmounted', 1, 1),
(@quiz_start + 12, 'deleted', 0, 2),
(@quiz_start + 12, 'removed', 0, 3),
(@quiz_start + 12, 'disposed', 0, 4),

-- Q14: Slot
(@quiz_start + 13, 'slot', 1, 1),
(@quiz_start + 13, 'template', 0, 2),
(@quiz_start + 13, 'yield', 0, 3),
(@quiz_start + 13, 'block', 0, 4),

-- Q15: State Management
(@quiz_start + 14, 'Pinia', 1, 1),
(@quiz_start + 14, 'Redux', 0, 2),
(@quiz_start + 14, 'Vuex 5', 0, 3),
(@quiz_start + 14, 'Recoil', 0, 4),

-- Q16: nextTick
(@quiz_start + 15, 'nextTick()', 1, 1),
(@quiz_start + 15, 'setTimeout()', 0, 2),
(@quiz_start + 15, 'updateDOM()', 0, 3),
(@quiz_start + 15, 'forceUpdate()', 0, 4),

-- Q17: style scoped
(@quiz_start + 16, 'scoped', 1, 1),
(@quiz_start + 16, 'local', 0, 2),
(@quiz_start + 16, 'module', 0, 3),
(@quiz_start + 16, 'private', 0, 4),

-- Q18: router-link
(@quiz_start + 17, '<router-link>', 1, 1),
(@quiz_start + 17, '<a href="...">', 0, 2),
(@quiz_start + 17, '<link-to>', 0, 3),
(@quiz_start + 17, '<navigate>', 0, 4),

-- Q19: watch vs watchEffect
(@quiz_start + 18, 'watchは対象を明示、watchEffectは依存を自動収集', 1, 1),
(@quiz_start + 18, 'watchEffectは非同期処理専用', 0, 2),
(@quiz_start + 18, 'Vue 3ではwatchは廃止された', 0, 3),
(@quiz_start + 18, '両者に動作の違いはない', 0, 4),

-- Q20: Options vs Composition
(@quiz_start + 19, '論理的な関心事ごとのコード整理と再利用', 1, 1),
(@quiz_start + 19, 'コード量が必ず少なくなる', 0, 2),
(@quiz_start + 19, 'クラスベースの記述が可能になる', 0, 3),
(@quiz_start + 19, 'テンプレートが不要になる', 0, 4);