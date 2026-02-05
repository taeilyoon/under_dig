# Alpha-2-17: 핵심 데이터 모델 정의 및 정립 (Core Data Models Definition)

## 목표
- Alpha-2 단계에서 사용되는 모든 핵심 엔티티(`Score`, `Item`, `Inventory`, `Buff`)의 데이터 구조를 명확히 정의하고 통일합니다.
- 데이터의 영속성(Persistence) 및 확장성을 고려한 모델링을 수행합니다.

## 핵심 모델 구조 (Entity Schema)

### 1. ScoreData (점수 모델)
- `total`: 누적 총 점수.
- `stageProgress`: 현재 도달한 스테이지 번호.
- `kills`: 누적 처치 수.
- `maxCombo`: 해당 판에서 달성한 최대 콤보 횟수.

### 2. Item & ItemEffect (아이템 및 효과 모델)
- `Item`: 
  - `id`: 유니크 식별자.
  - `name`, `description`: 표시 명칭 및 설명.
  - `type`: 소모품 분류 (`potion`, `scroll`, `artifact`).
  - `effects`: 하나 이상의 `ItemEffect` 목록.
- `ItemEffect`:
  - `type`: 효과 종류 (`hp_restore`, `atk_boost` 등).
  - `value`: 수치 데이터.
  - `duration`: 버프 지속 턴 수 (즉발형은 `null`).

### 3. Buff (지속 효과 모델)
- `type`, `value`, `duration`: 아이템 효과에서 파생된 현재 활성화된 상태 정보.

### 4. Inventory (인벤토리 모델)
- `maxSlots`: 최대 가용 슬롯 수.
- `slots`: `Item` 객체들의 리스트 (비어있을 경우 `null`).

## 구현 현황
- `lib/models/score_model.dart`: 점수 데이터 구조화.
- `lib/item/item.dart`: 아이템 및 효과 데이터 구조화.
- `lib/item/inventory.dart`: 인벤토리 관리 로직 포함.
- `lib/models/buff_model.dart`: 버프 데이터 구조화.

## 향후 확장성
- 향후 JSON 직렬화(`toJson`, `fromJson`)를 모든 모델에 적용하여 서버 연동 및 로컬 저장소(Hive) 최적화를 진행할 예정입니다.
