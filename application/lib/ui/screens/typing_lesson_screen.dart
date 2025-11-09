import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../mock/mock_data.dart';
import '../widgets/typing_keyboard_mock.dart';

class TypingLessonScreen extends StatelessWidget {
  const TypingLessonScreen({super.key, required this.lesson});

  final LessonInfo lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: Text(lesson.title),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.settings_outlined),
            onPress: () {},
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: lesson.progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '進捗 ${(lesson.progress * 100).round()}%',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            _PromptCard(lesson: lesson),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            const Spacer(),
            TypingKeyboardMock(
              highlightedKeys: const {'ㅎ', 'ㅏ', 'ㄴ', 'ㄱ'},
              highlightShift: false,
              nextKeyLabel: '次は ㄴ',
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.lesson});

  final LessonInfo lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '問題',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(lesson.sampleWord, style: theme.textTheme.displaySmall),
            const SizedBox(height: 4),
            Text(
              '(${lesson.sampleMeaning})',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
              ),
              child: Row(
                children: [
                  Text(
                    '入 力:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('하_', style: theme.textTheme.displaySmall),
                  const Spacer(),
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Color(0xFF7ED321)),
                      SizedBox(width: 8),
                      Icon(Icons.cancel_outlined, color: Color(0xFFD0021B)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
