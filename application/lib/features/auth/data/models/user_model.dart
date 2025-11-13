/// ユーザー情報を表すモデルクラス
/// バックエンドのUser型に対応
class UserModel {
  /// ユーザーID (例: usr_abc123)
  final String id;

  /// Auth0ユーザーID (例: auth0|123456)
  final String auth0UserId;

  /// ユーザー名 (@なし、一意)
  final String username;

  /// 表示名
  final String displayName;

  /// メールアドレス
  final String email;

  /// プロフィール画像URL
  final String? profileImageUrl;

  /// 自己紹介
  final String? bio;

  /// ユーザータイプ (NORMAL, PREMIUM, OFFICIAL)
  final String type;

  /// フォロワー数
  final int followersCount;

  /// フォロー中の数
  final int followingCount;

  /// 投稿数
  final int postsCount;

  /// 完了したレッスン数
  final int totalLessonsCompleted;

  /// 最高WPM
  final double maxWPM;

  /// 最高正確度
  final double maxAccuracy;

  /// 最終ログイン日時
  final DateTime? lastLoginAt;

  /// アカウント作成日時
  final DateTime createdAt;

  /// 最終更新日時
  final DateTime? updatedAt;

  /// アカウントが有効かどうか
  final bool isActive;

  /// アカウントがバンされているかどうか
  final bool isBanned;

  const UserModel({
    required this.id,
    required this.auth0UserId,
    required this.username,
    required this.displayName,
    required this.email,
    this.profileImageUrl,
    this.bio,
    required this.type,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.totalLessonsCompleted,
    required this.maxWPM,
    required this.maxAccuracy,
    this.lastLoginAt,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
    required this.isBanned,
  });

  /// JSONからUserModelを生成
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      auth0UserId: json['auth0UserId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      type: json['type'] as String,
      followersCount: json['followersCount'] as int,
      followingCount: json['followingCount'] as int,
      postsCount: json['postsCount'] as int,
      totalLessonsCompleted: json['totalLessonsCompleted'] as int,
      maxWPM: (json['maxWPM'] as num).toDouble(),
      maxAccuracy: (json['maxAccuracy'] as num).toDouble(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isActive: json['isActive'] as bool,
      isBanned: json['isBanned'] as bool,
    );
  }

  /// UserModelをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth0UserId': auth0UserId,
      'username': username,
      'displayName': displayName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'type': type,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'totalLessonsCompleted': totalLessonsCompleted,
      'maxWPM': maxWPM,
      'maxAccuracy': maxAccuracy,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'isBanned': isBanned,
    };
  }

  /// コピーを作成
  UserModel copyWith({
    String? id,
    String? auth0UserId,
    String? username,
    String? displayName,
    String? email,
    String? profileImageUrl,
    String? bio,
    String? type,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? totalLessonsCompleted,
    double? maxWPM,
    double? maxAccuracy,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isBanned,
  }) {
    return UserModel(
      id: id ?? this.id,
      auth0UserId: auth0UserId ?? this.auth0UserId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      type: type ?? this.type,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      maxWPM: maxWPM ?? this.maxWPM,
      maxAccuracy: maxAccuracy ?? this.maxAccuracy,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isBanned: isBanned ?? this.isBanned,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, displayName: $displayName, '
        'email: $email, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
