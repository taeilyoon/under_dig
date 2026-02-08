import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';

class DoorObject extends GridEntity with HasGameRef<MyGame> {
  late PositionComponent visual;

  DoorObject({required super.gridX, required super.gridY})
      : super(size: Vector2.all(GridSystem.tileSize * 0.9));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    try {
      final sprite = await gameRef.loadSprite('tiles/wall.png');
      visual = SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      );
    } catch (e) {
      visual = RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF5D4037),
        anchor: Anchor.center,
        position: size / 2,
      );
    }
    add(visual);
    
    add(TextComponent(
      text: "EXIT",
      textRenderer: TextPaint(style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
      anchor: Anchor.center,
      position: size / 2,
    ));
  }

  void tryEnter() {
    if (gameRef.scoreEngine.keys > 0) {
      gameRef.scoreEngine.keys--;
      gameRef.notifyUi();
      print("Door Unlocked! Advancing Stage.");
      gameRef.advanceStage();
    } else {
      print("The door is locked. You need a KEY!");
    }
  }
}
