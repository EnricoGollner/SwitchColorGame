import 'dart:async';

import 'package:color_switch_game/src/components/circle_rotator.dart';
import 'package:color_switch_game/src/components/color_switcher.dart';
import 'package:color_switch_game/src/components/ground.dart';
import 'package:color_switch_game/src/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player myPlayer;
  final List<Color> gameColors;

  MyGame({
    this.gameColors = const [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
    ],
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  @override
  Color backgroundColor() => const Color(0xff222222);

  @override
  FutureOr<void> onLoad() {
    decorator = PaintDecorator.blur(0);
    return super.onLoad();
  }

  @override
  void onMount() {
    _initializeGame();
    super.onMount();
  }

  @override
  void update(double dt) {
    final double cameraY = camera.viewfinder.position.y;
    final double playerY = myPlayer.position.y;

    if (playerY < cameraY) camera.viewfinder.position = Vector2(0, playerY);
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();
    super.onTapDown(event);
  }

  void _initializeGame() {
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2(0, 0));
    _generateGameComponents();
  }

  void _generateGameComponents() {
    world.add(ColorSwitcher(position: Vector2(0, 180)));
    world.add(CircleRotator(
      position: Vector2(0, 0),
      size: Vector2(200, 200),
    ));

    world.add(ColorSwitcher(position: Vector2(0, -200)));
    world.add(CircleRotator(
      position: Vector2(0, -400),
      size: Vector2(150, 150),
    ));
  }

  void gameOver() {
    for (var element in world.children) {
      element.removeFromParent();
    }
    _initializeGame();
  }

  bool get isGamePaused => timeScale == 0;

  void pauseGame() {
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0;
  }

  void resumeGame() {
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1;
  }
}
