import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/models/game_move.dart';
import 'package:game/models/game_result.dart';
import 'package:game/providers/game_providers.dart';
import 'package:game/screens/result_screen.dart';
import 'package:game/widgets/move_choice_card.dart';

class OfflineGameScreen extends ConsumerStatefulWidget {
  const OfflineGameScreen({super.key});

  static const routeName = '/offline';

  @override
  ConsumerState<OfflineGameScreen> createState() => _OfflineGameScreenState();
}

class _OfflineGameScreenState extends ConsumerState<OfflineGameScreen> {
  late final ConfettiController _confetti;
  bool _transitioning = false;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 1));
    ref.listen<OfflineGameState>(offlineGameProvider, (previous, current) {
      final result = current.lastResult;
      if (result == null || result == previous?.lastResult || _transitioning) {
        return;
      }
      if (result.outcome == GameOutcome.win) {
        _confetti.play();
      }
      _transitioning = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        Navigator.of(context)
            .push(
              PageRouteBuilder(
                pageBuilder: (_, animation, unused) => const ResultScreen(),
                transitionsBuilder: (_, animation, unusedSecondary, child) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            )
            .then((_) => _transitioning = false);
      });
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _selectMove(GameMove move) {
    HapticFeedback.lightImpact();
    ref.read(offlineGameProvider.notifier).selectMove(move);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(offlineGameProvider);
    final theme = Theme.of(context);
    final selectedMove = state.lastResult?.playerMove;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Arena'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF05030F), Color(0xFF090B1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _scoreBubble('You', state.playerScore, Colors.greenAccent),
                    _scoreBubble(
                        'Opponent', state.opponentScore, Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Select your move',
                  style: theme.textTheme.headlineSmall,
                )
                    .animate()
                    .fade(duration: 600.ms)
                    .slideX(begin: -0.2),
                const SizedBox(height: 18),
                Row(
                  children: GameMove.values.map((move) {
                    final isSelected = selectedMove == move;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Opacity(
                          opacity: state.busy && !isSelected ? 0.65 : 1,
                          child: MoveChoiceCard(
                            move: move,
                            selected: isSelected,
                            disabled: state.busy,
                            onTap: () => _selectMove(move),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                if (state.lastResult != null)
                  Column(
                    children: [
                      Text(
                        'Opponent chose ${state.lastResult!.opponentMove.label}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.lastResult!.outcome.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: state.lastResult!.outcome.highlight,
                        ),
                      ),
                    ],
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.1),
                const Spacer(),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: state.busy ? 1 : 0,
                  child: const LinearProgressIndicator(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 32,
              colors: const [
                Color(0xFF7DF9FF),
                Color(0xFFFFC048),
                Color(0xFF5B6BFF)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBubble(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
