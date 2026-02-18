import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game/screens/auth_gate.dart';
import 'package:game/utils/color_extensions.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  static const routeName = '/launch';

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _particleController.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AuthGate.routeName);
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          final glow = 1 + (_particleController.value * 0.25);
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: const [Color.fromARGB(255, 116, 124, 192), Color(0xFF090B1A)],
                radius: 0.8,
                focal: Alignment.center,
              ),
            ),
            child: Center(
              child: Hero(
                tag: 'logo',
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacityValue(0.08),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7DF9FF).withOpacityValue(0.4),
                        blurRadius: 24 * glow,
                        spreadRadius: 4 * _particleController.value,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Stone Paper Scissors',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'A sleek throwdown',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().scaleXY(
                    begin: 0.9,
                    end: 1.05,
                    curve: Curves.easeInOut,
                    duration: 1500.ms,
                  ),
            ),
          );
        },
      ),
    );
  }
}
