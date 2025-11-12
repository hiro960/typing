/// アプリケーション全体で使用する基底例外クラス
abstract class AppException implements Exception {
  /// エラーコード
  final String code;

  /// エラーメッセージ
  final String message;

  /// 元の例外 (ある場合)
  final Object? originalError;

  /// スタックトレース (ある場合)
  final StackTrace? stackTrace;

  const AppException({
    required this.code,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return '$runtimeType(code: $code, message: $message)';
  }
}

// ==================== 認証関連の例外 ====================

/// 認証エラー
class AuthException extends AppException {
  const AuthException({
    required super.code,
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  /// 認証トークンが無効
  factory AuthException.invalidToken([String? detail]) {
    return AuthException(
      code: 'INVALID_TOKEN',
      message: detail ?? 'トークンが無効です',
    );
  }

  /// 認証トークンの有効期限切れ
  factory AuthException.tokenExpired() {
    return const AuthException(
      code: 'TOKEN_EXPIRED',
      message: 'トークンの有効期限が切れています。再ログインしてください。',
    );
  }

  /// ログインがキャンセルされた
  factory AuthException.loginCancelled() {
    return const AuthException(
      code: 'LOGIN_CANCELLED',
      message: 'ログインがキャンセルされました',
    );
  }

  /// ログインに失敗
  factory AuthException.loginFailed([String? detail]) {
    return AuthException(
      code: 'LOGIN_FAILED',
      message: detail ?? 'ログインに失敗しました',
    );
  }

  /// ユーザーが未登録
  factory AuthException.userNotRegistered() {
    return const AuthException(
      code: 'USER_NOT_REGISTERED',
      message: 'ユーザーが登録されていません',
    );
  }
}

// ==================== API関連の例外 ====================

/// API呼び出しエラー
class ApiException extends AppException {
  /// HTTPステータスコード
  final int? statusCode;

  /// レスポンスボディ
  final dynamic responseBody;

  const ApiException({
    required super.code,
    required super.message,
    this.statusCode,
    this.responseBody,
    super.originalError,
    super.stackTrace,
  });

  /// 400 Bad Request - バリデーションエラー
  factory ApiException.badRequest(String message) {
    return ApiException(
      code: 'BAD_REQUEST',
      message: message,
      statusCode: 400,
    );
  }

  /// 401 Unauthorized - 認証エラー
  factory ApiException.unauthorized([String? message]) {
    return ApiException(
      code: 'UNAUTHORIZED',
      message: message ?? '認証に失敗しました。再ログインしてください。',
      statusCode: 401,
    );
  }

  /// 403 Forbidden - 権限エラー
  factory ApiException.forbidden([String? message]) {
    return ApiException(
      code: 'FORBIDDEN',
      message: message ?? 'この操作を実行する権限がありません',
      statusCode: 403,
    );
  }

  /// 404 Not Found - リソースが見つからない
  factory ApiException.notFound([String? message]) {
    return ApiException(
      code: 'NOT_FOUND',
      message: message ?? '要求されたリソースが見つかりません',
      statusCode: 404,
    );
  }

  /// 409 Conflict - リソース競合
  factory ApiException.conflict(String message) {
    return ApiException(
      code: 'CONFLICT',
      message: message,
      statusCode: 409,
    );
  }

  /// 422 Unprocessable Entity - 処理不可能なエンティティ
  factory ApiException.unprocessable(String message) {
    return ApiException(
      code: 'UNPROCESSABLE',
      message: message,
      statusCode: 422,
    );
  }

  /// 500 Internal Server Error - サーバーエラー
  factory ApiException.serverError([String? message]) {
    return ApiException(
      code: 'SERVER_ERROR',
      message: message ?? 'サーバーエラーが発生しました。時間をおいて再試行してください。',
      statusCode: 500,
    );
  }

  /// ネットワークエラー
  factory ApiException.networkError([String? message]) {
    return ApiException(
      code: 'NETWORK_ERROR',
      message: message ?? 'ネットワークエラーが発生しました。接続を確認してください。',
    );
  }

  /// タイムアウトエラー
  factory ApiException.timeout() {
    return const ApiException(
      code: 'TIMEOUT',
      message: 'リクエストがタイムアウトしました。時間をおいて再試行してください。',
    );
  }

  /// レスポンスのパースエラー
  factory ApiException.parseError([String? message]) {
    return ApiException(
      code: 'PARSE_ERROR',
      message: message ?? 'レスポンスの解析に失敗しました',
    );
  }

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message, statusCode: $statusCode)';
  }
}

// ==================== バリデーション関連の例外 ====================

/// 入力バリデーションエラー
class ValidationException extends AppException {
  /// エラーが発生したフィールド
  final String? field;

  const ValidationException({
    required super.code,
    required super.message,
    this.field,
  });

  /// ユーザー名のフォーマットエラー
  factory ValidationException.invalidUsername() {
    return const ValidationException(
      code: 'INVALID_USERNAME',
      message: 'ユーザー名は3〜20文字の英数字とアンダースコアのみ使用できます',
      field: 'username',
    );
  }

  /// 表示名が空
  factory ValidationException.emptyDisplayName() {
    return const ValidationException(
      code: 'EMPTY_DISPLAY_NAME',
      message: '表示名を入力してください',
      field: 'displayName',
    );
  }

  /// 自己紹介が長すぎる
  factory ValidationException.bioTooLong() {
    return const ValidationException(
      code: 'BIO_TOO_LONG',
      message: '自己紹介は160文字以内で入力してください',
      field: 'bio',
    );
  }

  @override
  String toString() {
    return 'ValidationException(code: $code, message: $message, field: $field)';
  }
}

// ==================== その他の例外 ====================

/// 予期しないエラー
class UnknownException extends AppException {
  const UnknownException({
    super.originalError,
    super.stackTrace,
  }) : super(
          code: 'UNKNOWN_ERROR',
          message: '予期しないエラーが発生しました',
        );
}
