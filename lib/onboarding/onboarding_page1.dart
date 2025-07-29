import 'package:flutter/material.dart';
import 'package:suno_samjho/onboarding/onboarding_page2.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding Page 1'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to Onboarding Page 1!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const OnboardingPage2()));
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
