// ignore_for_file: invalid_annotation_target, non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_post.freezed.dart';
part 'diary_post.g.dart';

@freezed
abstract class DiaryUserSummary with _$DiaryUserSummary {
  const factory DiaryUserSummary({
    required String id,
    required String username,
    required String displayName,
    String? profileImageUrl,
    @Default('NORMAL') String type,
  }) = _DiaryUserSummary;

  factory DiaryUserSummary.fromJson(Map<String, dynamic> json) =>
      _$DiaryUserSummaryFromJson(json);
}

@freezed
abstract class DiaryQuotedPost with _$DiaryQuotedPost {
  const factory DiaryQuotedPost({
    required String id,
    required String content,
    required DiaryUserSummary user,
    @Default(<String>[]) List<String> imageUrls,
    @Default(<String>[]) List<String> tags,
    DateTime? createdAt,
  }) = _DiaryQuotedPost;

  factory DiaryQuotedPost.fromJson(Map<String, dynamic> json) =>
      _$DiaryQuotedPostFromJson(json);
}

@freezed
abstract class DiaryPageInfo with _$DiaryPageInfo {
  const factory DiaryPageInfo({
    String? nextCursor,
    @Default(false) bool hasNextPage,
    @Default(0) int count,
  }) = _DiaryPageInfo;

  factory DiaryPageInfo.fromJson(Map<String, dynamic> json) =>
      _$DiaryPageInfoFromJson(json);
}

@freezed
abstract class DiaryPost with _$DiaryPost {
  const factory DiaryPost({
    required String id,
    required String content,
    @Default(<String>[]) List<String> imageUrls,
    @Default(<String>[]) List<String> tags,
    String? quotedPostId,
    @Default(true) bool shareToDiary,
    @Default('public') String visibility,
    required DiaryUserSummary user,
    DiaryQuotedPost? quotedPost,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int quotesCount,
    @Default(false) bool liked,
    @Default(false) bool bookmarked,
    @Default(false) bool isEdited,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? editedAt,
  }) = _DiaryPost;

  factory DiaryPost.fromJson(Map<String, dynamic> json) =>
      _$DiaryPostFromJson(json);
}


class DiaryFeedPage {
  DiaryFeedPage({required this.posts, required this.pageInfo});

  final List<DiaryPost> posts;
  final DiaryPageInfo pageInfo;

  bool get hasNextPage => pageInfo.hasNextPage;
  String? get nextCursor => pageInfo.nextCursor;
}
