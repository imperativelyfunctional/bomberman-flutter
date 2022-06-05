import 'package:bonfire/bonfire.dart';

class Brick extends GameDecorationWithCollision {
  Brick(Vector2 position, Vector2 size, Future<Sprite> sprite,
      Iterable<CollisionArea>? collisions)
      : super.withSprite(
            sprite: sprite,
            position: position,
            size: size,
            collisions: collisions);
}
