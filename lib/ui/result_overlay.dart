import 'package:flutter/material.dart';
import '../game.dart';

class ResultOverlay extends StatelessWidget {
  final MyGame game;

  const ResultOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 450,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.red, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            _buildResultRow('최종 점수', '1,234'), // TODO: Bind real data
            _buildResultRow('도달 스테이지', 'Stage 5'),
            _buildResultRow('처치한 적', '12'),
            _buildResultRow('최대 콤보', '7'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('Result');
                game.overlays.add('Lobby');
                game.resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('로비로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
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
      ),
    );
  }
}
