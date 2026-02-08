import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/drop/drop_manager.dart';

class Chest extends GridEntity with Destructible, HasGameRef<MyGame> {
  late PositionComponent _visual;

  Chest({required super.gridX, required super.gridY})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(1); // One hit to attempt opening
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    if (gameRef.scoreEngine.keys > 0) {
      super.takeDamage(amount, propagate: propagate);
    } else {
      print("Needs a key to open this chest!");
    }
  }

  @override
  void onDeath() {
    gameRef.scoreEngine.keys--;
    gameRef.notifyUi();

    print("Chest Opened! Found loot.");
    final item = DropManager().dropItem(gameRef.scoreEngine.stageProgress);
    final success = gameRef.inventory.addItem(item);
    if (success) {
      print('Added ${item.name} to inventory');
    } else {
      print('Inventory full!');
    }
    super.onDeath();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      final sprite = await gameRef.loadSprite('objects/chest.png');
      _visual = SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      );
    } catch (e) {
      _visual = RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.amber,
        anchor: Anchor.center,
        position: size / 2,
      );
    }
    add(_visual);
    addHpIndicator();
  }
}
