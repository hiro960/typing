import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/utils/logger.dart';

/// 音声認識の状態
enum SpeechRecognitionStatus {
  notInitialized,
  ready,
  listening,
  done,
  error,
}

/// 音声認識サービス
class SpeechRecognitionService {
  SpeechRecognitionService();

  final SpeechToText _speechToText = SpeechToText();

  SpeechRecognitionStatus _status = SpeechRecognitionStatus.notInitialized;
  String _lastRecognizedText = '';
  String _errorMessage = '';

  /// 現在のステータス
  SpeechRecognitionStatus get status => _status;

  /// 最後に認識されたテキスト
  String get lastRecognizedText => _lastRecognizedText;

  /// エラーメッセージ
  String get errorMessage => _errorMessage;

  /// 音声認識が利用可能かどうか
  bool get isAvailable => _status != SpeechRecognitionStatus.notInitialized &&
      _status != SpeechRecognitionStatus.error;

  /// リスニング中かどうか
  bool get isListening => _status == SpeechRecognitionStatus.listening;

  /// 初期化
  Future<bool> initialize() async {
    try {
      final available = await _speechToText.initialize(
        onError: (error) {
          AppLogger.error(
            'Speech recognition error: ${error.errorMsg}',
            tag: 'SpeechRecognitionService',
          );
          _status = SpeechRecognitionStatus.error;
          _errorMessage = error.errorMsg;
        },
        onStatus: (status) {
          AppLogger.debug(
            'Speech recognition status: $status',
            tag: 'SpeechRecognitionService',
          );
          if (status == 'listening') {
            _status = SpeechRecognitionStatus.listening;
          } else if (status == 'done' || status == 'notListening') {
            _status = SpeechRecognitionStatus.done;
          }
        },
      );

      if (available) {
        _status = SpeechRecognitionStatus.ready;
        AppLogger.info(
          'Speech recognition initialized successfully',
          tag: 'SpeechRecognitionService',
        );
      } else {
        _status = SpeechRecognitionStatus.error;
        _errorMessage = 'Speech recognition not available';
        AppLogger.warning(
          'Speech recognition not available',
          tag: 'SpeechRecognitionService',
        );
      }

      return available;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to initialize speech recognition',
        tag: 'SpeechRecognitionService',
        error: error,
        stackTrace: stackTrace,
      );
      _status = SpeechRecognitionStatus.error;
      _errorMessage = error.toString();
      return false;
    }
  }

  /// 音声認識を開始
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (_status == SpeechRecognitionStatus.notInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        return;
      }
    }

    _lastRecognizedText = '';
    _errorMessage = '';

    try {
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          _lastRecognizedText = result.recognizedWords;
          onResult(result.recognizedWords, result.finalResult);
        },
        localeId: 'ko-KR', // 韓国語
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      );
      _status = SpeechRecognitionStatus.listening;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to start listening',
        tag: 'SpeechRecognitionService',
        error: error,
        stackTrace: stackTrace,
      );
      _status = SpeechRecognitionStatus.error;
      _errorMessage = error.toString();
    }
  }

  /// 音声認識を停止
  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      _status = SpeechRecognitionStatus.done;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to stop listening',
        tag: 'SpeechRecognitionService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// 音声認識をキャンセル
  Future<void> cancel() async {
    try {
      await _speechToText.cancel();
      _status = SpeechRecognitionStatus.ready;
      _lastRecognizedText = '';
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to cancel listening',
        tag: 'SpeechRecognitionService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// リセット（再初期化可能な状態に）
  void reset() {
    _status = SpeechRecognitionStatus.ready;
    _lastRecognizedText = '';
    _errorMessage = '';
  }

  /// 利用可能なロケールを取得
  Future<List<LocaleName>> getAvailableLocales() async {
    if (_status == SpeechRecognitionStatus.notInitialized) {
      await initialize();
    }
    return _speechToText.locales();
  }

  /// 韓国語ロケールが利用可能かどうかを確認
  Future<bool> isKoreanAvailable() async {
    final locales = await getAvailableLocales();
    return locales.any((locale) => locale.localeId.startsWith('ko'));
  }
}
