import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';

class Enemy extends PositionComponent with Destructible {
  // Visual component
  late RectangleComponent _visual;

  Enemy({required int gridX, required int gridY, int hp = 1})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initStats(hp, gridX, gridY);
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
