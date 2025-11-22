part of 'home_screen.dart';

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.focusLesson,
    required this.onFocusTap,
    required this.onCustomPracticeTap,
  });

  final lesson_index.LessonMeta? focusLesson;
  final VoidCallback? onFocusTap;
  final VoidCallback onCustomPracticeTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      const Text('弱点強化'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    focusLesson?.title ?? '全レッスン制覇まであと少し',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FButton(
                    onPress: onFocusTap,
                    style: FButtonStyle.secondary(),
                    child: Text(
                      focusLesson == null ? '完了済み' : '今すぐ開始',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune, color: theme.colorScheme.secondary),
                      const SizedBox(width: 6),
                      const Text('カスタム練習'),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
