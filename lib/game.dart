import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:under_dig/components/player.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/components/archer.dart';
import 'package:under_dig/components/golem.dart';
import 'package:under_dig/components/breakable_block.dart';
import 'package:under_dig/managers/level_manager.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/score/score_engine.dart';
import 'package:under_dig/ui/combo_tracker.dart';
import 'package:under_dig/item/inventory.dart';
import 'package:under_dig/managers/buff_manager.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents, PanDetector {
  late Player _player;
  Player get player => _player;

  late LevelManager levelManager;

  bool isGameStarted = false;

  // Engines and Managers
  final ScoreEngine scoreEngine = ScoreEngine();
  final ComboTracker comboTracker = ComboTracker();
  final Inventory inventory = Inventory();
  final BuffManager buffManager = BuffManager();

  // Track all destructibles (Enemies, Blocks)
  final List<Destructible> _destructibles = [];

  Vector2? _dragStart;
  bool _hasSwiped = false;
  static const double _swipeThreshold = 50.0;

  // Turn System
  double _timeSinceLastStep = 0.0;
  static const double _stepThreshold = 2.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Add Level (Grid Background)
    levelManager = LevelManager();
    add(levelManager);

    // 2. Add Player
    _player = Player();
    add(_player);

    // Initial Spawns
    _initialSpawns();

    // Setup Camera
    final gridWidth = GridSystem.cols * GridSystem.tileSize;
    final gridHeight = GridSystem.rows * GridSystem.tileSize;
    camera.viewfinder.position = Vector2(gridWidth / 2, gridHeight / 2);
    camera.viewfinder.anchor = Anchor.center;
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

    // Update combo timer
    comboTracker.tick((dt * 1000).toInt());

    _timeSinceLastStep += dt;
    if (_timeSinceLastStep >= _stepThreshold) {
      advanceStep();
    }
  }

  void startGame() {
    isGameStarted = true;
    overlays.remove('Lobby');
    overlays.add('HUD');
  }

  void onGameOver() {
    isGameStarted = false;
    overlays.remove('HUD');
    overlays.add('Result');
  }

  void resetGame() {
    isGameStarted = false;
    scoreEngine.reset();
    comboTracker.reset();
    inventory.clear();
    buffManager.clear();

    _player.hp = 10;
    _player.gridX = 0;
    _player.gridY = 0;
    _player.position = GridSystem.gridToWorld(0, 0);

    // Remove all existing destructibles
    for (var d in _destructibles) {
      (d as Component).removeFromParent();
    }
    _destructibles.clear();
    _initialSpawns();
  }

  void advanceStep() {
    _timeSinceLastStep = 0.0;

    // Process Buffs
    buffManager.updateBuffs();

    // Clean up dead/removed objects
    _destructibles.removeWhere((d) => (d as Component).parent == null);

    final enemies = _destructibles.whereType<Enemy>().toList();
    enemies.sort((a, b) => b.gridY.compareTo(a.gridY));

    for (final enemy in enemies) {
      if (enemy.hp > 0) {
        enemy.onStep();
      }
    }

    spawnEnemyAtTop();
  }

  void spawnEnemyAtTop() {
    final random = Random();
    int attempts = 0;

    while (attempts < 10) {
      int x = random.nextInt(GridSystem.cols);
      if (_player.gridX == x && _player.gridY == 0) {
        attempts++;
        continue;
      }

      if (getDestructibleAt(x, 0) == null) {
        double roll = random.nextDouble();
        if (roll < 0.1) {
          spawnGolem(x, 0);
        } else if (roll < 0.3) {
          spawnArcher(x, 0);
        } else {
          spawnEnemy(x, 0, hp: random.nextInt(3) + 1);
        }
        break;
      }
      attempts++;
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

  void spawnBlock(int x, int y) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final block = BreakableBlock(gridX: x, gridY: y);
      add(block);
      _destructibles.add(block);
    }
  }

  Destructible? getDestructibleAt(int x, int y) {
    for (final obj in _destructibles) {
      if ((obj as Component).parent != null &&
          obj.gridX == x &&
          obj.gridY == y) {
        return obj;
      }
    }
    return null;
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (!isGameStarted) return;
    _dragStart = info.eventPosition.global;
    _hasSwiped = false;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_hasSwiped || _dragStart == null) return;
    final currentPoint = info.eventPosition.global;
    final delta = currentPoint - _dragStart!;
    if (delta.length > _swipeThreshold) {
      bool isHorizontal = delta.x.abs() > delta.y.abs();
      if (isHorizontal) {
        if (delta.x > 0)
          _player.move(1, 0);
        else
          _player.move(-1, 0);
      } else {
        if (delta.y > 0)
          _player.move(0, 1);
        else
          _player.move(0, -1);
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
