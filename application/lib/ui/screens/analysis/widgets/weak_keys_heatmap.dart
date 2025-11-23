import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class WeakKeysHeatmap extends StatelessWidget {
  const WeakKeysHeatmap({super.key, required this.weakKeys});

  final List<WeakKey> weakKeys;

  static const _hangulRows = [
    ['ㅂ', 'ㅈ', 'ㄷ', 'ㄱ', 'ㅅ', 'ㅛ', 'ㅕ', 'ㅑ', 'ㅐ', 'ㅔ'],
    ['ㅁ', 'ㄴ', 'ㅇ', 'ㄹ', 'ㅎ', 'ㅗ', 'ㅓ', 'ㅏ', 'ㅣ'],
    [' ','ㅋ', 'ㅌ', 'ㅊ', 'ㅍ', 'ㅠ', 'ㅜ', 'ㅡ', ' '],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Calculate max count for normalization
    final maxCount = weakKeys.fold<int>(0, (max, e) => e.count > max ? e.count : max);
    final keyMap = {for (var e in weakKeys) e.key: e.count};

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          for (final row in _hangulRows) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final key in row) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: _HeatmapKey(
                        label: key,
                        count: keyMap[key] ?? 0,
                        maxCount: maxCount,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeatmapKey extends StatelessWidget {
  const _HeatmapKey({
    required this.label,
    required this.count,
    required this.maxCount,
  });

  final String label;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate intensity (0.0 - 1.0)
    final intensity = maxCount > 0 ? count / maxCount : 0.0;
    
    // Color interpolation: Surface -> Red
    final color = Color.lerp(
      theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      theme.colorScheme.error,
      intensity,
    )!;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: intensity > 0 
                ? theme.colorScheme.error.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: intensity > 0.5 
                    ? theme.colorScheme.onError 
                    : theme.colorScheme.onSurface,
              ),
            ),
            if (count > 0)
              Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 8,
                  color: intensity > 0.5 
                      ? theme.colorScheme.onError.withValues(alpha: 0.8)
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
