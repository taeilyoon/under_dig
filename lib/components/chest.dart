import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';

import 'package:under_dig/game.dart';
import 'package:under_dig/drop/drop_manager.dart';

class Chest extends GridEntity with Destructible, HasGameRef<MyGame> {
  late PositionComponent _visual;

  Chest({required super.gridX, required super.gridY, int hp = 1})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  @override
  void onDeath() {
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

    // Visual: Chest Sprite
    final sprite = await gameRef.loadSprite('objects/chest.png');
    _visual = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_visual);

    // HP Indicator (Optional for Chest? Maybe just hit to open)
    addHpIndicator();
  }
}
