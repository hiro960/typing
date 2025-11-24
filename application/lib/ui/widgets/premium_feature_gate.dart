import 'package:chaletta/features/paywall/domain/subscription_providers.dart';
import 'package:chaletta/features/paywall/domain/subscription_state.dart';
import 'package:chaletta/ui/app_spacing.dart';
import 'package:chaletta/ui/utils/snackbar_helper.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumFeatureGateScreen extends ConsumerWidget {
  const PremiumFeatureGateScreen({super.key, this.focusFeature});

  final String? focusFeature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureLabel = focusFeature ?? 'この機能';
    final subscriptionState = ref.watch(subscriptionControllerProvider);

    ref.listen<SubscriptionState>(subscriptionControllerProvider, (prev, next) {
      if (next.isSuccess) {
        SnackBarHelper.showSuccess(context, 'プロプランにアップグレードしました！');
        Navigator.of(context).maybePop();
      } else if (next.hasError && next.error != null) {
        _logError(next.error!);
        // UIには詳細を出さず、短め通知のみ
        SnackBarHelper.show(
          context,
          '購入に失敗しました。時間をおいて再度お試しください。',
          duration: const Duration(seconds: 2),
        );
      }
    });

    return AppPageScaffold(
      header: FHeader.nested(
        title: const Text('プロプラン'),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
      ),
      child: PremiumFeatureGate(
        focusFeature: featureLabel,
        isLoading: subscriptionState.isLoading,
        onSubscribe: () => ref
            .read(subscriptionControllerProvider.notifier)
            .startSubscription(),
      ),
    );
  }
}

class PremiumFeatureGate extends StatelessWidget {
  const PremiumFeatureGate({
    super.key,
    required this.focusFeature,
    this.isLoading = false,
    this.onSubscribe,
  });

  final String focusFeature;
  final bool isLoading;
  final VoidCallback? onSubscribe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Icon(
                Icons.workspace_premium_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                '$focusFeatureはプロプラン専用です',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                '月額¥400でアップグレードすると、AIサポートと詳細分析が使い放題になります。',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _BenefitCard(
              icon: Icons.chat_bubble_outline,
              title: 'AI先生に質問ができる',
              description: '韓国語の疑問をAIに聞けます。表現の幅をすぐに増やせます。',
            ),
            const SizedBox(height: AppSpacing.md),
            _BenefitCard(
              icon: Icons.auto_fix_high_outlined,
              title: 'AI先生の添削',
              description: '文法・表現のミスを指摘して、より自然な文章に整えます。',
            ),
            const SizedBox(height: AppSpacing.md),
            _BenefitCard(
              icon: Icons.analytics_outlined,
              title: '詳細な分析レポート',
              description: '苦手なキー・成長推移・学習習慣を可視化し、効率アップを後押し。',
            ),
            const SizedBox(height: AppSpacing.xxl),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FButton(
                onPress: isLoading ? null : onSubscribe,
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('月額¥400でアップグレード'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('後で考える'),
            ),
          ],
        ),
      ),
    );
  }
}

void _logError(Object error) {
  if (error is PlatformException) {
    debugPrint(
      '[IAP] PlatformException ${error.code}: ${error.message} details=${error.details}',
    );
    return;
  }
  if (error is IAPError) {
    debugPrint(
      '[IAP] ${error.code}: ${error.message} details=${error.details}',
    );
    return;
  }
  debugPrint('[IAP] error: $error');
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
