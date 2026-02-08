import 'package:flame/components.dart';

class GridSystem {
  static const int rows = 8;
  static const int cols = 8;
  static const double tileSize = 64.0; // Back to fixed size for stability

  static Vector2 gridToWorld(int x, int y) {
    return Vector2(x * tileSize + tileSize / 2, y * tileSize + tileSize / 2);
  }

  static Vector2 worldToGrid(Vector2 worldPos) {
    return Vector2(
      (worldPos.x / tileSize).floorToDouble(),
      (worldPos.y / tileSize).floorToDouble(),
    );
  }

  static bool isValid(int x, int y) {
    return x >= 0 && x < cols && y >= 0 && y < rows;
  }
}
