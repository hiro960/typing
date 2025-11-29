// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryUserSummary _$DiaryUserSummaryFromJson(Map<String, dynamic> json) =>
    _DiaryUserSummary(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      type: json['type'] as String? ?? 'NORMAL',
    );

Map<String, dynamic> _$DiaryUserSummaryToJson(_DiaryUserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'type': instance.type,
    };

_DiaryQuotedPost _$DiaryQuotedPostFromJson(Map<String, dynamic> json) =>
    _DiaryQuotedPost(
      id: json['id'] as String,
      content: json['content'] as String,
      user: DiaryUserSummary.fromJson(json['user'] as Map<String, dynamic>),
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DiaryQuotedPostToJson(_DiaryQuotedPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'user': instance.user,
      'imageUrls': instance.imageUrls,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_DiaryPageInfo _$DiaryPageInfoFromJson(Map<String, dynamic> json) =>
    _DiaryPageInfo(
      nextCursor: json['nextCursor'] as String?,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DiaryPageInfoToJson(_DiaryPageInfo instance) =>
    <String, dynamic>{
      'nextCursor': instance.nextCursor,
      'hasNextPage': instance.hasNextPage,
      'count': instance.count,
    };

_DiaryPost _$DiaryPostFromJson(Map<String, dynamic> json) => _DiaryPost(
  id: json['id'] as String,
  content: json['content'] as String,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  quotedPostId: json['quotedPostId'] as String?,
  shareToDiary: json['shareToDiary'] as bool? ?? true,
  visibility: json['visibility'] as String? ?? 'public',
  user: DiaryUserSummary.fromJson(json['user'] as Map<String, dynamic>),
  quotedPost: json['quotedPost'] == null
      ? null
      : DiaryQuotedPost.fromJson(json['quotedPost'] as Map<String, dynamic>),
  likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
  commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
  quotesCount: (json['quotesCount'] as num?)?.toInt() ?? 0,
  liked: json['liked'] as bool? ?? false,
  bookmarked: json['bookmarked'] as bool? ?? false,
  isEdited: json['isEdited'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  editedAt: json['editedAt'] == null
      ? null
      : DateTime.parse(json['editedAt'] as String),
);

Map<String, dynamic> _$DiaryPostToJson(_DiaryPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'tags': instance.tags,
      'quotedPostId': instance.quotedPostId,
      'shareToDiary': instance.shareToDiary,
      'visibility': instance.visibility,
      'user': instance.user,
      'quotedPost': instance.quotedPost,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'quotesCount': instance.quotesCount,
      'liked': instance.liked,
      'bookmarked': instance.bookmarked,
      'isEdited': instance.isEdited,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
    };
