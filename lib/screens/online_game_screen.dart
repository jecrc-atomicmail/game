import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:game/models/game_move.dart';
import 'package:game/models/game_result.dart';
import 'package:game/providers/game_providers.dart';
import 'package:game/utils/color_extensions.dart';
import 'package:game/widgets/move_choice_card.dart';

class OnlineGameScreen extends ConsumerWidget {
  const OnlineGameScreen({super.key});

  static const routeName = '/online';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onlineMatchProvider);
    final result = state.lastResult;
    return Scaffold(
      appBar: AppBar(title: const Text('Online Arena')),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05030F), Color(0xFF030308)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: state.connected
                      ? [const Color(0xFF5B6BFF), const Color(0xFF090B1A)]
                      : [const Color(0xFF272A4F), const Color(0xFF111437)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: state.connected
                        ? const Color(0xFF5B6BFF).withOpacityValue(0.3)
                        : Colors.black26,
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.lobbyStatus,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.opponentStatus,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.matchmakingNote,
                    style: const TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: GameMove.values.map((move) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: MoveChoiceCard(
                        move: move,
                        selected: false,
                        disabled: state.busy || !state.connected,
                        onTap: () =>
                            ref.read(onlineMatchProvider.notifier).selectMove(move),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1C3B), Color(0xFF05030F)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      result.outcome.title,
                      style: TextStyle(
                        color: result.outcome.highlight,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.playerMove.label} vs ${result.opponentMove.label}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (result.outcome == GameOutcome.win) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: Lottie.asset(
                          'assets/animations/celebration.json',
                          repeat: false,
                        ),
                      ),
                    ],
                  ],
                ),
              )
                  .animate()
                  .fade(duration: 600.ms)
                  .slideY(begin: 0.2),
            if (state.busy)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
