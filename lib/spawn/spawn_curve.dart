// Stage-progress based spawn curve definitions for Under Dig
import 'dart:math' as math;

class SpawnCurve {
  final double enemyRate; // probability in [0,1]
  final double itemRate; // probability in [0,1]
  final double hazardRate; // probability in [0,1]
  final double bossChance; // probability in [0,1]
  final int lootTier; // tier for loot drops

  SpawnCurve({
    required this.enemyRate,
    required this.itemRate,
    required this.hazardRate,
    required this.bossChance,
    required this.lootTier,
  });
}

SpawnCurve spawnCurveForStage(int stageProgress) {
  // Simple, tunable curves based on stage progress
  double nextStage = stageProgress.toDouble();
  double enemyRate = (0.30 + 0.05 * nextStage).clamp(0.0, 1.0);
  double itemRate = (0.25 + 0.04 * nextStage).clamp(0.0, 1.0);
  double hazardRate = (0.20 + 0.03 * nextStage).clamp(0.0, 1.0);
  double bossChance = (0.08 + 0.01 * nextStage).clamp(0.0, 0.5);
  int lootTier = (1 + (stageProgress ~/ 5)).clamp(1, 5);

  return SpawnCurve(
    enemyRate: enemyRate,
    itemRate: itemRate,
    hazardRate: hazardRate,
    bossChance: bossChance,
    lootTier: lootTier,
  );
}
