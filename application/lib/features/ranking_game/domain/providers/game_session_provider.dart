import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_game_providers.dart';
import 'package:chaletta/features/typing/domain/services/hangul_composer.dart';

part 'game_session_provider.g.dart';

/// ゲームセッションプロバイダー
@riverpod
class RankingGameSession extends _$RankingGameSession {
  Timer? _gameTimer;
  int _totalTypedCharacters = 0;
  final HangulComposer _composer = HangulComposer();

  @override
  RankingGameSessionState build(String difficulty) {
    ref.onDispose(() {
      _gameTimer?.cancel();
    });
    return RankingGameSessionState.initial(difficulty);
  }

  /// ゲームを開始
  Future<void> startGame() async {
    // 単語をロード
    final wordLoader = ref.read(wordLoaderServiceProvider);
    final difficultyEnum = RankingGameDifficulty.values.firstWhere(
      (d) => d.name == state.difficulty,
      orElse: () => RankingGameDifficulty.beginner,
    );

    final words = await wordLoader.loadAndShuffleWords(difficultyEnum);

    state = state.copyWith(
      wordQueue: words,
      currentWord: words.isNotEmpty ? words.first : null,
      isPlaying: true,
      startTime: DateTime.now(),
      wordIndex: 0,
    );

    _totalTypedCharacters = 0;

    // タイマー開始（100ms間隔）
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _tick();
    });
  }

  /// タイマーティック
  void _tick() {
    if (!state.isPlaying) return;

    final newRemainingTime = state.remainingTimeMs - 100;

    if (newRemainingTime <= 0) {
      _endGame();
      return;
    }

    state = state.copyWith(remainingTimeMs: newRemainingTime);
  }

  /// 字母（初声・中声・終声）のセット
  static const _jamos = {
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
  };

  /// 文字入力処理
  void processInput(String input) {
    if (!state.isPlaying || state.currentWord == null) return;

    // ターゲット単語を字母に分解
    final target = state.currentWord!.word;
    final targetJamos = HangulComposer.decomposeText(target);

    // 現在の位置に対応する期待される字母
    if (state.currentPosition >= targetJamos.length) return;
    final expectedJamo = targetJamos[state.currentPosition];

    // 字母が入力された場合
    if (_jamos.contains(input)) {
      if (input == expectedJamo) {
        // 正解：composerに入力を渡して次に進む
        _composer.input(input);
        _onCorrectJamo();
      } else {
        // 不正解：ミスを記録
        _onMistake();
      }
    } else if (input == ' ' && expectedJamo == ' ') {
      // スペースの処理
      _composer.addSpace();
      _onCorrectJamo();
    } else {
      // その他の文字（記号など）
      if (input == expectedJamo) {
        _composer.input(input);
        _onCorrectJamo();
      } else {
        _onMistake();
      }
    }
  }

  /// 正解字母入力時の処理
  void _onCorrectJamo() {
    _totalTypedCharacters++;
    final newComboMeter = state.comboMeter.onCorrectKey();
    final newPosition = state.currentPosition + 1;

    // ターゲット単語の字母数を確認
    final target = state.currentWord!.word;
    final targetJamos = HangulComposer.decomposeText(target);

    state = state.copyWith(
      currentPosition: newPosition,
      inputBuffer: _composer.text,
      comboMeter: newComboMeter,
    );

    // ボーナス時間チェック
    _checkBonusTime(newComboMeter);

    // 単語完了チェック
    if (newPosition >= targetJamos.length) {
      _onWordComplete();
    }
  }

  /// 単語完了時の処理
  void _onWordComplete() {
    final word = state.currentWord!;
    final newCombo = state.currentCombo + 1;
    final scoreGain = _calculateScore(word.word.length, newCombo);
    final newScore = state.score + scoreGain;

    // 次の単語を取得
    final nextWordIndex = state.wordIndex + 1;
    final nextWord = nextWordIndex < state.wordQueue.length
        ? state.wordQueue[nextWordIndex]
        : state.wordQueue[nextWordIndex % state.wordQueue.length];

    // コンポーザーをリセット
    _composer.reset();

    state = state.copyWith(
      score: newScore,
      correctCount: state.correctCount + 1,
      currentCombo: newCombo,
      maxCombo: max(state.maxCombo, newCombo),
      characterLevel: _calculateCharacterLevel(newScore),
      currentWord: nextWord,
      inputBuffer: '',
      currentPosition: 0,
      wordIndex: nextWordIndex,
    );
  }

  /// ミス時の処理
  void _onMistake() {
    // コンポーザーをリセット
    _composer.reset();

    state = state.copyWith(
      currentCombo: 0,
      inputBuffer: '',
      currentPosition: 0,
      comboMeter: state.comboMeter.onMistake(),
    );
  }

  /// バックスペース処理
  void deleteLastCharacter() {
    if (_composer.text.isEmpty || state.currentPosition == 0) return;

    _composer.backspace();
    state = state.copyWith(
      inputBuffer: _composer.text,
      currentPosition: state.currentPosition - 1,
    );
  }

  /// ボーナス時間のチェックと適用
  void _checkBonusTime(ComboMeterState newComboMeter) {
    // bonusGainedは秒単位
    final bonusGained = newComboMeter.totalBonusTime - state.totalBonusTime;
    if (bonusGained > 0) {
      state = state.copyWith(
        // タイマーはミリ秒なので変換して加算
        remainingTimeMs: state.remainingTimeMs + (bonusGained * 1000),
        // totalBonusTimeは秒単位で保持
        totalBonusTime: newComboMeter.totalBonusTime,
      );
    }
  }

  /// スコア計算
  int _calculateScore(int charCount, int combo) {
    final baseScore = charCount * 10;
    final comboBonus = combo * 2;
    final multiplier = switch (state.difficulty) {
      'beginner' => 1.0,
      'intermediate' => 1.5,
      'advanced' => 2.0,
      _ => 1.0,
    };
    return ((baseScore + comboBonus) * multiplier).round();
  }

  /// キャラクターレベル計算
  int _calculateCharacterLevel(int score) {
    // PixelCharacters.evolutionThresholdsと同じ閾値を使用
    const thresholds = [0, 100, 250, 450, 700, 1000];
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (score >= thresholds[i]) return i;
    }
    return 0;
  }

  /// ゲーム終了
  void _endGame() {
    _gameTimer?.cancel();
    state = state.copyWith(
      isPlaying: false,
      isFinished: true,
      remainingTimeMs: 0,
    );
  }

  /// 平均入力速度を取得（文字/分）
  double getAvgInputSpeed() {
    if (state.startTime == null) return 0;
    final elapsedSeconds = DateTime.now().difference(state.startTime!).inSeconds;
    if (elapsedSeconds < 1) return 0;
    return _totalTypedCharacters * 60 / elapsedSeconds;
  }

  /// ゲームをリセット
  void reset() {
    _gameTimer?.cancel();
    _totalTypedCharacters = 0;
    _composer.reset();
    state = RankingGameSessionState.initial(state.difficulty);
  }
}
