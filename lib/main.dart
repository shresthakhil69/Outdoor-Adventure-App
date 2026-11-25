import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Firebase connected: ${Firebase.app().options.projectId}');
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
      },
    );
  }
}