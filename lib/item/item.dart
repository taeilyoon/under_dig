enum ItemType { potion, scroll, artifact }

class ItemEffect {
  final String type;
  final double value;
  final int? duration; // Duration in turns, null for instant

  ItemEffect({required this.type, required this.value, this.duration});
}

class Item {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final List<ItemEffect> effects;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.effects,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ItemType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      effects: (json['effects'] as List)
          .map(
            (e) => ItemEffect(
              type: e['type'],
              value: e['value'].toDouble(),
              duration: e['duration'],
            ),
          )
          .toList(),
    );
  }
}
