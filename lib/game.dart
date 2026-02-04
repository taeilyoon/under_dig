import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:under_dig/components/player.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/components/breakable_block.dart';
import 'package:under_dig/managers/level_manager.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents, PanDetector {
  late Player _player;
  Player get player => _player;

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
    add(LevelManager());

    // 2. Add Player
    _player = Player();
    add(_player);

    // 3. Add Enemies with Variable HP
    spawnEnemy(3, 3, hp: 1); // Weak (Red)
    spawnEnemy(5, 5, hp: 2); // Medium (Purple)
    spawnEnemy(2, 6, hp: 3); // Strong (Black)

    // 4. Add Breakable Blocks
    spawnBlock(4, 4); // Crate
    spawnBlock(1, 1); // Crate

    // 4. Setup Camera
    // Center camera on the 8x8 grid
    final gridWidth = GridSystem.cols * GridSystem.tileSize;
    final gridHeight = GridSystem.rows * GridSystem.tileSize;

    camera.viewfinder.position = Vector2(gridWidth / 2, gridHeight / 2);
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _timeSinceLastStep += dt;
    if (_timeSinceLastStep >= _stepThreshold) {
      advanceStep();
    }
  }

  /// Advances the game state by one step.
  /// Called manually by Player action OR automatically by timer.
  /// Advances the game state by one step.
  /// Called manually by Player action OR automatically by timer.
  void advanceStep() {
    _timeSinceLastStep = 0.0;
    print("--- Step Advanced ---");

    // Clean up dead/removed objects
    _destructibles.removeWhere((d) => (d as Component).parent == null);

    // 1. Enemy Turn: Move Enemies (Bottom-up to prevent overlap)
    // Filter for Enemies only
    final enemies = _destructibles.whereType<Enemy>().toList();

    // Sort by Y descending (Process bottom enemies first so they move out of the way)
    enemies.sort((a, b) => b.gridY.compareTo(a.gridY));

    for (final enemy in enemies) {
      if (enemy.hp > 0) {
        // Only active enemies
        enemy.onStep();
      }
    }

    // 2. Spawn new enemy at top
    spawnEnemyAtTop();
  }

  void spawnEnemyAtTop() {
    final random = Random();
    int attempts = 0;

    // Try to find an empty spot in the first row (y=0)
    while (attempts < 10) {
      int x = random.nextInt(GridSystem.cols);

      // Don't spawn on player
      if (_player.gridX == x && _player.gridY == 0) {
        attempts++;
        continue;
      }

      // Don't spawn on existing destructible
      if (getDestructibleAt(x, 0) == null) {
        // Spawn random HP enemy
        int hp = random.nextInt(3) + 1; // 1, 2, or 3
        spawnEnemy(x, 0, hp: hp);
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

  void spawnBlock(int x, int y) {
    if (GridSystem.isValid(x, y) && getDestructibleAt(x, y) == null) {
      final block = BreakableBlock(gridX: x, gridY: y);
      add(block);
      _destructibles.add(block);
    }
  }

  // Check if any destructible exists at target coordinates
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
        if (delta.x > 0) {
          _player.move(1, 0); // Right
        } else {
          _player.move(-1, 0); // Left
        }
      } else {
        if (delta.y > 0) {
          _player.move(0, 1); // Down
        } else {
          _player.move(0, -1); // Up
        }
      }

      _hasSwiped = true; // Prevent multiple moves in one drag
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _dragStart = null;
    _hasSwiped = false;
  }
}
