import 'package:flutter/material.dart';
import 'splash_content.dart';

/// Splash screen that displays branding visuals.
/// Navigation timing is managed by StartScreen in main.dart.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashContent();
  }
}
