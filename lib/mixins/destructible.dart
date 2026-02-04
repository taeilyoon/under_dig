import 'package:flame/components.dart';
import 'package:flutter/material.dart';

mixin Destructible on PositionComponent {
  int hp = 1;
  int maxHp = 1;

  // Grid coordinates
  int gridX = 0;
  int gridY = 0;

  // HP Indicator
  TextComponent? _hpText;

  void initStats(int hp, int x, int y) {
    this.hp = hp;
    this.maxHp = hp;
    this.gridX = x;
    this.gridY = y;
  }

  Future<void> addHpIndicator() async {
    _hpText = TextComponent(
      text: '$hp',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12, // Small font
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y + 2), // Just below the entity
    );
    add(_hpText!);
  }

  void _updateHpIndicator() {
    _hpText?.text = '$hp';
  }

  void takeDamage(int amount) {
    hp -= amount;
    _updateHpIndicator();

    if (hp <= 0) {
      onDeath();
    } else {
      onDamageTaken();
    }
  }

  void onDeath() {
    removeFromParent();
  }

  void onDamageTaken() {
    // Optional: Override for visual feedback
    print('${this.runtimeType} taken damage. HP: $hp');
  }
}
