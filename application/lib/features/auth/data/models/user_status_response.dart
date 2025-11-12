import 'user_model.dart';

/// GET /api/users/status のレスポンス型
class UserStatusResponse {
  /// ユーザーが登録済みかどうか
  final bool registered;

  /// ユーザー情報 (登録済みの場合のみ)
  final UserModel? user;

  const UserStatusResponse({
    required this.registered,
    this.user,
  });

  /// JSONからUserStatusResponseを生成
  factory UserStatusResponse.fromJson(Map<String, dynamic> json) {
    return UserStatusResponse(
      registered: json['registered'] as bool,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// UserStatusResponseをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'registered': registered,
      'user': user?.toJson(),
    };
  }

  @override
  String toString() {
    return 'UserStatusResponse(registered: $registered, user: $user)';
  }
}

/// POST /api/users/setup のリクエストボディ型
class UserSetupRequest {
  /// ユーザー名 (@なし、3〜20文字、英数字とアンダースコアのみ)
  final String username;

  /// 表示名 (1〜50文字)
  final String displayName;

  /// 自己紹介 (最大160文字、任意)
  final String? bio;

  /// プロフィール画像URL (任意)
  final String? profileImageUrl;

  const UserSetupRequest({
    required this.username,
    required this.displayName,
    this.bio,
    this.profileImageUrl,
  });

  /// UserSetupRequestをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    };
  }

  @override
  String toString() {
    return 'UserSetupRequest(username: $username, displayName: $displayName)';
  }
}

/// GET /api/users/check-username のレスポンス型
class UsernameAvailabilityResponse {
  /// ユーザー名が利用可能かどうか
  final bool available;

  const UsernameAvailabilityResponse({
    required this.available,
  });

  /// JSONからUsernameAvailabilityResponseを生成
  factory UsernameAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return UsernameAvailabilityResponse(
      available: json['available'] as bool,
    );
  }

  /// UsernameAvailabilityResponseをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'available': available,
    };
  }

  @override
  String toString() {
    return 'UsernameAvailabilityResponse(available: $available)';
  }
}
