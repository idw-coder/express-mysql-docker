-- React基礎クイズ シードデータ
-- 実行例（プロジェクトルートで）: docker exec -i mysql mysql -u root -p myapp < db/seed-quiz-react.sql
-- 既存のクイズデータを削除してから投入します（author_id=1 を想定）

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM quiz_choice;
DELETE FROM quiz;
DELETE FROM quiz_category;

SET FOREIGN_KEY_CHECKS = 1;

-- カテゴリ（DELETE 後も AUTO_INCREMENT が残るため id=1 を明示）
INSERT INTO quiz_category (id, slug, category_name, author_id, description, display_order)
VALUES (1, 'react-basic', 'React基礎・実践', 1, 'Reactの基本概念、Hooks、コンポーネント設計に関する問題です。', 1);
ALTER TABLE quiz_category AUTO_INCREMENT = 2;

-- クイズ（category_id=1）。DELETE 後も AUTO_INCREMENT が残るためリセット
ALTER TABLE quiz AUTO_INCREMENT = 1;
INSERT INTO quiz (slug, category_id, author_id, question, explanation) VALUES
('react-usestate-hook', 1, 1, 'Reactでコンポーネントの状態を管理するために使用するHookは？', '正解はuseStateです。const [count, setCount] = useState(0)のように使用し、状態の値と更新関数を返します。useEffectは副作用の処理用、useContextはコンテキストの参照用、useReducerは複雑な状態管理用で、基本的な状態管理にはuseStateを使用します。'),
('react-useeffect-hook', 1, 1, 'Reactで副作用（side effects）を処理するために使用するHookは？', '正解はuseEffectです。API呼び出し、DOM操作、タイマー設定などの副作用を処理します。useEffect(() => { /* 処理 */ }, [依存配列])の形式で使用します。useStateは状態管理用、useMemoは計算結果のメモ化用、useCallbackは関数のメモ化用です。'),
('react-optimization-hooks', 1, 1, 'Reactでコンポーネントを最適化し、不要な再レンダリングを防ぐために使用するHookは？', '正解はuseMemoまたはuseCallbackです。useMemoは計算結果をメモ化し、useCallbackは関数をメモ化して、依存配列が変わらない限り同じ参照を返します。useStateは状態管理用、useEffectは副作用処理用、useRefは値の保持用で最適化目的ではありません。'),
('react-not-standard-feature', 1, 1, 'Reactの標準機能として間違っているものは？', 'Reduxは外部ライブラリであり、Reactの標準機能ではありません。Context APIはReact標準のデータ共有機能です。useState、useEffectもReact標準のHookです。Reduxは状態管理ライブラリとして人気ですが、別途インストールが必要です。'),
('react-conditional-rendering', 1, 1, 'Reactで条件付きレンダリングを行う際の正しい構文は？', '正解は{condition ? <Component /> : null}または{condition && <Component />}です。JSXの中ではJavaScriptの式のみ使用可能で、if文は使えません。三項演算子や&&演算子で条件分岐を行います。{if (condition)}やwhen...thenはJSXで無効な構文です。'),
('react-list-key-prop', 1, 1, 'Reactでリストをレンダリングする際に必要なプロパティは？', '正解はkeyです。keyプロパティは、Reactが各要素を一意に識別し、効率的にDOMを更新するために必要です。idはHTML属性、indexは配列のインデックス、refはDOM参照用で、Reactのリストレンダリングにはkeyを使用します。'),
('react-custom-hook-naming', 1, 1, 'ReactでカスタムHookを作成する際の命名規則は？', '正解は「useで始まる」です。useMyCustomHook、useFetchDataのように、必ず「use」で始める必要があります。これはReactがHookのルール（条件分岐内で呼ばない等）を検証するために必要です。hookやReactで始める規則はありません。'),
('react-controlled-component', 1, 1, 'Reactでフォームの入力値をstateで管理するコンポーネントの種類は？', '正解はControlled Componentです。value属性とonChangeハンドラでReactのstateと入力を同期させます。Uncontrolled Componentはrefを使用してDOM要素から直接値を取得する方式です。Form ComponentやInput Componentは正式な用語ではありません。'),
('react-memo-hoc', 1, 1, 'Reactでパフォーマンス最適化のために使用できる高階コンポーネントは？', '正解はReact.memoです。propsが変更されない限りコンポーネントの再レンダリングをスキップします。const MemoizedComponent = React.memo(Component)のように使用します。React.optimize、React.cache、React.fastはReactに存在しないAPIです。'),
('react-routing-library', 1, 1, 'Reactでルーティングを実装するために一般的に使用されるライブラリは？', '正解はReact Routerです。BrowserRouter、Route、Linkなどのコンポーネントを提供し、SPAのルーティングを実現します。React Routeは存在しません。React NavigationはReact Native用です。React LinkはReact Routerのコンポーネント名であり、ライブラリ名ではありません。'),
('react-useref-hook', 1, 1, 'ReactでDOM要素への参照を保持するために使用するHookは？', '正解はuseRefです。const inputRef = useRef(null)のように使用し、ref={inputRef}でDOM要素に接続します。再レンダリングを引き起こさずに値を保持できるため、タイマーIDの保存などにも使用されます。'),
('react-useeffect-cleanup', 1, 1, 'useEffectでクリーンアップ関数を返す目的は？', '正解はメモリリークの防止です。タイマーやイベントリスナーの解除、APIリクエストのキャンセルなどに使用します。useEffect(() => { return () => { /* クリーンアップ */ } }, [])の形式で、コンポーネントのアンマウント時や依存配列が変更された時に実行されます。'),
('react-useeffect-dependency', 1, 1, 'useEffectの依存配列を空配列[]にした場合の動作は？', '正解はマウント時のみ実行です。コンポーネントが初めてレンダリングされた時だけ実行され、その後の再レンダリングでは実行されません。依存配列を省略すると毎回実行、依存配列に値を指定するとその値が変更された時のみ実行されます。'),
('react-props-types', 1, 1, 'Reactでpropsの型チェックを行うために使用するライブラリは？', '正解はPropTypesです。React.PropTypes.string、React.PropTypes.numberのように使用します。TypeScriptを使用する場合は型定義で代替できます。PropTypesは開発モードでのみ動作し、本番ビルドでは削除されます。'),
('react-context-api', 1, 1, 'Reactでコンポーネントツリー全体でデータを共有する標準機能は？', '正解はContext APIです。createContext()でコンテキストを作成し、Providerで値を提供、useContext()で値を取得します。propsのバケツリレーを避けるために使用されます。Reduxは外部ライブラリです。'),
('react-usememo-usage', 1, 1, 'useMemoを使用する適切な場面は？', '正解は高コストな計算結果のメモ化です。useMemo(() => expensiveCalculation(a, b), [a, b])のように使用し、依存配列の値が変わらない限り計算結果を再利用します。単純な値の保持には不要で、過度な使用は逆にパフォーマンスを低下させる可能性があります。'),
('react-usecallback-usage', 1, 1, 'useCallbackを使用する適切な場面は？', '正解は子コンポーネントに渡す関数のメモ化です。useCallback(() => { /* 処理 */ }, [依存配列])で関数をメモ化し、依存配列が変わらない限り同じ関数参照を返します。React.memoと組み合わせて、不要な再レンダリングを防ぎます。'),
('react-component-lifecycle', 1, 1, '関数コンポーネントでライフサイクルメソッドの代わりに使用するのは？', '正解はuseEffectです。useEffect(() => { /* componentDidMount相当 */ }, [])でマウント時の処理、return文でcomponentWillUnmount相当のクリーンアップを実現できます。クラスコンポーネントのライフサイクルメソッドは関数コンポーネントでは使用できません。'),
('react-jsx-syntax', 1, 1, 'JSXでクラス名を指定する属性は？', '正解はclassNameです。JSXではclassはJavaScriptの予約語のため使用できず、代わりにclassNameを使用します。例：<div className="container">。idやstyleはそのまま使用できます。'),
('react-event-handler', 1, 1, 'Reactでイベントハンドラを定義する際の正しい命名規則は？', '正解はonClick、onChangeのようにonで始めることです。HTMLのonclickとは異なり、JSXではキャメルケースで記述します。例：<button onClick={handleClick}>。onClick、onChange、onSubmitなどが標準的なイベントハンドラです。'),
('react-fragment', 1, 1, 'Reactで複数の要素をラップせずに返す方法は？', '正解はFragment（<>...</>または<React.Fragment>...</React.Fragment>）です。不要なDOM要素を追加せずに複数の要素をグループ化できます。空のdivでラップするよりも意味的に正しく、DOMツリーが深くなりません。'),
('react-hooks-rules', 1, 1, 'React Hooksの使用に関するルールとして正しいのは？', '正解は条件分岐やループ内で呼び出さないことです。Hooksは常に同じ順序で呼び出される必要があり、トップレベルでのみ使用します。関数コンポーネントまたはカスタムHook内でのみ使用でき、クラスコンポーネントでは使用できません。'),
('react-props-spread', 1, 1, 'Reactでpropsを展開して渡す構文は？', '正解は<Component {...props} />です。スプレッド演算子を使用してオブジェクトの全プロパティをpropsとして渡せます。例：const props = { name: "John", age: 30 }; <User {...props} />は<User name="John" age={30} />と同等です。'),
('react-state-update-async', 1, 1, 'Reactの状態更新はどのように動作するか？', '正解は非同期でバッチ処理されることです。setStateやuseStateの更新関数は即座に反映されず、Reactが最適なタイミングでバッチ処理して更新します。複数の状態更新は1回の再レンダリングにまとめられることがあります。'),
('react-usestate-functional-update', 1, 1, 'useStateで前の状態値に基づいて更新する方法は？', '正解はsetCount(prev => prev + 1)のように関数形式で更新することです。前の状態値に依存する更新では、関数形式を使用することで最新の状態を確実に参照できます。setCount(count + 1)だと古い値が参照される可能性があります。'),
('react-error-boundary', 1, 1, 'Reactで子コンポーネントのエラーをキャッチする機能は？', '正解はError Boundaryです。クラスコンポーネントでcomponentDidCatchとgetDerivedStateFromErrorを実装するか、react-error-boundaryライブラリを使用します。関数コンポーネントでは直接実装できないため、ライブラリを使用するかクラスコンポーネントで実装します。'),
('react-portal', 1, 1, 'ReactでDOMツリーの外側にコンポーネントをレンダリングする機能は？', '正解はPortalです。ReactDOM.createPortal(child, container)を使用して、モーダルやツールチップなどをbody直下などにレンダリングできます。イベントの伝播はReactツリーに従うため、通常のコンポーネントと同じように動作します。'),
('react-lazy-suspense', 1, 1, 'Reactでコンポーネントの遅延読み込みを実装する組み合わせは？', '正解はReact.lazy()とSuspenseです。React.lazy(() => import("./Component"))でコンポーネントを遅延読み込みし、<Suspense fallback={<Loading />}>でラップします。コード分割によりバンドルサイズを削減し、初期読み込み時間を短縮できます。'),
('react-higher-order-component', 1, 1, 'Reactで高階コンポーネント（HOC）の特徴は？', '正解はコンポーネントを受け取って新しいコンポーネントを返す関数です。const EnhancedComponent = withAuth(Component)のように使用し、認証チェックやログ記録などの横断的関心事を追加できます。Hooksの登場により、多くの場合Hooksで代替可能になりました。'),
('react-render-props', 1, 1, 'ReactのRender Propsパターンの特徴は？', '正解はrenderプロパティに関数を渡してレンダリングロジックを共有することです。<DataProvider render={data => <Component data={data} />} />のように使用します。Hooksの登場により、多くの場合useContextやカスタムHookで代替可能になりました。'),
('react-strict-mode', 1, 1, 'React.StrictModeの主な目的は？', '正解は開発時の問題を検出することです。非推奨APIの警告、予期しない副作用の検出、レガシーなライフサイクルメソッドの警告などを表示します。本番環境では影響しません。アプリケーション全体を<React.StrictMode>でラップして使用します。'),
('react-useeffect-infinite-loop', 1, 1, 'useEffectで無限ループが発生する原因は？', '正解は依存配列の設定ミスです。useEffect内で状態を更新し、その状態が依存配列に含まれていると、更新→再実行→更新の無限ループが発生します。依存配列を適切に設定するか、更新条件を追加することで防げます。'),
('react-keys-index', 1, 1, 'Reactでリストのkeyに配列のインデックスを使用する問題点は？', '正解は要素の追加・削除・並び替え時に問題が発生することです。インデックスは要素の位置に基づくため、要素の順序が変わると正しく更新されない可能性があります。一意で安定したID（データベースのIDなど）を使用することが推奨されます。'),
('react-concurrent-features', 1, 1, 'React 18のConcurrent Featuresの主な利点は？', '正解はユーザー体験の向上です。startTransition、useDeferredValue、Suspenseの改善により、緊急でない更新を中断可能にし、UIの応答性を向上させます。レンダリングを優先度付けし、よりスムーズなインタラクションを実現します。'),
('react-server-components', 1, 1, 'React Server Componentsの主な特徴は？', '正解はサーバー側でレンダリングされ、クライアントに送信されないことです。データベースアクセスやファイルシステムへのアクセスを直接行え、バンドルサイズを削減できます。Next.js 13以降でサポートされています。'),
('react-testing-library', 1, 1, 'React Testing Libraryの推奨されるテスト方法は？', '正解はユーザーの視点でテストすることです。実装の詳細ではなく、ユーザーが実際に操作する方法（テキスト入力、ボタンクリックなど）でテストします。getByRole、getByTextなどのクエリを使用して、ユーザーが期待する動作を検証します。'),
('react-performance-profiler', 1, 1, 'Reactでパフォーマンスを測定するために使用するコンポーネントは？', '正解はProfilerです。<React.Profiler id="App" onRender={callback}>でコンポーネントのレンダリング時間を測定できます。開発ツールのReact DevTools Profilerでも同様の測定が可能です。本番環境では使用を避けるべきです。'),
('react-hydration-error', 1, 1, 'Reactでハイドレーションエラーが発生する主な原因は？', '正解はサーバーとクライアントのレンダリング結果が一致しないことです。SSR（Server-Side Rendering）でサーバー側とクライアント側のHTMLが異なると発生します。日付やランダム値の使用、ブラウザ専用APIの使用などが原因になることがあります。'),
('react-forwardref', 1, 1, 'React.forwardRefの主な用途は？', '正解はrefを子コンポーネントに転送することです。const Component = React.forwardRef((props, ref) => <input ref={ref} />)のように使用し、親コンポーネントから子コンポーネントのDOM要素に直接アクセスできるようにします。フォームライブラリなどでよく使用されます。');

