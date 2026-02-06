import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/game.dart';

import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/components/hp_bar.dart';

class Enemy extends GridEntity with Destructible, HasGameRef<MyGame> {
  // Visual component
  late PositionComponent visual;
  late HpBarComponent hpBar;

  Enemy({
    required super.gridX,
    required super.gridY,
    int hp = 1,
    this.attackPower = 1,
  }) : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  int attackPower;

  @override
  void onDeath() {
    gameRef.scoreEngine.onKill();
    gameRef.scoreEngine.onComboIncrement();
    gameRef.comboTracker.increment();

    // Death Animation: Scale down and fade
    visual.add(ScaleEffect.to(Vector2.all(0), EffectController(duration: 0.2)));
    visual.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.2),
        onComplete: () => removeFromParent(),
      ),
    );
  }

  void onStep() {
    if (!isMounted) return;

    // Calculate new position (Down 1)
    int nextX = gridX;
    int nextY = gridY + 1;

    // 1. Check Collision with Player
    if (gameRef.player.gridX == nextX && gameRef.player.gridY == nextY) {
      return;
    }

    // 2. Check collisions with other blocks/enemies
    if (gameRef.getDestructibleAt(nextX, nextY) != null) {
      return;
    }

    // 3. Move if valid
    if (GridSystem.isValid(nextX, nextY)) {
      gridY = nextY;

      // Move Animation
      final targetPosition = GridSystem.gridToWorld(gridX, gridY);
      add(
        MoveEffect.to(
          targetPosition,
          EffectController(duration: 0.15, curve: Curves.easeInOut),
        ),
      );
    }
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    if (propagate && isMounted) {
      final connected = _findConnectedEnemies(gameRef);

      for (final enemy in connected) {
        if (enemy != this) {
          enemy.takeDamage(amount, propagate: false);
        }
      }
    }
    super.takeDamage(amount, propagate: propagate);
    hpBar.updateHp(hp);

    // Damage Flash
    visual.add(
      ColorEffect(
        Colors.red,
        EffectController(duration: 0.05, reverseDuration: 0.05),
      ),
    );
  }

  Set<Enemy> _findConnectedEnemies(MyGame game) {
    Set<Enemy> visited = {};
    List<Enemy> queue = [this];
    visited.add(this);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      final neighbors = [
        _getEnemyAt(game, current.gridX, current.gridY - 1),
        _getEnemyAt(game, current.gridX, current.gridY + 1),
        _getEnemyAt(game, current.gridX - 1, current.gridY),
        _getEnemyAt(game, current.gridX + 1, current.gridY),
      ];

      for (final neighbor in neighbors) {
        if (neighbor != null &&
            neighbor.maxHp == maxHp && // Same Type/Color
            !visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add(neighbor);
        }
      }
    }
    return visited;
  }

  Enemy? _getEnemyAt(MyGame game, int x, int y) {
    final target = game.getDestructibleAt(x, y);
    if (target is Enemy) {
      return target;
    }
    return null;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    Color? color;
    Sprite? sprite;
    switch (maxHp) {
      case 1:
        sprite = await gameRef.loadSprite('enemies/slime.png');
        break;
      case 2:
        color = const Color(0xFF800080); // Purple
        break;
      case 3:
        color = const Color(0xFF000000); // Black
        break;
      default:
        color = const Color(0xFF00FF00); // Green (Debug)
    }

    if (sprite != null) {
      visual = SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      );
    } else {
      visual = RectangleComponent(
        size: size,
        paint: Paint()..color = color ?? Colors.white,
        anchor: Anchor.center,
        position: size / 2,
      );
    }
    add(visual);

    hpBar = HpBarComponent(
      maxHp: maxHp.toDouble(),
      currentHp: hp.toDouble(),
      width: size.x,
      height: 4,
    );
    hpBar.position = Vector2(0, -size.y / 2 - 5);
    add(hpBar);

    addHpIndicator();
  }
}
