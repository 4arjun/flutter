import 'package:flutter/material.dart';
import 'package:lascade_demo_app/screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lascade Store',
      theme: ThemeData(
        fontFamily: 'Inter', // Match Figma font if needed
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
