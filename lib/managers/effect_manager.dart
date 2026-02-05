import 'package:flame/components.dart';

class EffectManager {
  static final EffectManager _instance = EffectManager._internal();
  factory EffectManager() => _instance;
  EffectManager._internal();

  void playSound(String soundKey) {
    // Placeholder for FlameAudio.play
    print('Playing sound: $soundKey');
  }

  void triggerVisualEffect(String effectType, Vector2 position) {
    // Placeholder for triggering particles or animations
    print('Triggering visual effect: $effectType at $position');
  }

  void showFloatingText(String text, Vector2 position) {
    // Logic to spawn a TextComponent with moving effect
    print('Showing floating text: $text at $position');
  }
}
