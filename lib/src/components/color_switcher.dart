import 'dart:math' as math;
import 'package:color_switch_game/src/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColorSwitcher extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final double radius;
  
  ColorSwitcher({
    required super.position,
    this.radius = 20
  });

  @override
  void render(Canvas canvas) {
    final length = gameRef.gameColors.length;
    final sweepAngle = (math.pi * 2) / length;

    for (int i = 0; i < length; i++) {
      canvas.drawArc(
        size.toRect(),
        i * sweepAngle,
        sweepAngle,
        true,
        Paint()..color = gameRef.gameColors[i],
      );
    }
  }
}