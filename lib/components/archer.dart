import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/systems/grid_system.dart';

class Archer extends Enemy {
  Archer({required super.gridX, required super.gridY})
    : super(hp: 2, attackPower: 1);

  @override
  void onStep() {
    if (!isMounted) return;
    final game = findGame()! as MyGame;

    // AI: Check if player is in the same row or column
    if (game.player.gridX == gridX || game.player.gridY == gridY) {
      _shootProjectile(game);
    } else {
      // Normal move
      super.onStep();
    }
  }

  void _shootProjectile(MyGame game) {
    print('Archer at ($gridX, $gridY) shoots at Player!');
    // Deal direct damage for now
    game.player.takeDamage(attackPower);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Special Archer color
    if (visual is RectangleComponent) {
      (visual as RectangleComponent).paint.color = Colors.orange;
    }
  }
}
