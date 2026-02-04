import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:under_dig/components/player.dart';
import 'package:under_dig/managers/level_manager.dart';
import 'package:under_dig/systems/grid_system.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents, PanDetector {
  late Player _player;
  Vector2? _dragStart;
  bool _hasSwiped = false;
  static const double _swipeThreshold = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Add Level (Grid Background)
    add(LevelManager());

    // 2. Add Player
    _player = Player();
    add(_player);

    // 3. Setup Camera
    // Center camera on the 8x8 grid
    final gridWidth = GridSystem.cols * GridSystem.tileSize;
    final gridHeight = GridSystem.rows * GridSystem.tileSize;

    camera.viewfinder.position = Vector2(gridWidth / 2, gridHeight / 2);
    camera.viewfinder.anchor = Anchor.center;
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
