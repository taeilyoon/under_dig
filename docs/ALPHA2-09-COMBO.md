# Alpha-2-09: 콤보 시스템 설계 및 UI 연동

목표
- 콤보 추적 로직을 구현하고 HUD/UI에 표시한다.
- ScoreEngine과의 연동 예시를 포함하여 콤보 피드백을 명확하게 제공한다.

구성
- ComboTracker API 제안
  - combo: 현재 콤보 카운트
  - timeLeft: 콤보 유지 시간 남은 시간
  - reset(): 콤보 리셋
- ScoreEngine 연동 예시
  - 콤보가 증가할 때 보너스 점수 반영
- UI 요구사항
  - HUD에 콤보 카운트 표시
  - 콤보 유지 시간 바 또는 애니메이션
  - 콤보 리셋 시 애니메이션/피드백

데이터 흐름
- 콤보 증가 이벤트 처리
- 타이머 감소 및 만료 시 콤보 리셋
- UI 바인딩

테스트 계획
- 콤보 증가 시 보너스 점수 누적 확인
- 콤보 리셋 시 상태 초기화 확인
- UI 바인딩 정상 여부에 대한 간단한 테스트

파일 포인트
- lib/ui/combo_tracker.dart
- lib/score/score_engine.dart (Combo 로직)
- docs/ALPHA2-09-COMBO.md
