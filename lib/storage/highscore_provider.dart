// Abstract provider for high score persistence. Replace with Hive/SharedPreferences
// when dependencies are available.
abstract class HighScoreProvider {
  Future<void> save(int score);
  Future<int> load();
}

class InMemoryHighScoreProvider implements HighScoreProvider {
  static final Map<String, int> _store = {};
  static const String _key = 'high_score';

  @override
  Future<void> save(int score) async {
    _store[_key] = score;
  }

  @override
  Future<int> load() async {
    return _store[_key] ?? 0;
  }
}
