import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../mock/mock_data.dart';
import '../screens/diary_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/typing_lesson_screen.dart';
import '../screens/wordbook_screen.dart';
import '../widgets/post_composer_sheet.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _openPostComposer() {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return const PostComposerSheet();
      },
    );
  }

  void _openTypingLesson(LessonInfo lesson) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TypingLessonScreen(lesson: lesson),
      ),
    );
  }

  void _openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onStartLesson: _openTypingLesson,
        onOpenSettings: _openSettings,
      ),
      const DiaryScreen(),
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
          FBottomNavigationBarItem(icon: Icon(FIcons.bell), label: Text('通知')),
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
