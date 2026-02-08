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
  }

  void _navigateTo(String route) {
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
            _game.isGameStarted = true;
            _navigateTo('Game');
          },
          onSettingsPressed: () => _navigateTo('Settings'),
        );
      case 'Settings':
        return SettingsScreen(onBack: () => _navigateTo('Lobby'));
      case 'Game':
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          body: ListenableBuilder(
            listenable: _game,
            builder: (context, _) {
              if (_game.player.hp <= 0 && _game.isGameStarted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _game.onGameOver();
                  _navigateTo('Result');
                });
              }
              return Column(
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
              );
            },
          ),
        );
      case 'Result':
        return ResultScreen(
          score: _game.scoreEngine.total,
          stage: _game.scoreEngine.stageProgress,
          onHome: () => _navigateTo('Lobby'),
        );
      default:
        return const Center(child: Text('Unknown Route'));
    }
  }
}
