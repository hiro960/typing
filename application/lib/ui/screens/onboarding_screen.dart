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
  int _currentPage = 0;

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
    super.dispose();
  }

  void _openAuth() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SocialAuthScreen()));
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
                        child: const Icon(Icons.bolt, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Midnight Typing',
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
              const SizedBox(height: 32),
              FButton(onPress: _openAuth, child: const Text('ログイン / 新規登録')),
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
    return FCard.raw(
      style: (style) => style.copyWith(
        decoration: style.decoration.copyWith(
          gradient: const LinearGradient(
            colors: [Color(0xFF111726), Color(0xFF0C1220)],
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
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
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
