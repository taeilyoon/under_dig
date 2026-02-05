import 'package:under_dig/models/card_model.dart';

class CardManager {
  static final CardManager _instance = CardManager._internal();
  factory CardManager() => _instance;
  CardManager._internal();

  final List<ActionCard> _deck = [];
  final List<ActionCard> _hand = [];
  final int maxHandSize = 3;

  List<ActionCard> get hand => List.unmodifiable(_hand);

  void addToDeck(ActionCard card) {
    _deck.add(card);
  }

  void drawCards() {
    // Basic logic to fill hand from deck
    while (_hand.length < maxHandSize && _deck.isNotEmpty) {
      _hand.add(_deck.removeAt(0));
    }
  }

  void useCard(int index) {
    if (index < 0 || index >= _hand.length) return;
    final card = _hand[index];
    if (card.isReady) {
      card.use();
      // Logic to trigger effect in game
      print('Used card: ${card.name}');
      // Move back to deck or discard? For now, keep in hand but on cooldown
    }
  }

  void tickCooldowns() {
    for (var card in _hand) {
      card.tick();
    }
  }
}
