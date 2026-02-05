class ScoreData {
  int total;
  int stageProgress;
  int kills;
  int maxCombo;

  ScoreData({
    this.total = 0,
    this.stageProgress = 0,
    this.kills = 0,
    this.maxCombo = 0,
  });

  void reset() {
    total = 0;
    stageProgress = 0;
    kills = 0;
    maxCombo = 0;
  }
}
