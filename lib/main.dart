import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'ui/lobby_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/result_screen.dart';
import 'ui/hud_overlay.dart';

void main() {
  runApp(const UnderDigApp());
}

class UnderDigApp extends StatelessWidget {
  const UnderDigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Under Dig',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  String _currentRoute = 'Lobby';
  late MyGame _game;

  @override
  void initState() {
    super.initState();
    _game = MyGame();
    // Listen to game state changes for Game Over
    _game.addListener(_handleGameStateChange);
  }

  @override
  void dispose() {
    _game.removeListener(_handleGameStateChange);
    super.dispose();
  }

  void _handleGameStateChange() {
    // If game has started but player HP hits 0, trigger result screen
    if (_game.isGameStarted && _game.player.hp <= 0) {
      _navigateTo('Result');
    }
  }

  void _navigateTo(String route) {
    if (!mounted) return;
    setState(() {
      _currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentRoute) {
      case 'Lobby':
        return LobbyScreen(
          onStartPressed: () {
            _game.resetGame();
            _game.startGame();
            _navigateTo('Game');
          },
          onSettingsPressed: () => _navigateTo('Settings'),
        );
      case 'Settings':
        return SettingsScreen(onBack: () => _navigateTo('Lobby'));
      case 'Game':
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          body: Column(
            children: [
              HudHeader(game: _game),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12, width: 2),
                      ),
                      child: GameWidget(game: _game),
                    ),
                  ),
                ),
              ),
              HudFooter(game: _game),
            ],
          ),
        );
      case 'Result':
        return ResultScreen(
          score: _game.scoreEngine.total,
          stage: _game.scoreEngine.stageProgress,
          onHome: () {
            _game.resetGame();
            _navigateTo('Lobby');
          },
        );
      default:
        return const Center(child: Text('Unknown Route'));
    }
  }
}
