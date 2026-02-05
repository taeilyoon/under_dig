import 'package:under_dig/item/item.dart';
import 'package:under_dig/models/buff_model.dart';
import 'package:under_dig/managers/buff_manager.dart';

class ItemLogic {
  static void useItem(Item item, dynamic player) {
    for (var effect in item.effects) {
      if (effect.duration == null || effect.duration == 0) {
        // Instant effect
        _applyInstantEffect(effect, player);
      } else {
        // Buff effect
        BuffManager().addBuff(
          Buff(
            type: effect.type,
            value: effect.value,
            duration: effect.duration!,
          ),
        );
      }
    }
  }

  static void _applyInstantEffect(ItemEffect effect, dynamic player) {
    switch (effect.type) {
      case 'hp_restore':
        // player.heal(effect.value.toInt());
        break;
      case 'area_damage':
        // Trigger area damage logic
        break;
      default:
        print('Unknown instant effect: ${effect.type}');
    }
  }
}
