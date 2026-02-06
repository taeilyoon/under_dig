import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/game.dart';

class BreakableBlock extends GridEntity with Destructible, HasGameRef<MyGame> {
  late PositionComponent visual;
  bool _isVisualInitialized = false;

  BreakableBlock({required super.gridX, required super.gridY, int hp = 2})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  @override
  void onDeath() {
    // Hide UI elements immediately
    for (var child in children) {
      if (child != visual) {
        child.removeFromParent();
      }
    }

    if (!_isVisualInitialized) {
      removeFromParent();
      return;
    }

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
    try {
      final sprite = await gameRef.loadSprite('tiles/wall.png');
      visual = SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      );
    } catch (e) {
      // Fallback to Rectangle if sprite fails to load
      visual = RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF8B4513),
        anchor: Anchor.center,
        position: size / 2,
      );
    }

    _isVisualInitialized = true;
    add(visual);

    // HP Indicator
    addHpIndicator();
  }
}
