import 'diary_comment.dart';
import 'diary_post.dart';

class DiaryNotification {
  DiaryNotification({
    required this.id,
    required this.type,
    required this.actor,
    required this.isRead,
    this.post,
    this.comment,
    this.postId,
    this.commentId,
    this.createdAt,
  });

  final String id;
  final String type;
  final DiaryUserSummary actor;
  final bool isRead;
  final DiaryPost? post;
  final DiaryComment? comment;
  final String? postId;
  final String? commentId;
  final DateTime? createdAt;

  factory DiaryNotification.fromJson(Map<String, dynamic> json) {
    return DiaryNotification(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'LIKE',
      actor: DiaryUserSummary.fromJson(
        json['actor'] as Map<String, dynamic>,
      ),
      isRead: json['isRead'] as bool? ?? false,
      postId: json['postId'] as String?,
      commentId: json['commentId'] as String?,
      post: json['post'] != null
          ? DiaryPost.fromJson(json['post'] as Map<String, dynamic>)
          : null,
      comment: json['comment'] != null
          ? DiaryComment.fromJson(json['comment'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}

class DiaryNotificationsPage {
  DiaryNotificationsPage({
    required this.notifications,
    required this.pageInfo,
  });

  final List<DiaryNotification> notifications;
  final DiaryPageInfo pageInfo;

  bool get hasNextPage => pageInfo.hasNextPage;
  String? get nextCursor => pageInfo.nextCursor;
}
