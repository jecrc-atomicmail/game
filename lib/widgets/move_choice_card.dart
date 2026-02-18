import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game/models/game_move.dart';
import 'package:game/utils/color_extensions.dart';

class MoveChoiceCard extends StatelessWidget {
  const MoveChoiceCard({
    required this.move,
    this.selected = false,
    this.disabled = false,
    this.onTap,
    super.key,
  });

  final GameMove move;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = move.accentColor;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: selected
                  ? [
                      color.withOpacityValue(0.95),
                      color.withOpacityValue(0.5)
                    ]
                  : [
                      color.withOpacityValue(0.5),
                      color.withOpacityValue(0.2)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: selected ? Colors.white : Colors.white10,
            width: selected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
            color: color.withOpacityValue(0.35),
              blurRadius: selected ? 30 : 16,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(move.icon, size: 34, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              move.label,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            if (selected)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ).animate().scale(duration: 400.ms),
              ),
          ],
        ),
      ),
    );
  }
}
