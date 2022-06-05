import 'package:bomberman/brick.dart';
import 'package:bonfire/bonfire.dart';

import 'main.dart';

class Explosion extends AnimatedObjectOnce with Sensor {
  Explosion({
    required super.position,
    required super.size,
    required super.animation,
    required super.onFinish,
  }) {
    var vector2 = Vector2(cellSize, cellSize) * 0.9;
    setupSensorArea(areaSensor: [
      CollisionArea.rectangle(size: vector2, align: Vector2(cellSize, 0)),
      CollisionArea.rectangle(size: vector2, align: Vector2(0, cellSize)),
      CollisionArea.rectangle(
          size: vector2, align: Vector2(cellSize, cellSize * 2)),
      CollisionArea.rectangle(
          size: vector2, align: Vector2(cellSize * 2, cellSize)),
    ]);
  }

  @override
  void onContact(GameComponent component) {
    if (component is Brick) {
      component.removeFromParent();
      add(AnimatedObjectOnce(
        animation: SpriteAnimation.load(
          "tiled/tiles.png",
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.5,
            texturePosition: Vector2(5 * 16, 3 * 16),
            textureSize: Vector2(16, 16),
          ),
        ),
        position: component.position,
        size: Vector2(cellSize, cellSize),
      ));
    }

    if (component is Player) {
      component.die();
    }
  }
}
