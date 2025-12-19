import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watnow_autumn_team3_front/login/loginfirst.dart';

// デザイン定義
const Color _primaryGreen = Color(0xFF386641);
const Color _lightGreen = Color(0xFF6A994E);
const Color _backgroundColor = Color(0xFFF7F7F0);

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // --- Supabaseに登録する関数 ---
  Future<void> _signUp() async {
    // パスワード一致チェック
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードが一致しません')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Supabase Authでユーザー作成
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        // SQL側の raw_user_meta_data->>'name' や 'chronotype' と合わせる
        data: {
          'name': _usernameController.text.trim(),
          'chronotype': 'unknown', // 初期値として設定
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録完了！')),
        );
        // ログイン画面へ戻る
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('予期せぬエラーが発生しました')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            const Text(
              '新規登録',
              style: TextStyle(color: _primaryGreen, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            _buildInputField('ユーザーネーム:', false, const BorderSide(color: Colors.blue, width: 2.0), _usernameController),
            const SizedBox(height: 24.0),
            _buildInputField('メールアドレス:', false, const BorderSide(color: _lightGreen, width: 2.0), _emailController),
            const SizedBox(height: 24.0),
            _buildInputField('パスワード:', true, const BorderSide(color: _lightGreen, width: 2.0), _passwordController),
            const SizedBox(height: 24.0),
            _buildInputField('再パスワード:', true, const BorderSide(color: _lightGreen, width: 2.0), _confirmPasswordController),
            
            const SizedBox(height: 40.0),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('登録'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, bool isPassword, BorderSide borderSide, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(color: _primaryGreen, fontSize: 16)),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: _primaryGreen),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius:  BorderRadius.circular(30.0),
              borderSide: borderSide,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:  BorderRadius.circular(30.0),
              borderSide: borderSide,
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // これをimportする
// import 'package:watnow_autumn_team3_front/login/createaccount.dart';
// import 'package:watnow_autumn_team3_front/login/loginfirst.dart'; // あなたの新規登録画面


// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart'; // 追加
// // import 'loginfirst.dart';

// // // デザイン定義（変更なし）
// const Color _primaryGreen = Color(0xFF386641);
// const Color _lightGreen = Color(0xFF6A994E);
// const Color _backgroundColor = Color(0xFFF7F7F0);

// class CreateAccountPage extends StatefulWidget { // StatefulWidgetに変更
//   const CreateAccountPage({super.key});

//   @override
//   State<CreateAccountPage> createState() => _CreateAccountPageState();
// }

// class _CreateAccountPageState extends State<CreateAccountPage> {
//   // 入力内容を管理するためのコントローラー
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isLoading = false; // 処理中のグルグル表示用

//   // --- Supabaseに登録する関数 ---
//   Future<void> _signUp() async {
//     // パスワード一致チェック
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('パスワードが一致しません')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // 1. Supabase Authでユーザー作成
//       final response = await Supabase.instance.client.auth.signUp(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//         // ユーザーネームをメタデータとして保存する場合
//         data: {'username': _usernameController.text.trim()},
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('登録完了！メールを確認してください')),
//         );
//         // ログイン画面へ戻る
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const LoginPage()),
//         );
//       }
//     } on AuthException catch (error) {
//       // Supabase特有のエラー
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error.message), backgroundColor: Colors.red),
//         );
//       }
//     } catch (error) {
//       // その他のエラー
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('予期せぬエラーが発生しました')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     // メモリリーク防止のためコントローラーを破棄
//     _emailController.dispose();
//     _passwordController.dispose();
//     _usernameController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: _backgroundColor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 80),
//             const Text(
//               '新規登録',
//               style: TextStyle(color: _primaryGreen, fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 50),

//             // フォームセクション（Controllerを渡すように変更）
//             _buildInputField('ユーザーネーム:', false, const BorderSide(color: Colors.blue, width: 2.0), _usernameController),
//             const SizedBox(height: 24.0),
//             _buildInputField('メールアドレス:', false, const BorderSide(color: _lightGreen, width: 2.0), _emailController),
//             const SizedBox(height: 24.0),
//             _buildInputField('パスワード:', true, const BorderSide(color: _lightGreen, width: 2.0), _passwordController),
//             const SizedBox(height: 24.0),
//             _buildInputField('再パスワード:', true, const BorderSide(color: _lightGreen, width: 2.0), _confirmPasswordController),
            
//             const SizedBox(height: 40.0),

//             // 登録ボタン
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _signUp, // 処理中は無効化
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryGreen,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//                 ),
//                 child: _isLoading 
//                   ? const CircularProgressIndicator(color: Colors.white) 
//                   : const Text('登録'),
//               ),
//             ),

//             SizedBox(height: MediaQuery.of(context).size.height * 0.1),
//             // ... (下部のログインテキスト部分は変更なし)
//           ],
//         ),
//       ),
//     );
//   }

//   // 入力フィールド（controller引数を追加）
//   Widget _buildInputField(String label, bool isPassword, BorderSide borderSide, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(label, style: const TextStyle(color: _primaryGreen, fontSize: 16)),
//         const SizedBox(height: 8.0),
//         TextField(
//           controller: controller, // ここに割り当て
//           obscureText: isPassword,
//           style: const TextStyle(color: _primaryGreen),
//           decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//               borderRadius: const BorderRadius.all(Radius.circular(30.0)),
//               borderSide: borderSide,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: const BorderRadius.all(Radius.circular(30.0)),
//               borderSide: borderSide,
//             ),
//             fillColor: Colors.white,
//             filled: true,
//           ),
//         ),
//       ],
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'loginfirst.dart'; // LoginPage を使うため


// void main() async {
//   // 1. Flutterの初期化を確実に行う
//   WidgetsFlutterBinding.ensureInitialized();

//   // 2. Supabaseを初期化する
//   await Supabase.initialize(
//     url: 'https://upqonlirbjcjrcvwsqer.supabase.co', // Supabaseの設定画面にあるURL
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVwcW9ubGlyYmpjanJjdndzcWVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwOTg1MzIsImV4cCI6MjA3ODY3NDUzMn0.S924bwGaAFf9G4M0AEPyTV2HXJlb7naPspRGaxZhsiI',        // Supabaseの設定画面にあるAnon Key
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: CreateAccountPage(),
//     );
//   }
// }

