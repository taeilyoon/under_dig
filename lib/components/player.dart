import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/enemy.dart'; // Import Enemy

class Player extends PositionComponent with KeyboardHandler {
  int gridX = 0;
  int gridY = 0;

  int hp = 10;
  int attackPower = 1;

  // Visual component (using a simple rectangle for now)
  late RectangleComponent _visual;

  Player() : super(size: Vector2.all(GridSystem.tileSize * 0.8));

  void takeDamage(int amount) {
    hp -= amount;
    print("Player took $amount damage! HP: $hp");
    if (hp <= 0) {
      print("GAME OVER");
      // TODO: Handle Game Over
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set initial position
    gridX = 0;
    gridY = 0;
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Visual representation (Blue Box)
    _visual = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF0000FF),
      anchor: Anchor.center,
      position: size / 2, // Relative to parent
    );
    add(_visual);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        move(0, -1);
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        move(0, 1);
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        move(-1, 0);
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        move(1, 0);
        return true;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onMount() {
    super.onMount();
  }

  void move(int dx, int dy) {
    // Access MyGame instance
    final game = findGame()! as MyGame;

    final newX = gridX + dx;
    final newY = gridY + dy;

    if (GridSystem.isValid(newX, newY)) {
      // Check for destructible (Enemy or Block)
      final target = game.getDestructibleAt(newX, newY);

      if (target != null) {
        // Bump Combat!
        print('Attack target at $newX, $newY. HP: ${target.hp}');

        // Player attacks Target
        target.takeDamage(attackPower);

        // Counter-Attack: If target is Enemy AND survives, it hits back.
        if (target is Enemy) {
          if (target.hp > 0) {
            print("Enemy Counter-Attacks!");
            takeDamage(target.attackPower);
          } else {
            print("Enemy destroyed! Safe kill.");
          }
        }

        // Advance Turn on Attack
        game.advanceStep();

        // Don't move into the tile
        return;
      }

      gridX = newX;
      gridY = newY;
      // TODO: Add move animation via Update or specialized Effect
      position = GridSystem.gridToWorld(gridX, gridY);

      // Advance Turn on Move
      game.advanceStep();
    }
  }
}
