# Alpha-2-14: 스테이지 진행도 기반 스폰 및 난이도 통합 (Spawn & Difficulty Integration)

## 목표
- `StageProgress`가 증가함에 따라 게임의 난이도와 보상 수준을 동적으로 조절하는 시스템을 구축합니다.
- `SpawnController`와 `LevelManager`를 통합하여 실시간 난이도 스케일링을 구현합니다.

## 핵심 메커니즘
1. **난이도 스케일링 (Difficulty Scaling)**
   - 스테이지가 올라갈수록 `SpawnCurve`를 통해 적 등장 빈도(`enemyRate`)와 위험 요소 확률(`hazardRate`)이 상승합니다.
   - `SpawnController.tickSpawn()`을 사용하여 매 틱마다 생성될 엔티티의 수를 결정합니다.

2. **보상 최적화 (Reward Optimization)**
   - 스테이지 진행도에 따라 `lootTier`가 상승하여 상자에서 더 강력한 아이템이 드롭될 확률이 높아집니다.
   - 고난이도 스테이지일수록 콤보를 통한 점수 획득 효율이 증가하도록 유도합니다.

3. **레벨 관리자 역할 (LevelManager)**
   - 현재 스테이지 상태를 보유하고, 다음 스테이지로 넘어가는 시점을 관리합니다.
   - `advanceStage()` 메서드를 통해 모든 하위 시스템(`SpawnController`, `DropManager` 등)에 변경 사항을 전파합니다.

## 구현 상세
- `lib/managers/level_manager.dart`: 스테이지 상태 관리 및 스폰 로직 통합.
- `SpawnController`: 스테이지별 스폰 데이터를 계산하고 보정하는 엔진 역할.

## 향후 작업
- **Alpha-2-15**: 스테이지 업 시 시각적 알림 및 환경 변화(배경색 등) 추가.
- **Alpha-2-16**: 난이도 곡선 밸런싱 테스트 및 조정.
