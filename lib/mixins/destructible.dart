import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/components/grid_entity.dart';

mixin Destructible on GridEntity {
  int hp = 1;
  int maxHp = 1;

  // HP Indicator
  TextComponent? _hpText;

  void initDestructible(int hp) {
    this.hp = hp;
    this.maxHp = hp;
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

  void takeDamage(int amount, {bool propagate = true}) {
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
