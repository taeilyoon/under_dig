import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/game.dart';

class BreakableBlock extends GridEntity with Destructible, HasGameRef<MyGame> {
  late PositionComponent _visual;

  BreakableBlock({required super.gridX, required super.gridY, int hp = 2})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Visual: Wall Sprite
    final sprite = await gameRef.loadSprite('tiles/wall.png');
    _visual = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_visual);

    // HP Indicator
    addHpIndicator();
  }
}
