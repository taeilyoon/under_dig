# Alpha-2-07 Spawn Curve Integration (StageProgress)

Goal: Define and integrate a StageProgress-based spawn curve into the game loop.

What to implement:
- A spawn curve that maps stageProgress to enemy/item/hazard spawn rates.
- A lightweight bridge to connect the spawn curve to the game loop (spawn per tick).
- Basic tests scaffolding to verify changes.

Assumptions:
- StageProgress starts at 0.
- Spawn curve supports extension to include hazard and item spawn rates in future iterations.

Acceptance Criteria:
- Spawn curve function spawnCurveForStage(int stageProgress) exists and returns a valid SpawnCurve.
- A simple SpawnController.tickSpawn() returns a reasonable integer based on the curve.
- Documentation updated.
