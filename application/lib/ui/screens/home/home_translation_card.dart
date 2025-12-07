part of 'home_screen.dart';

/// 翻訳カード
class _TranslationCard extends ConsumerStatefulWidget {
  const _TranslationCard();

  @override
  ConsumerState<_TranslationCard> createState() => _TranslationCardState();
}

class _TranslationCardState extends ConsumerState<_TranslationCard> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 初期テキストを同期
    final initialText = ref.read(translationControllerProvider).inputText;
    _textController.text = initialText;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    ref.read(translationControllerProvider.notifier).updateInputText(text);
  }

  Future<void> _onTranslate() async {
    _focusNode.unfocus();
    await ref.read(translationControllerProvider.notifier).translate();
  }

  void _onToggleDirection() {
    ref.read(translationControllerProvider.notifier).toggleDirection();
  }

  void _onClear() {
    _textController.clear();
    ref.read(translationControllerProvider.notifier).clearInput();
  }

  void _onRestoreHistory(TranslationResult result) {
    _textController.text = result.sourceText;
    ref.read(translationControllerProvider.notifier).restoreFromHistory(result);
  }

  void _onAddToWordbook(TranslationResult result) {
    // 翻訳方向に応じて単語と意味を設定
    // 日本語→韓国語: 韓国語が単語、日本語が意味
    // 韓国語→日本語: 韓国語が単語、日本語が意味
    final String initialWord;
    final String initialMeaning;

    if (result.direction == TranslationDirection.jaToKo) {
      initialWord = result.translatedText; // 韓国語
      initialMeaning = result.sourceText; // 日本語
    } else {
      initialWord = result.sourceText; // 韓国語
      initialMeaning = result.translatedText; // 日本語
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordFormScreen(
          initialWord: initialWord,
          initialMeaning: initialMeaning,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translationState = ref.watch(translationControllerProvider);

    // 翻訳方向のラベル
    final directionLabel =
        translationState.direction == TranslationDirection.jaToKo
            ? '日本語 → 韓国語'
            : '韓国語 → 日本語';

    final placeholderText =
        translationState.direction == TranslationDirection.jaToKo
            ? '日本語を入力してください'
            : '한국어를 입력해 주세요';

    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 方向切り替えボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  directionLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _onToggleDirection,
                  icon: const Icon(Icons.swap_horiz, size: 24),
                  tooltip: '言語を入れ替え',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // 入力欄
            ModernTextInput(
              controller: _textController,
              focusNode: _focusNode,
              placeholder: placeholderText,
              minLines: 2,
              maxLines: 4,
              onChanged: _onTextChanged,
            ),
            const SizedBox(height: AppSpacing.md),

            // 翻訳ボタン
            Row(
              children: [
                Expanded(
                  child: FButton(
                    onPress: translationState.isTranslating ||
                            translationState.inputText.trim().isEmpty
                        ? null
                        : _onTranslate,
                    child: translationState.isTranslating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('翻訳する'),
                  ),
                ),
                if (translationState.inputText.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    onPressed: _onClear,
                    icon: const Icon(Icons.clear, size: 20),
                    tooltip: 'クリア',
                  ),
                ],
              ],
            ),

            // エラーメッセージ
            if (translationState.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        translationState.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 翻訳結果
            if (translationState.translatedText != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.translate,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '翻訳結果',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      translationState.translatedText!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 履歴セクション
            if (translationState.history.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                '直近の翻訳',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...translationState.history.map(
                (result) => _TranslationHistoryItem(
                  result: result,
                  onTap: () => _onRestoreHistory(result),
                  onAddToWordbook: () => _onAddToWordbook(result),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 翻訳履歴アイテム
class _TranslationHistoryItem extends StatelessWidget {
  const _TranslationHistoryItem({
    required this.result,
    required this.onTap,
    required this.onAddToWordbook,
  });

  final TranslationResult result;
  final VoidCallback onTap;
  final VoidCallback onAddToWordbook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final directionIcon = result.direction == TranslationDirection.jaToKo
        ? '日->韓'
        : '韓->日';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                directionIcon,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.sourceText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    result.translatedText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAddToWordbook,
              icon: Icon(
                Icons.add,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              tooltip: '単語帳に追加',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
