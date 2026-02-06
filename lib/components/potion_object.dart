import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/components/hp_bar.dart';

class PotionObject extends GridEntity with Destructible {
  late RectangleComponent visual;
  late HpBarComponent hpBar;

  PotionObject({required super.gridX, required super.gridY})
    : super(size: Vector2.all(GridSystem.tileSize * 0.7)) {
    initDestructible(2); // 2 HP
  }

  void onStep() {
    if (!isMounted) return;
    final game = findGame()! as MyGame;

    // Gravity: Move Down 1
    int nextX = gridX;
    int nextY = gridY + 1;

    // Check Player
    if (game.player.gridX == nextX && game.player.gridY == nextY) {
      return;
    }

    // Check Other Objects
    if (game.getDestructibleAt(nextX, nextY) != null) {
      return;
    }

    // Move if valid
    if (GridSystem.isValid(nextX, nextY)) {
      gridY = nextY;
      position = GridSystem.gridToWorld(gridX, gridY);
    }
  }

  @override
  void onDeath() {
    final game = findGame()! as MyGame;
    print("Potion Destroyed! Healing Player.");
    game.player.heal(1);
    super.onDeath();
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    if (propagate && isMounted) {
      final game = findGame()! as MyGame;
      final connected = _findConnectedPotions(game);

      for (final potion in connected) {
        if (potion != this) {
          potion.takeDamage(amount, propagate: false);
        }
      }
    }
    super.takeDamage(amount, propagate: propagate);
    hpBar.updateHp(hp);
  }

  Set<PotionObject> _findConnectedPotions(MyGame game) {
    Set<PotionObject> visited = {};
    List<PotionObject> queue = [this];
    visited.add(this);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      final neighbors = [
        _getPotionAt(game, current.gridX, current.gridY - 1),
        _getPotionAt(game, current.gridX, current.gridY + 1),
        _getPotionAt(game, current.gridX - 1, current.gridY),
        _getPotionAt(game, current.gridX + 1, current.gridY),
      ];

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
    if (target is PotionObject) {
      return target;
    }
    return null;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    visual = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF00FFCC),
      anchor: Anchor.center,
      position: size / 2,
    );
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
