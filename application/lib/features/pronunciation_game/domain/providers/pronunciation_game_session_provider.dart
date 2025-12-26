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

/// iOS音声認識セッションの待機時間定数
/// iOSの音声認識エンジンはセッション間で十分なクリーンアップ時間が必要
class _SpeechTimingConstants {
  _SpeechTimingConstants._();

  /// スケジュールされた再起動前の基本待機時間
  static const Duration baseRestartDelay = Duration(milliseconds: 1000);

  /// 再起動処理中のiOSセッションクリーンアップ待機時間
  static const Duration restartCleanupDelay = Duration(milliseconds: 1000);

  /// 正解/不正解/スキップ後の再開前待機時間
  static const Duration resultProcessingDelay = Duration(milliseconds: 800);

  /// 手動再起動時のセッションクリーンアップ待機時間
  static const Duration manualRestartDelay = Duration(milliseconds: 1000);

  /// listen()呼び出し前の既存セッション停止後の待機時間
  static const Duration preListenStopDelay = Duration(milliseconds: 300);

  /// リスニング開始後のフラグ解除前待機時間
  static const Duration postListenSettleDelay = Duration(milliseconds: 300);

  /// 音声認識の最大リスニング時間（iOSの内部タイムアウトより短く設定）
  static const Duration listenForDuration = Duration(seconds: 30);

  /// 無音検出までの待機時間
  /// 重要: iOSの内部タイムアウト（約2秒）より長く設定しても効果がない場合がある
  static const Duration pauseForDuration = Duration(seconds: 10);

  /// 自動再起動の最大連続回数（この回数を超えると自動再起動を停止）
  static const int maxConsecutiveRestarts = 3;

  /// 連続エラー時のバックオフ係数（エラー回数 × この値 の追加待機時間）
  static const Duration backoffIncrement = Duration(milliseconds: 800);

  /// 再起動リクエストのデバウンス時間（この時間内の重複リクエストは無視）
  static const Duration restartDebounceTime = Duration(milliseconds: 500);

  /// No speech detected エラーの連続回数上限（この回数を超えると手動再起動を要求）
  static const int maxNoSpeechErrors = 2;
}

/// 発音ゲームセッションプロバイダー
@riverpod
class PronunciationGameSession extends _$PronunciationGameSession {
  Timer? _gameTimer;
  SpeechToText? _speechToText;
  bool _speechInitialized = false;
  bool _isListeningActive = false;
  bool _isRestartingListening = false; // 再起動処理の排他制御フラグ
  bool _isProcessingResult = false; // 正解/不正解処理中フラグ
  bool _isDisposed = false; // プロバイダーが破棄されたかどうか
  int _sessionId = 0; // 現在のゲームセッションID（古いコールバックを無視するため）

  // 内部状態追跡用
  DateTime? _lastListeningStartTime;
  DateTime? _lastListeningStopTime;
  DateTime? _lastErrorTime;
  DateTime? _lastStatusChangeTime;
  int _restartCount = 0;
  int _errorCount = 0;
  String? _lastStatus;
  String? _lastErrorMsg;

  // 連続再起動制御用
  int _consecutiveRestartCount = 0; // 成功なしでの連続再起動回数
  DateTime? _lastSuccessfulRecognition; // 最後に認識が成功した時刻
  DateTime? _lastRestartScheduleTime; // 最後に再起動がスケジュールされた時刻（デバウンス用）
  int _noSpeechErrorCount = 0; // "No speech detected" エラーの連続回数

