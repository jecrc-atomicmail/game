import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:game/config/env.dart';
import 'package:game/screens/auth_gate.dart';
import 'package:game/screens/home_screen.dart';
import 'package:game/screens/launch_screen.dart';
import 'package:game/screens/login_screen.dart';
import 'package:game/screens/online_game_screen.dart';
import 'package:game/screens/offline_game_screen.dart';
import 'package:game/screens/profile_screen.dart';
import 'package:game/screens/result_screen.dart';
import 'package:game/theme/app_theme.dart';

final _clerkConfig = ClerkAuthConfig(
  publishableKey: clerkPublishableKey,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const ProviderScope(child: AppEntry()));
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ClerkAuth(
      config: _clerkConfig,
      child: ClerkErrorListener(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.premiumTheme,
          home: const LaunchScreen(),
          routes: {
            LaunchScreen.routeName: (_) => const LaunchScreen(),
            LoginScreen.routeName: (_) => const LoginScreen(),
            HomeScreen.routeName: (_) => const HomeScreen(),
            OfflineGameScreen.routeName: (_) => const OfflineGameScreen(),
            OnlineGameScreen.routeName: (_) => const OnlineGameScreen(),
            ResultScreen.routeName: (_) => const ResultScreen(),
            ProfileScreen.routeName: (_) => const ProfileScreen(),
            AuthGate.routeName: (_) => const AuthGate(),
          },
        )
            .animate()
            .fade(duration: 700.ms)
            .slideY(curve: Curves.easeOut, duration: 800.ms),
      ),
    );
  }
}
