import 'dart:math';
import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:under_dig/components/player.dart';
import 'package:under_dig/components/enemy.dart';
import 'package:under_dig/components/archer.dart';
import 'package:under_dig/components/golem.dart';
import 'package:under_dig/components/breakable_block.dart';
import 'package:under_dig/components/potion_object.dart';
import 'package:under_dig/managers/level_manager.dart';
import 'package:under_dig/mixins/destructible.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/score/score_engine.dart';
import 'package:under_dig/ui/combo_tracker.dart';
import 'package:under_dig/item/inventory.dart';
import 'package:under_dig/managers/buff_manager.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents, PanDetector {
  Player? _player;
  Player get player {
    _player ??= Player();
    return _player!;
  }

  late LevelManager levelManager;
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

  @override
  Color backgroundColor() => const Color(0xFF1A1A1A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    levelManager = LevelManager();
    add(levelManager);
    add(player);
    _initialSpawns();
    _updateCamera();
  }

  void _updateCamera() {
    if (!isMounted) return;

    // Grid 512x512
    camera.viewfinder.position = Vector2(256, 256);
    camera.viewfinder.anchor = Anchor.center;

    // RESPONSIVE LOGIC: Force width to fit
    final zoomX = (size.x * 0.95) / 512.0;
    final zoomY = (size.y - 320) / 512.0;

    camera.viewfinder.zoom = min(zoomX, zoomY).clamp(0.1, 3.0);

    // Position board between HUD areas
    const headerH = 110.0;
    const footerH = 180.0;
    final shift = (headerH - footerH) / 2;
    camera.viewfinder.position.y -= (shift / camera.viewfinder.zoom);
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
    if (_player != null && _player!.gridY >= GridSystem.rows - 1)
      advanceStage();
  }

  void startGame() {
    isGameStarted = true;
    overlays.remove('Lobby');
    overlays.add('HudHeader');
    overlays.add('HudFooter');
    _updateCamera();
  }

  void onGameOver() {
    isGameStarted = false;
    overlays.remove('HudHeader');
    overlays.remove('HudFooter');
    overlays.add('Result');
  }

  void resetGame() {
    isGameStarted = false;
    scoreEngine.reset();
    comboTracker.reset();
    inventory.clear();
    buffManager.clear();
    levelManager.reset();
    if (_player != null) {
      _player!.hp = 10;
      _player!.gridX = 0;
      _player!.gridY = 0;
      _player!.position = GridSystem.gridToWorld(0, 0);
    }
    for (var d in _destructibles) (d as Component).removeFromParent();
    _destructibles.clear();
    _initialSpawns();
  }

  void advanceStage() {
    levelManager.advanceStage();
    for (var d in _destructibles) (d as Component).removeFromParent();
    _destructibles.clear();
    if (_player != null) {
      _player!.gridY = 0;
      _player!.position = GridSystem.gridToWorld(_player!.gridX, 0);
    }
    _initialSpawns();
  }

  void advanceStep() {
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
