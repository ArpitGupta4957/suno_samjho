import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/main_page.dart';
import '../onboarding/onboarding_page1.dart';
import '../splash/splash_content.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashContent();
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return DashboardPage(
            userName: session.user.userMetadata?['name'] as String? ??
                session.user.email?.split('@').first ??
                'User',
          );
        } else {
          return const OnboardingPage1();
        }
      },
    );
  }
}
