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
      // IgnorePointer set to true would block everything.
      // We want to allow hits through the empty space but KEEP them for children.
      // So we use a Stack without a full-screen blocking container.
      child: SafeArea(
        child: Stack(
          children: [
            // Header Area - Wrap in IgnorePointer(ignoring: false) to catch hits
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: false, // Catch hits for stat cards
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
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
            ),

            // Middle Area (Empty) - Hits will pass through to Flame by default in a Stack if no widget is here

            // Combo Notification
            if (game.comboTracker.combo > 1)
              IgnorePointer(
                ignoring:
                    true, // Let combo text be purely visual, hits pass through
                child: Align(
                  alignment: const Alignment(0, -0.45),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${game.comboTracker.combo} COMBO!',
                        style: TextStyle(
                          fontSize: 32,
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
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 120,
                        height: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
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
              ),

            // Footer Area: Inventory
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: false, // Catch hits for inventory slots
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'INVENTORY',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(game.inventory.maxSlots, (
                          index,
                        ) {
                          final item = game.inventory.slots[index];
                          return Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: item != null
                                    ? Colors.white70
                                    : Colors.white10,
                                width: 1.2,
                              ),
                            ),
                            child: item != null
                                ? const Center(
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  )
                                : null,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 9,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
