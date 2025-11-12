# Flutter認証実装完了

## 実装完了日
2025-01-XX

## 概要
韓国語タイピングアプリのFlutter側に、Auth0認証とバックエンドAPI連携を使用した完全な認証フローを実装しました。

---

## 実装した機能

### 1. 依存関係の追加
`pubspec.yaml`に以下のパッケージを追加：

**Runtime Dependencies:**
- `flutter_riverpod: ^2.6.1` - 状態管理
- `riverpod_annotation: ^2.6.1` - Riverpodアノテーション
- `dio: ^5.9.0` - HTTPクライアント
- `flutter_secure_storage: ^9.2.2` - トークンの暗号化保存
- `flutter_dotenv: ^5.2.1` - 環境変数管理
- `json_annotation: ^4.9.0` - JSONシリアライゼーション

**Dev Dependencies:**
- `build_runner: ^2.4.15` - コード生成
- `riverpod_generator: ^2.6.2` - Riverpodコード生成
- `json_serializable: ^6.9.2` - JSONシリアライゼーション生成

### 2. 環境設定
- `.env` / `.env.example` ファイルを作成
- Auth0設定（Domain, ClientID, Audience）
- バックエンドAPI URL
- `.gitignore`に`.env`を追加

### 3. Coreレイヤー

#### `lib/core/config/env_config.dart`
- 環境変数の読み込みと管理
- Auth0設定の取得
- 環境変数のバリデーション

#### `lib/core/constants/api_constants.dart`
- すべてのAPIエンドポイントの定義
- 認証、ユーザー、投稿、フォロー、レッスン、通知など

#### `lib/core/utils/logger.dart`
- 統一されたログ出力
- APIリクエスト/レスポンスのログ
- 認証関連のログ

#### `lib/core/exceptions/app_exception.dart`
- カスタム例外クラス
- `AuthException` - 認証エラー
- `ApiException` - API呼び出しエラー
- `ValidationException` - バリデーションエラー

### 4. Dataレイヤー

#### Models (`lib/features/auth/data/models/`)
- **`auth_tokens.dart`**: Auth0トークン情報（アクセス、リフレッシュ、IDトークン）
- **`user_model.dart`**: ユーザー情報モデル（バックエンドのUser型に対応）
- **`user_status_response.dart`**:
  - `UserStatusResponse` - 登録状況確認レスポンス
  - `UserSetupRequest` - ユーザー登録リクエスト
  - `UsernameAvailabilityResponse` - username重複チェックレスポンス

#### Services (`lib/features/auth/data/services/`)
- **`token_storage_service.dart`**:
  - トークンの暗号化保存・取得・削除
  - `flutter_secure_storage`を使用

- **`auth0_service.dart`**:
  - Auth0 Universal Loginの実行
  - ログイン/ログアウト
  - トークンリフレッシュ
  - Authorization Code + PKCE フロー

- **`api_client_service.dart`**:
  - Dioインスタンスの管理
  - インターセプターの設定
  - トークンの自動付与（Authorizationヘッダー）
  - 401エラー時の自動リフレッシュ & リトライ
  - エラーハンドリング

#### Repository (`lib/features/auth/data/repositories/`)
- **`auth_repository.dart`**:
  - ログイン処理（Auth0 → トークン保存 → 登録状況確認）
  - ログアウト処理
  - 自動ログイン（アプリ起動時）
  - ユーザー登録（`POST /api/users/setup`）
  - 登録状況確認（`GET /api/users/status`）
  - Username重複チェック（`GET /api/users/check-username`）

### 5. Domainレイヤー

#### Providers (`lib/features/auth/domain/providers/`)
- **`auth_providers.dart`**:
  - Service Providers（Auth0Service, TokenStorageService, ApiClientService, AuthRepository）
  - `AuthStatus` 列挙型（initial, unauthenticated, authenticatedButNotRegistered, authenticated, error）
  - `AuthState` クラス（認証状態を保持）
  - `AuthStateNotifier` - 認証状態の管理
    - 自動ログイン
    - ログイン
    - ユーザー登録
    - ログアウト
  - Computed Providers（currentUser, isAuthenticated）
  - username重複チェック用Provider

