import '../spawn/spawn_curve.dart';

// Very lightweight spawn controller that uses stage progress to estimate spawns per tick.
class SpawnController {
  int _stageProgress;
  SpawnCurve _curve;

  SpawnController({int initialStageProgress = 0})
    : _stageProgress = initialStageProgress,
      _curve = spawnCurveForStage(initialStageProgress);

  void updateStage(int stageProgress) {
    _stageProgress = stageProgress;
    _curve = spawnCurveForStage(stageProgress);
  }

  // Simple heuristic: map enemyRate to an integer spawn count per tick
  int estimateEnemiesPerTick() {
    return (_curve.enemyRate * 3).floor();
  }

  // Expose current curve for debugging/inspection
  SpawnCurve get curve => _curve;

  // Produce number of enemies to spawn for the current tick, based on stageProgress
  int tickSpawn() {
    // Base spawn count from enemy rate
    int count = estimateEnemiesPerTick();
    if (count < 0) count = 0;
    // Adjust based on hazard rate to simulate increased risk at higher depths
    int hazardBonus = 0;
    if (_curve.hazardRate > 0.75) {
      hazardBonus = 2;
    } else if (_curve.hazardRate > 0.5) {
      hazardBonus = 1;
    }
    int total = (count + hazardBonus).clamp(0, 8);
    return total;
  }
}
