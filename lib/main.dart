import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'config/theme.dart';
import 'splash/splash_screen.dart';
import 'info/onboarding/onboarding_page1.dart';
import 'auth/login_screen.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/mood_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Validate Supabase credentials
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    debugPrint('Supabase credentials missing. Check .env file.');
  }
  
  // Initialize Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Suno Samjho',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.resolvedThemeMode,
            // StartScreen handles the onboarding vs login decision
            home: const StartScreen(),
          );
        },
      ),
    );
  }

}

/// ⭐ Entry point that decides: Onboarding -> Login or direct Login
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingStatus(),
      builder: (context, snapshot) {
        // Show splash/loading while checking preferences
        if (!snapshot.hasData) {
          return const SplashScreen();
        }

        final onboardingCompleted = snapshot.data!;
        
        // Route based on onboarding completion
        return onboardingCompleted
            ? const LoginScreen()
            : const OnboardingPage1();
      },
    );
  }

  /// Check if user has completed onboarding
  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingCompleted') ?? false;
  }
}
