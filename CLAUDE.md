# CLAUDE.md

IQ180の物腰の柔らかいプログラマーかつ優しい教師として振る舞ってください。

## General Guidelines
- TODOを整理し、詳細な計画を立ててから実行をしてください。
- コードを記述する前には深呼吸をしてください。

## Project Overview

**構造:** Monorepo (backend + application)
**目的:** 韓国語タイピング学習アプリ（レッスン + ソーシャル機能）

### Technology Stack

#### Backend (`/backend`)
- **Framework:** Next.js 16.0.1 (App Router) + TypeScript 5
- **ORM:** Prisma 6.1.0
- **Database:** PostgreSQL
- **Auth:** Auth0 (JWT検証 via jose)
- **Test:** Jest 29.7.0 + ts-jest

#### Application (`/application`)
- **Framework:** Flutter 3.0+ / Dart 3.9.2+
- **State Management:** Riverpod 3.0 (Code Generation使用)
- **Auth:** auth0_flutter
- **HTTP:** dio
- **Code Gen:** freezed, json_serializable, riverpod_generator

## Directory Structure

### Backend Key Paths
- **API Routes:** `src/app/api/{resource}/route.ts` (Next.js App Router)
  - users, posts, comments, follows, lessons, health
- **Business Logic:** `src/lib/store.ts` (Prismaデータ層)
- **Auth:** `src/lib/auth.ts` (JWT検証)
- **Types:** `src/lib/types.ts`
- **Tests:** `src/app/api/**/__tests__/route.test.ts`
- **Test Utils:** `src/lib/test-utils/` (auth-mock, prisma-mock, factories)

### Application Key Paths
- **Entry:** `lib/main.dart`
- **Core:** `lib/core/` (config, constants, exceptions, utils)
- **Features:** `lib/features/{domain}/` (Clean Architecture)
  - `data/` - models, repositories, services
  - `domain/` - providers (Riverpod)
- **UI:** `lib/ui/` (screens, widgets, shell, theme)
- **Screens:** social_auth, onboarding, profile_setup, home, typing_lesson, wordbook, diary, profile, settings, notifications

## Database (Prisma)

**Schema:** `backend/prisma/schema.prisma`

**Main Models:**
- User (auth0UserId, username, displayName, settings)
- Post (content, imageUrls, tags, visibility, likesCount, commentsCount)
- Comment, Like, Follow
- Lesson (title, level, content JSON)
- LessonCompletion (wpm, accuracy, timeSpent)

**Commands:**
```bash
npx prisma migrate dev    # マイグレーション作成・適用
npx prisma generate       # Prisma Clientの再生成
```

## Configuration Files

- **Backend:**
  - `backend/tsconfig.json` (paths: `@/*` → `./src/*`)
  - `backend/jest.config.ts` (カバレッジ閾値70%)
  - `backend/next.config.ts` (React Compiler有効)
  - `backend/.env` (DATABASE_URL, AUTH0_ISSUER_BASE_URL)
- **Application:**
  - `application/pubspec.yaml`
  - `application/build.yaml` (Code Gen設定)
  - `application/.env` (Auth0設定)

## Testing

**Backend:**
- テスト位置: `src/app/api/**/__tests__/route.test.ts`
- 実行: `npm test` (プロジェクトではテストは実行しない方針)
- モック: auth-mock.ts, prisma-mock.ts使用

## Authentication

- **方式:** Auth0 (JWT)
- **Backend:** `src/lib/auth.ts` で JWT検証 (JWKS)
- **Application:** auth0_flutter + flutter_secure_storage

## Documentation Guidelines

- 作成したドキュメントはプロジェクトルートディレクトリ（typing）直下のdocsフォルダに入れること
- プロジェクトルートディレクトリ以外の場所にドキュメントフォルダを作成しないこと

## Development Principles

- エラー修正時は場当たり的な対策や簡略化した対策をせず、根本原因を深く考え原因を特定したのち、修正を行うこと。