  @override
  PronunciationGameSessionState build(PronunciationGameConfig config) {
    AppLogger.info(
      'build() called for config=$config, previous sessionId=$_sessionId',
      tag: 'PronunciationGameSession',
    );

    // 再ビルド時に全てのインスタンス変数をリセット
    // Riverpod の Notifier は再構築時にインスタンス変数をリセットしないため、明示的にリセットが必要
    _gameTimer?.cancel();
    _gameTimer = null;
    _speechToText = null;
    _speechInitialized = false;
    _isListeningActive = false;
    _isRestartingListening = false;
    _isProcessingResult = false;
    _isDisposed = false;
    _sessionId = 0;
    _koreanLocaleId = null;

    // 内部状態のリセット
    _lastListeningStartTime = null;
    _lastListeningStopTime = null;
    _lastErrorTime = null;
    _lastStatusChangeTime = null;
    _restartCount = 0;
    _errorCount = 0;
    _lastStatus = null;
    _lastErrorMsg = null;
    _consecutiveRestartCount = 0;
    _lastSuccessfulRecognition = null;
    _lastRestartScheduleTime = null;
    _noSpeechErrorCount = 0;

    ref.onDispose(() {
      AppLogger.info(
        'onDispose called for config=$config',
        tag: 'PronunciationGameSession',
      );
      _isDisposed = true; // 破棄フラグを設定
      _gameTimer?.cancel();
      // onDispose内ではstateを変更できないため、直接停止処理のみ行う
      _disposeListening();
    });
    return PronunciationGameSessionState.initial(config);
  }

  /// onDispose用のクリーンアップ（stateを変更しない）
  void _disposeListening() {
    _isListeningActive = false;
    _isRestartingListening = false;
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
    _isRestartingListening = false;
    _isProcessingResult = false;
    _koreanLocaleId = null;

    // 状態をリセット（現在の設定を維持）
    state = PronunciationGameSessionState.initial(
      PronunciationGameConfig(
        difficulty: state.difficulty,
        isPracticeMode: state.isPracticeMode,
        targetQuestionCount: state.targetQuestionCount,
      ),
    );

    AppLogger.info(
      'Previous session cleaned up successfully',
      tag: 'PronunciationGameSession',
    );
  }

