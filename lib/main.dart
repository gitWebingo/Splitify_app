import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'views/onboarding_screen.dart';

void main() {
  runApp(const SplitifyApp());
}

class SplitifyApp extends StatelessWidget {
  const SplitifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.elegantTheme,
      home: const OnboardingScreen(),
    );
  }
}
