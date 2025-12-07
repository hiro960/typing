part of 'home_screen.dart';

/// 為替レート + 翻訳を統合したツールカード
class _QuickToolsCard extends ConsumerWidget {
  const _QuickToolsCard({required this.onTranslationTap});

  final VoidCallback onTranslationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeRateAsync = ref.watch(exchangeRateProvider);
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(12),
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
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            // 翻訳ボタン
            InkWell(
              onTap: onTranslationTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.translate,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '日↔️韓翻訳',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

    return Row(
      children: [
        Icon(
          Icons.currency_exchange,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '100円',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${(exchangeRate.rate * 100).toStringAsFixed(1)}₩',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                _formatDateTime(exchangeRate.fetchedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerLoading(
                child: Container(
                  width: 100,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ShimmerLoading(
                child: Container(
                  width: 60,
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

    return Row(
      children: [
        Icon(
          Icons.currency_exchange,
          size: 18,
          color: theme.colorScheme.error,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            '取得失敗',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
