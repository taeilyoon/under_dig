// Abstract persistence interface for high scores
abstract class HighScorePersistence {
  Future<void> save(int score);
  Future<int> load();
}

// In-memory fallback implementation (no external dependencies)
class InMemoryHighScorePersistence implements HighScorePersistence {
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

// Placeholder for real Hive/SharedPreferences backed implementation
// To be wired in when dependencies are available in the Flutter project
class PersistentHighScoreStorage extends InMemoryHighScorePersistence
    implements HighScorePersistence {
  // This class intentionally defers to InMemory implementation for now.
  // Replace with Hive/SharedPreferences-backed code when dependencies are added.
}
