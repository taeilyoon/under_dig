import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';

class BreakableBlock extends PositionComponent with Destructible {
  late RectangleComponent _visual;

  BreakableBlock({required int gridX, required int gridY, int hp = 2})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initStats(hp, gridX, gridY);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Visual: Brown Crate
    _visual = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF8B4513), // Saddle Brown
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_visual);

    // Inner detail (lighter brown square)
    add(
      RectangleComponent(
        size: size * 0.6,
        paint: Paint()..color = const Color(0xFFA0522D), // Sienna
        anchor: Anchor.center,
        position: size / 2,
      ),
    );
  }
}
