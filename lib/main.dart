import 'package:flutter/material.dart';
import 'package:outdoor_adventure/screens/level_interest_screen.dart';
import 'package:outdoor_adventure/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yak & Trail Nepal',
      theme: AppTheme.light,
      home: const LevelInterestScreen(),
    );
  }
}