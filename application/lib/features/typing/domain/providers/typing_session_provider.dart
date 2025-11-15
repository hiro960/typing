import 'dart:async';

import 'package:characters/characters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../lessons/data/models/lesson_models.dart';
import '../../../lessons/domain/providers/lesson_providers.dart';
import '../../data/models/typing_models.dart';
import '../services/hangul_composer.dart';

part 'typing_session_provider.g.dart';

@Riverpod(keepAlive: false)
class TypingSession extends _$TypingSession {
  HangulComposer? _composer;
  Timer? _timer;

  @override
  FutureOr<TypingSessionState> build(String lessonId) async {
    final lesson = await ref.watch(lessonDetailProvider(lessonId).future);
    _composer = HangulComposer();
    ref.onDispose(_disposeResources);
    return TypingSessionState(
      lessonId: lessonId,
      lesson: lesson,
      jamoState: JamoState.empty,
    );
  }

  void start() {
    final current = _currentState;
    if (current == null || current.isRunning || current.isCompleted) {
      return;
    }
    _setState(current.copyWith(isRunning: true));
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final latest = _currentState;
      if (latest == null || latest.isCompleted) {
        return;
      }
      _setState(latest.copyWith(elapsedMs: latest.elapsedMs + 100));
    });
  }

  void pause() {
    _timer?.cancel();
    final current = _currentState;
    if (current != null) {
      _setState(current.copyWith(isRunning: false));
    }
  }

  void handleCharacter(String char) {
    final current = _currentState;
    if (current == null || current.isCompleted) {
      return;
    }
    final previous = current.inputBuffer;
    if (char == '\n') {
      _composer?.addNewLine();
    } else {
      _composer?.input(char);
    }
    _syncState(previous);
  }

  void handleSpace() {
    final current = _currentState;
    if (current == null || current.isCompleted) return;
    final previous = current.inputBuffer;
    _composer?.addSpace();
    _syncState(previous);
  }

  void handleBackspace() {
    final current = _currentState;
    if (current == null || current.isCompleted) {
      return;
    }
    final previous = current.inputBuffer;
    _composer?.backspace();
    _syncState(previous);
  }

  void _syncState(String previousBuffer) {
    final composer = _composer;
    final current = _currentState;
    if (composer == null || current == null) {
      return;
    }
    final updatedRecords = _updateRecords(
      current,
      previousBuffer,
      composer.text,
    );
    _setState(
      current.copyWith(
        inputBuffer: composer.text,
        jamoState: composer.jamoState,
        records: updatedRecords,
      ),
    );
    _checkItemCompletion();
  }

  List<InputRecord> _updateRecords(
    TypingSessionState currentState,
    String previous,
    String current,
  ) {
    final target = _currentItemFromState(currentState).text.characters.toList();
    final prevChars = previous.characters.toList();
    final currentChars = current.characters.toList();
    final updated = [...currentState.records];
    final now = DateTime.now();

    if (currentChars.length > prevChars.length) {
      final index = currentChars.length - 1;
      final inserted = currentChars[index];
      final expected = index < target.length ? target[index] : null;
      updated.add(
        InputRecord(
          key: inserted,
          expectedChar: expected,
          isCorrect: expected != null && inserted == expected,
          timestamp: now,
          sectionIndex: currentState.currentSectionIndex,
          itemIndex: currentState.currentItemIndex,
        ),
      );
      return updated;
    }

    if (currentChars.length < prevChars.length) {
      for (int i = updated.length - 1; i >= 0; i--) {
        final record = updated[i];
        if (record.sectionIndex == currentState.currentSectionIndex &&
            record.itemIndex == currentState.currentItemIndex) {
          updated.removeAt(i);
          break;
        }
      }
      return updated;
    }

    if (currentChars.isNotEmpty &&
        prevChars.isNotEmpty &&
        currentChars.last != prevChars.last) {
      for (int i = updated.length - 1; i >= 0; i--) {
        final record = updated[i];
        if (record.sectionIndex == currentState.currentSectionIndex &&
            record.itemIndex == currentState.currentItemIndex) {
          final index = currentChars.length - 1;
          final expected = index < target.length ? target[index] : null;
          updated[i] = InputRecord(
            key: currentChars.last,
            expectedChar: expected,
            isCorrect: expected != null && currentChars.last == expected,
            timestamp: now,
            sectionIndex: record.sectionIndex,
            itemIndex: record.itemIndex,
          );
          break;
        }
      }
    }

    return updated;
  }

  void _checkItemCompletion() {
    final current = _currentState;
    if (current == null) return;
    final target = _currentItemFromState(current).text;
    if (current.inputBuffer == target) {
      _composer?.reset();
      _advanceToNextItem();
    }
  }

  LessonSection _currentSection(TypingSessionState current) =>
      current.lesson.content.sections[current.currentSectionIndex];

  LessonItem _currentItemFromState(TypingSessionState current) =>
      _currentSection(current).items[current.currentItemIndex];

  void _advanceToNextItem() {
    final current = _currentState;
    if (current == null) return;
    final section = current.currentSectionIndex;
    final item = current.currentItemIndex;
    final sectionLength = _currentSection(current).items.length;

    if (item + 1 < sectionLength) {
      _setState(
        current.copyWith(
          currentItemIndex: item + 1,
          inputBuffer: '',
          jamoState: JamoState.empty,
        ),
      );
      return;
    }

    if (section + 1 < current.lesson.content.sections.length) {
      _setState(
        current.copyWith(
          currentSectionIndex: section + 1,
          currentItemIndex: 0,
          inputBuffer: '',
          jamoState: JamoState.empty,
        ),
      );
      return;
    }

    _completeLesson();
  }

  void _completeLesson() {
    _timer?.cancel();
    final current = _currentState;
    if (current == null) return;
    _setState(
      current.copyWith(
        isRunning: false,
        isCompleted: true,
        inputBuffer: '',
        jamoState: JamoState.empty,
      ),
    );
  }

  void _disposeResources() {
    _timer?.cancel();
    _composer = null;
  }

  TypingSessionState? get _currentState => state.asData?.value;

  void _setState(TypingSessionState newState) {
    state = AsyncData(newState);
  }
}
