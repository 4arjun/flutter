import 'package:flutter/material.dart';
import 'package:lascade_demo_app/navigator/main_tab_screen.dart';
import 'package:lascade_demo_app/navigator/auth_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lascade_demo_app/providers/Auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Nested Navigation App',
      debugShowCheckedModeBanner: false,
      home: authState.auth ? const MainTabScreen() : const AuthStack(),
    );
  }
}
