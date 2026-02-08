class ScoreData {
  int total;
  int stageProgress;
  int kills;
  int maxCombo;
  int keys;

  ScoreData({
    this.total = 0,
    this.stageProgress = 0,
    this.kills = 0,
    this.maxCombo = 0,
    this.keys = 0,
  });

  void reset() {
    total = 0;
    stageProgress = 0;
    kills = 0;
    maxCombo = 0;
    keys = 0;
  }
}
