import 'package:under_dig/item/inventory.dart';

// Placeholder for a Flutter or Flame-based Inventory HUD.
// This will be expanded with actual UI rendering logic.
class InventoryHud {
  final Inventory inventory;

  InventoryHud({required this.inventory});

  void render() {
    // Basic logic to iterate through inventory.slots and display icons
    for (int i = 0; i < inventory.maxSlots; i++) {
      final item = inventory.slots[i];
      if (item != null) {
        // Draw item.id icon at position i
      } else {
        // Draw empty slot background
      }
    }
  }

  void handleTap(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= inventory.maxSlots) return;

    final item = inventory.slots[slotIndex];
    if (item != null) {
      // Show tooltip or use item
      print('Interacted with item in slot $slotIndex: ${item.name}');
    }
  }
}
