import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:game/models/game_move.dart';
import 'package:game/models/game_result.dart';
import 'package:game/providers/game_providers.dart';
import 'package:game/screens/offline_game_screen.dart';
import 'package:game/screens/online_game_screen.dart';
import 'package:game/screens/profile_screen.dart';
import 'package:game/utils/color_extensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastResult = ref.watch(currentGameResultProvider);
    final theme = Theme.of(context);
    final clerkState = ClerkAuth.of(context);
    final user = clerkState.user;
    final resultCard = lastResult == null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Finish an arena to unlock a cinematic recap.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        : Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lastResult.outcome == GameOutcome.win
                  ? const Color(0xFF00FF91)
                  : Colors.white24,
              Colors.white10,
            ],
          ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: lastResult.outcome == GameOutcome.win
                      ? Lottie.asset(
                          'assets/animations/celebration.json',
                          repeat: false,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          lastResult.outcome == GameOutcome.draw
                              ? Icons.pause_circle
                              : Icons.close,
                          size: 48,
                          color: lastResult.outcome == GameOutcome.lose
                              ? Colors.redAccent
                              : Colors.amberAccent,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastResult.outcome.title,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(lastResult.subtitle,
                          style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        '${lastResult.playerMove.label} vs ${lastResult.opponentMove.label}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user?.firstName ?? 'Player'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () =>
                Navigator.of(context).pushNamed(ProfileScreen.routeName),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05030F), Color(0xFF111437)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your arena',
              style: theme.textTheme.headlineSmall,
            ).animate().fade(duration: 600.ms),
            const SizedBox(height: 12),
            resultCard,
            const SizedBox(height: 6),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _buildModeCard(
                    context,
                    title: 'Offline Duel',
                    subtitle: 'Face the AI with slick animations.',
                    icon: Icons.smart_toy,
                    color: const Color(0xFF7DF9FF),
                    route: OfflineGameScreen.routeName,
                  ),
                  const SizedBox(height: 20),
                  _buildModeCard(
                    context,
                    title: 'Online Clash',
                    subtitle: 'Real-time matchups, status updates.',
                    icon: Icons.wifi_protected_setup,
                    color: const Color(0xFF5B6BFF),
                    route: OnlineGameScreen.routeName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required String route}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _navigate(context, route),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [
              color.withOpacityValue(0.4),
              color.withOpacityValue(0.15)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacityValue(0.45),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -40,
              child: Icon(
                icon,
                size: 120,
                color: color.withOpacityValue(0.15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start',
                        style: TextStyle(
                          letterSpacing: 1,
                          color: color.withOpacityValue(0.9),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: color,
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fade(duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
