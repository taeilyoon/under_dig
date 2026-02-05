import 'package:flutter/material.dart';
import '../game.dart';

class HudOverlay extends StatelessWidget {
  final MyGame game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar: Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('HP', '${game.player.hp}', color: Colors.red),
              _buildStat(
                'STAGE',
                '${game.scoreEngine.stageProgress}',
                color: Colors.blue,
              ),
              _buildStat(
                'SCORE',
                '${game.scoreEngine.total}',
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Combo
          if (game.comboTracker.combo > 1)
            Row(
              children: [
                Text(
                  '${game.comboTracker.combo} COMBO!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: (game.comboTracker.timeLeftMs / 3000).clamp(
                      0.0,
                      1.0,
                    ),
                    backgroundColor: Colors.white24,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          const Spacer(),
          // Bottom Bar: Inventory
          Row(
            children: List.generate(game.inventory.maxSlots, (index) {
              final item = game.inventory.slots[index];
              return Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: item != null
                    ? Tooltip(
                        message: '${item.name}\n${item.description}',
                        child: const Center(
                          child: Icon(
                            Icons.star, // Simplified icon for now
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, {required Color color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.7), fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
