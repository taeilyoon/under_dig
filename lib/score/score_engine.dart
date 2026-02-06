import 'dart:math' as math;
import 'package:flutter/foundation.dart';

enum ScoreEvent { StageAdvance, Kill, Combo }

class ScoreConfig {
  final int baseStagePoints; // progress-based stage points per stage
  final int killPoints; // points per kill
  final int comboBase; // base value for combo bonus calculation
  final double comboGrowth; // multiplier factor for combo growth (optional)
  final double stageProgressFactor; // factor for stage progress bonus scaling
  ScoreConfig({
    this.baseStagePoints = 5,
    this.killPoints = 20,
    this.comboBase = 6,
    this.comboGrowth = 0.25,
    this.stageProgressFactor = 0.25,
  });
}

class ScoreEngine extends ChangeNotifier {
  final ScoreConfig config;
  int _total = 0;
  int stageProgress = 0;
  int kills = 0;
  int combo = 0;

  ScoreEngine({ScoreConfig? config}) : config = config ?? ScoreConfig();

  int get total => _total;

  // State mutation methods
  void onStageAdvance() {
    stageProgress += 1;
    _total += _stageProgressPoints(stageProgress);
    notifyListeners();
  }

  int onKill() {
    kills += 1;
    int delta = config.killPoints;
    _total += delta;
    notifyListeners();
    return delta;
  }

  int onComboIncrement() {
    combo += 1;
    int delta = _comboBonus(combo);
    _total += delta;
    notifyListeners();
    return delta;
  }

  int onComboReset() {
    int prev = combo;
    combo = 0;
    notifyListeners();
    return prev;
  }

  // Calculate potential score delta for a given event without mutating state
  int calculateScore(ScoreEvent event) {
    switch (event) {
      case ScoreEvent.StageAdvance:
        // anticipate next stage progression
        int nextStage = stageProgress + 1;
        return _stageProgressPoints(nextStage);
      case ScoreEvent.Kill:
        return config.killPoints;
      case ScoreEvent.Combo:
        int nextCombo = combo + 1;
        return _comboBonus(nextCombo);
    }
  }

  // Private scoring helpers
  int _stageProgressPoints(int s) {
    // Stage-progress based scoring with a scalable factor
    // factor = 1 + stageProgressFactor * log2(s + 1)
    double factor =
        1.0 + config.stageProgressFactor * (math.log(s + 1) / math.log(2));
    double val = config.baseStagePoints * s * factor;
    return val.floor();
  }

  int _comboBonus(int c) {
    if (c < 2) return 0;
    // comboBonus grows with log2(combo+1) scaled by config.comboBase
    double bonus = config.comboBase * (math.log(c + 1) / math.log(2));
    return bonus.floor();
  }

  void reset() {
    _total = 0;
    stageProgress = 0;
    kills = 0;
    combo = 0;
    notifyListeners();
  }
}
