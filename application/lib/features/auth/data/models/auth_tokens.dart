/// Auth0から取得したトークン情報を管理するクラス
class AuthTokens {
  /// アクセストークン (API呼び出し用、有効期限: 1時間)
  final String accessToken;

  /// リフレッシュトークン (トークン更新用、有効期限: 30日)
  final String? refreshToken;

  /// IDトークン (ユーザー情報を含む)
  final String? idToken;

  /// トークンの有効期限 (秒単位)
  final int? expiresIn;

  /// トークンのタイプ (通常は "Bearer")
  final String tokenType;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    this.expiresIn,
    this.tokenType = 'Bearer',
  });

  /// JSONからAuthTokensを生成
  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      idToken: json['idToken'] as String?,
      expiresIn: json['expiresIn'] as int?,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }

  /// AuthTokensをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'idToken': idToken,
      'expiresIn': expiresIn,
      'tokenType': tokenType,
    };
  }

  /// コピーを作成
  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
    String? idToken,
    int? expiresIn,
    String? tokenType,
  }) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      idToken: idToken ?? this.idToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  String toString() {
    return 'AuthTokens(accessToken: ${accessToken.substring(0, 20)}..., '
        'refreshToken: ${refreshToken?.substring(0, 20)}..., '
        'expiresIn: $expiresIn)';
  }
}
