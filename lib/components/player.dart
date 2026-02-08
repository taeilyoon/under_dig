import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:under_dig/game.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/components/hp_bar.dart';
import 'package:under_dig/components/key_object.dart';
import 'package:under_dig/components/door_object.dart';
import 'package:under_dig/components/grid_entity.dart';

class Player extends PositionComponent
    with KeyboardHandler, HasGameRef<MyGame> {
  int gridX = 0;
  int gridY = 0;

  int hp = 10;
  int maxHp = 10;
  int attackPower = 1;

  late PositionComponent visual;
  late HpBarComponent _hpBar;
  bool _isVisualInitialized = false;

  Player() : super(size: Vector2.all(GridSystem.tileSize * 0.8));

  void takeDamage(int amount) {
    hp -= amount;
    _hpBar.updateHp(hp);
    if (_isVisualInitialized) {
      visual.add(
        ColorEffect(
          Colors.red,
          EffectController(duration: 0.1, reverseDuration: 0.1),
        ),
      );
    }
    if (hp <= 0) {
      gameRef.onGameOver();
    }
  }

  void heal(int amount) {
    hp = (hp + amount).clamp(0, maxHp);
    _hpBar.updateHp(hp);
    if (_isVisualInitialized) {
      visual.add(
        ColorEffect(
          Colors.green,
          EffectController(duration: 0.1, reverseDuration: 0.1),
        ),
      );
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;

    try {
      final sprite = await gameRef.loadSprite('player/attack_down.png');
      visual = SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
        position: size / 2,
      );
    } catch (e) {
      visual = RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blue,
        anchor: Anchor.center,
        position: size / 2,
      );
    }
    _isVisualInitialized = true;
    add(visual);

    _hpBar = HpBarComponent(
      maxHp: maxHp.toDouble(),
      currentHp: hp.toDouble(),
      width: size.x,
      height: 6,
    );
    _hpBar.position = Vector2(0, size.y / 2 + 10); // 캐릭터 하단으로 위치 변경
    add(_hpBar);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp))
        move(0, -1);
      else if (keysPressed.contains(LogicalKeyboardKey.arrowDown))
        move(0, 1);
      else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        move(-1, 0);
      else if (keysPressed.contains(LogicalKeyboardKey.arrowRight))
        move(1, 0);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void move(int dx, int dy) {
    final newX = gridX + dx;
    final newY = gridY + dy;

    if (GridSystem.isValid(newX, newY)) {
      final target = gameRef.getDestructibleAt(newX, newY);
      if (target != null) {
        _performBumpAnimation(dx, dy);
        target.takeDamage(attackPower);
        if (target is Enemy && target.hp > 0) takeDamage(target.attackPower);
        gameRef.advanceStep();
        return;
      }

      final otherComponents = gameRef.children.whereType<GridEntity>();
      for (final comp in otherComponents) {
        if (comp.gridX == newX && comp.gridY == newY) {
          if (comp is KeyObject) {
            comp.collect();
          } else if (comp is DoorObject) {
            comp.tryEnter();
            return;
          }
        }
      }

      gridX = newX;
      gridY = newY;
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
    add(
      MoveEffect.by(
        Vector2(dx.toDouble(), dy.toDouble()) * 10,
        EffectController(duration: 0.05, reverseDuration: 0.05),
      ),
    );
  }
}
