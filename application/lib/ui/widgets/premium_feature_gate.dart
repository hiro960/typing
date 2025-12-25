import 'package:chaletta/features/paywall/domain/subscription_providers.dart';
import 'package:chaletta/features/paywall/domain/subscription_state.dart';
import 'package:chaletta/ui/app_spacing.dart';
import 'package:chaletta/ui/utils/snackbar_helper.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumFeatureGateScreen extends ConsumerStatefulWidget {
  const PremiumFeatureGateScreen({super.key, this.focusFeature});

  final String? focusFeature;

  @override
  ConsumerState<PremiumFeatureGateScreen> createState() =>
      _PremiumFeatureGateScreenState();
}

class _PremiumFeatureGateScreenState
    extends ConsumerState<PremiumFeatureGateScreen> {
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    final featureLabel = widget.focusFeature ?? 'この機能';
    final subscriptionState = ref.watch(subscriptionControllerProvider);

    ref.listen<SubscriptionState>(subscriptionControllerProvider, (prev, next) {
      if (next.isSuccess) {
        final message = _isRestoring ? '購入情報を復元しました！' : 'プロプランにアップグレードしました！';
        SnackBarHelper.showSuccess(context, message);
        Navigator.of(context).maybePop();
      } else if (next.hasError && next.error != null) {
        _logError(next.error!);
        final errorMessage = next.error.toString();

        String displayMessage;
        if (errorMessage.contains('復元できる購入情報が見つかりません')) {
          displayMessage = '復元できる購入情報が見つかりませんでした。';
        } else if (errorMessage.contains('expired') ||
            errorMessage.contains('Subscription has expired')) {
          displayMessage = 'サブスクリプションの期限が切れています。再購入してください。';
        } else {
          displayMessage = '購入に失敗しました。時間をおいて再度お試しください。';
        }

        SnackBarHelper.show(
          context,
          displayMessage,
          duration: const Duration(seconds: 3),
        );

        // エラー後はフラグをリセット
        setState(() {
          _isRestoring = false;
        });
      }
    });

    return AppPageScaffold(
      title: 'プロプラン',
      showBackButton: true,
      child: PremiumFeatureGate(
        focusFeature: featureLabel,
        isLoading: subscriptionState.isLoading,
        onSubscribe: () {
          setState(() {
            _isRestoring = false;
          });
          ref.read(subscriptionControllerProvider.notifier).startSubscription();
        },
        onRestore: () {
          setState(() {
            _isRestoring = true;
          });
          ref.read(subscriptionControllerProvider.notifier).restorePurchases();
        },
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
    this.onRestore,
  });

  final String focusFeature;
  final bool isLoading;
  final VoidCallback? onSubscribe;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Icon(
            Iconsax.crown,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$focusFeatureはプロプラン専用です',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '月額¥600でアップグレードすると、AIサポートと詳細分析が使い放題になります。',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _BenefitCard(
            icon: Iconsax.message,
            title: 'AI先生に質問ができる',
            description: '韓国語の疑問をAIに聞けます。表現の幅をすぐに増やせます。',
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Iconsax.magic_star,
            title: 'AI先生の添削',
            description: '文法・表現のミスを指摘して、より自然な文章に整えます。',
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Iconsax.chart_2,
            title: '詳細な学習分析レポート',
            description: '苦手なキー・成長推移・学習習慣を可視化し、効率アップを後押し。',
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Iconsax.verify,
            title: '日記に認証マーク',
            description: 'プロユーザーの日記には認証マークが表示され、信頼性が高まります。',
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Iconsax.translate,
            title: '日記の翻訳機能',
            description: '韓国語の日記を日本語に翻訳。他のユーザーの投稿内容を簡単に理解できます。',
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Iconsax.volume_high,
            title: '高品質なネイティブ発音',
            description: '発音練習で、AIが生成した高品質な韓国語ネイティブ発音を聴くことができます。',
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: isLoading ? null : onSubscribe,
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('月額¥600でアップグレード'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('後で考える'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: isLoading ? null : onRestore,
            child: Text(
              '購入情報を復元',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          const _LegalTextSection(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

void _logError(Object error) {
  // 本番環境ではログ出力を行わない
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

class _LegalTextSection extends StatefulWidget {
  const _LegalTextSection();

  @override
  State<_LegalTextSection> createState() => _LegalTextSectionState();
}

class _LegalTextSectionState extends State<_LegalTextSection> {
  final _termsRecognizer = TapGestureRecognizer();
  final _privacyRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final linkStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
    );
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.5,
    );

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textStyle,
            children: [
              const TextSpan(text: '購入すると、'),
              TextSpan(
                text: '利用規約',
                style: linkStyle,
                recognizer: _termsRecognizer
                  ..onTap = () => _openUrl('https://chaletta.app/terms'),
              ),
              const TextSpan(text: 'および'),
              TextSpan(
                text: 'プライバシーポリシー',
                style: linkStyle,
                recognizer: _privacyRecognizer
                  ..onTap = () => _openUrl('https://chaletta.app/privacy'),
              ),
              const TextSpan(text: 'に同意したことになります。'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'サブスクリプションは1ヶ月ごとに自動更新されます。\n'
          'いつでもApp Storeの設定から解約できます。',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
