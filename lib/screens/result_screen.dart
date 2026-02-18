import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:game/models/game_move.dart';
import 'package:game/models/game_result.dart';
import 'package:game/providers/game_providers.dart';
import 'package:game/utils/color_extensions.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  static const routeName = '/result';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(currentGameResultProvider);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF030208),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF091322), Color(0xFF191C3C)],
            ),
            borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacityValue(0.06),
                    blurRadius: 40,
                    spreadRadius: 6,
                  ),
                ],
          ),
          child: result == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Awaiting Results',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const Text('Play a round to unlock the cinematic recap.'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      result.outcome.title,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: result.outcome.highlight,
                      ),
                    ).animate().fade(duration: 700.ms),
                    const SizedBox(height: 16),
                    Text(
                      result.subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ).animate().fade(duration: 900.ms),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      child: Lottie.asset(
                        'assets/animations/celebration.json',
                        repeat: result.outcome != GameOutcome.win,
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MoveDetail(
                          title: 'You',
                          move: result.playerMove.label,
                          color: Colors.lightGreenAccent,
                        ),
                        _MoveDetail(
                          title: 'Opponent',
                          move: result.opponentMove.label,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Play Again'),
                    ).animate().scale(duration: 600.ms),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil(ModalRoute.withName('/home')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Home'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MoveDetail extends StatelessWidget {
  const _MoveDetail({
    required this.title,
    required this.move,
    required this.color,
  });

  final String title;
  final String move;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Text(
          move,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
