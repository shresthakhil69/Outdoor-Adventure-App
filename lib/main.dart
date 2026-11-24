import 'screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'screens/level_interest_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yak & Trail',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const OnboardingScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const Scaffold(
          body: Center(child: Text('Home')),
        ),
        '/register': (_) =>  RegisterScreen(),

        '/forgot': (_) => const Scaffold(
          body: Center(child: Text('Forgot password')),
        ),
        '/settings': (_) => const SettingsScreen(),
        '/edit-profile': (_) => const LevelInterestScreen(),
      },
    );
  }
}