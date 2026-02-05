import 'dart:math' as math;
import 'package:under_dig/item/item.dart';

class DropPoolEntry {
  final Item item;
  final double
  weight; // Use weights instead of simple probability for better scaling

  DropPoolEntry({required this.item, required this.weight});
}

class DropTable {
  static final Map<ItemType, List<DropPoolEntry>> _itemPools = {
    ItemType.potion: [
      DropPoolEntry(
        item: Item(
          id: 'potion_small',
          name: 'Small Potion',
          description: 'Heals 10 HP',
          type: ItemType.potion,
          effects: [ItemEffect(type: 'hp_restore', value: 10)],
        ),
        weight: 100,
      ),
      DropPoolEntry(
        item: Item(
          id: 'potion_large',
          name: 'Large Potion',
          description: 'Heals 30 HP',
          type: ItemType.potion,
          effects: [ItemEffect(type: 'hp_restore', value: 30)],
        ),
        weight: 20,
      ),
    ],
    ItemType.scroll: [
      DropPoolEntry(
        item: Item(
          id: 'scroll_power',
          name: 'Scroll of Power',
          description: 'Increases attack by 2 for 5 turns',
          type: ItemType.scroll,
          effects: [ItemEffect(type: 'atk_boost', value: 2, duration: 5)],
        ),
        weight: 50,
      ),
      DropPoolEntry(
        item: Item(
          id: 'scroll_shield',
          name: 'Scroll of Shielding',
          description: 'Absorbs 1 hit',
          type: ItemType.scroll,
          effects: [ItemEffect(type: 'def_shield', value: 1)],
        ),
        weight: 30,
      ),
    ],
  };

  static Item pickItem(int stageProgress) {
    final random = math.Random();

    // Choose pool type first (Potions 60%, Scrolls 40% base)
    final poolType = random.nextDouble() < 0.6
        ? ItemType.potion
        : ItemType.scroll;
    final pool = _itemPools[poolType] ?? [];

    if (pool.isEmpty) {
      // Fallback
      return Item(
        id: 'error_item',
        name: 'Mystery Item',
        description: 'Does something unexpected',
        type: ItemType.artifact,
        effects: [],
      );
    }

    // Calculate total weight with stage scaling
    double totalWeight = 0;
    for (var entry in pool) {
      totalWeight += _scaleWeight(entry, stageProgress);
    }

    double roll = random.nextDouble() * totalWeight;
    double current = 0;

    for (var entry in pool) {
      current += _scaleWeight(entry, stageProgress);
      if (roll <= current) {
        return entry.item;
      }
    }

    return pool.last.item;
  }

  static double _scaleWeight(DropPoolEntry entry, int stageProgress) {
    // Basic scaling: Rare items (lower base weight) get a small boost as stageProgress increases
    if (entry.weight < 50) {
      return entry.weight + (stageProgress * 0.5);
    }
    return entry.weight;
  }
}
