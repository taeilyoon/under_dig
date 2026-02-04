import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/grid_entity.dart';

class Chest extends GridEntity with Destructible {
  late RectangleComponent _visual;

  Chest({required super.gridX, required super.gridY, int hp = 1})
    : super(size: Vector2.all(GridSystem.tileSize * 0.8)) {
    initDestructible(hp);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Visual: Gold Chest
    _visual = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFFFFD700), // Gold
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_visual);

    // Lock detail
    add(
      RectangleComponent(
        size: size * 0.2,
        paint: Paint()..color = Colors.black,
        anchor: Anchor.center,
        position: size / 2,
      ),
    );

    // HP Indicator (Optional for Chest? Maybe just hit to open)
    addHpIndicator();
  }

  @override
  void onDeath() {
    print("Chest Opened! Found loot.");
    // TODO: Drop Item
    super.onDeath();
  }
}
