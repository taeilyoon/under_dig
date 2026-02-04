import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add a simple component to verify Flame is working
    add(
      TextComponent(
        text: 'Flame Environment Ready!',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
