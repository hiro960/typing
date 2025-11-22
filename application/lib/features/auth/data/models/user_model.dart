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
  /// アカウントがバンされているかどうか
  final bool isBanned;
  final UserSettingsModel settings;

  /// ログインユーザーがこのユーザーをフォローしているか
  final bool isFollowing;

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
    this.settings = const UserSettingsModel(),
    this.isFollowing = false,
  });

  /// JSONからUserModelを生成
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      auth0UserId: json['auth0UserId'] as String? ?? '',
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      type: json['type'] as String? ?? 'NORMAL',
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      postsCount: json['postsCount'] as int? ?? 0,
      totalLessonsCompleted: json['totalLessonsCompleted'] as int? ?? 0,
      maxWPM: (json['maxWPM'] as num?)?.toDouble() ?? 0.0,
      maxAccuracy: (json['maxAccuracy'] as num?)?.toDouble() ?? 0.0,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      isBanned: json['isBanned'] as bool? ?? false,
      settings: UserSettingsModel.fromJson(
        json['settings'] as Map<String, dynamic>?,
      ),
      isFollowing: json['isFollowing'] as bool? ?? false,
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
      'settings': settings.toJson(),
      'isFollowing': isFollowing,
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
    UserSettingsModel? settings,
    bool? isFollowing,
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
      settings: settings ?? this.settings,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, displayName: $displayName, '
        'email: $email, type: $type, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id && other.isFollowing == isFollowing;
  }

  @override
  int get hashCode => id.hashCode ^ isFollowing.hashCode;
}

class UserSettingsModel {
  const UserSettingsModel({
    this.notifications = const UserNotificationSettingsModel(),
    this.postDefaultVisibility = 'public',
    this.profileVisibility = 'public',
  });

  final UserNotificationSettingsModel notifications;
  final String postDefaultVisibility;
  final String profileVisibility;

  factory UserSettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UserSettingsModel();
    }
    return UserSettingsModel(
      notifications: UserNotificationSettingsModel.fromJson(
        json['notifications'] as Map<String, dynamic>?,
      ),
      postDefaultVisibility:
          (json['postDefaultVisibility'] as String?) ?? 'public',
      profileVisibility: (json['profileVisibility'] as String?) ?? 'public',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.toJson(),
      'postDefaultVisibility': postDefaultVisibility,
      'profileVisibility': profileVisibility,
    };
  }

  UserSettingsModel copyWith({
    UserNotificationSettingsModel? notifications,
    String? postDefaultVisibility,
    String? profileVisibility,
  }) {
    return UserSettingsModel(
      notifications: notifications ?? this.notifications,
      postDefaultVisibility: postDefaultVisibility ?? this.postDefaultVisibility,
      profileVisibility: profileVisibility ?? this.profileVisibility,
    );
  }
}

class UserNotificationSettingsModel {
  const UserNotificationSettingsModel({
    this.push = true,
    this.email = true,
    this.comment = true,
    this.like = true,
    this.follow = true,
    this.quote = true,
  });

  final bool push;
  final bool email;
  final bool comment;
  final bool like;
  final bool follow;
  final bool quote;

  factory UserNotificationSettingsModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const UserNotificationSettingsModel();
    }
    return UserNotificationSettingsModel(
      push: json['push'] as bool? ?? true,
      email: json['email'] as bool? ?? true,
      comment: json['comment'] as bool? ?? true,
      like: json['like'] as bool? ?? true,
      follow: json['follow'] as bool? ?? true,
      quote: json['quote'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push': push,
      'email': email,
      'comment': comment,
      'like': like,
      'follow': follow,
      'quote': quote,
    };
  }

  UserNotificationSettingsModel copyWith({
    bool? push,
    bool? email,
    bool? comment,
    bool? like,
    bool? follow,
    bool? quote,
  }) {
    return UserNotificationSettingsModel(
      push: push ?? this.push,
      email: email ?? this.email,
      comment: comment ?? this.comment,
      like: like ?? this.like,
      follow: follow ?? this.follow,
      quote: quote ?? this.quote,
    );
  }
}
