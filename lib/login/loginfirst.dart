import 'package:flutter/material.dart';

// デザインに合わせて色を定義
const Color _primaryGreen = Color(0xFF386641); // 濃い緑の背景色
const Color _lightGreen = Color(0xFF6A994E);  // テキストフィールドのボーダーやヒントに使う色

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メールアドレスとパスワードを入力してください')),
      );
      return;
    }
    // 仮の認証成功として Home に遷移
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 画面のサイズを取得してPaddingの値を調整しやすくする
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // キーボードが表示されたときに画面がリサイズされないようにする
      resizeToAvoidBottomInset: false, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            // 要素を縦方向にスペースをあけて配置
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 1. ロゴと上部の余白
              SizedBox(height: screenHeight * 0.15),
              const Icon(
                Icons.eco, // 芽のアイコンに最も近いものを使用
                size: 100,
                color: Colors.white,
              ),

              // 2. フォームとボタン
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // メールアドレス
                  const Text('メールアドレス:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'example@domain.com', fillColor: _primaryGreen),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24.0),

                  // パスワード
                  const Text('パスワード:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // パスワードを隠す
                    decoration: const InputDecoration(hintText: 'パスワード', fillColor: _primaryGreen),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 40.0),

                  // ログインボタン
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // ボタンの背景を白に
                        foregroundColor: _primaryGreen, // 文字色を濃い緑に
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // 角丸を強くする
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('ログイン'),
                    ),
                  ),
                ],
              ),
              
              // 3. 下部の登録テキスト
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
                        // 登録ページへの遷移処理
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'こちら',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold, // 強調
                          decoration: TextDecoration.underline, // 下線（画像にはないが視認性向上のため）
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
    );
  }
}

// テーマを外部からも使えるように LoginTheme を提供
final ThemeData loginTheme = ThemeData(
  scaffoldBackgroundColor: _primaryGreen,
  primaryColor: _primaryGreen,
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: _primaryGreen,
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