import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game/screens/launch_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final clerkState = ClerkAuth.of(context);
    final user = clerkState.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                user?.firstName?.substring(0, 1) ?? '',
                style: const TextStyle(fontSize: 32),
              ),
            ).animate().scale(duration: 600.ms),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Unknown Player',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? 'user@email.com',
              style:
                  const TextStyle(color: Colors.white70, letterSpacing: 1.1),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await clerkState.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LaunchScreen.routeName,
                    (route) => false,
                  );
                }
              },
              child: const Text('Log Out'),
            )
                .animate()
                .fade(duration: 400.ms)
                .slideY(),
          ],
        ),
      ),
    );
  }
}
