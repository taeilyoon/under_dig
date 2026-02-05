# Alpha-2-08 Highscore Persistence (StageProgress)

Goal: Implement saving/loading of high scores with local storage. Prepare for Hive/SharedPreferences integration.

Approach:
- Introduce HighScoreProvider interface with save/load methods.
- Provide an in-memory implementation as a placeholder until a real persistence layer is wired.
- Outline the schema for stored data and migration notes for future upgrades.

What’s next:
- Replace InMemoryHighScoreProvider with Hive or SharedPreferences-based provider.
- Implement migration strategy if needed.
- Add unit tests for persistence interactions.
