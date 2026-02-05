enum CardType { attack, utility, defense }

class ActionCard {
  final String id;
  final String name;
  final String description;
  final CardType type;
  final Map<String, dynamic> effects;
  final int cooldown;
  int currentCooldown = 0;

  ActionCard({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.effects,
    this.cooldown = 3,
  });

  bool get isReady => currentCooldown == 0;

  void use() {
    currentCooldown = cooldown;
  }

  void tick() {
    if (currentCooldown > 0) currentCooldown--;
  }
}
