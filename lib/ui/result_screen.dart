import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int stage;
  final VoidCallback onHome;

  const ResultScreen({
    super.key,
    required this.score,
    required this.stage,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '최종 점수: $score',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              '도달 스테이지: $stage',
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: onHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text('로비로 돌아가기', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
