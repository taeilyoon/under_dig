import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/components/enemy.dart';

class Golem extends Enemy {
  Golem({required super.gridX, required super.gridY})
    : super(hp: 5, attackPower: 2);

  @override
  void onStep() {
    // Golem is slow: Only moves every 2 steps
    // We could implement a step counter
    // For now, normal move
    super.onStep();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Special Golem color (Grey)
    if (visual is RectangleComponent) {
      (visual as RectangleComponent).paint.color = Colors.grey;
    }
    // Make Golem slightly larger
    visual.size = size * 1.1;

    // Adjust HP bar for larger Golem
    hpBar.size = Vector2(size.x * 1.2, 5);
    hpBar.position = Vector2(0, -size.y / 2 - 8);
  }
}
