enum ItemType { Potion, Scroll, Elixir }

class Item {
  final String id;
  final String name;
  final ItemType type;
  final Map<String, dynamic> effects;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.effects,
  });
}
