// ignore_for_file: invalid_annotation_target, non_abstract_class_inherits_abstract_member

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'writing_models.freezed.dart';
part 'writing_models.g.dart';

/// エントリのレベル種別
enum EntryLevel {
  template, // 骨子文テンプレート
  basic, // 基礎語彙
  advanced, // 高級語彙
  sentence, // 例文（閲覧のみ、出題対象外）
}

/// 学習モード
enum WritingMode {
  typing, // タイピング練習
  list, // 一覧確認
}

/// 書き取りのレーン種別
enum WritingLane { topik, beginner, hobby }

/// 書き取りエントリ（日本語と韓国語のペア）
@freezed
abstract class WritingEntry with _$WritingEntry {
  const factory WritingEntry({
    required String id,
    required EntryLevel level,
    required String jpText,
    required String koText,
  }) = _WritingEntry;

  factory WritingEntry.fromJson(Map<String, dynamic> json) =>
      _$WritingEntryFromJson(json);
}

/// 書き取りトピック（題材）
@freezed
abstract class WritingTopic with _$WritingTopic {
  const factory WritingTopic({
    required String id,
    required String name,
    required String description,
    required String patternId,
    required List<WritingEntry> entries,
  }) = _WritingTopic;

  factory WritingTopic.fromJson(Map<String, dynamic> json) =>
      _$WritingTopicFromJson(json);
}

/// 書き取りパターン（構成パターン）
@freezed
abstract class WritingPattern with _$WritingPattern {
  const factory WritingPattern({
    required String id,
    required String name,
    required String description,
    required String icon,
    required List<WritingTopic> topics,
    @Default(WritingLane.topik)
    @JsonKey(includeFromJson: false, includeToJson: false)
    WritingLane lane,
  }) = _WritingPattern;

  factory WritingPattern.fromJson(Map<String, dynamic> json) =>
      _$WritingPatternFromJson(json);
}

/// 行ごとの判定履歴
@freezed
abstract class EntryResult with _$EntryResult {
  const factory EntryResult({
    required String entryId,
    required bool correct,
    required DateTime timestamp,
  }) = _EntryResult;

  factory EntryResult.fromJson(Map<String, dynamic> json) =>
      _$EntryResultFromJson(json);
}

/// 書き取り完了記録
@freezed
abstract class WritingCompletion with _$WritingCompletion {
  const factory WritingCompletion({
    required String id,
    required String patternId,
    required String topicId,
    required WritingMode mode,
    required int timeSpent, // 経過時間（秒）
    required DateTime completedAt,
    required List<EntryResult> results,
  }) = _WritingCompletion;

  factory WritingCompletion.fromJson(Map<String, dynamic> json) =>
      _$WritingCompletionFromJson(json);
}

/// 書き取り進捗統計
@freezed
abstract class WritingStats with _$WritingStats {
  const factory WritingStats({
    @Default(0) int totalCompletions,
    @Default(0) int totalCorrect,
    @Default(0) int totalAttempts,
    @Default({}) Map<String, int> patternCompletions,
  }) = _WritingStats;

  factory WritingStats.fromJson(Map<String, dynamic> json) =>
      _$WritingStatsFromJson(json);
}

/// WritingPatternの拡張メソッド
extension WritingPatternExtension on WritingPattern {
  /// アイコン名からIconDataを取得
  IconData getIconData() {
    switch (icon) {
      case 'link':
        return Icons.link;
      case 'compare_arrows':
        return Icons.compare_arrows;
      case 'push_pin':
        return Icons.push_pin;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'description':
        return Icons.description;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'balance':
        return Icons.balance;
      case 'build':
        return Icons.build;
      case 'work':
        return Icons.work;
      default:
        return Icons.help_outline; // デフォルトアイコン
    }
  }
}
