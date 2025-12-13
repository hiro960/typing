import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/listening_settings.dart';
import '../../data/models/word_model.dart';
import 'wordbook_providers.dart';

part 'listening_player_controller.g.dart';

/// 再生状態
enum ListeningPlaybackStatus {
  /// 初期状態
  idle,

  /// 再生中
  playing,

  /// 一時停止中
  paused,
}

/// 現在再生中の言語
enum CurrentlyPlaying {
  /// なし
  none,

  /// 日本語を再生中
  japanese,

  /// 韓国語を再生中
  korean,
}

/// 聞き流し再生の状態
class ListeningPlayerState {
  const ListeningPlayerState({
    required this.words,
    required this.currentIndex,
    required this.status,
    required this.currentlyPlaying,
    required this.loopCount,
  });

  const ListeningPlayerState.initial()
      : words = const <Word>[],
        currentIndex = 0,
        status = ListeningPlaybackStatus.idle,
        currentlyPlaying = CurrentlyPlaying.none,
        loopCount = 0;

  final List<Word> words;
  final int currentIndex;
  final ListeningPlaybackStatus status;
  final CurrentlyPlaying currentlyPlaying;
  final int loopCount;

  /// 現在の単語を取得
  Word? get currentWord =>
      currentIndex >= 0 && currentIndex < words.length
          ? words[currentIndex]
          : null;

  /// 総単語数
  int get totalWords => words.length;

  /// 位置表示テキスト（例: "3 / 25"）
  String get positionText => '${currentIndex + 1} / $totalWords';

  /// 再生中かどうか
  bool get isPlaying => status == ListeningPlaybackStatus.playing;

  /// 一時停止中かどうか
  bool get isPaused => status == ListeningPlaybackStatus.paused;

  /// セッションが開始されているか
  bool get hasSession => words.isNotEmpty;

  ListeningPlayerState copyWith({
    List<Word>? words,
    int? currentIndex,
    ListeningPlaybackStatus? status,
    CurrentlyPlaying? currentlyPlaying,
    int? loopCount,
  }) {
    return ListeningPlayerState(
      words: words ?? this.words,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      currentlyPlaying: currentlyPlaying ?? this.currentlyPlaying,
      loopCount: loopCount ?? this.loopCount,
    );
  }
}

@Riverpod(keepAlive: false)
class ListeningPlayerController extends _$ListeningPlayerController {
  bool _shouldStop = false;

  @override
  ListeningPlayerState build() => const ListeningPlayerState.initial();

  /// 再生開始（単語をシャッフルして再生を開始）
  void start(List<Word> words) {
    if (words.isEmpty) return;

    final shuffled = [...words]..shuffle(Random());
    state = ListeningPlayerState(
      words: shuffled,
      currentIndex: 0,
      status: ListeningPlaybackStatus.playing,
      currentlyPlaying: CurrentlyPlaying.none,
      loopCount: 0,
    );

    _shouldStop = false;
    _playLoop();
  }

  /// 一時停止
  void pause() {
    if (state.status != ListeningPlaybackStatus.playing) return;
    _shouldStop = true;
    ref.read(wordAudioServiceProvider.notifier).stop();
    state = state.copyWith(status: ListeningPlaybackStatus.paused);
  }

  /// 再生再開
  void resume() {
    if (state.status != ListeningPlaybackStatus.paused) return;
    _shouldStop = false;
    state = state.copyWith(status: ListeningPlaybackStatus.playing);
    _playLoop();
  }

  /// 次の単語へスキップ
  void next() {
    if (!state.hasSession) return;
    _shouldStop = true;
    ref.read(wordAudioServiceProvider.notifier).stop();

    final nextIndex = (state.currentIndex + 1) % state.words.length;
    final newLoopCount =
        nextIndex == 0 ? state.loopCount + 1 : state.loopCount;

    state = state.copyWith(
      currentIndex: nextIndex,
      currentlyPlaying: CurrentlyPlaying.none,
      loopCount: newLoopCount,
    );

    if (state.isPlaying || state.isPaused) {
      _shouldStop = false;
      state = state.copyWith(status: ListeningPlaybackStatus.playing);
      _playLoop();
    }
  }

  /// 前の単語へ
  void previous() {
    if (!state.hasSession) return;
    _shouldStop = true;
    ref.read(wordAudioServiceProvider.notifier).stop();

    final prevIndex = state.currentIndex > 0
        ? state.currentIndex - 1
        : state.words.length - 1;

    state = state.copyWith(
      currentIndex: prevIndex,
      currentlyPlaying: CurrentlyPlaying.none,
    );

    if (state.isPlaying || state.isPaused) {
      _shouldStop = false;
      state = state.copyWith(status: ListeningPlaybackStatus.playing);
      _playLoop();
    }
  }

  /// 停止・リセット
  void stop() {
    _shouldStop = true;
    ref.read(wordAudioServiceProvider.notifier).stop();
    state = const ListeningPlayerState.initial();
  }

  /// メインの再生ループ
  Future<void> _playLoop() async {
    final audioService = ref.read(wordAudioServiceProvider.notifier);

    while (!_shouldStop && state.hasSession) {
      final currentWord = state.currentWord;
      if (currentWord == null) break;

      // 設定を取得
      final settings = await ref.read(listeningSettingsProvider.future);

      // 1. 日本語再生
      state = state.copyWith(currentlyPlaying: CurrentlyPlaying.japanese);
      await audioService.speakJapanese(currentWord.meaning);
      if (_shouldStop) break;

      // 2. 日本語→韓国語のインターバル
      await Future.delayed(
        Duration(milliseconds: settings.japaneseToKoreanMs),
      );
      if (_shouldStop) break;

      // 3. 韓国語再生
      state = state.copyWith(currentlyPlaying: CurrentlyPlaying.korean);
      await audioService.speakKorean(currentWord.word);
      if (_shouldStop) break;

      // 4. 次の単語へのインターバル
      await Future.delayed(Duration(milliseconds: settings.wordToWordMs));
      if (_shouldStop) break;

      // 5. 次の単語へ進む（無限ループ）
      final nextIndex = (state.currentIndex + 1) % state.words.length;
      final newLoopCount =
          nextIndex == 0 ? state.loopCount + 1 : state.loopCount;

      state = state.copyWith(
        currentIndex: nextIndex,
        currentlyPlaying: CurrentlyPlaying.none,
        loopCount: newLoopCount,
      );
    }
  }
}
