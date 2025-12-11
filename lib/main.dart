// lib/main.dart
import 'package:flutter/material.dart';
import 'login/loginfirst.dart'; // ログイン画面 & loginTheme を読み込む

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: loginTheme,         // ← loginfirst.dart で定義したテーマ
      home: const LoginPage(),   // ← 最初に表示する画面
    );
  }
}
