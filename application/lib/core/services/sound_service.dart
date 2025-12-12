import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 効果音の種類
enum SoundEffect {
  correct,
  incorrect,
}

/// 効果音再生サービス
class SoundService {
  SoundService() : _audioPlayer = AudioPlayer();

  final AudioPlayer _audioPlayer;

  /// 効果音を再生
  Future<void> play(SoundEffect effect) async {
    final soundFile = switch (effect) {
      SoundEffect.correct => 'se/correct.mp3',
      SoundEffect.incorrect => 'se/incorrect.mp3',
    };
    await _audioPlayer.play(AssetSource(soundFile));
  }

  /// 正解音を再生
  Future<void> playCorrect() => play(SoundEffect.correct);

  /// 不正解音を再生
  Future<void> playIncorrect() => play(SoundEffect.incorrect);

  /// リソースを解放
  void dispose() {
    _audioPlayer.dispose();
  }
}

/// SoundServiceのProvider
final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService();
  ref.onDispose(() => service.dispose());
  return service;
});
