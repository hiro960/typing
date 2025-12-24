# 認証フロー詳細ドキュメント

## 概要

本ドキュメントでは、韓国語タイピングアプリの認証フローをBackendとApplication（Flutter）の両観点から整理し、1日でログアウトされる問題の原因と解決策を説明します。

---

## 目次

1. [エラー分析](#1-エラー分析)
2. [トークンの種類と有効期限](#2-トークンの種類と有効期限)
3. [認証フロー全体像](#3-認証フロー全体像)
4. [Application側の実装詳細](#4-application側の実装詳細)
5. [Backend側の実装詳細](#5-backend側の実装詳細)
6. [問題の根本原因](#6-問題の根本原因)
7. [解決策](#7-解決策)
8. [ファイル一覧](#8-ファイル一覧)

---

## 1. エラー分析

### 発生しているエラー

```
[AUTH ERROR] JWT verification failed: n: "exp" claim timestamp check failed
{
  code: 'ERR_JWT_EXPIRED',
  claim: 'exp',
  reason: 'check_failed'
}
```

### エラーの意味

- `ERR_JWT_EXPIRED`: JWTのAccess Tokenの有効期限（`exp` claim）が切れている
- これは**正常な挙動**であり、Access Tokenは定期的に期限切れになる
- **本来の期待動作**: Refresh Tokenを使って新しいAccess Tokenを取得すべき

---

## 2. トークンの種類と有効期限

Auth0で発行されるトークンは3種類あります：

| トークン | 用途 | デフォルト有効期限 | 保存場所 |
|---------|------|-----------------|---------|
| **Access Token** | API認証用 | 24時間（86400秒） | TokenStorageService / CredentialsManager |
| **ID Token** | ユーザー情報 | 24時間 | TokenStorageService / CredentialsManager |
| **Refresh Token** | トークン更新用 | 30日（設定依存） | TokenStorageService / CredentialsManager |

### Auth0ダッシュボードでの設定確認箇所

1. **Applications → [Your App] → Settings → Refresh Token Rotation**
2. **APIs → [Your API] → Settings → Token Expiration**

---

## 3. 認証フロー全体像

```
┌─────────────────────────────────────────────────────────────────────┐
│                        初回ログインフロー                             │
└─────────────────────────────────────────────────────────────────────┘

[User] → [Flutter App] → [Auth0 Universal Login] → [Auth0 Server]
                                                          │
                    ┌─────────────────────────────────────┘
                    ▼
            Access Token + Refresh Token + ID Token
                    │
                    ▼
    ┌───────────────────────────────────┐
    │  Flutter側トークン保存              │
    │  1. CredentialsManager (auth0_flutter内部) │
    │  2. TokenStorageService (SecureStorage)    │
    └───────────────────────────────────┘
                    │
                    ▼
    [Backend API] ← Access Token (Bearer)


┌─────────────────────────────────────────────────────────────────────┐
│                      アプリ起動時（自動ログイン）                      │
└─────────────────────────────────────────────────────────────────────┘

[App起動] → AuthStateNotifier.build() → _tryAutoLogin()
                                              │
                                              ▼
                    AuthRepository.tryAutoLogin()
                                              │
                                              ▼
                    Auth0Service.getStoredCredentials()
                                              │
                                              ▼
                    CredentialsManager.credentials()
                           │                  │
                   [Token有効]          [Token期限切れ]
                           │                  │
                           ▼                  ▼
                    トークン返却      自動Refresh試行
                                              │
                              ┌───────────────┴───────────────┐
                              ▼                               ▼
                      [Refresh成功]                    [Refresh失敗]
                              │                               │
                              ▼                               ▼
                      新Token返却                 CredentialsManagerException
                                                              │
                                                              ▼
                                                     null返却 → ログアウト


┌─────────────────────────────────────────────────────────────────────┐
│                      API呼び出し時（401エラー発生時）                  │
└─────────────────────────────────────────────────────────────────────┘

[APIリクエスト] → [Backend] → 401 Unauthorized
        │
        ▼
ApiClientService._onError()
        │
        ▼
Auth0Service.refreshTokens() → CredentialsManager.credentials()
        │                               │
        ▼                               ▼
   [成功] → 再リクエスト          [失敗] → クレデンシャルクリア
                                              │
                                              ▼
                                        ログアウト状態へ
```

---

## 4. Application側の実装詳細

### 4.1 主要ファイル構成

```
application/lib/features/auth/
├── data/
│   ├── models/
│   │   └── auth_tokens.dart          # トークンモデル
│   ├── repositories/
│   │   └── auth_repository.dart      # 認証ビジネスロジック
│   └── services/
│       ├── auth0_service.dart        # Auth0との通信
│       ├── token_storage_service.dart # トークン永続化
│       └── api_client_service.dart   # HTTP通信 + インターセプター
└── domain/
    └── providers/
        └── auth_providers.dart       # Riverpodプロバイダー
```

### 4.2 ログイン処理

**ファイル**: `auth0_service.dart:41-104`

```dart
Future<AuthTokens> login() async {
  final credentials = await webAuth.login(
    audience: EnvConfig.auth0Audience,
    scopes: {
      'openid',
      'profile',
      'email',
      'offline_access', // ← Refresh Token取得に必須
    },
  );
  // ...
}
```

**重要ポイント**:
- `offline_access`スコープによりRefresh Tokenを取得
- Audienceの設定が必須（設定しないとJWEトークンが発行される）

### 4.3 トークンリフレッシュ処理

**ファイル**: `auth0_service.dart:147-182`

```dart
Future<AuthTokens> refreshTokens() async {
  final credentials = await _credentialsManager.credentials();
  // auth0_flutterのCredentialsManagerが自動でリフレッシュを試みる
  return AuthTokens(...);
}
```

**ファイル**: `api_client_service.dart:99-176` (401エラー時の自動リフレッシュ)

```dart
if (error.response?.statusCode == 401) {
  // 最大3回リトライ
  final newTokens = await _auth0Service.refreshTokens();
  await _tokenStorage.saveTokens(newTokens);
  // リクエスト再試行
}
```

### 4.4 自動ログイン処理

**ファイル**: `auth_repository.dart:81-122`

```dart
Future<UserStatusResponse?> tryAutoLogin() async {
  // 1. CredentialsManagerから有効なトークンを取得
  //    期限切れなら自動リフレッシュ
  final storedCredentials = await _auth0Service.getStoredCredentials();

  if (storedCredentials == null) {
    // リフレッシュ失敗 → ログアウト
    return null;
  }

  // 2. TokenStorageServiceと同期
  await _tokenStorage.saveTokens(storedCredentials);

  // 3. ユーザー状態確認
  return await checkUserStatus();
}
```

---

## 5. Backend側の実装詳細

### 5.1 JWT検証

**ファイル**: `backend/src/lib/auth.ts:30-102`

```typescript
async function verifyAuth0Token(request: NextRequest): Promise<JWTPayload> {
  const token = authHeader.substring(7);

  const verifyOptions = {
    issuer: AUTH0_ISSUER,
    audience: process.env.AUTH0_AUDIENCE, // 設定されている場合のみ
  };

  const { payload } = await jwtVerify(token, JWKS, verifyOptions);
  return payload;
}
```

**検証内容**:
- 署名の検証（JWKS使用）
- Issuerの検証
- Audienceの検証（設定時）
- **有効期限（exp）の検証** ← これが失敗している

### 5.2 エラーハンドリング

```typescript
if (errorCode === "ERR_JWT_EXPIRED") {
  throw ERROR.UNAUTHORIZED("Token has expired");
}
```

---

## 6. 問題の根本原因

### 6.1 実装確認結果

| フロー | 実装状況 | 備考 |
|-------|---------|------|
| ログイン時のトークン取得 | ✅ 正常 | `offline_access`スコープあり |
| CredentialsManagerへの保存 | ✅ 正常 | `webAuth.login()`が内部で自動保存 |
| TokenStorageServiceへの保存 | ✅ 正常 | `AuthRepository.login()`で保存 |
| APIリクエスト時のトークン付与 | ✅ 正常 | `_onRequest()`で付与 |
| 401エラー時のリフレッシュ | ✅ 実装あり | **ここで失敗している可能性** |
| アプリ起動時の自動ログイン | ✅ 実装あり | `credentials()`で自動リフレッシュ |

### 6.2 直接的な原因

**リフレッシュ処理は実装されているが、`auth0_flutter`の`credentials()`メソッドが失敗している。**

### 6.3 考えられる原因

#### 原因1: Refresh Token Rotation の問題（最も可能性高い）

**Auth0の現在の設定**:
- Rotation: **有効**（重複期間60秒）
- Access Token有効期限: 86400秒（24時間）
- Refresh Token最大有効期間: 2592000秒（30日）
- Refresh Tokenアイドル時間: 1296000秒（15日）

Rotationが有効な場合の挙動：
1. リフレッシュ時に新しいRefresh Tokenが発行される
2. 古いRefresh Tokenは60秒後に無効化
3. **新しいRefresh Tokenが`auth0_flutter`内部で正しく保存されないと、次回リフレッシュが失敗**

#### 原因2: CredentialsManagerの内部状態の問題

`credentials()`メソッドがスローする可能性のあるエラー：
- `code: 'NO_CREDENTIALS'` - クレデンシャルが保存されていない
- `code: 'NO_REFRESH_TOKEN'` - Refresh Tokenがない
- `code: 'INVALID_REFRESH_TOKEN'` - Refresh Tokenが無効（Rotationで無効化済み）

#### 原因3: KeyChain/Keystore アクセスの問題

iOS/Androidのセキュアストレージへのアクセスが何らかの理由で失敗している可能性。

---

## 7. 解決策

### 7.1 即座に試す検証方法【推奨】

**Refresh Token Rotationを一時的に無効化して検証**:

1. **Auth0ダッシュボード → Applications → [Your App] → Settings**
2. **Refresh Token Behavior** セクション
3. **Rotation**: `Rotating` → `Non-Rotating` に変更
4. 保存してアプリを再テスト

**これで問題が解決すれば、Rotationが原因です。**

### 7.2 現在のAuth0設定（確認済み）

| 設定項目 | 現在の値 | 状態 |
|---------|---------|------|
| Access Token有効期限 | 86400秒（24時間）| ✅ 正常 |
| Refresh Token最大有効期間 | 2592000秒（30日）| ✅ 正常 |
| Refresh Tokenアイドル時間 | 1296000秒（15日）| ✅ 正常 |
| Rotation | 有効（重複60秒）| ⚠️ **要確認** |
| Application Type | Native | ✅ 正常 |
| Grant Types: Refresh Token | 有効 | ✅ 正常 |

### 7.3 デバッグログの追加 【実装済み】

以下のデバッグログが `auth0_service.dart` に追加されました：

**出力されるログの例**:
```
[AUTH] Getting stored credentials from Auth0
[AUTH] hasValidCredentials: true/false
[AUTH] Token info - expiresAt: 2025-12-25T10:00:00, now: 2025-12-24T10:00:00, remaining: 86400s, hasRefreshToken: true
[AUTH] Retrieved stored credentials (refreshed if needed)
```

**401エラー発生時**:
```
[AUTH] refreshTokens() called - attempting to get fresh credentials
[AUTH] Before refresh - hasValidCredentials: false
[AUTH] refreshTokens() success - expiresAt: ..., remaining: ...s, hasRefreshToken: true
```

**エラー発生時**:
```
[ERROR] [Auth0Service] CredentialsManagerException - code: INVALID_REFRESH_TOKEN, message: ...
```

アプリを再ビルドしてログを確認してください。

### 7.4 Refresh Token Rotationへの対応（必要な場合）

Rotation有効時の安全な更新処理を実装：

```dart
Future<AuthTokens> refreshTokensSafely() async {
  try {
    // 現在のトークンをバックアップ
    final currentTokens = await _tokenStorage.getTokens();

    try {
      final newTokens = await _auth0Service.refreshTokens();
      await _tokenStorage.saveTokens(newTokens);
      return newTokens;
    } catch (e) {
      // 失敗した場合、バックアップを復元（次回再試行用）
      if (currentTokens != null) {
        await _tokenStorage.saveTokens(currentTokens);
      }
      rethrow;
    }
  } catch (e) {
    throw AuthException.tokenExpired();
  }
}
```

### 7.5 Proactive Token Refresh（推奨改善）

期限切れ前に事前更新する仕組みの追加：

```dart
// トークンが残り10分で期限切れになる場合、事前に更新
Future<void> refreshTokenIfNeeded() async {
  final tokens = await _tokenStorage.getTokens();
  if (tokens?.expiresIn != null && tokens!.expiresIn! < 600) {
    await refreshTokens();
  }
}
```

---

## 8. ファイル一覧

### Application（Flutter）

| ファイル | 役割 |
|---------|-----|
| `lib/features/auth/data/services/auth0_service.dart` | Auth0との直接通信（ログイン、リフレッシュ） |
| `lib/features/auth/data/services/token_storage_service.dart` | SecureStorageへのトークン永続化 |
| `lib/features/auth/data/services/api_client_service.dart` | Dio HTTP通信 + 401時の自動リフレッシュ |
| `lib/features/auth/data/repositories/auth_repository.dart` | 認証ビジネスロジックの統合 |
| `lib/features/auth/domain/providers/auth_providers.dart` | Riverpod認証状態管理 |
| `lib/features/auth/data/models/auth_tokens.dart` | トークンモデル定義 |
| `lib/core/config/env_config.dart` | 環境変数設定 |

### Backend（Next.js）

| ファイル | 役割 |
|---------|-----|
| `src/lib/auth.ts` | JWT検証、Auth0トークン検証 |
| `src/lib/errors.ts` | エラーレスポンス定義 |

---

## 付録: トークンリフレッシュのシーケンス図

```
┌────────┐     ┌─────────────┐     ┌───────────────────┐     ┌────────┐
│ User   │     │ Flutter App │     │ CredentialsManager│     │ Auth0  │
└───┬────┘     └──────┬──────┘     └─────────┬─────────┘     └───┬────┘
    │                 │                      │                   │
    │ API Request     │                      │                   │
    │───────────────>│                      │                   │
    │                 │ getAccessToken()     │                   │
    │                 │─────────────────────>│                   │
    │                 │                      │                   │
    │                 │ [Token期限切れの場合] │                   │
    │                 │                      │ POST /oauth/token │
    │                 │                      │ (refresh_token)   │
    │                 │                      │──────────────────>│
    │                 │                      │                   │
    │                 │                      │ New Access Token  │
    │                 │                      │<──────────────────│
    │                 │                      │                   │
    │                 │ New Access Token     │                   │
    │                 │<─────────────────────│                   │
    │                 │                      │                   │
    │ API Response    │                      │                   │
    │<────────────────│                      │                   │
```

---

## 推奨アクション

1. **即座に確認**: Auth0ダッシュボードでRefresh Tokenの設定を確認
2. **ログ追加**: `getStoredCredentials()`にデバッグログを追加して詳細を把握
3. **設定変更**: 必要に応じてRefresh Token Lifetimeを延長
4. **長期改善**: Proactive Token Refreshの実装を検討

---

*最終更新: 2025年12月24日*
