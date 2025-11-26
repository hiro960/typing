import 'dart:async';
import 'dart:developer' as developer;
// import 'dart:math' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../lessons/data/models/lesson_models.dart';
import '../../../lessons/domain/providers/lesson_progress_providers.dart';
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

  void resume() {
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

  void reset() {
    _timer?.cancel();
    _composer?.reset();
    final current = _currentState;
    if (current == null) return;

    _setState(
      current.copyWith(
        currentSectionIndex: 0,
        currentItemIndex: 0,
        currentPosition: 0,
        inputBuffer: '',
        records: const [],
        mistakeHistory: const {},
        jamoState: JamoState.empty,
        elapsedMs: 0,
        isRunning: false,
        isCompleted: false,
      ),
    );
  }

  void handleCharacter(String char) {
    final current = _currentState;
    final composer = _composer;
    if (current == null || current.isCompleted || composer == null) {
      return;
    }

    // すべての文字を字母レベルで処理
    // 期待される文字列全体を字母に分解
    final targetText = _currentItemFromState(current).text;
    final targetJamos = HangulComposer.decomposeText(targetText);

    // 現在の位置に対応する期待される字母
    final expectedJamoNullable = current.currentPosition < targetJamos.length
        ? targetJamos[current.currentPosition]
        : null;

    if (expectedJamoNullable == null) return;

    // null checkの後、String型の変数に代入
    final expectedJamo = expectedJamoNullable;

    developer.log('Input: $char, Expected jamo: $expectedJamo, Position: ${current.currentPosition}');

    // 字母が入力された場合、即座に検証
    if (_jamos.contains(char)) {
      if (char == expectedJamo) {
        // 正解：composerに入力を渡して表示を更新
        composer.input(char);
        _recordCorrect(current, char, expectedJamo, composer);
      } else {
        // 不正解：ミスを記録してcomposerをリセット
        _recordMistake(current, char, expectedJamo, composer);
      }
    } else if (char == ' ' && expectedJamo == ' ') {
      // スペースの処理
      composer.addSpace();
      _recordCorrect(current, char, expectedJamo, composer);
    } else if (char == '\n' && expectedJamo == '\n') {
      // 改行の処理
      composer.addNewLine();
      _recordCorrect(current, char, expectedJamo, composer);
    } else {
      // 記号・数字などその他の文字の処理
      if (char == expectedJamo) {
        // 正解：composerに入力を渡して次に進む
        composer.input(char);
        _recordCorrect(current, char, expectedJamo, composer);
      } else {
        // 不正解：ミスを記録
        _recordMistake(current, char, expectedJamo, composer);
      }
    }
  }

  void handleSpace() {
    final current = _currentState;
    final composer = _composer;
    if (current == null || current.isCompleted || composer == null) return;

    // 字母レベルで処理
    final targetText = _currentItemFromState(current).text;
    final targetJamos = HangulComposer.decomposeText(targetText);
    final expectedJamo = current.currentPosition < targetJamos.length
        ? targetJamos[current.currentPosition]
        : null;

    if (expectedJamo != null && expectedJamo == ' ') {
      composer.addSpace();
      _recordCorrect(current, ' ', expectedJamo, composer);
    }
  }

  /// 正解を記録して次に進む
  void _recordCorrect(
    TypingSessionState current,
    String inputChar,
    String expectedJamo,
    HangulComposer composer,
  ) {
    developer.log('Correct! Moving to next jamo');

    final updatedRecords = [...current.records];
    updatedRecords.add(
      InputRecord(
        key: inputChar,
        expectedChar: expectedJamo,
        isCorrect: true,
        timestamp: DateTime.now(),
        sectionIndex: current.currentSectionIndex,
        itemIndex: current.currentItemIndex,
      ),
    );

    _setState(
      current.copyWith(
        currentPosition: current.currentPosition + 1,
        records: updatedRecords,
        inputBuffer: composer.text,
        jamoState: composer.jamoState,
      ),
    );

    _checkItemCompletion();
  }

  /// ミスを記録してcomposerをリセット
  void _recordMistake(
    TypingSessionState current,
    String inputChar,
    String expectedJamo,
    HangulComposer composer,
  ) {
    developer.log('Mistake! Expected: $expectedJamo, Got: $inputChar');

    final updatedMistakes = Map<String, int>.from(current.mistakeHistory);
    updatedMistakes[inputChar] = (updatedMistakes[inputChar] ?? 0) + 1;

    final updatedRecords = [...current.records];
    updatedRecords.add(
      InputRecord(
        key: inputChar,
        expectedChar: expectedJamo,
        isCorrect: false,
        timestamp: DateTime.now(),
        sectionIndex: current.currentSectionIndex,
        itemIndex: current.currentItemIndex,
      ),
    );

    // composerをリセット
    composer.reset();

    _setState(
      current.copyWith(
        mistakeHistory: updatedMistakes,
        records: updatedRecords,
        inputBuffer: '',
        jamoState: JamoState.empty,
      ),
    );
  }

  void handleBackspace() {
    final current = _currentState;
    final composer = _composer;
    if (current == null || current.isCompleted || composer == null) {
      return;
    }

    composer.backspace();

    // Backspaceは確定文字を削除する可能性がある
    _setState(
      current.copyWith(
        inputBuffer: composer.text,
        jamoState: composer.jamoState,
      ),
    );
  }

  /// 字母（初声・中声・終声）のセット
  static const _jamos = {
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
  };


  void _checkItemCompletion() {
    final current = _currentState;
    if (current == null) return;

    // 字母レベルでの完了判定
    final targetText = _currentItemFromState(current).text;
    final targetJamos = HangulComposer.decomposeText(targetText);

    // currentPositionが字母の長さに到達したら完了
    if (current.currentPosition >= targetJamos.length) {
      _composer?.reset();
      _advanceToNextItem();
    }
  }

  LessonSection _currentSection(TypingSessionState current) =>
      current.lesson.content.sections[current.currentSectionIndex];

  LessonItem _currentItemFromState(TypingSessionState current) =>
      _currentSection(current).items[current.currentItemIndex];

  /// レッスン内の総問題数を計算
  int _calculateTotalItems(TypingSessionState state) {
    return state.lesson.content.sections.fold(
      0,
      (sum, section) => sum + section.items.length,
    );
  }

  /// 現在までに完了した問題数を計算
  int _calculateCompletedItems(TypingSessionState state) {
    int completed = 0;

    // 完了済みセクションの全アイテムを加算
    for (int i = 0; i < state.currentSectionIndex; i++) {
      completed += state.lesson.content.sections[i].items.length;
    }

    // 現在のセクションで完了したアイテムを加算（+1は現在完了したアイテムを含む）
    completed += state.currentItemIndex + 1;

    return completed;
  }

  /// WPMを計算
  int _calculateWpm(int correctCount, int elapsedMs) {
    if (elapsedMs <= 0) {
      return 0;
    }
    final minutes = elapsedMs / 60000;
    if (minutes == 0) {
      return 0;
    }
    return (correctCount / minutes).round();
  }

  /// 正解率を計算
  /// 正解率 = (入力文字数 - ミス入力文字数) / 入力文字数
  double _calculateAccuracy(TypingSessionState state) {
    final totalCount = state.records.length;
    final incorrectCount = state.records.where((r) => !r.isCorrect).length;
    return totalCount == 0 ? 0.0 : (totalCount - incorrectCount) / totalCount;
  }

  void _advanceToNextItem() {
    final current = _currentState;
    if (current == null) return;

    // 問題完了後に進捗を保存
    final completedItems = _calculateCompletedItems(current);
    final totalItems = _calculateTotalItems(current);
    final wpm = _calculateWpm(current.records.length, current.elapsedMs);
    final accuracy = _calculateAccuracy(current);

    // 進捗を保存（非同期だが待たない）
    ref.read(lessonProgressControllerProvider.notifier).markCompleted(
          lessonId: current.lessonId,
          completedItems: completedItems,
          totalItems: totalItems,
          wpm: wpm,
          accuracy: accuracy,
        );

    final section = current.currentSectionIndex;
    final item = current.currentItemIndex;
    final sectionLength = _currentSection(current).items.length;

    if (item + 1 < sectionLength) {
      _setState(
        current.copyWith(
          currentItemIndex: item + 1,
          currentPosition: 0,
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
          currentPosition: 0,
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
