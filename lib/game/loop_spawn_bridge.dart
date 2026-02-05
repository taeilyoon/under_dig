import 'spawn_controller.dart';

// Integrates SpawnController with the game loop.
class LoopSpawnBridge {
  final SpawnController spawnController;

  LoopSpawnBridge({required this.spawnController});

  // Call this on every game tick to determine how many enemies to spawn this tick.
  int tick() {
    // In a real loop, you'd spawn 'count' enemies here and enqueue them into the game world.
    return spawnController.tickSpawn();
  }
}
