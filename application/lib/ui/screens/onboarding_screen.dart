import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'social_auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  final _termsLinkRecognizer = TapGestureRecognizer();
  int _currentPage = 0;
  bool _agreedToTerms = false;

  static const _slides = [
    (
      title: '指に馴染む韓国語タイピング',
      description: 'テンポに合わせた練習カリキュラムで、毎日の心地良いルーティンに。',
      badge: 'FLOWモード',
      icon: Icons.keyboard_alt_outlined,
    ),
    (
      title: '日記を書いてアウトプット',
      description: 'つぶやき感覚で日常を投稿。翻訳ヒントと添削で自然な韓国語が身につきます。',
      badge: '日記',
      icon: Icons.article_outlined,
    ),
    (
      title: '推し活仲間と繋がる',
      description: 'コミュニティで学習状況をシェアして、仲間と繋がろう！',
      badge: 'コミュニティ',
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _termsLinkRecognizer.dispose();
    super.dispose();
  }

  void _openAuth() {
    if (!_agreedToTerms) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SocialAuthScreen()));
  }

  void _showTermsDialog() {
    final theme = Theme.of(context);
    showFDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context, style, animation) => FDialog.adaptive(
        style: style,
        animation: animation,
        title: const Text('利用規約'),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Text(
              '''本規約は、ユーザーと当社との間の本サービスの利用に関わる一切の関係に適用されます。

【禁止コンテンツ】
当社は、不適切なコンテンツおよび悪質なユーザーに対して一切の寛容を示しません。以下のコンテンツの投稿、共有、送信は固く禁じられています。

1. 暴力的・攻撃的なコンテンツ
暴力を助長、賛美、または描写するコンテンツ、脅迫、いじめ、ハラスメント

2. 差別的なコンテンツ
人種、民族、国籍、宗教、性別、性的指向、障害、その他の特性に基づく差別、ヘイトスピーチ

3. 性的に不適切なコンテンツ
ポルノグラフィー、性的に露骨なコンテンツ、未成年者に関連する不適切なコンテンツ

4. 違法なコンテンツ
違法行為を助長または促進するコンテンツ、著作権・商標権を侵害するコンテンツ

5. 詐欺・誤情報
虚偽の情報、詐欺的なコンテンツ、なりすまし

6. スパム・悪意のあるコンテンツ
未承諾の広告、マルウェア、フィッシング

7. プライバシー侵害
他者の個人情報を無断で公開すること

8. その他の有害なコンテンツ
自傷行為や自殺を助長するコンテンツ、危険な行為を促すコンテンツ

【違反者への措置】
本規約に違反した場合、警告、コンテンツの削除、一時的な利用停止、または永久的なアカウント削除の措置が講じられます。

【ユーザーの責任】
ユーザーは、本サービスを安全で健全なコミュニティとして維持するために協力し、不適切なコンテンツや悪質なユーザーを発見した場合は報告することが推奨されます。

詳細な利用規約はウェブサイトでご確認いただけます。''',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.6,
              ),
            ),
          ),
        ),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FScaffold(
      childPad: false,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.bolt, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'チャレッタ',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '気持ち良いタイピング習慣を',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) =>
                      setState(() => _currentPage = value),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _OnboardingCard(
                        title: slide.title,
                        description: slide.description,
                        badge: slide.badge,
                        icon: slide.icon,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _currentPage == index ? 28 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() => _agreedToTerms = value ?? false);
                      },
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                        children: [
                          TextSpan(
                            text: '利用規約',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _termsLinkRecognizer
                              ..onTap = _showTermsDialog,
                          ),
                          const TextSpan(text: 'に同意する'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FButton(
                onPress: _agreedToTerms ? _openAuth : null,
                child: const Text('ログイン / 新規登録'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
  });

  final String title;
  final String description;
  final String badge;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return FCard.raw(
      style: (style) => style.copyWith(
        decoration: style.decoration.copyWith(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF111726), const Color(0xFF0C1220)]
                : [theme.colorScheme.surfaceContainerHighest, theme.colorScheme.surfaceContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
              child: Text(
                badge,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Icon(icon, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
