import 'dart:math' as math;
import 'package:under_dig/item/item.dart';

class DropPoolEntry {
  final Item item;
  final double probability; // 0.0 - 1.0
  DropPoolEntry({required this.item, required this.probability});
}

List<DropPoolEntry> getDropPool(int stageProgress) {
  // Simple staged drop pool example
  final common = Item(
    id: 'potion_small',
    name: 'Small Potion',
    description: 'Heals 10 HP',
    type: ItemType.potion,
    effects: [ItemEffect(type: 'hp_restore', value: 10)],
  );
  final rare = Item(
    id: 'scroll_power',
    name: 'Scroll of Power',
    description: 'Increases attack by 2 for 5 turns',
    type: ItemType.scroll,
    effects: [ItemEffect(type: 'atk_boost', value: 2, duration: 5)],
  );
  return [
    DropPoolEntry(
      item: common,
      probability: 0.6 + (stageProgress * 0.01).clamp(0.0, 0.4),
    ),
    DropPoolEntry(
      item: rare,
      probability: 0.2 + (stageProgress * 0.01).clamp(0.0, 0.3),
    ),
  ];
}
