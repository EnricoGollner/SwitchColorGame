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
    _myGame = MyGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _myGame),
          Visibility(
            visible: _myGame.isGamePaused,
            replacement:  Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => setState(() => _myGame.pauseGame()),
                icon: const Icon(Icons.pause),
              ),
            ),
            child: Container(
              color: Colors.black45,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PAUSED',
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
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}