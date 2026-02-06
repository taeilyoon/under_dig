import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/components/grid_entity.dart';
import 'package:under_dig/components/hp_bar.dart';

class PotionObject extends GridEntity with Destructible {
  late RectangleComponent visual;
  late HpBarComponent hpBar;

  PotionObject({required super.gridX, required super.gridY})
    : super(size: Vector2.all(GridSystem.tileSize * 0.7)) {
    initDestructible(2); // 2 HP as requested
  }

  @override
  void onDeath() {
    final game = findGame()! as MyGame;
    print("Potion Destroyed! Healing Player.");
    game.player.heal(1); // Heal 1 HP on death
    super.onDeath();
  }

  @override
  void takeDamage(int amount, {bool propagate = true}) {
    super.takeDamage(amount, propagate: propagate);
    hpBar.updateHp(hp);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Visual: Bright Green/Teal for Potion
    visual = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF00FFCC),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(visual);

    // HP Bar
    hpBar = HpBarComponent(
      maxHp: maxHp.toDouble(),
      currentHp: hp.toDouble(),
      width: size.x,
      height: 4,
    );
    hpBar.position = Vector2(0, -size.y / 2 - 5);
    add(hpBar);

    addHpIndicator();
  }
}
