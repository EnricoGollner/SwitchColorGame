import 'package:color_switch_game/src/audio/audio_manager.dart';
import 'package:color_switch_game/src/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MyGame _myGame;

  @override
  void initState() {
    _myGame = MyGame(audioManager: AudioManager());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _myGame),
          Visibility(
            visible: !_myGame.isGamePaused,
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => setState(() => _myGame.pauseGame()),
                  icon: const Icon(Icons.pause),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: ValueListenableBuilder(
                valueListenable: _myGame.currentScore,
                builder: (context, int value, child) {
                  return Text(
                    'Score: $value',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                        )
                      ]
                    ),
                  );
                },
              ),
            ),
          ),
          if (_myGame.isGamePaused)
            Container(
              color: Colors.black45,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PAUSED!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: IconButton(
                        onPressed: () => setState(() => _myGame.resumeGame()),
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 140,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
