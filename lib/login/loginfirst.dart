import 'package:flutter/material.dart';
import 'createaccount.dart'; // 🔸 新規登録画面への遷移用
import 'package:watnow_autumn_team3_front/app/app_state.dart'; // ← 追加

// デザインに合わせて色を定義
const Color _primaryGreen = Color(0xFF386641); // 濃い緑の背景色
const Color _lightGreen = Color(0xFF6A994E);  // テキストフィールド枠などに使う色

/// 外からも使うログイン用テーマ（main.dart から参照される）
final ThemeData loginTheme = ThemeData(
  scaffoldBackgroundColor: _primaryGreen,
  primaryColor: _primaryGreen,
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // 🔸 TextField 内部は白
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 画面の高さを取得して、上の余白をいい感じに調整
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 1. ロゴ＆上部余白
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.15),
                  const Icon(
                    Icons.eco,
                    size: 100,
                    color: Colors.white,
                  ),
                ],
              ),

              // 2. フォーム＋ログインボタン
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // メールアドレス
                  const Text(
                    'メールアドレス:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@mail.com',
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // パスワード
                  const Text(
                    'パスワード:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'パスワードを入力',
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // ログインボタン
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: ログイン成功したら AppState に遷移させる
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const AppState()),
                        );
                      },
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
                      child: const Text('ログイン'),
                    ),
                  ),
                ],
              ),

              // 3. 下部の「新規登録はこちら」
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
                        // 🔸 新規登録ページへの遷移
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CreateAccountPage(),
                          ),
                        );
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
    );
  }
}
