import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/components/hp_bar.dart';

class Player extends PositionComponent
    with KeyboardHandler, HasGameRef<MyGame> {
  int gridX = 0;
  int gridY = 0;

  int hp = 10;
  int maxHp = 10;
  int attackPower = 1;

  // Visual components
  late PositionComponent visual;
  late HpBarComponent _hpBar;

  Player() : super(size: Vector2.all(GridSystem.tileSize * 0.8));

  void takeDamage(int amount) {
    hp -= amount;
    _hpBar.updateHp(hp);
    print("Player took $amount damage! HP: $hp");

    // Simple damage flash effect
    visual.add(
      ColorEffect(
        Colors.red,
        EffectController(duration: 0.1, reverseDuration: 0.1),
      ),
    );

    if (hp <= 0) {
      print("GAME OVER");
      gameRef.onGameOver();
    }
  }

  void heal(int amount) {
    hp = (hp + amount).clamp(0, maxHp);
    _hpBar.updateHp(hp);
    print("Player healed $amount! Current HP: $hp");

    // Heal flash effect
    visual.add(
      ColorEffect(
        Colors.green,
        EffectController(duration: 0.1, reverseDuration: 0.1),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set initial position
    gridX = 0;
    gridY = 0;
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    // Load Sprite
    final sprite = await gameRef.loadSprite('player/attack_down.png');
    visual = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
      position: size / 2,
    );
    add(visual);

    // 2. Add HP Bar
    _hpBar = HpBarComponent(
      maxHp: maxHp.toDouble(),
      currentHp: hp.toDouble(),
      width: size.x,
      height: 6,
    );
    _hpBar.position = Vector2(0, -10); // Position above the player
    add(_hpBar);
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
      final target = gameRef.getDestructibleAt(newX, newY);

      if (target != null) {
        // Bump Combat!
        _performBumpAnimation(dx, dy);

        target.takeDamage(attackPower);

        if (target is Enemy) {
          if (target.hp > 0) {
            takeDamage(target.attackPower);
          }
        }

        gameRef.advanceStep();
        return;
      }

      gridX = newX;
      gridY = newY;

      // Move Animation
      final targetPosition = GridSystem.gridToWorld(gridX, gridY);
      add(
        MoveEffect.to(
          targetPosition,
          EffectController(duration: 0.1, curve: Curves.easeInOut),
        ),
      );

      gameRef.advanceStep();
    }
  }

  void _performBumpAnimation(int dx, int dy) {
    final bumpVector = Vector2(dx.toDouble(), dy.toDouble()) * 10;
    add(
      MoveEffect.by(
        bumpVector,
        EffectController(duration: 0.05, reverseDuration: 0.05),
      ),
    );
  }
}
