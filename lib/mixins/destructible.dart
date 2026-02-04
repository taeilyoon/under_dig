import 'package:flame/components.dart';

mixin Destructible on PositionComponent {
  int hp = 1;
  int maxHp = 1;

  // Grid coordinates
  int gridX = 0;
  int gridY = 0;

  void initStats(int hp, int x, int y) {
    this.hp = hp;
    this.maxHp = hp;
    this.gridX = x;
    this.gridY = y;
  }

  void takeDamage(int amount) {
    hp -= amount;
    if (hp <= 0) {
      onDeath();
    } else {
      onDamageTaken();
    }
  }

  void onDeath() {
    removeFromParent();
  }

  void onDamageTaken() {
    // Optional: Override for visual feedback
    print('${this.runtimeType} taken damage. HP: $hp');
  }
}
