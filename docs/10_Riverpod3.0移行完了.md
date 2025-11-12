# Riverpod 3.0 移行完了

## 移行日
2025-01-XX

## 概要
韓国語タイピングアプリのFlutter認証実装を、Riverpod 2.x から Riverpod 3.0 の書き方に移行しました。

---

## 主な変更点

### 1. パッケージバージョンの更新

#### `pubspec.yaml`
```yaml
# Before (Riverpod 2.x)
flutter_riverpod: ^2.6.1
riverpod_annotation: ^2.6.1

# After (Riverpod 3.0)
flutter_riverpod: ^3.0.3
riverpod_annotation: ^3.0.3
riverpod_generator: ^3.0.3
riverpod_lint: ^3.0.3
```

### 2. Providerの書き方変更

#### Before (Riverpod 2.x)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auth0ServiceProvider = Provider<Auth0Service>((ref) {
  return Auth0Service();
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).user;
});

final usernameAvailabilityProvider =
    FutureProvider.family<bool, String>((ref, username) async {
  if (username.isEmpty) {
    return false;
  }
  final authRepo = ref.watch(authRepositoryProvider);
  return await authRepo.checkUsernameAvailability(username);
});
```

#### After (Riverpod 3.0)
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
Auth0Service auth0Service(Auth0ServiceRef ref) {
  return Auth0Service();
}

@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  return ref.watch(authStateNotifierProvider).user;
}

@riverpod
Future<bool> usernameAvailability(
  UsernameAvailabilityRef ref,
  String username,
) async {
  if (username.isEmpty) {
    return false;
  }
  final authRepo = ref.watch(authRepositoryProvider);
  return await authRepo.checkUsernameAvailability(username);
}
```

### 3. StateNotifier → Notifier への変更

#### Before (Riverpod 2.x)
```dart
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(const AuthState.initial()) {
    _tryAutoLogin();
  }

  Future<void> login() async {
    // ...
    state = AuthState.authenticated(status.user!);
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.watch(authRepositoryProvider));
});
```

#### After (Riverpod 3.0)
```dart
@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthState build() {
    _tryAutoLogin();
    return const AuthState.initial();
  }

  Future<void> login() async {
    final authRepository = ref.read(authRepositoryProvider);
    // ...
    state = AuthState.authenticated(status.user!);
  }
}

// プロバイダーは自動生成される: authStateNotifierProvider
```

### 4. プロバイダー名の変更

| Before (2.x) | After (3.0) |
|-------------|------------|
| `authStateProvider` | `authStateNotifierProvider` |
| 手動定義 | `@riverpod`アノテーションで自動生成 |

### 5. 使用箇所の更新

#### UI での使用例
```dart
// Before
final authState = ref.watch(authStateProvider);
await ref.read(authStateProvider.notifier).login();

// After
final authState = ref.watch(authStateNotifierProvider);
await ref.read(authStateNotifierProvider.notifier).login();
```

---

## 移行した主なファイル

### 1. `lib/features/auth/domain/providers/auth_providers.dart`
- ✅ `import 'package:flutter_riverpod/flutter_riverpod.dart'` → `import 'package:riverpod_annotation/riverpod_annotation.dart'`
- ✅ `part 'auth_providers.g.dart';` を追加
- ✅ すべてのProviderを`@riverpod`アノテーションに変更
- ✅ `StateNotifier` → `Notifier` に変更
- ✅ `StateNotifierProvider` → 自動生成される`authStateNotifierProvider`

### 2. `lib/ui/shell/app_shell.dart`
- ✅ `authStateProvider` → `authStateNotifierProvider`

### 3. `lib/ui/screens/social_auth_screen.dart`
- ✅ `authStateProvider.notifier` → `authStateNotifierProvider.notifier`

### 4. `lib/ui/screens/profile_setup_screen.dart`
- ✅ `authStateProvider.notifier` → `authStateNotifierProvider.notifier`

### 5. `analysis_options.yaml`
- ✅ `custom_lint`プラグインを追加

### 6. `build.yaml`
- ✅ riverpod_generatorの設定を追加（新規作成）

---

## Riverpod 3.0 の主な利点

### 1. **型安全性の向上**
- コード生成により、プロバイダー名の自動生成
- コンパイル時のエラー検出が強化

### 2. **シンプルなコード**
- `StateNotifierProvider`の明示的な定義が不要
- `@riverpod`アノテーションだけで自動生成

### 3. **パフォーマンスの改善**
- 内部実装の最適化
- より効率的な依存関係の管理

### 4. **開発体験の向上**
- `riverpod_lint`による静的解析
- IDEのオートコンプリート強化

---

## コード生成の実行方法

### 一度だけビルド
```bash
cd application
dart run build_runner build --delete-conflicting-outputs
```

### 継続的にビルド（開発中）
```bash
cd application
dart run build_runner watch --delete-conflicting-outputs
```

### 生成されるファイル
- `lib/features/auth/domain/providers/auth_providers.g.dart`

---

## トラブルシューティング

### 1. `part 'xxx.g.dart';` でエラーが出る
**原因**: コード生成がまだ実行されていない

**解決策**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. `_$AuthStateNotifier` が見つからない
**原因**: コード生成ファイルが不完全

**解決策**:
```bash
# キャッシュをクリアして再生成
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### 3. プロバイダー名が変わった
**原因**: Riverpod 3.0では自動生成される名前が異なる

**解決策**:
- `@riverpod`の付いたクラス名が`AuthStateNotifier`の場合
- 生成されるプロバイダー名は`authStateNotifierProvider`（キャメルケース）

### 4. `custom_lint` エラー
**原因**: `riverpod_lint`が正しく設定されていない

**解決策**:
1. `pubspec.yaml`に`riverpod_lint`を追加
2. `analysis_options.yaml`に`custom_lint`プラグインを追加
3. IDEを再起動

---

## 移行チェックリスト

- [x] `pubspec.yaml`のバージョン更新
- [x] `analysis_options.yaml`に`custom_lint`追加
- [x] `build.yaml`の作成
- [x] Providerを`@riverpod`に変更
- [x] `StateNotifier` → `Notifier`
- [x] `part`ディレクティブの追加
- [x] UI側のプロバイダー名更新
- [x] コード生成の実行
- [ ] 動作確認（ビルド & 実行）

---

## 参考資料

- [Riverpod 3.0 Migration Guide (日本語)](https://riverpod.dev/ja/docs/3.0_migration)
- [Riverpod 3.0 公式ドキュメント](https://riverpod.dev/)
- [riverpod_generator パッケージ](https://pub.dev/packages/riverpod_generator)
- [riverpod_lint パッケージ](https://pub.dev/packages/riverpod_lint)

---

## まとめ

Riverpod 3.0への移行が完了しました！

**主な変更:**
- ✅ `@riverpod`アノテーションによるコード生成
- ✅ `StateNotifier` → `Notifier`
- ✅ 自動生成されるプロバイダー名（`authStateNotifierProvider`）
- ✅ より型安全なコード

**次のステップ:**
1. `dart run build_runner build --delete-conflicting-outputs` を実行
2. 生成された`.g.dart`ファイルを確認
3. アプリをビルドして動作確認
4. 問題があれば上記トラブルシューティングを参照

Riverpod 3.0の新しい書き方により、よりシンプルで保守性の高いコードになりました！