### 6. UIレイヤー

#### `lib/main.dart`
- `ProviderScope`でアプリ全体をラップ
- 起動時に`.env`を読み込み
- 環境変数のバリデーション
- エラー時のフォールバック画面

#### `lib/ui/shell/app_shell.dart`
- **認証状態に基づいた画面切り替え**:
  - `initial` → ローディング画面
  - `unauthenticated` → ログイン画面
  - `authenticatedButNotRegistered` → プロフィール入力画面
  - `authenticated` → メインアプリ
  - `error` → エラー画面
- メインアプリのボトムナビゲーション（ホーム、日記、単語帳、通知、プロフィール）

#### `lib/ui/screens/social_auth_screen.dart`
- **Auth0ログイン画面**:
  - Universal Loginボタン
  - ログイン処理の実行
  - ローディング状態の表示
  - エラーハンドリング
  - キャンセル時の処理

#### `lib/ui/screens/profile_setup_screen.dart`
- **プロフィール入力画面**:
  - 表示名入力
  - ユーザー名入力（リアルタイム重複チェック）
  - 自己紹介入力
  - バリデーション（3〜20文字、英数字とアンダースコアのみ）
  - デバウンス処理（500ms）
  - チェック中のローディング表示
  - 利用可能時のチェックマーク表示
  - ユーザー登録API呼び出し
  - エラーハンドリング

---

## 認証フロー

### 初回ログインフロー
```
1. ユーザーがログインボタンをタップ
2. Auth0 Universal Login起動（auth0_flutter）
3. Google / Apple / X で認証
4. Auth0からトークン取得（アクセス、リフレッシュ、ID）
5. トークンを暗号化して保存（flutter_secure_storage）
6. GET /api/users/status でDB確認
7a. 登録済み → ホーム画面へ
7b. 未登録 → プロフィール入力画面へ
8. POST /api/users/setup でユーザー登録
9. ホーム画面へ
```

### 2回目以降のログインフロー
```
1. アプリ起動
2. 保存されているトークンを確認
3. GET /api/users/status でDB確認（トークン有効性もチェック）
4. 登録済みユーザー → 直接ホーム画面へ
```

### トークンリフレッシュフロー
```
1. API呼び出し時に401エラー
2. インターセプターが自動検知
3. Auth0でトークンをリフレッシュ
4. 新しいトークンを保存
5. 元のリクエストを再実行
6. リフレッシュ失敗時 → ログイン画面へ
```

---

## ファイル構成

```
application/
├── .env                                    # 環境変数（gitignoreに追加済み）
├── .env.example                            # 環境変数のテンプレート
├── pubspec.yaml                            # 依存関係更新
├── lib/
│   ├── main.dart                           # アプリエントリーポイント（ProviderScope、dotenv）
│   ├── core/
│   │   ├── config/
│   │   │   └── env_config.dart             # 環境変数管理
│   │   ├── constants/
│   │   │   └── api_constants.dart          # APIエンドポイント定義
│   │   ├── utils/
│   │   │   └── logger.dart                 # ログ出力
│   │   └── exceptions/
│   │       └── app_exception.dart          # カスタム例外
│   ├── features/
│   │   └── auth/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   ├── auth_tokens.dart
│   │       │   │   ├── user_model.dart
│   │       │   │   └── user_status_response.dart
│   │       │   ├── services/
│   │       │   │   ├── auth0_service.dart
│   │       │   │   ├── token_storage_service.dart
│   │       │   │   └── api_client_service.dart
│   │       │   └── repositories/
│   │       │       └── auth_repository.dart
│   │       └── domain/
│   │           └── providers/
│   │               └── auth_providers.dart
│   └── ui/
│       ├── shell/
│       │   └── app_shell.dart              # 認証状態ベースのルーティング
│       └── screens/
│           ├── social_auth_screen.dart     # ログイン画面
│           └── profile_setup_screen.dart   # プロフィール入力画面
```

