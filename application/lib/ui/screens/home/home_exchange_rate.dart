part of 'home_screen.dart';

/// 為替レート + 翻訳を統合したクイックツールカード
/// モダンなグラスモーフィズム風デザイン
class _QuickToolsCard extends ConsumerWidget {
  const _QuickToolsCard({required this.onTranslationTap});

  final VoidCallback onTranslationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeRateAsync = ref.watch(exchangeRateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.4)
              : AppColors.lightBorder.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          // 為替レート部分
          Expanded(
            child: exchangeRateAsync.when(
              data: (rate) => _ExchangeRateContent(exchangeRate: rate),
              loading: () => _ExchangeRateLoadingContent(baseColor: baseColor),
              error: (_, __) => const _ExchangeRateErrorContent(),
            ),
          ),
          // 区切り線
          Container(
            width: 1,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.outline.withValues(alpha: 0.0),
                  theme.colorScheme.outline.withValues(alpha: 0.2),
                  theme.colorScheme.outline.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // 翻訳ボタン
          _TranslationButton(onTap: onTranslationTap),
        ],
      ),
    );
  }
}

/// 翻訳ボタン
class _TranslationButton extends StatelessWidget {
  const _TranslationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.secondary.withValues(alpha: 0.3),
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.secondary.withValues(alpha: 0.15),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.translate,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '翻訳',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isDark ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExchangeRateContent extends StatelessWidget {
  const _ExchangeRateContent({required this.exchangeRate});

  final ExchangeRate exchangeRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // 為替アイコン
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.primaryBright.withValues(alpha: 0.3),
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primaryBright.withValues(alpha: 0.15),
                    ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Iconsax.dollar_circle,
            size: 18,
            color: isDark ? AppColors.primaryBright : AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '¥100',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Iconsax.arrow_right,
                      size: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${(exchangeRate.rate * 100).toStringAsFixed(0)}₩',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.primaryBright : AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _formatDateTime(exchangeRate.fetchedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'たった今';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}時間前';
    } else {
      return '${diff.inDays}日前';
    }
  }
}

class _ExchangeRateLoadingContent extends StatelessWidget {
  const _ExchangeRateLoadingContent({required this.baseColor});

  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShimmerLoading(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerLoading(
                child: Container(
                  width: 100,
                  height: 18,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ShimmerLoading(
                child: Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExchangeRateErrorContent extends StatelessWidget {
  const _ExchangeRateErrorContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Iconsax.dollar_circle,
            size: 18,
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            '為替レート取得失敗',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
