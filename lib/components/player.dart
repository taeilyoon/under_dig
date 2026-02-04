import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:under_dig/systems/grid_system.dart';

class Player extends PositionComponent with KeyboardHandler {
  int gridX = 0;
  int gridY = 0;

  // Visual component (using a simple rectangle for now)
  late RectangleComponent _visual;

  Player() : super(size: Vector2.all(GridSystem.tileSize * 0.8));

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

  void move(int dx, int dy) {
    final newX = gridX + dx;
    final newY = gridY + dy;

    if (GridSystem.isValid(newX, newY)) {
      gridX = newX;
      gridY = newY;
      // TODO: Add move animation via Update or specialized Effect
      position = GridSystem.gridToWorld(gridX, gridY);
    }
  }
}
