import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/game.dart';

class BreakableBlock extends GridEntity with Destructible, HasGameRef<MyGame> {
  late PositionComponent visual;

  BreakableBlock({required super.gridX, required super.gridY, int hp = 2})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  @override
  void onDeath() {
    // Death Animation
    visual.add(
      ScaleEffect.to(Vector2.all(0), EffectController(duration: 0.15)),
    );
    visual.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.15),
        onComplete: () => removeFromParent(),
      ),
    );
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    super.takeDamage(amount, propagate: propagate);

    // Shake effect on damage
    add(
      MoveEffect.by(
        Vector2(2, 0),
        EffectController(
          duration: 0.05,
          reverseDuration: 0.05,
          alternate: true,
        ),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Visual: Wall Sprite
    final sprite = await gameRef.loadSprite('tiles/wall.png');
    visual = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
      position: size / 2,
    );
    add(visual);

    // HP Indicator
    addHpIndicator();
  }
}
