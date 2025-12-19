import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// 相対パスでインポートするのが一番確実です
import 'login/loginfirst.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://upqonlirbjcjrcvwsqer.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVwcW9ubGlyYmpjanJjdndzcWVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwOTg1MzIsImV4cCI6MjA3ODY3NDUzMn0.S924bwGaAFf9G4M0AEPyTV2HXJlb7naPspRGaxZhsiI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Auth App',
      // loginfirst.dart で定義したテーマを適用する
      theme: loginTheme, 
      home: const LoginPage(),
    );
  }
}

// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'login/loginfirst.dart'; // ログイン画面 & loginTheme を読み込む
// import 'package:supabase_flutter/supabase_flutter.dart'; // これをimportする

// /// ① Todoクラス（データの形だけ決める）
// class Todo {
// final String title;
// bool isDone;

// Todo(this.title, {this.isDone = false});
// }

// void main() {
// runApp(const MyApp());
// }

// /// ② アプリの入口（MyApp）
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: loginTheme,         // ← loginfirst.dart で定義したテーマ
//       home: const LoginPage(),   // ← 最初に表示する画面
//     );
//   }
// }



// Removed duplicate MyApp constructor/build block that caused a conflicting definition.