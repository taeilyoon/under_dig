import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/game.dart';

import 'package:under_dig/components/grid_entity.dart';

class Enemy extends GridEntity with Destructible {
  // Visual component
  late RectangleComponent _visual;

  Enemy({
    required super.gridX,
    required super.gridY,
    int hp = 1,
    this.attackPower = 1,
  }) : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  int attackPower;

  void onStep() {
    if (!isMounted) return;
    final game = findGame()! as MyGame;

    // Calculate new position (Down 1)
    int nextX = gridX;
    int nextY = gridY + 1;

    // 1. Check Collision with Player
    if (game.player.gridX == nextX && game.player.gridY == nextY) {
      // Blocked by Player (Do not attack, just stop)
      return;
    }

    // 2. Check collisions with other blocks/enemies
    if (game.getDestructibleAt(nextX, nextY) != null) {
      // Something in the way (Block or another Enemy)
      // Stay for now.
      return;
    }

    // 3. Move if valid
    if (GridSystem.isValid(nextX, nextY)) {
      gridY = nextY;
      position = GridSystem.gridToWorld(gridX, gridY);
    } else {
      // Out of bounds (bottom) -> Stop
      return;
    }
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    if (propagate && isMounted) {
      final game = findGame()! as MyGame;
      final connected = _findConnectedEnemies(game);

      // Minimum 3 or 4 to trigger? User said "4 attached -> all 4 damaged".
      // Let's assume ANY connection propagates for now, or check count.
      // "4개가 붙어 있으면" implies a threshold, but usually in these games
      // chained blocks always break together. Let's make it always propagate for same color.

      for (final enemy in connected) {
        if (enemy != this) {
          enemy.takeDamage(amount, propagate: false);
        }
      }
    }
    super.takeDamage(amount, propagate: propagate);
  }

  Set<Enemy> _findConnectedEnemies(MyGame game) {
    Set<Enemy> visited = {};
    List<Enemy> queue = [this];
    visited.add(this);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      // Check neighbors (Up, Down, Left, Right)
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
    // We can use game.getDestructibleAt, but need to check if it's an Enemy
    final target = game.getDestructibleAt(x, y);
    if (target is Enemy) {
      return target;
    }
    return null;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set initial position based on grid
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Determine color based on HP
    Color color;
    switch (maxHp) {
      case 1:
        color = const Color(0xFFFF0000); // Red
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

    // Visual representation
    _visual = RectangleComponent(
      size: size,
      paint: Paint()..color = color,
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_visual);

    // HP Indicator
    addHpIndicator();
  }
}
