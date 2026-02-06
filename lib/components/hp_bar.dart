import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HpBarComponent extends PositionComponent with HasPaint {
  final double maxHp;
  double currentHp;
  final double width;
  final double height;

  HpBarComponent({
    required this.maxHp,
    required this.currentHp,
    this.width = 40,
    this.height = 6,
  }) : super(size: Vector2(width, height));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Background (Black/Empty)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = Colors.black54,
    );

    // Progress
    final progress = (currentHp / maxHp).clamp(0.0, 1.0);

    // Color logic: Green -> Yellow -> Red
    Color barColor = Colors.green;
    if (progress < 0.3) {
      barColor = Colors.red;
    } else if (progress < 0.6) {
      barColor = Colors.orange;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width * progress, height),
      Paint()..color = barColor,
    );

    // Border
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()
        ..color = Colors.white70
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void updateHp(int newHp) {
    currentHp = newHp.toDouble();
  }
}
