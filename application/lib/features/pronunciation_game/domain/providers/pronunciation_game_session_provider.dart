import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:chaletta/core/utils/logger.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_game_providers.dart';
import 'package:chaletta/features/ranking_game/data/pixel_characters.dart';

part 'pronunciation_game_session_provider.g.dart';

/// 発音ゲームセッションプロバイダー
@riverpod
class PronunciationGameSession extends _$PronunciationGameSession {
  Timer? _gameTimer;
  SpeechToText? _speechToText;
  bool _speechInitialized = false;
  bool _isListeningActive = false;
  DateTime? _lastRestartTime;
  bool _isProcessingResult = false; // 正解/不正解処理中フラグ
  bool _isDisposed = false; // プロバイダーが破棄されたかどうか

  @override
  PronunciationGameSessionState build(String difficulty) {
    _isDisposed = false; // 再ビルド時にリセット
    ref.onDispose(() {
      _isDisposed = true; // 破棄フラグを設定
      _gameTimer?.cancel();
      // onDispose内ではstateを変更できないため、直接停止処理のみ行う
      _disposeListening();
    });
    return PronunciationGameSessionState.initial(difficulty);
  }

  /// onDispose用のクリーンアップ（stateを変更しない）
  void _disposeListening() {
    _isListeningActive = false;
    if (_speechToText != null) {
      try {
        _speechToText!.stop();
        _speechToText!.cancel();
      } catch (e) {
        // onDispose時のエラーは無視
      }
    }
  }

  /// 利用可能な韓国語ロケールID
  String? _koreanLocaleId;

  /// 前回のセッションをクリーンアップ
  Future<void> _cleanupPreviousSession() async {
    AppLogger.info(
      'Cleaning up previous session',
      tag: 'PronunciationGameSession',
    );

    // タイマーをキャンセル
    _gameTimer?.cancel();
    _gameTimer = null;

    // 音声認識を停止
    await _stopListening();

    // 音声認識インスタンスをリセット（再初期化のため）
    if (_speechToText != null) {
      try {
        await _speechToText!.cancel();
      } catch (e) {
        AppLogger.warning(
          'Error cancelling speech: $e',
          tag: 'PronunciationGameSession',
        );
      }
      _speechToText = null;
    }

    // 全てのフラグをリセット
    _speechInitialized = false;
    _isListeningActive = false;
    _isProcessingResult = false;
    _lastRestartTime = null;
    _koreanLocaleId = null;

    // 状態をリセット
    state = PronunciationGameSessionState.initial(state.difficulty);

    AppLogger.info(
      'Previous session cleaned up successfully',
      tag: 'PronunciationGameSession',
    );
  }

