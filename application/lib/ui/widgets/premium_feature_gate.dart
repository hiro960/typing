import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../app_spacing.dart';

class PremiumFeatureGate extends StatelessWidget {
  const PremiumFeatureGate({
    super.key,
    required this.title,
    required this.description,
    this.onPress,
  });

  final String title;
  final String description;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 42,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '$titleは有料プラン専用です',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FButton(
              onPress: onPress ?? () => Navigator.of(context).maybePop(),
              child: const Text('プランを確認する'),
            ),
          ],
        ),
      ),
    );
  }
}
