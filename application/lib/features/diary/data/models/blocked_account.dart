class BlockedAccount {
  const BlockedAccount({
    required this.id,
    required this.blockedId,
    required this.createdAt,
    this.blockedUser,
  });

  final String id;
  final String blockedId;
  final DateTime createdAt;
  final BlockedUserSummary? blockedUser;

  factory BlockedAccount.fromJson(Map<String, dynamic> json) {
    return BlockedAccount(
      id: json['id'] as String,
      blockedId: json['blockedId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      blockedUser: json['blockedUser'] == null
          ? null
          : BlockedUserSummary.fromJson(
              json['blockedUser'] as Map<String, dynamic>,
            ),
    );
  }
}

class BlockedUserSummary {
  const BlockedUserSummary({
    required this.id,
    required this.username,
    required this.displayName,
    this.profileImageUrl,
  });

  final String id;
  final String username;
  final String displayName;
  final String? profileImageUrl;

  factory BlockedUserSummary.fromJson(Map<String, dynamic> json) {
    return BlockedUserSummary(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
