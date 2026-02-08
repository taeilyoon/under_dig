import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: const Text('설정', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingTile('배경음악', true),
          _buildSettingTile('효과음', true),
          _buildSettingTile('진동', false),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String title, bool initialValue) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Switch(
        value: initialValue,
        onChanged: (v) {},
        activeColor: Colors.amber,
      ),
    );
  }
}
