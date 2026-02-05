# Alpha-2-07 Spawn Curve Integration (StageProgress)

Goal: Define and integrate a StageProgress-based spawn curve into the game loop.

What to implement:
- A spawn curve that maps stageProgress to enemy/item/hazard spawn rates.
- A lightweight bridge to connect the spawn curve to the game loop (spawn per tick).
- Basic tests scaffolding to verify changes.

Assumptions:
- StageProgress starts at 0.
- Spawn curve supports extension to include hazard and item spawn rates in future iterations.

<<<<<<< Updated upstream
Acceptance Criteria:
- Spawn curve function spawnCurveForStage(int stageProgress) exists and returns a valid SpawnCurve.
- A simple SpawnController.tickSpawn() returns a reasonable integer based on the curve.
- Documentation updated.
=======
파일 포인트
- lib/spawn/spawn_curve.dart
- lib/game/spawn_controller.dart
- lib/game/loop_spawn_bridge.dart

테스트 계획
- spawnCurveForStage의 기본값 및 경계 케이스 테스트
- tickSpawn의 기본 동작 테스트
- LoopSpawnBridge.tick의 간단한 동작 시나리오 테스트

수용 기준
- SpawnCurve가 StageProgress에 따라 합리적인 값을 반환
- tickSpawn이 게임 루프에서 활용될 수 있도록 연결되어 있음
- 문서가 최신 상태 유지

패치 2 커밋 반영: Spawn Curve 기반 스폰 로직 확장 및 문서 업데이트 반영

패치 2 업데이트: StageProgress 기준 스폰 로직 확장 및 문서 보강 완료
- 추가 노트
- 예시 시나리오: StageProgress 0->1->2 단계에서 Tick Spawn의 예시 흐름을 간단한 수치로 보여준다.
>>>>>>> Stashed changes
