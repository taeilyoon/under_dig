import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';

class KeyObject extends GridEntity with HasGameRef<MyGame> {
  KeyObject({required super.gridX, required super.gridY})
      : super(size: Vector2.all(GridSystem.tileSize * 0.6));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    try {
      final sprite = await gameRef.loadSprite('items/key.png');
      add(SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      ));
    } catch (e) {
      // Fallback to a yellow diamond/rectangle if asset is missing
      add(RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.yellow,
        anchor: Anchor.center,
        position: size / 2,
      )..angle = 0.785); // 45 degrees
    }
  }

  void collect() {
    gameRef.scoreEngine.keys++;
    gameRef.notifyUi();
    print("Key collected! Total: ${gameRef.scoreEngine.keys}");
    removeFromParent();
  }
}
