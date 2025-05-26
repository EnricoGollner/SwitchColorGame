import 'package:color_switch_game/src/components/circle_arc.dart';
import 'package:color_switch_game/src/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'dart:math' as math;

class CircleRotator extends PositionComponent with HasGameRef<MyGame> {
  final double thickness;
  final double rotationSpeed;

  CircleRotator({
    required super.position,
    required super.size,
    this.thickness = 8,
    this.rotationSpeed = 2,
  })  : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  @override
  void onLoad() {
    super.onLoad();

    const circle = math.pi * 2;
    final sweep = circle / gameRef.gameColors.length;
    for (int i = 0; i < gameRef.gameColors.length; i++) {
      add(CircleArc(
        color: gameRef.gameColors[i],
        startAngle: i * sweep,
        sweepAngle: sweep,
      ));
    }
    add(RotateEffect.to(
      math.pi * 2,
      EffectController(
        speed: rotationSpeed,
        infinite: true,
      ),
    ));
  }
}
