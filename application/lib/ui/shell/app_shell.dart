import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../mock/mock_data.dart';
import '../screens/diary_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/typing_lesson_screen.dart';
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

  void _onDestinationSelected(int index) {
    if (index == 2) {
      _openPostComposer();
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(onStartLesson: _openTypingLesson),
      DiaryScreen(onCompose: _openPostComposer),
      const SizedBox.shrink(),
      const NotificationsScreen(),
      const ProfileScreen(),
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
            icon: Icon(FIcons.circlePlus),
            label: Text('投稿'),
          ),
          FBottomNavigationBarItem(icon: Icon(FIcons.bell), label: Text('通知')),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.userRound),
            label: Text('プロフィール'),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[_selectedIndex],
      ),
    );
  }
}
