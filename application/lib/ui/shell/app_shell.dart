import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/services/push_notification_service.dart';
import '../../features/auth/domain/providers/auth_providers.dart';
import '../../features/typing/domain/providers/typing_providers.dart';
import '../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../screens/diary/bookmarks_screen.dart';
import '../screens/diary/diary_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/diary/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/wordbook/wordbook_screen.dart';
import '../screens/profile/profile_setup_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/diary/post_create_screen.dart';
import '../screens/diary/search_screen.dart';

/// 認証状態に基づいて画面を切り替えるルートウィジェット
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // 認証状態に応じて画面を切り替え
    switch (authState.status) {
      case AuthStatus.initial:
        // 初期化中はローディング画面を表示
        return const _LoadingScreen();

      case AuthStatus.unauthenticated:
        // 未認証の場合はオンボーディング画面（説明画面）を表示
        return const OnboardingScreen();

      case AuthStatus.authenticatedButNotRegistered:
        // 認証済みだが未登録の場合はプロフィール入力画面を表示
        return const ProfileSetupScreen();

      case AuthStatus.authenticated:
        // 認証済みかつ登録済みの場合はメインアプリを表示
        return const _MainAppShell();

      case AuthStatus.error:
        // エラーの場合はエラー画面を表示
        return _ErrorScreen(message: authState.errorMessage ?? '不明なエラー');
    }
  }
}

/// ローディング画面
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// エラー画面
class _ErrorScreen extends ConsumerWidget {
  final String message;

  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.warning_2,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'エラーが発生しました',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  // エラーをクリアしてログアウト
                  ref.read(authStateProvider.notifier).clearError();
                  await ref.read(authStateProvider.notifier).logout();
                },
                icon: const Icon(Iconsax.refresh),
                label: const Text('ログイン画面に戻る'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// メインアプリのシェル (認証済みユーザー向け)
class _MainAppShell extends ConsumerStatefulWidget {
  const _MainAppShell();

  @override
  ConsumerState<_MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<_MainAppShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // アプリ起動時にオフラインキューを処理
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(offlineQueueProvider.notifier).processQueue();
        ref.read(wordbookOfflineQueueProvider.notifier).processQueue();
        PushNotificationService(ref).initialize();
      }
    });
  }

  void _openPostComposer() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PostCreateScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchScreen(),
      ),
    );
  }

  void _openBookmarks() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BookmarksScreen(),
      ),
    );
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onOpenSettings: _openSettings,
        onNavigateToDiary: () => _onDestinationSelected(1),
        onNavigateToWordbook: () => _onDestinationSelected(2),
      ),
      DiaryScreen(
        onOpenSearch: _openSearch,
        onOpenBookmarks: _openBookmarks,
      ),
      const WordbookScreen(),
      const NotificationsScreen(),
      ProfileScreen(onOpenSettings: _openSettings),
    ];

    return FScaffold(
      childPad: false,
      footer: FBottomNavigationBar(
        index: _selectedIndex,
        onChange: _onDestinationSelected,
        children: const [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.bookOpenText),
            label: Text('ホーム'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.notebookPen),
            label: Text('日記'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.bookmark),
            label: Text('単語帳'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.bell),
            label: Text('通知'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.userRound),
            label: Text('プロフィール'),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: screens[_selectedIndex],
          ),
          if (_selectedIndex != 2) // 単語帳画面（インデックス2）では非表示
            Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 24),
              child: _PostFab(onPressed: _openPostComposer),
            ),
        ],
      ),
    );
  }
}

class _PostFab extends StatelessWidget {
  const _PostFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(34),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Center(
            child: Icon(FIcons.plus, size: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
