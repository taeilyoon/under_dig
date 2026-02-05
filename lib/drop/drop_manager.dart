import 'package:under_dig/item/item.dart';
import 'package:under_dig/drop/drop_table.dart';

class DropManager {
  static final DropManager _instance = DropManager._internal();
  factory DropManager() => _instance;
  DropManager._internal();

  Item dropItem(int stageProgress) {
    return DropTable.pickItem(stageProgress);
  }

  List<Item> dropItems(int stageProgress, int count) {
    return List.generate(count, (_) => dropItem(stageProgress));
  }
}
