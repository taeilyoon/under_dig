import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/systems/grid_system.dart';

class LevelManager extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _drawGrid();
  }

  void _drawGrid() {
    // Checkerboard pattern
    for (int y = 0; y < GridSystem.rows; y++) {
      for (int x = 0; x < GridSystem.cols; x++) {
        final isEven = (x + y) % 2 == 0;
        final color = isEven
            ? const Color(0xFF444444)
            : const Color(0xFF666666);

        final tile = RectangleComponent(
          position: Vector2(x * GridSystem.tileSize, y * GridSystem.tileSize),
          size: Vector2.all(GridSystem.tileSize),
          paint: Paint()..color = color,
          anchor: Anchor.topLeft,
        );
        add(tile);
      }
    }
  }
}
