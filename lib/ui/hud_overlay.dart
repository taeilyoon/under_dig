import 'package:flutter/material.dart';
import '../game.dart';

class HudOverlay extends StatefulWidget {
  final MyGame game;

  const HudOverlay({super.key, required this.game});

  @override
  State<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends State<HudOverlay> {
  @override
  void initState() {
    super.initState();
    widget.game.scoreEngine.addListener(_update);
  }

  @override
  void dispose() {
    widget.game.scoreEngine.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Header Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    'HP',
                    '${game.player.hp}',
                    Colors.redAccent,
                    Icons.favorite,
                  ),
                  _buildStatCard(
                    'STAGE',
                    '${game.scoreEngine.stageProgress}',
                    Colors.blueAccent,
                    Icons.layers,
                  ),
                  _buildStatCard(
                    'SCORE',
                    '${game.scoreEngine.total}',
                    Colors.amber,
                    Icons.monetization_on,
                  ),
                ],
              ),
            ),
          ),

          // Middle Area: Combo Notification
          if (game.comboTracker.combo > 1)
            Align(
              alignment: const Alignment(0, -0.4), // Slightly above center
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${game.comboTracker.combo} COMBO!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 150,
                    height: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (game.comboTracker.timeLeftMs / 3000).clamp(
                          0.0,
                          1.0,
                        ),
                        backgroundColor: Colors.black,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Footer Area: Inventory
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'INVENTORY',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(game.inventory.maxSlots, (index) {
                      final item = game.inventory.slots[index];
                      return Container(
                        width: 54,
                        height: 54,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: item != null
                                ? Colors.white70
                                : Colors.white10,
                            width: 1.5,
                          ),
                        ),
                        child: item != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // TODO: Use item logic
                                },
                              )
                            : null,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