-- 選択肢（quiz_id 1〜39 の順。各4択）
INSERT INTO quiz_choice (quiz_id, choice_text, is_correct, display_order) VALUES
(1, 'useState', 1, 1),(1, 'useEffect', 0, 2),(1, 'useContext', 0, 3),(1, 'useReducer', 0, 4),
(2, 'useEffect', 1, 1),(2, 'useState', 0, 2),(2, 'useMemo', 0, 3),(2, 'useCallback', 0, 4),
(3, 'useMemo または useCallback', 1, 1),(3, 'useState', 0, 2),(3, 'useEffect', 0, 3),(3, 'useRef', 0, 4),
(4, 'Context API', 0, 1),(4, 'Redux', 1, 2),(4, 'useState', 0, 3),(4, 'useEffect', 0, 4),
(5, '{condition ? <Component /> : null} または {condition && <Component />}', 1, 1),(5, '{if (condition) <Component />}', 0, 2),(5, '{condition ? <Component />}', 0, 3),(5, '{when condition then <Component />}', 0, 4),
(6, 'key', 1, 1),(6, 'id', 0, 2),(6, 'index', 0, 3),(6, 'ref', 0, 4),
(7, 'useで始まる', 1, 1),(7, 'hookで始まる', 0, 2),(7, 'Reactで始まる', 0, 3),(7, '特に規則はない', 0, 4),
(8, 'Controlled Component', 1, 1),(8, 'Uncontrolled Component', 0, 2),(8, 'Form Component', 0, 3),(8, 'Input Component', 0, 4),
(9, 'React.memo', 1, 1),(9, 'React.optimize', 0, 2),(9, 'React.cache', 0, 3),(9, 'React.fast', 0, 4),
(10, 'React Router', 1, 1),(10, 'React Route', 0, 2),(10, 'React Navigation', 0, 3),(10, 'React Link', 0, 4),
(11, 'useRef', 1, 1),(11, 'useState', 0, 2),(11, 'useMemo', 0, 3),(11, 'useCallback', 0, 4),
(12, 'メモリリークの防止', 1, 1),(12, 'パフォーマンスの向上', 0, 2),(12, '状態のリセット', 0, 3),(12, 'エラーの防止', 0, 4),
(13, 'マウント時のみ実行', 1, 1),(13, '毎回実行', 0, 2),(13, 'アンマウント時のみ実行', 0, 3),(13, '実行されない', 0, 4),
(14, 'PropTypes', 1, 1),(14, 'TypeCheck', 0, 2),(14, 'PropValidator', 0, 3),(14, 'ReactTypes', 0, 4),
(15, 'Context API', 1, 1),(15, 'Redux', 0, 2),(15, 'MobX', 0, 3),(15, 'Zustand', 0, 4),
(16, '高コストな計算結果のメモ化', 1, 1),(16, 'すべての計算結果のメモ化', 0, 2),(16, '状態の管理', 0, 3),(16, '副作用の処理', 0, 4),
(17, '子コンポーネントに渡す関数のメモ化', 1, 1),(17, 'すべての関数のメモ化', 0, 2),(17, 'DOM要素への参照', 0, 3),(17, '状態の更新', 0, 4),
(18, 'useEffect', 1, 1),(18, 'useState', 0, 2),(18, 'useLifecycle', 0, 3),(18, 'useMount', 0, 4),
(19, 'className', 1, 1),(19, 'class', 0, 2),(19, 'class-name', 0, 3),(19, 'cssClass', 0, 4),
(20, 'onClick、onChangeのようにonで始める', 1, 1),(20, 'handleClick、handleChangeのようにhandleで始める', 0, 2),(20, 'click、changeのように小文字で記述', 0, 3),(20, '特に規則はない', 0, 4),
(21, 'Fragment（<>...</>）', 1, 1),(21, '空のdivでラップ', 0, 2),(21, 'spanでラップ', 0, 3),(21, '配列で返す', 0, 4),
(22, '条件分岐やループ内で呼び出さない', 1, 1),(22, 'クラスコンポーネントでも使用できる', 0, 2),(22, 'どこでも呼び出せる', 0, 3),(22, 'useStateのみ使用可能', 0, 4),
(23, '<Component {...props} />', 1, 1),(23, '<Component props={props} />', 0, 2),(23, '<Component *props />', 0, 3),(23, '<Component ...props />', 0, 4),
(24, '非同期でバッチ処理される', 1, 1),(24, '同期的に即座に反映される', 0, 2),(24, '次のフレームで反映される', 0, 3),(24, '手動で反映する必要がある', 0, 4),
(25, 'setCount(prev => prev + 1)のように関数形式で更新', 1, 1),(25, 'setCount(count + 1)のように直接更新', 0, 2),(25, 'useEffect内で更新', 0, 3),(25, 'useRefで更新', 0, 4),
(26, 'Error Boundary', 1, 1),(26, 'try-catch', 0, 2),(26, 'useError', 0, 3),(26, 'ErrorHandler', 0, 4),
(27, 'Portal', 1, 1),(27, 'Fragment', 0, 2),(27, 'Overlay', 0, 3),(27, 'Layer', 0, 4),
(28, 'React.lazy()とSuspense', 1, 1),(28, 'useLazy()とuseSuspense()', 0, 2),(28, 'import()とuseEffect()', 0, 3),(28, 'React.load()とLoading', 0, 4),
(29, 'コンポーネントを受け取って新しいコンポーネントを返す関数', 1, 1),(29, '状態を持つコンポーネント', 0, 2),(29, '子要素を受け取るコンポーネント', 0, 3),(29, 'イベントハンドラを持つコンポーネント', 0, 4),
(30, 'renderプロパティに関数を渡してレンダリングロジックを共有', 1, 1),(30, 'propsを直接レンダリングする', 0, 2),(30, 'コンポーネントを返す関数', 0, 3),(30, '状態を管理するパターン', 0, 4),
(31, '開発時の問題を検出する', 1, 1),(31, 'パフォーマンスを向上させる', 0, 2),(31, 'エラーを自動修正する', 0, 3),(31, '本番環境でのみ動作する', 0, 4),
(32, '依存配列の設定ミス', 1, 1),(32, 'useStateの使用', 0, 2),(32, 'useEffectの使用自体', 0, 3),(32, 'コンポーネントの再レンダリング', 0, 4),
(33, '要素の追加・削除・並び替え時に問題が発生する', 1, 1),(33, 'パフォーマンスが低下する', 0, 2),(33, 'エラーが発生する', 0, 3),(33, '特に問題はない', 0, 4),
(34, 'ユーザー体験の向上', 1, 1),(34, 'バンドルサイズの削減', 0, 2),(34, 'メモリ使用量の削減', 0, 3),(34, '開発速度の向上', 0, 4),
(35, 'サーバー側でレンダリングされ、クライアントに送信されない', 1, 1),(35, 'クライアント側でのみ動作する', 0, 2),(35, '状態を持つことができる', 0, 3),(35, 'イベントハンドラを使用できる', 0, 4),
(36, 'ユーザーの視点でテストする', 1, 1),(36, 'コンポーネントの内部実装をテストする', 0, 2),(36, '状態の値を直接テストする', 0, 3),(36, 'propsの構造をテストする', 0, 4),
(37, 'Profiler', 1, 1),(37, 'Performance', 0, 2),(37, 'Timer', 0, 3),(37, 'Measure', 0, 4),
(38, 'サーバーとクライアントのレンダリング結果が一致しない', 1, 1),(38, 'useStateの使用', 0, 2),(38, 'useEffectの使用', 0, 3),(38, 'propsの変更', 0, 4),
(39, 'refを子コンポーネントに転送する', 1, 1),(39, 'propsを転送する', 0, 2),(39, 'イベントを転送する', 0, 3),(39, '状態を転送する', 0, 4);
