import 'package:under_dig/models/buff_model.dart';

class BuffManager {
  static final BuffManager _instance = BuffManager._internal();
  factory BuffManager() => _instance;
  BuffManager._internal();

  final List<Buff> _activeBuffs = [];

  List<Buff> get activeBuffs => List.unmodifiable(_activeBuffs);

  void addBuff(Buff buff) {
    // If same buff type exists, we could either stack duration or replace.
    // For now, let's just add it.
    _activeBuffs.add(buff);
  }

  void updateBuffs() {
    for (var buff in _activeBuffs) {
      buff.tick();
    }
    _activeBuffs.removeWhere((buff) => buff.isExpired);
  }

  double getModifier(String type) {
    double total = 0;
    for (var buff in _activeBuffs) {
      if (buff.type == type) {
        total += buff.value;
      }
    }
    return total;
  }

  void clear() {
    _activeBuffs.clear();
  }
}
