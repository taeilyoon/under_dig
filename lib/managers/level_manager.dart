import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:under_dig/game/spawn_controller.dart';
import 'package:under_dig/systems/grid_system.dart';
import 'package:under_dig/game.dart';

class LevelManager extends Component {
  int _stageProgress = 0;
  late SpawnController _spawnController;

  int get stageProgress => _stageProgress;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spawnController = SpawnController(initialStageProgress: _stageProgress);
    _drawGrid();
  }

  void advanceStage() {
    _stageProgress++;
    _spawnController.updateStage(_stageProgress);
    final game = findGame()! as MyGame;
    game.scoreEngine.onStageAdvance();

    // TODO: Trigger UI update or animations for stage advancement
    print('Advanced to Stage: $_stageProgress');
    print('Current Difficulty: ${_spawnController.curve.enemyRate}');
  }

  void reset() {
    _stageProgress = 0;
    _spawnController.updateStage(0);
  }

  void _drawGrid() {
    // Checkerboard pattern
    for (int y = 0; y < GridSystem.rows; y++) {
      for (int x = 0; x < GridSystem.cols; x++) {
        final isEven = (x + y) % 2 == 0;
        final color = isEven
            ? const Color(0xFF444444)
            : const Color(0xFF666666);

        final tile = RectangleComponent(
          position: Vector2(x * GridSystem.tileSize, y * GridSystem.tileSize),
          size: Vector2.all(GridSystem.tileSize),
          paint: Paint()..color = color,
          anchor: Anchor.topLeft,
        );
        add(tile);
      }

      // Add a visible border around the entire board (512x512)
      final border = RectangleComponent(
        position: Vector2.zero(),
        size: Vector2(
          GridSystem.cols * GridSystem.tileSize,
          GridSystem.rows * GridSystem.tileSize,
        ),
        paint: Paint()
          ..color = Colors.white24
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      add(border);
    }
  }

  // Logic to be called by game loop to spawn enemies/items
  void spawnEntities() {
    final enemyCount = _spawnController.tickSpawn();
    // Logic to actually add Enemy components to the grid would go here
    for (int i = 0; i < enemyCount; i++) {
      // add(Enemy(...));
    }
  }
}
