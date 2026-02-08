import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'ui/lobby_overlay.dart';
import 'ui/settings_overlay.dart';
import 'ui/result_overlay.dart';
import 'ui/hud_overlay.dart';

void main() {
  runApp(
    GameWidget<MyGame>(
      game: MyGame(),
      overlayBuilderMap: {
        'Lobby': (context, game) => LobbyOverlay(game: game),
        'Settings': (context, game) => SettingsOverlay(game: game),
        'Result': (context, game) => ResultOverlay(game: game),
        'HudHeader': (context, game) => HudHeader(game: game),
        'HudFooter': (context, game) => HudFooter(game: game),
      },
      initialActiveOverlays: const ['Lobby'],
    ),
  );
}
