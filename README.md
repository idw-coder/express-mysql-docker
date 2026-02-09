Express + MySQL + TypeScript Docker環境構築

プロジェクト名: express-mysql-docker

技術スタック
- Node.js 20 (LTS)
- Express 5.0.0
- MySQL 8.4.0
- TypeScript 5.7.3
- Docker Compose

最終的なディレクトリ構造
express-mysql-docker/
├── .env
├── .env.example
├── .gitignore
├── docker-compose.yml
├── docker-compose.prod.yml
├── initdb/ (空ディレクトリ)
└── backend/
    ├── Dockerfile
    ├── package.json
    ├── package-lock.json
    ├── tsconfig.json
    ├── nodemon.json
    ├── node_modules/
    ├── src/
    │   └── index.ts
    └── dist/ (ビルド後に生成)

環境変数設定 (.env)
COMPOSE_PROJECT_NAME=express-mysql-docker
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=myapp
MYSQL_USER=appuser
MYSQL_PASSWORD=apppassword
NODE_ENV=development
DB_HOST=mysql
DB_PORT=3306
DB_USER=appuser
DB_PASSWORD=apppassword
DB_NAME=myapp
BACKEND_PORT=8888

docker-compose.yml (開発環境)
services: mysql (8.4.0), backend
mysqlは3306ポート公開、healthcheck設定済み
backendはnodemon使用、ボリュームマウントあり、ホットリロード対応
backendはmysqlのhealthyを待ってから起動

docker-compose.prod.yml (本番環境)
開発版との違いは command: npm start、NODE_ENV: production、ボリュームマウントなし、mysqlポート非公開

backend/Dockerfile
マルチステージビルド (base, dev, prod)
開発ステージは npm install + nodemon
本番ステージは npm ci --omit=dev + tsc build

backend/package.json
dependencies: express ^5.0.0, mysql2 ^3.16.3
devDependencies: typescript ^5.7.3, @types/express ^5.0.6, @types/node ^22.10.5, nodemon ^3.1.9, ts-node ^10.9.2
scripts: dev (nodemon), build (tsc), start (node dist/index.js)

backend/tsconfig.json
target: ES2020, module: commonjs
rootDir: ./src, outDir: ./dist
esModuleInterop: true, verbatimModuleSyntax: false
strict: true, skipLibCheck: true

backend/nodemon.json
watch: ["src"], ext: "ts", exec: "ts-node src/index.ts"

backend/src/index.ts
Express サーバー (ポート8888)
エンドポイント: GET / (ヘルスチェック), GET /db (MySQL接続テスト)
環境変数からDB接続情報取得
mysql2/promise使用

動作確認済み
開発環境: docker compose up で起動成功、curl http://localhost:8888/ → {"message":"health check"}、curl http://localhost:8888/db → {"message":"Database connection successful"}
本番環境: docker compose -f docker-compose.prod.yml up --build で起動成功、同様に動作確認済み


構築過程で解決した技術的な問題
TypeScriptのesModuleInterop設定が不足していたため、import express構文でエラー発生。esModuleInterop: true と verbatimModuleSyntax: false を追加して解決
tsconfig.jsonでrootDirとoutDirをコメント解除し、ビルド成果物をdist/に出力するよう設定
Docker Composeのversionキーは不要 (Docker Compose V2以降は obsolete)
