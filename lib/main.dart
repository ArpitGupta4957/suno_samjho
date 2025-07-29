import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';

void main() {
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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
