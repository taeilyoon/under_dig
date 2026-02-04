import 'package:flame/components.dart';
import 'package:under_dig/systems/grid_system.dart';

abstract class GridEntity extends PositionComponent {
  int gridX;
  int gridY;

  GridEntity({
    required this.gridX,
    required this.gridY,
    super.size,
    super.position,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Ensure position is synced with grid logic
    position = GridSystem.gridToWorld(gridX, gridY);
    anchor = Anchor.center;
  }

  /// Updates logical grid position and visual world position
  void setGridPosition(int x, int y) {
    gridX = x;
    gridY = y;
    position = GridSystem.gridToWorld(gridX, gridY);
  }
}
