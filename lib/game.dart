import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:under_dig/components/player.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/components/archer.dart';
import 'package:under_dig/components/golem.dart';
import 'package:under_dig/components/breakable_block.dart';
import 'package:under_dig/components/potion_object.dart';
import 'package:under_dig/components/key_object.dart';
import 'package:under_dig/components/door_object.dart';
import 'package:under_dig/managers/level_manager.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/score/score_engine.dart';
import 'package:under_dig/ui/combo_tracker.dart';
import 'package:under_dig/item/inventory.dart';
import 'package:under_dig/managers/buff_manager.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, PanDetector, ChangeNotifier {
  Player? _player;
  Player get player {
    _player ??= Player();
    return _player!;
  }

  final LevelManager levelManager = LevelManager();
  bool isGameStarted = false;

  final ScoreEngine scoreEngine = ScoreEngine();
  final ComboTracker comboTracker = ComboTracker();
  final Inventory inventory = Inventory();
  final BuffManager buffManager = BuffManager();

  final List<Destructible> _destructibles = [];

  Vector2? _dragStart;
  bool _hasSwiped = false;
  static const double _swipeThreshold = 25.0;
  double _lastInputTime = 0.0;
  static const double _inputCooldown = 0.15;

  int _turnCount = 0;
  bool _keySpawned = false;
  bool _doorSpawned = false;

  @override
  Color backgroundColor() => const Color(0xFF1A1A1A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(levelManager);
    add(player);
    _initialSpawns();
    _updateCamera();
  }

  void _updateCamera() {
    if (!isMounted) return;
    const double internalWidth = 512.0;
    camera.viewfinder.position = Vector2(256, 256);
    camera.viewfinder.anchor = Anchor.center;
    final zoomFactor = size.x / internalWidth;
    camera.viewfinder.zoom = zoomFactor;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isMounted) _updateCamera();
  }

  void _initialSpawns() {
    spawnEnemy(3, 3, hp: 1);
    spawnEnemy(5, 5, hp: 2);
    spawnEnemy(2, 6, hp: 3);
    spawnBlock(4, 4);
    spawnBlock(1, 1);
  }

  @override
  void update(double dt) {
    if (!isGameStarted) return;
    super.update(dt);
    comboTracker.tick((dt * 1000).toInt());
  }

  void notifyUi() => notifyListeners();

  void startGame() {
    isGameStarted = true;
    _updateCamera();
    notifyListeners();
  }

  void onGameOver() {
    isGameStarted = false;
    notifyListeners();
  }

  void resetGame() {
    isGameStarted = false;
    scoreEngine.reset();
    comboTracker.reset();
    inventory.clear();
    buffManager.clear();
    levelManager.reset();
    _turnCount = 0;
    _keySpawned = false;
    _doorSpawned = false;
    if (_player != null) {
      _player!.hp = 10;
      _player!.gridX = 0;
      _player!.gridY = 0;
      _player!.position = GridSystem.gridToWorld(0, 0);
    }
    for (var d in _destructibles) (d as Component).removeFromParent();
    _destructibles.clear();
    
    children.whereType<KeyObject>().forEach((k) => k.removeFromParent());
    children.whereType<DoorObject>().forEach((d) => d.removeFromParent());

    _initialSpawns();
    notifyListeners();
  }

  void advanceStage() {
    levelManager.advanceStage();
    _turnCount = 0;
    _keySpawned = false;
    _doorSpawned = false;
    for (var d in _destructibles) (d as Component).removeFromParent();
    _destructibles.clear();
    
    children.whereType<KeyObject>().forEach((k) => k.removeFromParent());
    children.whereType<DoorObject>().forEach((d) => d.removeFromParent());

    if (_player != null) {
      _player!.gridY = 0;
      _player!.position = GridSystem.gridToWorld(_player!.gridX, 0);
    }
    _initialSpawns();
    notifyListeners();
  }

  void advanceStep() {
    _turnCount++;
    buffManager.updateBuffs();
    _destructibles.removeWhere((d) => (d as Component).parent == null);
    final actors = _destructibles
        .where((d) => d is Enemy || d is PotionObject)
        .toList();
    actors.sort((a, b) => b.gridY.compareTo(a.gridY));
    for (final actor in actors) {
      if (actor.hp > 0) {
        if (actor is Enemy)
          actor.onStep();
        else if (actor is PotionObject)
          actor.onStep();
      }
    }
    spawnEnemyAtTop();

    // Spawn Key after 50 turns and Door after 100 turns
    if (_turnCount >= 50 && !_keySpawned) {
      _spawnRandomly<KeyObject>((x, y) => add(KeyObject(gridX: x, gridY: y)));
      _keySpawned = true;
    }
    if (_turnCount >= 100 && !_doorSpawned) {
      _spawnRandomly<DoorObject>((x, y) => add(DoorObject(gridX: x, gridY: y)));
      _doorSpawned = true;
    }

    notifyListeners();
  }

  void _spawnRandomly<T>(void Function(int x, int y) spawnFunc) {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      int x = random.nextInt(GridSystem.cols);
      int y = random.nextInt(GridSystem.rows);
      if (getDestructibleAt(x, y) == null && (player.gridX != x || player.gridY != y)) {
        spawnFunc(x, y);
        break;
      }
    }
  }

  void spawnEnemyAtTop() {
    final random = Random();
    int x = random.nextInt(GridSystem.cols);
    if (_player != null && _player!.gridX == x && _player!.gridY == 0) return;
    if (getDestructibleAt(x, 0) == null) {
      double roll = random.nextDouble();
      if (roll < 0.1)
        spawnGolem(x, 0);
      else if (roll < 0.25)
        spawnPotion(x, 0);
      else
        spawnEnemy(x, 0, hp: random.nextInt(3) + 1);
    }
  }

  void spawnEnemy(int x, int y, {int hp = 1}) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final enemy = Enemy(gridX: x, gridY: y, hp: hp);
      add(enemy);
      _destructibles.add(enemy);
    }
  }

  void spawnArcher(int x, int y) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final archer = Archer(gridX: x, gridY: y);
      add(archer);
      _destructibles.add(archer);
    }
  }

  void spawnGolem(int x, int y) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final golem = Golem(gridX: x, gridY: y);
      add(golem);
      _destructibles.add(golem);
    }
  }

  void spawnPotion(int x, int y) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final potion = PotionObject(gridX: x, gridY: y);
      add(potion);
      _destructibles.add(potion);
    }
  }

  void spawnBlock(int x, int y) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final block = BreakableBlock(gridX: x, gridY: y);
      add(block);
      _destructibles.add(block);
    }
  }

  Destructible? getDestructibleAt(int x, int y) {
    for (final obj in _destructibles) {
      if ((obj as Component).parent != null && obj.gridX == x && obj.gridY == y)
        return obj;
    }
    return null;
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (!isGameStarted) return;
    _dragStart = info.eventPosition.widget;
    _hasSwiped = false;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isGameStarted || _hasSwiped || _dragStart == null) return;
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    if (currentTime - _lastInputTime < _inputCooldown) return;
    final currentPoint = info.eventPosition.widget;
    final delta = currentPoint - _dragStart!;
    if (delta.length > _swipeThreshold) {
      _lastInputTime = currentTime;
      if (delta.x.abs() > delta.y.abs()) {
        if (_player != null) _player!.move(delta.x > 0 ? 1 : -1, 0);
      } else {
        if (_player != null) _player!.move(0, delta.y > 0 ? 1 : -1);
      }
      _hasSwiped = true;
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _dragStart = null;
    _hasSwiped = false;
  }
}
