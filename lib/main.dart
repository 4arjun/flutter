import 'package:flutter/material.dart';
import 'package:lascade_demo_app/navigator/auth_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Nested Navigation App',
      debugShowCheckedModeBanner: false,
      home: const AuthStack(),
    );
  }
}
