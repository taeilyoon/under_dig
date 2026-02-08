import 'package:flutter/material.dart';

class LobbyScreen extends StatelessWidget {
  final VoidCallback onStartPressed;
  final VoidCallback onSettingsPressed;

  const LobbyScreen({
    super.key,
    required this.onStartPressed,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Under Dig',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 60),
            _buildMenuButton('시작하기', onStartPressed, primary: true),
            const SizedBox(height: 20),
            _buildMenuButton('설정', onSettingsPressed),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    String text,
    VoidCallback onPressed, {
    bool primary = false,
  }) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? Colors.amber : Colors.white10,
          foregroundColor: primary ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
