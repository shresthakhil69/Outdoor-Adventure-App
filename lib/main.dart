import 'package:flutter/material.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Yak & Trail',
      theme: AppTheme.light,
      home: const SettingsScreen(),
    );
  }
}
