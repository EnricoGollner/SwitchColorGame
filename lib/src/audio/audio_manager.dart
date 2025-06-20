import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  Future<void> initialize() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'background.mp3',
      'collect.wav',
    ]);
  }

  Future<void> playBackground() async {
    await FlameAudio.bgm.play('background.mp3');
  }

  Future<void> stopBackground() async {
    await FlameAudio.bgm.stop();
  }

  Future<void> pauseBackground() async {
    await FlameAudio.bgm.pause();
  }

  Future<void> resumeBackground() async {
    await FlameAudio.bgm.resume();
  }
}