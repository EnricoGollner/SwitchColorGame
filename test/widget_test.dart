import 'package:color_switch_game/src/audio/audio_manager.dart';
import 'package:color_switch_game/src/components/ground.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:color_switch_game/src/my_game.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioManager extends Mock implements AudioManager {}

void main() {
  late MockAudioManager mockAudioManager;

  setUp(() {
    mockAudioManager = MockAudioManager();

    when(() => mockAudioManager.initialize()).thenAnswer((_) async {});
    when(() => mockAudioManager.playBackground()).thenAnswer((_) async {});
    when(() => mockAudioManager.pauseBackground()).thenAnswer((_) async {});
    when(() => mockAudioManager.resumeBackground()).thenAnswer((_) async {});
    when(() => mockAudioManager.stopBackground()).thenAnswer((_) async {});
  });

  final flameTester = FlameTester<MyGame>(() => MyGame(audioManager: mockAudioManager));


  group('MyGame Tests', () {
    flameTester.testGameWidget(
      'Initial game state has player, ground, zero score, and not paused',
      setUp: (game, tester) async {
        await game.ready();
        await game.initializeGame();
      },
      verify: (game, tester) async {
        expect(game.myPlayer, isNotNull);
        expect(game.world.contains(game.myPlayer), isTrue);

        final groundCount = game.world.children.whereType<Ground>().length;
        expect(groundCount, equals(1));

        expect(game.currentScore.value, equals(0));
        expect(game.isGamePaused, isFalse);
      },
    );

    flameTester.testGameWidget(
      'Game pauses and resumes, affecting time scale correctly',
      setUp: (game, tester) async {
        await game.ready();
      },
      verify: (game, tester) async {
        final initialY = game.myPlayer.position.y;

        game.pauseGame();
        await tester.pump();
        expect(game.isGamePaused, isTrue);
        expect(game.timeScale, equals(0.0));
        expect(game.myPlayer.position.y, equals(initialY));

        game.resumeGame();
        await tester.pump();
        expect(game.isGamePaused, isFalse);
        expect(game.timeScale, equals(1.0));
      },
    );

    flameTester.testGameWidget(
      'Score increments correctly',
      setUp: (game, tester) async {
        await game.ready();
      },
      verify: (game, tester) async {
        expect(game.currentScore.value, equals(0));

        game.increaseScore();
        expect(game.currentScore.value, equals(1));

        game.increaseScore();
        game.increaseScore();
        expect(game.currentScore.value, equals(3));
      },
    );

    flameTester.testGameWidget(
      'Game over resets state properly',
      setUp: (game, tester) async {
        await game.ready();
        game.increaseScore();
      },
      verify: (game, tester) async {
        expect(game.currentScore.value, equals(1));

        game.gameOver();
        await tester.pump();

        expect(game.isGamePaused, isFalse);
        expect(game.currentScore.value, equals(0));

        expect(game.myPlayer, isNotNull);
        expect(game.world.contains(game.myPlayer), isTrue);
      },
    );
  });
}
