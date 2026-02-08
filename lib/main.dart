import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'ui/lobby_overlay.dart';
import 'ui/settings_overlay.dart';
import 'ui/result_overlay.dart';
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
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late MyGame _game;

  @override
  void initState() {
    super.initState();
    _game = MyGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 1. Physical Layout Layer (Game Board & Basic HUD)
              Column(
                children: [
                  HudHeader(game: _game),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AspectRatio(
                          aspectRatio: 1.0, // Force square for 8x8 grid
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white12,
                                width: 2,
                              ),
                            ),
                            child: GameWidget(game: _game),
                          ),
                        ),
                      ),
                    ),
                  ),
                  HudFooter(game: _game),
                ],
              ),

              // 2. Interactive Overlays Layer (Lobby, Settings, Result)
              GameWidget<MyGame>(
                game: _game,
                overlayBuilderMap: {
                  'Lobby': (context, game) => LobbyOverlay(game: game),
                  'Settings': (context, game) => SettingsOverlay(game: game),
                  'Result': (context, game) => ResultOverlay(game: game),
                },
                initialActiveOverlays: const ['Lobby'],
              ),
            ],
          );
        },
      ),
    );
  }
}
