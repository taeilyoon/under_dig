import 'package:flutter/material.dart';
import '../game.dart';

class LobbyOverlay extends StatelessWidget {
  final MyGame game;

  const LobbyOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Under Dig',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              game.startGame();
            },
            child: const Text('시작하기'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              game.overlays.add('Settings');
              game.overlays.remove('Lobby');
            },
            child: const Text('설정'),
          ),
        ],
      ),
    );
  }
}
