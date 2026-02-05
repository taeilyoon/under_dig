# Alpha-2-07 Spawn Curve Integration (StageProgress) - 패치 2

목표
- StageProgress 기반 Spawn Curve 정의 및 게임 루프에의 연결 강화
- StageProgress가 증가할 때 Spawn Curve가 어떻게 변하는지 반영하고, 매 틱 스폰 수를 예측하는 기반 마련

구현 범위
- SpawnCurve 확장: stageProgress 외에 hazardRate, itemRate를 고려하여 스폰 비율을 조정하도록 확장
- SpawnController.tickSpawn() 보강: hazardRate에 따른 보정 로직 추가
- LoopSpawnBridge 연결 강화: 게임 루프의 매 틱 tick에 따라 tickSpawn()의 값을 받아 스폰 이벤트를 트리거
- 문서화 및 주석 보강: 코드에 주석으로 의도와 확장 포인트를 남김
- 테스트 초안: spawnCurveForStage의 기본 동작 검증, LoopSpawnBridge.tickSpawn의 기본 동작 검증

스펙
- spawnCurveForStage(int stageProgress) -> SpawnCurve
- SpawnController.tickSpawn() -> int
- LoopSpawnBridge.tick() -> int (SpawnController.tickSpawn()의 래핑)

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

패치 2 업데이트: StageProgress 기준 스폰 로직 확장 및 문서 보강 완료
- 추가 노트
- 예시 시나리오: StageProgress 0->1->2 단계에서 Tick Spawn의 예시 흐름을 간단한 수치로 보여준다.
