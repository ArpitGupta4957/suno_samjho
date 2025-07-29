import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding Page 2'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to Onboarding Page 2!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => LoginScreen()));
        },
        label: const Text('Next'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
