import 'package:flutter/material.dart';
import '../game.dart';

class SettingsOverlay extends StatelessWidget {
  final MyGame game;

  const SettingsOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            children: [
              const Text(
                '설정',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const Spacer(),
              const Text('배경음악', style: TextStyle(color: Colors.white)),
              Switch(value: true, onChanged: (v) {}),
              const SizedBox(height: 10),
              const Text('효과음', style: TextStyle(color: Colors.white)),
              Switch(value: true, onChanged: (v) {}),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  game.overlays.add('Lobby');
                  game.overlays.remove('Settings');
                },
                child: const Text('뒤로가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
