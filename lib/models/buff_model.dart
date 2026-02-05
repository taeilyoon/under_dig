class Buff {
  final String type;
  final double value;
  int duration; // Turns remaining

  Buff({required this.type, required this.value, required this.duration});

  bool get isExpired => duration <= 0;

  void tick() {
    if (duration > 0) duration--;
  }
}
