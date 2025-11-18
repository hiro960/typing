import 'diary_post.dart';

class DiaryHashtagTrend {
  const DiaryHashtagTrend({
    required this.tag,
    required this.usage,
  });

  final String tag;
  final int usage;

  factory DiaryHashtagTrend.fromJson(Map<String, dynamic> json) {
    return DiaryHashtagTrend(
      tag: json['tag'] as String,
      usage: json['usage'] as int? ?? 0,
    );
  }
}

class DiaryUserSearchPage {
  DiaryUserSearchPage({
    required this.users,
    required this.pageInfo,
  });

  final List<DiaryUserSummary> users;
  final DiaryPageInfo pageInfo;

  bool get hasNextPage => pageInfo.hasNextPage;
  String? get nextCursor => pageInfo.nextCursor;
}

class DiaryHashtagSearchPage {
  DiaryHashtagSearchPage({
    required this.tags,
    required this.pageInfo,
  });

  final List<DiaryHashtagTrend> tags;
  final DiaryPageInfo pageInfo;

  bool get hasNextPage => pageInfo.hasNextPage;
  String? get nextCursor => pageInfo.nextCursor;
}
