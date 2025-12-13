import 'package:flutter/material.dart';
import 'login/loginfirst.dart';
import 'app/app_state.dart'; // ← AppStateを置いてる場所に合わせて変更

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: loginTheme,
      home: const LoginPage(),
    );
  }
}
