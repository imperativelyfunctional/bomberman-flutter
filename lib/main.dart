import 'package:bomberman/bomber_man.dart';
import 'package:bomberman/brick.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

late double cellSize;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cellSize = MediaQuery.of(context).size.height / 13;
    return BonfireTiledWidget(
      showCollisionArea: true,
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
      ),
      joystick: Joystick(
        keyboardConfig: KeyboardConfig(),
      ),
      map: TiledWorldMap('tiled/level.json',
          objectsBuilder: {
            'brick': (properties) => Brick(
                    Vector2((properties.position.x ~/ cellSize).toDouble(),
                            (properties.position.y ~/ cellSize).toDouble()) *
                        cellSize,
                    Vector2(cellSize, cellSize),
                    Sprite.load('tiled/tiles.png',
                        srcPosition: Vector2(16 * 4, 16 * 3),
                        srcSize: Vector2(16, 16)),
                    [
                      CollisionArea.polygon(points: [
                        Vector2.zero(),
                        Vector2(cellSize - 2, 0),
                        Vector2(cellSize - 2, cellSize - 2),
                        Vector2(0, cellSize - 2)
                      ])
                    ])
          },
          forceTileSize: Size(cellSize, cellSize)),
      player: BomberMan(
          Vector2(cellSize, cellSize), Vector2(cellSize - 2, cellSize - 2))
        ..size = Vector2(cellSize, cellSize),
    );
  }
}
