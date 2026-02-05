// Lightweight in-memory high score storage (no external dependencies)
class HighScoreStorage {
  static const String _key = 'high_score';
  static final Map<String, int> _store = {};

  Future<void> save(int score) async {
    _store[_key] = score;
  }

  Future<int> load() async {
    return _store[_key] ?? 0;
  }
}