  /// 音声認識を初期化
  Future<bool> initializeSpeech() async {
    if (_speechInitialized) return true;

    _speechToText = SpeechToText();
    try {
      _speechInitialized = await _speechToText!.initialize(
        onError: (error) {
          // プロバイダーが破棄されている場合は何もしない
          if (_isDisposed) return;

          AppLogger.error(
            'Speech recognition error: ${error.errorMsg}, isListeningActive=$_isListeningActive',
            tag: 'PronunciationGameSession',
          );

          // リスニングがアクティブだった場合のみ再開処理を行う
          final wasListening = _isListeningActive;

          // エラー発生時はフラグをリセット
          _isListeningActive = false;

          // リスニング中にエラーが発生した場合は再開
          if (wasListening && !_isDisposed && state.isPlaying && !state.isFinished && !_isProcessingResult) {
            AppLogger.info(
              'Error occurred during listening, restarting after delay...',
              tag: 'PronunciationGameSession',
            );
            // 少し待ってからリスニングを再開
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!_isDisposed && state.isPlaying && !state.isFinished && !_isProcessingResult && !_isListeningActive) {
                _startListening();
              }
            });
          }
        },
        onStatus: (status) {
          // プロバイダーが破棄されている場合は何もしない
          if (_isDisposed) return;

          AppLogger.info(
            'Speech recognition status: $status, isListeningActive=$_isListeningActive',
            tag: 'PronunciationGameSession',
          );
          // 自動的にリスタートする処理（デバウンス付き）
          if (status == 'notListening' &&
              !_isDisposed &&
              state.isPlaying &&
              !state.isFinished &&
              !_isProcessingResult) {
            // isListeningActiveがtrueだった場合、またはstate.isListeningがtrueの場合に再開
            if (_isListeningActive || state.isListening) {
              _isListeningActive = false; // フラグをリセット
              final now = DateTime.now();
              // 前回のリスタートから500ms以上経過している場合のみ再起動
              if (_lastRestartTime == null ||
                  now.difference(_lastRestartTime!).inMilliseconds > 500) {
                _lastRestartTime = now;
                AppLogger.info(
                  'Restarting listening due to notListening status',
                  tag: 'PronunciationGameSession',
                );
                _restartListening();
              } else {
                AppLogger.info(
                  'Skipping restart: debounce period',
                  tag: 'PronunciationGameSession',
                );
              }
            }
          }
        },
      );

      // 韓国語ロケールを検索
      if (_speechInitialized) {
        final locales = await _speechToText!.locales();
        AppLogger.info(
          'Available locales: ${locales.map((l) => l.localeId).toList()}',
          tag: 'PronunciationGameSession',
        );
        // ko_KR, ko, korean などを探す
        for (final locale in locales) {
          if (locale.localeId.toLowerCase().startsWith('ko')) {
            _koreanLocaleId = locale.localeId;
            AppLogger.info(
              'Found Korean locale: $_koreanLocaleId',
              tag: 'PronunciationGameSession',
            );
            break;
          }
        }
        if (_koreanLocaleId == null) {
          AppLogger.warning(
            'Korean locale not found, using default',
            tag: 'PronunciationGameSession',
          );
        }
      }

      return _speechInitialized;
    } catch (e) {
      AppLogger.error(
        'Failed to initialize speech recognition',
        tag: 'PronunciationGameSession',
        error: e,
      );
      return false;
    }
  }

  /// ゲームを開始
  Future<void> startGame() async {
    // 前回のゲームセッションをクリーンアップ
    await _cleanupPreviousSession();

    // 音声認識を初期化
    final initialized = await initializeSpeech();
    if (!initialized) {
      AppLogger.error(
        'Failed to initialize speech recognition',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    // 単語をロード（ランキングゲームと同じ単語を使用）
    final wordLoader = ref.read(wordLoaderServiceProvider);
    final difficultyEnum = RankingGameDifficulty.values.firstWhere(
      (d) => d.name == state.difficulty,
      orElse: () => RankingGameDifficulty.beginner,
    );

    var words = await wordLoader.loadAndShuffleWords(difficultyEnum);

    // 初級モードでは1文字の単語を除外（세/새など発音で聞き分けられないものがあるため）
    if (state.difficulty == 'beginner') {
      words = words.where((w) => w.word.length >= 2).toList();
      AppLogger.info(
        'Filtered beginner words: ${words.length} words (excluded single-char words)',
        tag: 'PronunciationGameSession',
      );
    }

    // 単語を発音ゲーム用に変換
    final pronunciationWords = words.map((w) => PronunciationGameWord(
      word: w.word,
      meaning: w.meaning,
    )).toList();

    state = state.copyWith(
      wordQueue: pronunciationWords,
      currentWord: pronunciationWords.isNotEmpty ? pronunciationWords.first : null,
      isPlaying: true,
      startTime: DateTime.now(),
      wordIndex: 0,
    );

    // タイマー開始（100ms間隔）
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _tick();
    });

    // 音声認識開始
    await _startListening();
  }

  /// 音声認識を開始
  Future<void> _startListening() async {
    AppLogger.info(
      'Starting listening: speechToText=$_speechToText, initialized=$_speechInitialized, active=$_isListeningActive',
      tag: 'PronunciationGameSession',
    );

    if (_speechToText == null || !_speechInitialized) {
      AppLogger.warning(
        'Cannot start listening: speechToText or not initialized',
        tag: 'PronunciationGameSession',
      );
      return;
    }
    if (_isListeningActive) {
      AppLogger.info(
        'Listening already active, skipping',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    _isListeningActive = true;
    // リスニング開始時に認識テキストをクリア
    state = state.copyWith(isListening: true, recognizedText: '');

    try {
      // 既存のリスニングセッションをキャンセル
      if (_speechToText!.isListening) {
        await _speechToText!.stop();
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 検出した韓国語ロケール、なければko_KRを使用
      final localeId = _koreanLocaleId ?? 'ko_KR';
      AppLogger.info(
        'Using locale: $localeId, speechToText.isListening=${_speechToText!.isListening}',
        tag: 'PronunciationGameSession',
      );

      await _speechToText!.listen(
        onResult: _onSpeechResult,
        localeId: localeId,
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
        listenFor: const Duration(seconds: 10), // 最大10秒間リスニング
        pauseFor: const Duration(seconds: 2), // 2秒の無音で判定
      );
      AppLogger.info(
        'Speech listening started successfully with locale: $localeId',
        tag: 'PronunciationGameSession',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to start listening',
        tag: 'PronunciationGameSession',
        error: e,
      );
      _isListeningActive = false;
      state = state.copyWith(isListening: false);

      // エラー発生時はリトライ
      if (state.isPlaying && !state.isFinished && !_isProcessingResult) {
        AppLogger.info(
          'Retrying listening after error...',
          tag: 'PronunciationGameSession',
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (state.isPlaying && !state.isFinished && !_isProcessingResult && !_isListeningActive) {
            _startListening();
          }
        });
      }
    }
  }

  /// 音声認識を再開（停止してから開始）
  Future<void> _restartListening() async {
    AppLogger.info(
      'Restarting listening: isPlaying=${state.isPlaying}, isFinished=${state.isFinished}',
      tag: 'PronunciationGameSession',
    );

    if (!state.isPlaying || state.isFinished) {
      AppLogger.info(
        'Skip restart: game not playing or finished',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    // まず停止
    await _stopListening();

    // 認識テキストはクリアしない（再開時に_startListeningでクリアされる）

    // 少し待ってから再開
    await Future.delayed(const Duration(milliseconds: 300));
    if (!state.isPlaying || state.isFinished) return;

    await _startListening();
  }

  /// 音声認識を停止
  Future<void> _stopListening() async {
    _isListeningActive = false;
    if (_speechToText != null && _speechToText!.isListening) {
      await _speechToText!.stop();
    }
    if (state.isListening) {
      state = state.copyWith(isListening: false);
    }
  }

  /// 音声認識結果を処理
  void _onSpeechResult(SpeechRecognitionResult result) {
    AppLogger.info(
      'Speech result received: "${result.recognizedWords}", final: ${result.finalResult}',
      tag: 'PronunciationGameSession',
    );

    if (!state.isPlaying || state.currentWord == null) {
      AppLogger.info(
        'Ignoring result: isPlaying=${state.isPlaying}, currentWord=${state.currentWord}',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    final recognizedText = result.recognizedWords;

    // 即座に状態を更新してUIに反映
    state = state.copyWith(recognizedText: recognizedText);

    AppLogger.info(
      'State updated with recognizedText: "$recognizedText"',
      tag: 'PronunciationGameSession',
    );

    // 認識されたテキストとターゲットを比較
    _checkRecognition(recognizedText, result.finalResult);
  }

  /// テキストを正規化（スペース、句読点、記号を除去）
  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .trim()
        // 全角・半角スペースを除去
        .replaceAll(' ', '')
        .replaceAll('　', '')
        // 句読点・記号を除去
        .replaceAll(RegExp(r'[.,!?。、！？·\-]'), '');
  }

  /// 認識結果をチェック
  void _checkRecognition(String recognizedText, bool isFinal) {
    if (state.currentWord == null) return;

    // 処理中の場合は新しい判定をスキップ
    if (_isProcessingResult) {
      AppLogger.info(
        'Skipping check: already processing result',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    final target = state.currentWord!.word.toLowerCase().trim();
    final recognized = recognizedText.toLowerCase().trim();

    // 正規化したバージョン（스페이스、句読点を除去）
    final targetNormalized = _normalizeText(state.currentWord!.word);
    final recognizedNormalized = _normalizeText(recognizedText);

    AppLogger.info(
      'Checking: target="$target", recognized="$recognized", '
      'targetNorm="$targetNormalized", recognizedNorm="$recognizedNormalized", isFinal=$isFinal',
      tag: 'PronunciationGameSession',
    );

    // 空の認識結果は無視
    if (recognized.isEmpty) return;

    // 正規化後の比較（メイン判定）
    final normalizedMatch = recognizedNormalized == targetNormalized;

    AppLogger.info(
      'Normalized comparison: "$recognizedNormalized" == "$targetNormalized" => $normalizedMatch',
      tag: 'PronunciationGameSession',
    );

    // 完全一致の場合は即座に正解（正規化後も比較）
    if (recognized == target || normalizedMatch) {
      AppLogger.info(
        'Exact match! Correct!',
        tag: 'PronunciationGameSession',
      );
      _onWordCorrect();
      return;
    }

    // 部分一致の判定（正規化後も比較）
    final containsMatch = recognized.contains(target) ||
        (target.contains(recognized) && recognized.length > 1) ||
        recognizedNormalized.contains(targetNormalized) ||
        (targetNormalized.contains(recognizedNormalized) && recognizedNormalized.length > 1);

    // 十分な長さの判定（70%以上、正規化後で比較）
    final lengthMatch = recognizedNormalized.length >= targetNormalized.length * 0.7;

    AppLogger.info(
      'Partial match check: containsMatch=$containsMatch, lengthMatch=$lengthMatch '
      '(recognizedLen=${recognizedNormalized.length}, targetLen=${targetNormalized.length})',
      tag: 'PronunciationGameSession',
    );

    if (containsMatch && lengthMatch) {
      AppLogger.info(
        'Partial match accepted!',
        tag: 'PronunciationGameSession',
      );
      _onWordCorrect();
    } else if (isFinal) {
      // 最終結果で不正解の場合
      AppLogger.info(
        'Final result mismatch: Mistake! (containsMatch=$containsMatch, lengthMatch=$lengthMatch)',
        tag: 'PronunciationGameSession',
      );
      _onWordMistake();
    }
  }

  /// 正解時の処理
  Future<void> _onWordCorrect() async {
    // 二重処理を防止
    if (_isProcessingResult) return;
    _isProcessingResult = true;

    try {
      // まず音声認識を停止
      await _stopListening();

      final newCombo = state.currentCombo + 1;
      final word = state.currentWord!;
      final scoreGain = _calculateScore(word.word.length, newCombo);
      final newScore = state.score + scoreGain;

      // ボーナス時間計算（コンボに応じて）
      int bonusTime = 0;
      if (newCombo >= 10 && newCombo % 5 == 0) {
        bonusTime = 2; // 5コンボごとに2秒追加
      }

      // Step 1: まず正解フィードバックを表示（現在の単語を維持、スコアを更新）
      state = state.copyWith(
        score: newScore,
        correctCount: state.correctCount + 1,
        currentCombo: newCombo,
        maxCombo: max(state.maxCombo, newCombo),
        characterLevel: _calculateCharacterLevel(newScore),
        totalBonusTime: state.totalBonusTime + bonusTime,
        remainingTimeMs: state.remainingTimeMs + (bonusTime * 1000),
        lastInputResult: PronunciationInputResultType.correct,
        lastInputTime: DateTime.now(),
        // currentWord, wordIndex, recognizedText は維持（フィードバック表示のため）
      );

      // 正解フィードバックを表示する時間（ユーザーが正解を確認できる時間）
      await Future.delayed(const Duration(milliseconds: 800));

      if (!state.isPlaying || state.isFinished) return;

      // Step 2: 次の単語に移行
      final nextWordIndex = state.wordIndex + 1;
      final nextWord = nextWordIndex < state.wordQueue.length
          ? state.wordQueue[nextWordIndex]
          : state.wordQueue[nextWordIndex % state.wordQueue.length];

      state = state.copyWith(
        currentWord: nextWord,
        recognizedText: '',
        wordIndex: nextWordIndex,
        lastInputResult: PronunciationInputResultType.none, // 次の問題ではニュートラルに戻す
      );

      // 少し待ってからリスニングを再開
      await Future.delayed(const Duration(milliseconds: 200));
      if (state.isPlaying && !state.isFinished) {
        await _startListening();
      }
    } finally {
      _isProcessingResult = false;
    }
  }

  /// 不正解時の処理
  Future<void> _onWordMistake() async {
    // 二重処理を防止
    if (_isProcessingResult) return;
    _isProcessingResult = true;

    try {
      // まず音声認識を停止
      await _stopListening();

      // Step 1: 不正解フィードバックを表示（認識テキストは維持）
      state = state.copyWith(
        currentCombo: 0,
        lastInputResult: PronunciationInputResultType.mistake,
        lastInputTime: DateTime.now(),
        totalMistakes: state.totalMistakes + 1,
        // recognizedText は維持（フィードバック表示のため）
      );

      // 不正解フィードバックを表示する時間
      await Future.delayed(const Duration(milliseconds: 600));

      if (!state.isPlaying || state.isFinished) return;

      // Step 2: 再試行のため認識テキストをクリア
      state = state.copyWith(
        recognizedText: '',
        lastInputResult: PronunciationInputResultType.none, // ニュートラルに戻す
      );

      // 少し待ってからリスニングを再開
      await Future.delayed(const Duration(milliseconds: 200));
      if (state.isPlaying && !state.isFinished) {
        await _startListening();
      }
    } finally {
      _isProcessingResult = false;
    }
  }

  /// スキップ処理
  Future<void> skipWord() async {
    if (!state.isPlaying || state.currentWord == null) return;

    // まず音声認識を停止
    await _stopListening();

    // 次の単語を取得
    final nextWordIndex = state.wordIndex + 1;
    final nextWord = nextWordIndex < state.wordQueue.length
        ? state.wordQueue[nextWordIndex]
        : state.wordQueue[nextWordIndex % state.wordQueue.length];

    // 状態を更新（認識テキストをクリア）
    state = state.copyWith(
      currentCombo: 0,
      currentWord: nextWord,
      recognizedText: '',
      wordIndex: nextWordIndex,
      totalMistakes: state.totalMistakes + 1,
    );

    // 少し待ってからリスニングを再開
    await Future.delayed(const Duration(milliseconds: 300));
    if (state.isPlaying && !state.isFinished) {
      await _startListening();
    }
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

  /// スコア計算
  int _calculateScore(int charCount, int combo) {
    final baseScore = charCount * 15; // 発音ゲームはより高いスコア
    final comboBonus = combo * 3;
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
    return PixelCharacters.getEvolutionLevel(score, difficulty: state.difficulty);
  }

  /// ゲーム終了
  void _endGame() {
    _gameTimer?.cancel();
    _stopListening();
    state = state.copyWith(
      isPlaying: false,
      isFinished: true,
      isListening: false,
      remainingTimeMs: 0,
    );
  }

  /// ゲームをリセット
  void reset() {
    _gameTimer?.cancel();
    _stopListening();
    _isListeningActive = false;
    _isProcessingResult = false;
    state = PronunciationGameSessionState.initial(state.difficulty);
  }
}
