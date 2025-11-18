// ignore_for_file: invalid_annotation_target, non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

import 'diary_post.dart';

part 'diary_comment.freezed.dart';
part 'diary_comment.g.dart';

@freezed
abstract class DiaryComment with _$DiaryComment {
  const factory DiaryComment({
    required String id,
    required String postId,
    required String content,
    required DiaryUserSummary user,
    @Default(0) int likesCount,
    @Default(false) bool liked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DiaryComment;

  factory DiaryComment.fromJson(Map<String, dynamic> json) =>
      _$DiaryCommentFromJson(json);
}

class DiaryCommentsPage {
  DiaryCommentsPage({
    required this.comments,
    required this.pageInfo,
  });

  final List<DiaryComment> comments;
  final DiaryPageInfo pageInfo;

  bool get hasNextPage => pageInfo.hasNextPage;
  String? get nextCursor => pageInfo.nextCursor;
}
