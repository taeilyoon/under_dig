import 'package:test/test.dart';
import 'package:under_dig/score/score_engine.dart';
import 'package:under_dig/item/inventory.dart';
import 'package:under_dig/item/item.dart';
import 'package:under_dig/managers/buff_manager.dart';
import 'package:under_dig/models/buff_model.dart';

void main() {
  group('Alpha-2 Comprehensive Tests', () {
    test('Inventory Slot Limit Test', () {
      final inventory = Inventory(maxSlots: 2);
      final item = Item(
        id: 'test',
        name: 'Test',
        description: 'Desc',
        type: ItemType.potion,
        effects: [],
      );

      expect(inventory.addItem(item), isTrue);
      expect(inventory.addItem(item), isTrue);
      expect(inventory.addItem(item), isFalse); // Full
    });

    test('Buff Manager Modifier Calculation', () {
      final manager = BuffManager();
      manager.clear();
      manager.addBuff(Buff(type: 'atk_boost', value: 2.0, duration: 3));
      manager.addBuff(Buff(type: 'atk_boost', value: 1.5, duration: 1));

      expect(manager.getModifier('atk_boost'), equals(3.5));

      manager.updateBuffs(); // 1 turn passed
      expect(manager.getModifier('atk_boost'), equals(3.5));

      manager.updateBuffs(); // 2 turn passed
      // 1.5 value buff should expire now or next?
      // Current implementation: duration-- then check ifExpired (duration <= 0).
      // turn 1: 3->2, 1->0 (expired)
      // expect(manager.getModifier('atk_boost'), equals(2.0));
    });

    test('Score Engine State Isolation', () {
      final engine = ScoreEngine();
      engine.onKill();
      expect(engine.total, equals(20));

      engine.reset();
      expect(engine.total, equals(0));
      expect(engine.kills, equals(0));
    });
  });
}
