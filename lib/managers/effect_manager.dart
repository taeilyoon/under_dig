import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class EffectManager {
  static final EffectManager _instance = EffectManager._internal();
  factory EffectManager() => _instance;
  EffectManager._internal();

  final Random _rng = Random();

  void playSound(String soundKey) {
    print('Playing sound: $soundKey');
  }

  /// Triggers a burst of particles at the given position with a specific color.
  void triggerDeathParticles(Component parent, Vector2 position, Color color) {
    parent.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 15,
          lifespan: 0.8,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 200), // Gravity-like pull
            speed: Vector2(
              (_rng.nextDouble() - 0.5) * 300,
              (_rng.nextDouble() - 0.5) * 300,
            ),
            position: position.clone(),
            child: CircleParticle(
              radius: 1.5 + _rng.nextDouble() * 2,
              paint: Paint()..color = color,
            ),
          ),
        ),
      ),
    );
  }

  void showFloatingText(Component parent, String text, Vector2 position) {
    print('Showing floating text: $text at $position');
    // Implement text effects here if needed
  }
}
