import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/home_screen.dart';
import 'package:game/screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static const routeName = '/auth-gate';

  @override
  Widget build(BuildContext context) {
    final clerkState = ClerkAuth.of(context);
    if (!clerkState.isSignedIn) {
      return const LoginScreen();
    }
    return const HomeScreen();
  }
}
