import 'package:flutter/material.dart';

import '../../../features/writing/data/models/writing_models.dart';
import '../../app_spacing.dart';

/// タイピング画面用のレベルバッジ
class LevelBadge extends StatelessWidget {
  const LevelBadge({
    super.key,
    required this.label,
    required this.color,
    this.alignment = Alignment.centerLeft,
  });

  /// バッジのラベル
  final String label;

  /// バッジの色
  final Color color;

  /// バッジの配置位置
  final Alignment alignment;

  /// EntryLevelから生成するファクトリコンストラクタ
  factory LevelBadge.fromEntryLevel(EntryLevel level) {
    final (label, color) = switch (level) {
      EntryLevel.template => ('テンプレート', Colors.blue),
      EntryLevel.basic => ('基礎', Colors.green),
      EntryLevel.advanced => ('高級', Colors.orange),
      EntryLevel.sentence => ('例文', Colors.grey),
    };
    return LevelBadge(label: label, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
