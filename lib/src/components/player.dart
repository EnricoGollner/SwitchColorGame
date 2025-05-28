import 'package:color_switch_game/src/components/circle_arc.dart';
import 'package:color_switch_game/src/components/color_switcher.dart';
import 'package:color_switch_game/src/components/ground.dart';
import 'package:color_switch_game/src/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final double playerRadius;

  Color _color = Colors.white;
  
  Player({
    required super.position,
    this.playerRadius = 12,
  });

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      radius: playerRadius,
      anchor: anchor,
      collisionType: CollisionType.active,
    ));
  }


  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;

    Ground ground = gameRef.findByKeyName(Ground.keyName)!;

    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      _velocity.setValues(0, 0);
      position = Vector2(0, ground.position.y - (height / 2));
    } else {
      _velocity.y += _gravity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      (size / 2).toOffset(),
      playerRadius,
      Paint()..color = _color,
    );
  }

  void jump() => _velocity.y = -_jumpSpeed;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ColorSwitcher) {
      other.removeFromParent();
      _changeColorRandomly();
    } else if (other is CircleArc) {
      if (_color != other.color) {
        gameRef.gameOver();
      }
    }
  }

  void _changeColorRandomly() => _color = gameRef.gameColors.random();
}