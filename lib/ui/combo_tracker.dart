class ComboTracker {
  int _combo = 0;
  int _timeLeftMs = 0;
  final int _defaultWindowMs;

  ComboTracker({int windowMs = 3000})
    : _defaultWindowMs = windowMs,
      _timeLeftMs = windowMs;

  int get combo => _combo;
  int get timeLeftMs => _timeLeftMs;

  void increment() {
    _combo += 1;
    _resetTimer();
  }

  void reset() {
    _combo = 0;
    _timeLeftMs = _defaultWindowMs;
  }

  void tick(int ms) {
    if (_combo <= 0) return;
    _timeLeftMs -= ms;
    if (_timeLeftMs <= 0) {
      _combo = 0;
      _timeLeftMs = _defaultWindowMs;
    }
  }

  void _resetTimer() {
    _timeLeftMs = _defaultWindowMs;
  }
}