  /// 音声認識を初期化
  Future<bool> initializeSpeech() async {
    AppLogger.info(
      'initializeSpeech called: initialized=$_speechInitialized, sessionId=$_sessionId',
      tag: 'PronunciationGameSession',
    );

    if (_speechInitialized) {
      AppLogger.info(
        'Speech already initialized, skipping',
        tag: 'PronunciationGameSession',
      );
      return true;
    }

    _speechToText = SpeechToText();
    try {
      _speechInitialized = await _speechToText!.initialize(
        onError: (error) {
          // プロバイダーが破棄されている場合は何もしない
          if (_isDisposed) return;

          // エラー追跡
          _errorCount++;
          final now = DateTime.now();
          _lastErrorTime = now;
          _lastErrorMsg = error.errorMsg;

          // 「No speech detected」は通常のセッション終了なので、特別に処理
          final isNoSpeechError = error.errorMsg.contains('no_speech') ||
              error.errorMsg.contains('error_no_match') ||
              error.errorMsg.contains('No speech');

          if (isNoSpeechError) {
            _noSpeechErrorCount++;
            AppLogger.info(
              'Speech session ended: no speech detected (count=$_noSpeechErrorCount/${_SpeechTimingConstants.maxNoSpeechErrors})',
              tag: 'PronunciationGameSession',
            );
          } else {
            // 他のエラーではNo speechカウントをリセット
            _noSpeechErrorCount = 0;
            AppLogger.warning(
              'Speech error: ${error.errorMsg} (permanent=${error.permanent})',
              tag: 'PronunciationGameSession',
            );
          }

          // エラー発生時はフラグをリセット
          final wasStateListening = state.isListening;
          _isListeningActive = false;
          _lastListeningStopTime = now;

          // state.isListening も必ず false に戻す
          if (wasStateListening) {
            state = state.copyWith(isListening: false);
          }

          // No speech detectedが連続で発生した場合は自動再起動を停止
          if (isNoSpeechError && _noSpeechErrorCount >= _SpeechTimingConstants.maxNoSpeechErrors) {
            AppLogger.warning(
              'Too many consecutive no-speech errors. Waiting for user action.',
              tag: 'PronunciationGameSession',
            );
            // 状態を更新してユーザーにマイクボタンをタップするよう促す
            return;
          }

          // error_no_match や no_speech は permanent=true で来ることがあるが、
          // これらは一時的なエラーなので再起動を試みる
          // Androidでは多くのエラーがpermanent=trueで来るが、実際は回復可能
          final isRecoverableError = isNoSpeechError ||
              error.errorMsg.contains('error_busy') ||
              error.errorMsg.contains('error_client') ||
              error.errorMsg.contains('error_speech_timeout') ||
              error.errorMsg.contains('error_network') ||
              error.errorMsg.contains('error_audio') ||
              error.errorMsg.contains('error_server');

          // permanent=true でも回復可能なエラーなら再起動する
          final shouldRestart = (isRecoverableError || !error.permanent) &&
              !_isDisposed &&
              state.isPlaying &&
              !state.isFinished &&
              !_isProcessingResult;

          if (shouldRestart) {
            _scheduleListeningRestart();
          } else if (error.permanent && !isRecoverableError) {
            // 本当に永続的なエラー（権限なしなど）の場合のみゲームを停止
            AppLogger.error(
              'PERMANENT ERROR - stopping game: ${error.errorMsg}',
              tag: 'PronunciationGameSession',
            );
            _endGame();
          }
        },
        onStatus: (status) {
          // プロバイダーが破棄されている場合は何もしない
          if (_isDisposed) return;

          // ステータス変更追跡
          final now = DateTime.now();
          final previousStatus = _lastStatus;
          _lastStatusChangeTime = now;
          _lastStatus = status;

          // 重要なステータス変更のみログ出力
          if (status != previousStatus) {
            AppLogger.info(
              'Speech status: $previousStatus -> $status',
              tag: 'PronunciationGameSession',
            );
          }

          // セッション終了を示すステータスでフラグを更新
          // 注意: 再起動はonErrorコールバックでのみ行う（競合防止のため）
          // onStatusでは内部フラグのみ更新し、state.isListeningは更新しない
          // （UI表示はisPlayingを基準にしているため、isListeningの頻繁な更新は不要）
          final isEndStatus = status == 'notListening' ||
              status == 'done' ||
              status == 'doneNoResult';

          if (isEndStatus && _isListeningActive) {
            _isListeningActive = false;
            _lastListeningStopTime = now;
            // 注意: ここでは_scheduleListeningRestart()を呼ばない
            // 再起動はonErrorコールバックで処理される
          }
        },
      );

      // 韓国語ロケールを検索（タイムアウト付き）
      if (_speechInitialized) {
        try {
          final locales = await _speechToText!.locales().timeout(
            const Duration(seconds: 1),
            onTimeout: () => [], // タイムアウト時は空リストを返す
          );
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
        } catch (e) {
          // ロケール取得失敗時はデフォルトを使用
        }

        if (_koreanLocaleId == null) {
          // デフォルトで ko_KR を使用
          _koreanLocaleId = 'ko_KR';
          AppLogger.warning(
            'Korean locale not found, using default ko_KR',
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
  /// 戻り値: 成功した場合は true、初期化に失敗した場合は false
  Future<bool> startGame() async {
    // 新しいセッションIDを発行（古いコールバックを無効化するため）
    _sessionId++;
    AppLogger.info(
      'Starting new game session: $_sessionId',
      tag: 'PronunciationGameSession',
    );

    // 前回のゲームセッションをクリーンアップ
    await _cleanupPreviousSession();

    // 音声認識を初期化
    final initialized = await initializeSpeech();
    if (!initialized) {
      AppLogger.error(
        '❌ [startGame] Failed to initialize speech recognition - returning false',
        tag: 'PronunciationGameSession',
      );
      return false;
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

    AppLogger.info(
      '✅ [startGame] Game started successfully',
      tag: 'PronunciationGameSession',
    );
    return true;
  }

  /// 音声認識を開始
  Future<void> _startListening() async {
    if (_speechToText == null || !_speechInitialized) {
      AppLogger.warning(
        'Cannot start listening: speech not initialized',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    if (_isListeningActive) {
      // 既にリスニング中の場合はスキップ
      return;
    }

    final startTime = DateTime.now();
    _isListeningActive = true;
    _lastListeningStartTime = startTime;
    // リスニング状態を更新（recognizedTextは保持 - 自動再起動時に認識結果を消さないため）
    state = state.copyWith(isListening: true);

    // 現在のセッションIDをキャプチャ（古いセッションからのコールバックを無視するため）
    final currentSessionId = _sessionId;

    try {
      // 既存のリスニングセッションをキャンセル
      if (_speechToText!.isListening) {
        await _speechToText!.stop();
        await Future.delayed(_SpeechTimingConstants.preListenStopDelay);
      }

      // 検出した韓国語ロケール、なければko_KRを使用
      final localeId = _koreanLocaleId ?? 'ko_KR';

      AppLogger.info(
        'Starting speech recognition (locale=$localeId)',
        tag: 'PronunciationGameSession',
      );

      await _speechToText!.listen(
        onResult: (result) {
          // セッションIDが一致する場合のみ処理
          if (_sessionId == currentSessionId) {
            _onSpeechResult(result);
          }
        },
        localeId: localeId,
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
        // タイミング定数を使用（iOSの内部タイムアウトと競合しないよう調整済み）
        listenFor: _SpeechTimingConstants.listenForDuration,
        pauseFor: _SpeechTimingConstants.pauseForDuration,
      );

      // speech_to_text v7.0.0以降はlisten()がFuture<void>を返すため、
      // isListeningプロパティで開始成功を確認する
      // 少し待ってからチェック（非同期で状態が更新されるため）
      await Future.delayed(const Duration(milliseconds: 50));

      if (!_speechToText!.isListening) {
        AppLogger.warning(
          'listen() did not start listening - scheduling retry',
          tag: 'PronunciationGameSession',
        );

        _isListeningActive = false;
        _lastListeningStopTime = DateTime.now();
        state = state.copyWith(isListening: false);

        if (state.isPlaying && !state.isFinished && !_isProcessingResult) {
          _scheduleListeningRestart();
        }
        return;
      }

      AppLogger.info(
        'Speech recognition started successfully',
        tag: 'PronunciationGameSession',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to start listening: $e',
        tag: 'PronunciationGameSession',
        error: e,
      );

      _isListeningActive = false;
      _lastListeningStopTime = DateTime.now();
      state = state.copyWith(isListening: false);

      if (state.isPlaying && !state.isFinished && !_isProcessingResult) {
        _scheduleListeningRestart();
      }
    }
  }

  /// 音声認識の再起動をスケジュール（排他制御・デバウンス・バックオフ・最大回数制限付き）
  void _scheduleListeningRestart() {
    final now = DateTime.now();

    // デバウンス: 短期間に複数のリクエストが来た場合は無視
    if (_lastRestartScheduleTime != null) {
      final timeSinceLastSchedule = now.difference(_lastRestartScheduleTime!);
      if (timeSinceLastSchedule < _SpeechTimingConstants.restartDebounceTime) {
        AppLogger.info(
          'Restart debounced (${timeSinceLastSchedule.inMilliseconds}ms since last schedule)',
          tag: 'PronunciationGameSession',
        );
        return;
      }
    }

    _restartCount++;
    _consecutiveRestartCount++;
    _lastRestartScheduleTime = now;

    // 既に再起動処理中の場合はスキップ
    if (_isRestartingListening) {
      AppLogger.info(
        'Restart already in progress, skipping',
        tag: 'PronunciationGameSession',
      );
      return;
    }

    // 最大連続再起動回数を超えた場合は自動再起動を停止
    if (_consecutiveRestartCount > _SpeechTimingConstants.maxConsecutiveRestarts) {
      AppLogger.warning(
        'Max consecutive restarts reached ($_consecutiveRestartCount). '
        'Stopping auto-restart. User can tap mic to restart manually.',
        tag: 'PronunciationGameSession',
      );
      // isListeningをfalseにしてUIに反映（マイクボタンが非アクティブ表示になる）
      if (state.isListening) {
        state = state.copyWith(isListening: false);
      }
      return;
    }

    _isRestartingListening = true;

    // 指数バックオフ: 連続再起動が増えると待機時間を指数的に増やす
    final backoffMultiplier = 1 << (_consecutiveRestartCount - 1); // 2^(count-1)
    final backoffDelay = Duration(
      milliseconds: _SpeechTimingConstants.baseRestartDelay.inMilliseconds +
          (backoffMultiplier * _SpeechTimingConstants.backoffIncrement.inMilliseconds),
    );

    AppLogger.info(
      'Scheduling restart #$_consecutiveRestartCount (delay: ${backoffDelay.inMilliseconds}ms)',
      tag: 'PronunciationGameSession',
    );

    // バックオフ時間を待ってから再起動
    Future.delayed(backoffDelay, () async {
      if (_isDisposed || !state.isPlaying || state.isFinished || _isProcessingResult) {
        _isRestartingListening = false;
        return;
      }

      await _restartListening();
    });
  }

  /// 音声認識を再開（停止してから開始）
  Future<void> _restartListening() async {
    if (!state.isPlaying || state.isFinished) {
      _isRestartingListening = false;
      return;
    }

    // まず停止
    await _stopListening();

    // iOSセッションのクリーンアップを待つ
    await Future.delayed(_SpeechTimingConstants.restartCleanupDelay);

    if (_isDisposed || !state.isPlaying || state.isFinished) {
      _isRestartingListening = false;
      return;
    }

    // _startListening を呼ぶ前に _isRestartingListening を false にして、
    // 失敗時の再試行スケジュールがガードでブロックされないようにする
    _isRestartingListening = false;

    await _startListening();

    // リスニングが開始されたか確認し、失敗していれば再試行をスケジュール
    if (!_isListeningActive && state.isPlaying && !state.isFinished && !_isProcessingResult) {
      _scheduleListeningRestart();
    }
  }

  /// 音声認識を停止
  Future<void> _stopListening() async {
    final wasStateListening = state.isListening;
    final wasSpeechListening = _speechToText?.isListening ?? false;

    _isListeningActive = false;
    _lastListeningStopTime = DateTime.now();

    if (_speechToText != null) {
      // stop() と cancel() の両方を呼んでセッションを完全にクリーンアップ
      if (wasSpeechListening) {
        try {
          await _speechToText!.stop();
        } catch (e) {
          // 停止時のエラーは無視
        }
      }

      // cancel() を呼んでiOSの内部セッションを確実に解放
      try {
        await _speechToText!.cancel();
      } catch (e) {
        // キャンセル時のエラーは無視
      }
    }

    if (wasStateListening) {
      state = state.copyWith(isListening: false);
    }
  }

  /// 音声認識結果を処理
  void _onSpeechResult(SpeechRecognitionResult result) {
    // プロバイダーが破棄されている場合は何もしない
    if (_isDisposed) return;

    if (!state.isPlaying || state.currentWord == null) return;

    final recognizedText = result.recognizedWords;

    // 結果がある場合のみログ出力し、全てのエラーカウントをリセット
    if (recognizedText.isNotEmpty) {
      AppLogger.info(
        'Recognized: "$recognizedText" (final=${result.finalResult}, confidence=${result.confidence.toStringAsFixed(2)})',
        tag: 'PronunciationGameSession',
      );
      // 音声認識が成功したので、全てのエラーカウントをリセット
      _consecutiveRestartCount = 0;
      _noSpeechErrorCount = 0;
      _lastSuccessfulRecognition = DateTime.now();
    }

    // 即座に状態を更新してUIに反映
    state = state.copyWith(recognizedText: recognizedText);

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

  /// 韓国語数字（漢数詞）のマッピング
  static const Map<String, String> _koreanSinoNumbers = {
    '0': '영',
    '1': '일',
    '2': '이',
    '3': '삼',
    '4': '사',
    '5': '오',
    '6': '육',
    '7': '칠',
    '8': '팔',
    '9': '구',
  };

  /// 韓国語数字（固有数詞）のマッピング（1-10）
  static const Map<String, String> _koreanNativeNumbers = {
    '1': '하나',
    '2': '둘',
    '3': '셋',
    '4': '넷',
    '5': '다섯',
    '6': '여섯',
    '7': '일곱',
    '8': '여덟',
    '9': '아홉',
    '10': '열',
  };

  /// 逆マッピング（ハングル→数字）
  static final Map<String, String> _hangulToDigit = {
    // 漢数詞
    '영': '0', '공': '0',
    '일': '1',
    '이': '2',
    '삼': '3',
    '사': '4',
    '오': '5',
    '육': '6', '륙': '6',
    '칠': '7',
    '팔': '8',
    '구': '9',
    '십': '10',
    '백': '100',
    '천': '1000',
    '만': '10000',
    // 固有数詞
    '하나': '1',
    '둘': '2',
    '셋': '3',
    '넷': '4',
    '다섯': '5',
    '여섯': '6',
    '일곱': '7',
    '여덟': '8',
    '아홉': '9',
    '열': '10',
  };

  /// 数字をハングル（漢数詞）に変換
  String _convertDigitsToKorean(String text) {
    var result = text;
    for (final entry in _koreanSinoNumbers.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// ハングル数字を数字に変換
  String _convertKoreanToDigits(String text) {
    var result = text;
    // 長い文字列から先に置換（「하나」を「하」と「나」に分けないように）
    final sortedEntries = _hangulToDigit.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in sortedEntries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// テキストに数字が含まれているか確認
  bool _containsDigits(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  /// テキストにハングル数字が含まれているか確認
  bool _containsKoreanNumbers(String text) {
    for (final key in _hangulToDigit.keys) {
      if (text.contains(key)) return true;
    }
    return false;
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

    // 正規化したバージョン（スペース、句読点を除去）
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
    bool normalizedMatch = recognizedNormalized == targetNormalized;

    // 数字とハングルの変換を使った比較
    if (!normalizedMatch) {
      // 認識結果に数字が含まれている場合、ハングルに変換して比較
      if (_containsDigits(recognizedNormalized)) {
        final recognizedAsKorean = _convertDigitsToKorean(recognizedNormalized);
        if (recognizedAsKorean == targetNormalized) {
          normalizedMatch = true;
          AppLogger.info(
            'Number to Korean match: "$recognizedAsKorean" == "$targetNormalized"',
            tag: 'PronunciationGameSession',
          );
        }
      }

      // ターゲットに数字が含まれている場合、認識結果をハングルに変換して比較
      if (!normalizedMatch && _containsDigits(targetNormalized)) {
        final targetAsKorean = _convertDigitsToKorean(targetNormalized);
        if (recognizedNormalized == targetAsKorean) {
          normalizedMatch = true;
          AppLogger.info(
            'Target number to Korean match: "$recognizedNormalized" == "$targetAsKorean"',
            tag: 'PronunciationGameSession',
          );
        }
      }

      // 両方を数字に変換して比較
      if (!normalizedMatch && (_containsKoreanNumbers(recognizedNormalized) || _containsKoreanNumbers(targetNormalized))) {
        final recognizedAsDigits = _convertKoreanToDigits(recognizedNormalized);
        final targetAsDigits = _convertKoreanToDigits(targetNormalized);
        if (recognizedAsDigits == targetAsDigits) {
          normalizedMatch = true;
          AppLogger.info(
            'Korean to digits match: "$recognizedAsDigits" == "$targetAsDigits"',
            tag: 'PronunciationGameSession',
          );
        }
      }
    }

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

    // 十分な長さの判定（90%以上、正規化後で比較）
    final lengthMatch = recognizedNormalized.length >= targetNormalized.length * 0.9;

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

      // 完了した単語をリストに追加
      final newCompletedWords = [...state.completedWords, word];

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
        completedWords: newCompletedWords,
        // currentWord, wordIndex, recognizedText は維持（フィードバック表示のため）
      );

      // 正解フィードバックを表示する時間（ユーザーが正解を確認できる時間）
      await Future.delayed(const Duration(milliseconds: 800));

      if (!state.isPlaying || state.isFinished) return;

      // 練習モードで目標問題数に達したらゲーム終了
      if (state.isPracticeMode &&
          state.targetQuestionCount != null &&
          state.correctCount >= state.targetQuestionCount!) {
        _endGame();
        return;
      }

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

      // リスニングを再開（再起動処理との競合を防ぐ）
      if (state.isPlaying && !state.isFinished) {
        _isRestartingListening = true; // 再起動処理をブロック
        try {
          // iOSセッションが安定するまで十分待つ
          await Future.delayed(_SpeechTimingConstants.resultProcessingDelay);
          if (_isDisposed || !state.isPlaying || state.isFinished) return;
          await _startListening();
          // リスニングが開始されるまで少し待ってからフラグを解除
          await Future.delayed(_SpeechTimingConstants.postListenSettleDelay);
        } finally {
          _isRestartingListening = false;
        }
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

      // リスニングを再開（再起動処理との競合を防ぐ）
      if (state.isPlaying && !state.isFinished) {
        _isRestartingListening = true; // 再起動処理をブロック
        try {
          // iOSセッションが安定するまで十分待つ
          await Future.delayed(_SpeechTimingConstants.resultProcessingDelay);
          if (_isDisposed || !state.isPlaying || state.isFinished) return;
          await _startListening();
          // リスニングが開始されるまで少し待ってからフラグを解除
          await Future.delayed(_SpeechTimingConstants.postListenSettleDelay);
        } finally {
          _isRestartingListening = false;
        }
      }
    } finally {
      _isProcessingResult = false;
    }
  }

  /// 音声認識を手動で再起動（マイクボタンタップ時）
  Future<void> restartSpeechRecognition() async {
    if (!state.isPlaying || state.isFinished) return;

    // 既に再起動処理中の場合はスキップ
    if (_isRestartingListening) return;

    _isRestartingListening = true;

    try {
      AppLogger.info(
        'Manual restart requested',
        tag: 'PronunciationGameSession',
      );

      // 手動再起動なので全てのエラーカウントをリセット
      _consecutiveRestartCount = 0;
      _noSpeechErrorCount = 0;
      _lastRestartScheduleTime = null;

      // まず現在の音声認識を完全に停止
      _isListeningActive = false;
      _lastListeningStopTime = DateTime.now();

      if (_speechToText != null) {
        try {
          await _speechToText!.stop();
          await _speechToText!.cancel();
        } catch (e) {
          // 停止時のエラーは無視
        }
      }

      // UIに停止状態を反映
      state = state.copyWith(isListening: false, recognizedText: '');

      // iOSセッションのクリーンアップを待つ
      await Future.delayed(_SpeechTimingConstants.manualRestartDelay);

      if (_isDisposed || !state.isPlaying || state.isFinished) return;

      // 音声認識を再開
      await _startListening();
    } finally {
      _isRestartingListening = false;
    }
  }

  /// スキップ処理
  Future<void> skipWord() async {
    if (!state.isPlaying || state.currentWord == null) return;

    // まず音声認識を停止
    await _stopListening();

    // スキップした単語をリストに追加
    final skippedWord = state.currentWord!;
    final newSkippedWords = [...state.skippedWords, skippedWord];

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
      skippedWords: newSkippedWords,
    );

    // リスニングを再開（再起動処理との競合を防ぐ）
    if (state.isPlaying && !state.isFinished) {
      _isRestartingListening = true; // 再起動処理をブロック
      try {
        // iOSセッションが安定するまで十分待つ
        await Future.delayed(_SpeechTimingConstants.resultProcessingDelay);
        if (_isDisposed || !state.isPlaying || state.isFinished) return;
        await _startListening();
        // リスニングが開始されるまで少し待ってからフラグを解除
        await Future.delayed(_SpeechTimingConstants.postListenSettleDelay);
      } finally {
        _isRestartingListening = false;
      }
    }
  }

  /// タイマーティック
  void _tick() {
    if (!state.isPlaying) return;

    // 練習モードでは時間カウントダウンしない
    if (state.isPracticeMode) return;

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
    AppLogger.info(
      'reset() called: sessionId=$_sessionId',
      tag: 'PronunciationGameSession',
    );

    _gameTimer?.cancel();
    _gameTimer = null;
    _stopListening();

    // 音声認識インスタンスを完全にクリーンアップ
    if (_speechToText != null) {
      try {
        _speechToText!.cancel();
      } catch (e) {
        // リセット時のエラーは無視
      }
      _speechToText = null;
    }

    // 全てのフラグをリセット
    _speechInitialized = false;
    _isListeningActive = false;
    _isRestartingListening = false;
    _isProcessingResult = false;
    _koreanLocaleId = null;
    // sessionIdはリセットしない - 次のstartGame()でインクリメントされる

    // 現在の設定を維持してリセット
    state = PronunciationGameSessionState.initial(
      PronunciationGameConfig(
        difficulty: state.difficulty,
        isPracticeMode: state.isPracticeMode,
        targetQuestionCount: state.targetQuestionCount,
      ),
    );
  }
}
