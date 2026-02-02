import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'views/main_layout.dart'; // Changed to main_layout to skip onboarding for dev efficiency, or keep onboarding if preferred. Let's keep onboarding flow but ensure providers are up.
import 'views/onboarding_screen.dart';
import 'controllers/data_controller.dart';

void main() {
  runApp(const SplitifyApp());
}

class SplitifyApp extends StatelessWidget {
  const SplitifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataController()),
      ],
      child: MaterialApp(
        title: 'Splitify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.elegantTheme,
        home: const OnboardingScreen(),
      ),
    );
  }
}
