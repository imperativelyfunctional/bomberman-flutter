import 'package:bomberman/explosion.dart';
import 'package:bomberman/main.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

class BomberMan extends SimplePlayer with ObjectCollision {
  static const double maxSpeed = 6 * 20;
  bool canAttack = true;

  BomberMan(Vector2 position, Vector2 collisionSize)
      : super(
          animation: PlayerSpriteSheet.simpleDirectionAnimation,
          size: Vector2(16, 16),
          position: position,
          speed: maxSpeed,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(size: collisionSize),
        ],
      ),
    );
  }

  void _attack() {
    if (canAttack) {
      canAttack = false;
      var game = gameRef;
      var bombPosition = Vector2(
              ((position.x + cellSize / 2) ~/ cellSize).toDouble(),
              ((position.y + cellSize / 2) ~/ cellSize).toDouble()) *
          cellSize;
      game.add(AnimatedObjectOnce(
          onFinish: () {
            game.add(Explosion(
              onFinish: () => canAttack = true,
              position: bombPosition - Vector2(cellSize, cellSize),
              size: Vector2(cellSize, cellSize) * 3,
              animation: SpriteAnimation.load(
                "tiled/explosion.png",
                SpriteAnimationData.sequenced(
                  amount: 3,
                  stepTime: 0.6,
                  textureSize: Vector2(48, 48),
                  texturePosition: Vector2(0, 0),
                ),
              ),
            ));
          },
          position: bombPosition,
          size: Vector2(cellSize, cellSize),
          animation: SpriteAnimation.load(
            "tiled/bomb.png",
            SpriteAnimationData.sequenced(
              amount: 3,
              stepTime: 0.4,
              textureSize: Vector2(16, 16),
            ),
          )));
    }
  }

  @override
  void die() {
    super.die();
    gameRef.add(AnimatedObjectOnce(
        position: position,
        size: Vector2.all(cellSize),
        animation: SpriteAnimation.load(
          "tiled/player.png",
          SpriteAnimationData.sequenced(
            amount: 7,
            stepTime: 0.3,
            textureSize: Vector2(16, 16),
            texturePosition: Vector2(0, 32),
          ),
        ))
      ..priority = LayerPriority.getAbovePriority(LayerPriority.MAP));
    removeFromParent();
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN) {
      if (event.id == LogicalKeyboardKey.space.keyId) {
        _attack();
      }
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    speed = maxSpeed * event.intensity;
    super.joystickChangeDirectional(event);
  }
}

class PlayerSpriteSheet {
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "tiled/player.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "tiled/player.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 16),
        ),
      );

  static Future<SpriteAnimation> get runUp => SpriteAnimation.load(
        "tiled/player.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(3 * 16, 16),
        ),
      );

  static Future<SpriteAnimation> get runDown => SpriteAnimation.load(
        "tiled/player.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(3 * 16, 0),
        ),
      );

  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "tiled/player.png",
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(4 * 16, 0),
        ),
      );

  static SimpleDirectionAnimation get simpleDirectionAnimation =>
      SimpleDirectionAnimation(
        runRight: runRight,
        runLeft: runLeft,
        runDown: runDown,
        runUp: runUp,
        idleRight: idleRight,
      );
}
