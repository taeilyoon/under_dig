import '../lib/score/score_engine.dart';

void main() {
  // Lightweight ad-hoc tests without external test package
  var engine = ScoreEngine();
  var delta = engine.calculateScore(ScoreEvent.StageAdvance);
  assert(delta == 6, 'StageAdvance stage1 delta should be 6');
  engine = ScoreEngine();
  engine.onStageAdvance();
  delta = engine.calculateScore(ScoreEvent.StageAdvance);
  assert(delta == 13, 'StageAdvance stage2 delta should be 13');
  engine = ScoreEngine();
  delta = engine.calculateScore(ScoreEvent.Kill);
  assert(delta == 20, 'Kill delta should be 20');
  engine = ScoreEngine();
  delta = engine.calculateScore(ScoreEvent.Combo);
  assert(delta == 0, 'Combo delta initial should be 0');
  engine.onComboIncrement();
  delta = engine.calculateScore(ScoreEvent.Combo);
  assert(delta == 9, 'Combo delta after one increment should be 9');
  engine = ScoreEngine();
  engine.onStageAdvance();
  engine.onStageAdvance();
  delta = engine.calculateScore(ScoreEvent.StageAdvance);
  assert(delta == 22, 'StageAdvance stage3 delta should be 22');
  engine = ScoreEngine();
  engine.onComboIncrement();
  engine.onComboIncrement();
  delta = engine.calculateScore(ScoreEvent.Combo);
  assert(delta == 12, 'Combo delta after two increments should be 12');
  // Additional test: stage 4 and 5 and combo4
  engine = ScoreEngine();
  engine.onStageAdvance(); // stage1
  engine.onStageAdvance(); // stage2
  engine.onStageAdvance(); // stage3
  delta = engine.calculateScore(ScoreEvent.StageAdvance); // nextStage = 4
  assert(delta == 31, 'StageAdvance stage4 delta should be 31');
  // Additional test: combo after three increments
  engine = ScoreEngine();
  engine.onComboIncrement(); // 1
  engine.onComboIncrement(); // 2
  engine.onComboIncrement(); // 3
  delta = engine.calculateScore(ScoreEvent.Combo); // nextCombo=4
  assert(delta == 13, 'Combo delta after three increments should be 13');
  // Extra: stage5 delta with four advancements
  engine = ScoreEngine();
  engine.onStageAdvance(); // 1
  engine.onStageAdvance(); // 2
  engine.onStageAdvance(); // 3
  engine.onStageAdvance(); // 4
  delta = engine.calculateScore(ScoreEvent.StageAdvance); // nextStage = 5
  assert(delta == 41, 'StageAdvance stage5 delta should be 41');
  // Extra: combo4 delta
  engine = ScoreEngine();
  engine.onComboIncrement(); //1
  engine.onComboIncrement(); //2
  engine.onComboIncrement(); //3
  engine.onComboIncrement(); //4
  delta = engine.calculateScore(ScoreEvent.Combo); // nextCombo=5
  // log2(6) ~ 2.585; 6*2.585 = 15.51 -> 15
  assert(delta == 15, 'Combo delta after four increments should be 15');
  engine = ScoreEngine();
  var before = engine.total;
  engine.calculateScore(ScoreEvent.StageAdvance);
  assert(
    engine.total == before,
    'Score should not mutate on calculateScore call',
  );
  // Extra: Stage7 delta test
  {
    var eng7 = ScoreEngine();
    for (int i = 0; i < 6; i++)
      eng7.onStageAdvance(); // stageProgress reaches 6
    final delta7 = eng7.calculateScore(ScoreEvent.StageAdvance);
    assert(delta7 == 61, 'StageAdvance stage7 delta should be 61');
  }
  // Extra: Stage8 delta test
  {
    var eng8 = ScoreEngine();
    for (int i = 0; i < 7; i++)
      eng8.onStageAdvance(); // stageProgress reaches 7
    final delta8 = eng8.calculateScore(ScoreEvent.StageAdvance);
    assert(delta8 == 71, 'StageAdvance stage8 delta should be 71');
  }
  // Extra: Stage9 delta test
  {
    var eng9 = ScoreEngine();
    for (int i = 0; i < 8; i++) eng9.onStageAdvance();
    final delta9 = eng9.calculateScore(ScoreEvent.StageAdvance);
    assert(delta9 == 82, 'StageAdvance stage9 delta should be 82');
  }
  // Additional: Stage 10-12 delta checks to validate progression
  {
    var e10 = ScoreEngine();
    for (int i = 0; i < 9; i++)
      e10.onStageAdvance(); // stageProgress = 9, nextStage=10
    final d10 = e10.calculateScore(ScoreEvent.StageAdvance);
    assert(d10 == 93, 'StageAdvance stage10 delta should be 93');
  }
  {
    var e11 = ScoreEngine();
    for (int i = 0; i < 10; i++) e11.onStageAdvance(); // nextStage=11
    final d11 = e11.calculateScore(ScoreEvent.StageAdvance);
    assert(d11 == 104, 'StageAdvance stage11 delta should be 104');
  }
  {
    var e12 = ScoreEngine();
    for (int i = 0; i < 11; i++) e12.onStageAdvance(); // nextStage=12
    final d12 = e12.calculateScore(ScoreEvent.StageAdvance);
    assert(d12 == 115, 'StageAdvance stage12 delta should be 115');
  }
  {
    // Stage13 delta test
    var e13 = ScoreEngine();
    for (int i = 0; i < 12; i++)
      e13.onStageAdvance(); // stageProgress reaches 12, nextStage=13
    final d13 = e13.calculateScore(ScoreEvent.StageAdvance);
    assert(d13 == 126, 'StageAdvance stage13 delta should be 126');
  }
  print('Score engine tests passed (ad-hoc).');
}
