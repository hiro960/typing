// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryComment _$DiaryCommentFromJson(Map<String, dynamic> json) =>
    _DiaryComment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      user: DiaryUserSummary.fromJson(json['user'] as Map<String, dynamic>),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      liked: json['liked'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DiaryCommentToJson(_DiaryComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'content': instance.content,
      'user': instance.user,
      'likesCount': instance.likesCount,
      'liked': instance.liked,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
