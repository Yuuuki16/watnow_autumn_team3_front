
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watnow_autumn_team3_front/app/app_state.dart'; 
import 'createaccount.dart'; 
import 'package:watnow_autumn_team3_front/api/api_client.dart'; // 作成したファイルを指定

// デザイン用カラー（変更なし）
const Color _primaryGreen = Color(0xFF386641);
const Color _lightGreen = Color(0xFF6A994E);

// テーマ定義
final ThemeData loginTheme = ThemeData(
  scaffoldBackgroundColor: _primaryGreen,
  primaryColor: _primaryGreen,
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: _lightGreen, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: _lightGreen, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    hintStyle: TextStyle(color: _lightGreen),
  ),
);

// StatefulWidgetに変更
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ① 入力を管理するコントローラー
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // 処理中の表示用

  final api = ApiClient('http://10.0.2.2:8000');
  // ② ログイン処理の実装
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // Supabaseにメールアドレスとパスワードを送信して認証
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    final session = Supabase.instance.client.auth.currentSession;
    print('--- JWT (AccessToken) ---');
    print(session?.accessToken);
      
      // 認証成功：AppStateページへ（戻れないように pushReplacement）
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppState()),
        );
      }
    } on AuthException catch (error) {
      // 認証エラー（パスワード間違いなど）
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      // その他のエラー
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('予期せぬエラーが発生しました'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // メモリ節約のため破棄
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _primaryGreen, // 背景色を指定
      resizeToAvoidBottomInset: true, // キーボード表示時に画面をズラす
      body: SafeArea(
        child: SingleChildScrollView( // スクロール可能にしてエラーを防ぐ
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              height: screenHeight - 50, // 画面サイズに合わせて調整
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.15),
                      const Icon(Icons.eco, size: 100, color: Colors.white),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('メールアドレス:', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8.0),
                      // ③ コントローラーを紐付け
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'example@mail.com'),
                      ),
                      const SizedBox(height: 24.0),
                      const Text('パスワード:', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8.0),
                      // ③ コントローラーを紐付け
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'パスワードを入力'),
                      ),
                      const SizedBox(height: 40.0),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          // ④ ログイン処理を呼び出す
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: _primaryGreen)
                            : const Text('ログイン'),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'アカウントをお持ちでない方は',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CreateAccountPage()),
                            );
                          },
                          child: const Text(
                            'こちら',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// final api = ApiClient('http://127.0.0.1:8000');

// final me = await api.getJson('/auth/me');

// print(me);
// { user_id: "...", chronotype: "...", ai_status: "...", created_at: "..." }