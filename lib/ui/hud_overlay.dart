import 'package:flutter/material.dart';
import '../game.dart';

class HudHeader extends StatefulWidget {
  final MyGame game;
  const HudHeader({super.key, required this.game});

  @override
  State<HudHeader> createState() => _HudHeaderState();
}

class _HudHeaderState extends State<HudHeader> {
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

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
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
              '${widget.game.player.hp}',
              Colors.redAccent,
              Icons.favorite,
            ),
            _buildStatCard(
              'STAGE',
              '${widget.game.scoreEngine.stageProgress}',
              Colors.blueAccent,
              Icons.layers,
            ),
            _buildStatCard(
              'SCORE',
              '${widget.game.scoreEngine.total}',
              Colors.amber,
              Icons.monetization_on,
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
        mainAxisSize: MainAxisSize.min,
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

class HudFooter extends StatefulWidget {
  final MyGame game;
  const HudFooter({super.key, required this.game});

  @override
  State<HudFooter> createState() => _HudFooterState();
}

class _HudFooterState extends State<HudFooter> {
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

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
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
              children: List.generate(widget.game.inventory.maxSlots, (index) {
                final item = widget.game.inventory.slots[index];
                return Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: item != null ? Colors.white70 : Colors.white10,
                    ),
                  ),
                  child: item != null
                      ? const Icon(Icons.star, color: Colors.white, size: 20)
                      : null,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
