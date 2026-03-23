import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'config/theme.dart';
import 'splash/splash_screen.dart';
import 'onboarding/onboarding_page1.dart';
import 'auth/login_screen.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/mood_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    debugPrint('.env file not found or unreadable — skipping.');
  }

  // Validate Supabase credentials
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    debugPrint('Supabase credentials missing. Check .env file.');
  }

  // Initialize Supabase (skip if credentials missing)
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    } catch (e) {
      debugPrint('Supabase init failed: $e — running in offline mode.');
    }
  }

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

/// ⭐ Entry point that shows splash, then decides: Onboarding -> Login or direct Login
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _splashDone = false;
  bool? _onboardingCompleted;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Run both in parallel: minimum splash duration + preferences check
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 3)), // minimum splash duration
      _checkOnboardingStatus(),
    ]);

    if (!mounted) return;
    setState(() {
      _onboardingCompleted = results[1] as bool;
      _splashDone = true;
    });
  }

  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingCompleted') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Always show splash until minimum duration has passed
    if (!_splashDone) {
      return const SplashScreen();
    }

    // Route based on onboarding completion
    return _onboardingCompleted == true
        ? const LoginScreen()
        : const OnboardingPage1();
  }
}
