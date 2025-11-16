import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/supabase_config.dart';
import 'splash/splash_screen.dart';
import 'home/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    // In a real app you might show an error screen or fallback.
    debugPrint('Supabase credentials missing. Check .env file.');
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suno Samjho',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'OpenSans'),
        ),
      ),
      // Simple auth gate: if session exists go straight to dashboard
      home: Supabase.instance.client.auth.currentSession == null
          ? const SplashScreen()
          : DashboardPage(
              userName:
                  Supabase
                          .instance
                          .client
                          .auth
                          .currentUser
                          ?.userMetadata?['name']
                      as String? ??
                  Supabase.instance.client.auth.currentUser?.email
                      ?.split('@')
                      .first ??
                  'User',
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}