---

## 使用技術スタック

| レイヤー | 技術 |
|---------|-----|
| 状態管理 | Riverpod |
| HTTPクライアント | Dio |
| 認証 | Auth0 (auth0_flutter) |
| トークン保存 | flutter_secure_storage |
| 環境変数 | flutter_dotenv |
| UIフレームワーク | Flutter + ForUI |

---

## セキュリティ対策

1. ✅ **トークンの暗号化保存**: `flutter_secure_storage`を使用
2. ✅ **HTTPSのみ**: すべての通信はTLS 1.3で暗号化
3. ✅ **短い有効期限**: アクセストークンは1時間
4. ✅ **自動リフレッシュ**: 401エラー時に自動的にトークンを更新
5. ✅ **Authorization Code + PKCE**: Auth0の推奨フロー
6. ✅ **バリデーション**: すべての入力をクライアント側で検証
7. ✅ **エラーハンドリング**: 適切なエラーメッセージを表示

---

## 次のステップ

### 必須
1. **Auth0の設定**:
   - Auth0アカウントを作成
   - Applicationを作成（Native）
   - Callback URLs / Logout URLs を設定
   - API（Audience）を作成
   - `.env`ファイルに実際の値を設定

2. **iOSの設定**:
   - `ios/Runner/Info.plist`にURLスキームを追加
   - `chaletta`スキームの設定

3. **Androidの設定**:
   - `android/app/build.gradle.kts`にURLスキームを追加
   - マニフェストにインテントフィルターを追加

4. **動作確認**:
   - ログインフロー
   - プロフィール登録フロー
   - トークンリフレッシュ
   - ログアウト

### 任意
1. **ログアウト機能の追加**: 設定画面にログアウトボタンを追加
2. **プロフィール編集**: 登録後のユーザー情報編集機能
3. **エラーリトライ**: ネットワークエラー時の再試行機能
4. **オフライン対応**: キャッシュ機能の実装
5. **パフォーマンス改善**: ビルド時間短縮、アプリサイズ削減
6. **テスト**: 単体テスト、ウィジェットテスト、統合テストの追加

---

## トラブルシューティング

### 環境変数が読み込めない
- `.env`ファイルがプロジェクトルートに存在するか確認
- `pubspec.yaml`の`assets`に`.env`が追加されているか確認
- アプリを再起動

### Auth0ログインが開かない
- `auth0_flutter`のバージョンを確認
- URLスキーム（`chaletta`）が正しく設定されているか確認
- iOS: Info.plistのURLスキーム
- Android: build.gradleとマニフェスト

### 401エラーが発生する
- トークンが正しく保存されているか確認
- バックエンドのJWT検証設定を確認
- Auth0のAudienceが一致しているか確認

### Username重複チェックが動作しない
- バックエンドAPIが起動しているか確認
- ネットワーク接続を確認
- デバッグログを確認

---

## 参考資料

- [Auth0 Flutter SDK](https://github.com/auth0/auth0-flutter)
- [Riverpod Documentation](https://riverpod.dev/)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [docs/8_認証フロー詳細.md](./8_認証フロー詳細.md)

---

## まとめ

Flutter側の認証実装が完了しました！

**実装した主要機能:**
- ✅ Auth0 Universal Login
- ✅ トークンの暗号化保存
- ✅ 自動ログイン
- ✅ ユーザー登録（プロフィール入力）
- ✅ Username重複チェック（リアルタイム）
- ✅ 認証状態に基づいた画面遷移
- ✅ 401エラー時の自動トークンリフレッシュ
- ✅ エラーハンドリング

**アーキテクチャ:**
- Riverpodによる状態管理
- Clean Architectureに準拠（Core, Data, Domain, UI）
- Dioインターセプターによる自動トークン管理

次は、Auth0の実際の設定とiOS/Androidのネイティブ設定を行い、実機での動作確認を行ってください！
