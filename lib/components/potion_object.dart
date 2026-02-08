import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/components/hp_bar.dart';
import 'package:under_dig/managers/effect_manager.dart';

class PotionObject extends GridEntity with Destructible, HasGameRef<MyGame> {
  late PositionComponent visual;
  late HpBarComponent hpBar;

  PotionObject({
    required super.gridX,
    required super.gridY,
  }) : super(size: Vector2.all(GridSystem.tileSize * 0.7)) {
    initDestructible(2); // 2 HP as requested
  }

  void onStep() {
    if (!isMounted) return;
    int nextX = gridX;
    int nextY = gridY + 1;
    if (gameRef.player.gridX == nextX && gameRef.player.gridY == nextY) return;
    if (gameRef.getDestructibleAt(nextX, nextY) != null) return;
    if (GridSystem.isValid(nextX, nextY)) {
      gridY = nextY;
      final targetPosition = GridSystem.gridToWorld(gridX, gridY);
      add(MoveEffect.to(targetPosition, EffectController(duration: 0.15, curve: Curves.easeInOut)));
    }
  }

  @override
  void onDeath() {
    print("Potion Destroyed! Healing Player.");
    gameRef.player.heal(1);
    hpBar.removeFromParent();
    removeHpIndicator();
    
    // Trigger Particle Effect (Cyan for Potion)
    EffectManager().triggerDeathParticles(gameRef, position, const Color(0xFF00FFCC));

    visual.add(ScaleEffect.to(Vector2.all(0), EffectController(duration: 0.2)));
    visual.add(OpacityEffect.to(0, EffectController(duration: 0.2), onComplete: () => removeFromParent()));
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    if (propagate && isMounted) {
      final connected = _findConnectedPotions(gameRef);
      for (final potion in connected) {
        if (potion != this) potion.takeDamage(amount, propagate: false);
      }
    }
    super.takeDamage(amount, propagate: propagate);
    hpBar.updateHp(hp);
    visual.add(ColorEffect(Colors.white, EffectController(duration: 0.05, reverseDuration: 0.05)));
  }

  Set<PotionObject> _findConnectedPotions(MyGame game) {
    Set<PotionObject> visited = {};
    List<PotionObject> queue = [this];
    visited.add(this);
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final neighbors = [_getPotionAt(game, current.gridX, current.gridY - 1), _getPotionAt(game, current.gridX, current.gridY + 1), _getPotionAt(game, current.gridX - 1, current.gridY), _getPotionAt(game, current.gridX + 1, current.gridY)];
      for (final neighbor in neighbors) {
        if (neighbor != null && !visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add(neighbor);
        }
      }
    }
    return visited;
  }

  PotionObject? _getPotionAt(MyGame game, int x, int y) {
    final target = game.getDestructibleAt(x, y);
    return target is PotionObject ? target : null;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;
    try {
      final sprite = await gameRef.loadSprite('items/potion_red.png');
      visual = SpriteComponent(sprite: sprite, size: size, anchor: Anchor.center, position: size / 2);
    } catch (e) {
      visual = RectangleComponent(size: size, paint: Paint()..color = const Color(0xFF00FFCC), anchor: Anchor.center, position: size / 2);
    }
    add(visual);
    hpBar = HpBarComponent(maxHp: maxHp.toDouble(), currentHp: hp.toDouble(), width: size.x, height: 4);
    hpBar.position = Vector2(0, size.y / 2 + 5);
    add(hpBar);
    addHpIndicator();
  }
}
