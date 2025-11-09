# Korean Typing Backend

韓国語タイピング練習アプリのバックエンド API（Next.js）

## 技術スタック

- **Framework**: Next.js 16 (App Router)
- **Database**: PostgreSQL (開発環境: Docker / 本番環境: Neon)
- **ORM**: Prisma
- **Authentication**: Auth0
- **Hosting**: Vercel

## 前提条件

- Node.js 18.x 以上
- Docker & Docker Compose
- npm または yarn

## セットアップ

### 1. 依存関係のインストール

```bash
npm install
```

### 2. 環境変数の設定

`.env.example`をコピーして`.env`ファイルを作成します：

```bash
cp .env.example .env
```

`.env`ファイルを開き、必要な環境変数を設定します：

```env
# データベース接続情報（ローカル開発用）
DATABASE_URL="postgresql://korean_typing_user:korean_typing_password@localhost:5432/korean_typing_db?schema=public"

# Auth0設定（https://manage.auth0.com/ から取得）
AUTH0_DOMAIN=your-auth0-domain.auth0.com
AUTH0_CLIENT_ID=your-client-id
AUTH0_CLIENT_SECRET=your-client-secret
# ...その他
```

### 3. PostgreSQLの起動（Docker）

Docker Composeを使用してPostgreSQLを起動します：

```bash
# バックグラウンドで起動
docker compose up -d

# ログを確認
docker compose logs -f postgres

# 停止
docker compose down

# データベースを削除して再起動（データが削除されます）
docker compose down -v
docker compose up -d
```

### 4. Prismaのセットアップ

データベースのマイグレーションとクライアントの生成を行います：

```bash
# Prismaクライアントの生成
npm run prisma:generate

# マイグレーションの実行
npm run prisma:migrate

# Prisma Studioでデータを確認（オプション）
npx prisma studio
```

### 5. 開発サーバーの起動

```bash
npm run dev
```

ブラウザで [http://localhost:3000](http://localhost:3000) を開いて確認します。

## 開発コマンド

### Next.js

```bash
# 開発サーバー起動
npm run dev

# ビルド
npm run build

# 本番モードで起動
npm run start

# Lintチェック
npm run lint
```

### Prisma

```bash
# Prismaクライアントの生成
npm run prisma:generate

# マイグレーションの作成と実行
npm run prisma:migrate

# マイグレーションの作成のみ
npx prisma migrate dev --name migration_name --create-only

# Prisma Studioを開く（GUI でデータ確認・編集）
npx prisma studio

# スキーマのフォーマット
npx prisma format
```

### テスト

```bash
# テスト実行
npm test

# ウォッチモード
npm run test:watch

# カバレッジ
npm run test:coverage

# 詳細表示
npm run test:verbose
```

## ディレクトリ構造

```
backend/
├── src/
│   ├── app/              # Next.js App Router
│   │   ├── api/          # API Routes
│   │   ├── layout.tsx
│   │   └── page.tsx
│   └── lib/              # ユーティリティ・ヘルパー
│       └── prisma.ts     # Prisma Client インスタンス
├── prisma/
│   └── schema.prisma     # データベーススキーマ
├── docker-compose.yml    # PostgreSQL用Docker設定
├── .env                  # 環境変数（ローカル）
├── .env.example          # 環境変数のテンプレート
└── package.json
```

## Docker コマンド

```bash
# コンテナの起動
docker compose up -d

# コンテナの停止
docker compose down

# ログ確認
docker compose logs -f postgres

# PostgreSQLに接続
docker compose exec postgres psql -U korean_typing_user -d korean_typing_db

# データベースのリセット（全データ削除）
docker compose down -v
docker compose up -d
npm run prisma:migrate
```

## トラブルシューティング

### PostgreSQLに接続できない

1. Dockerコンテナが起動しているか確認：
   ```bash
   docker compose ps
   ```

2. PostgreSQLのログを確認：
   ```bash
   docker compose logs postgres
   ```

3. ポート5432が既に使用されていないか確認：
   ```bash
   lsof -i :5432
   ```

### Prismaのマイグレーションエラー

1. データベース接続URLが正しいか確認（.envファイル）
2. PostgreSQLが起動しているか確認
3. データベースをリセット：
   ```bash
   docker compose down -v
   docker compose up -d
   npx prisma migrate reset
   ```

## 本番環境へのデプロイ

### Vercelへのデプロイ

1. Vercelプロジェクトを作成
2. 環境変数を設定（Vercel Dashboard）
3. Neon PostgreSQLをセットアップして`DATABASE_URL`を設定
4. Gitリポジトリと連携して自動デプロイ

```bash
# Vercel CLIでデプロイ
vercel
```

## 参考資料

- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Auth0 Documentation](https://auth0.com/docs)
- [Vercel Documentation](https://vercel.com/docs)

## ライセンス

Private
