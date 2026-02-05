import 'package:under_dig/item/item.dart';

class Inventory {
  final int maxSlots;
  final List<Item?> slots;

  Inventory({this.maxSlots = 5}) : slots = List.filled(maxSlots, null);

  bool addItem(Item item) {
    for (int i = 0; i < maxSlots; i++) {
      if (slots[i] == null) {
        slots[i] = item;
        return true;
      }
    }
    return false; // Inventory full
  }

  Item? useItem(int index) {
    if (index < 0 || index >= maxSlots) return null;
    final item = slots[index];
    slots[index] = null;
    return item;
  }

  void clear() {
    for (int i = 0; i < maxSlots; i++) {
      slots[i] = null;
    }
  }
}
