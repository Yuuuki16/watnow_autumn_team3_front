import 'package:flutter/material.dart';
import 'loginfirst.dart'; // LoginPage を使うため

// デザインに合わせて色を定義
// ログイン画面と同じトーンで合わせている
const Color _primaryGreen = Color(0xFF386641); // 濃い緑（ボタン・テキスト）
const Color _lightGreen = Color(0xFF6A994E); // 薄い緑（ボーダーなど）
const Color _backgroundColor = Color(0xFFF7F7F0); // 薄いベージュの背景色

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // キーボード表示でリサイズを許可
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            // 上部の余白
            const SizedBox(height: 80),

            // 1. タイトル
            const Text(
              '新規登録',
              style: TextStyle(
                color: _primaryGreen,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // タイトルとフォームの間の余白
            const SizedBox(height: 50),

            // 2. フォームセクション
            _buildInputField(
              'ユーザーネーム:',
              false,
              const BorderSide(color: Colors.blue, width: 2.0),
            ), // ユーザーネームは青枠
            const SizedBox(height: 24.0),

            _buildInputField(
              'メールアドレス:',
              false,
              const BorderSide(color: _lightGreen, width: 2.0),
            ),
            const SizedBox(height: 24.0),

            _buildInputField(
              'パスワード:',
              true,
              const BorderSide(color: _lightGreen, width: 2.0),
            ),
            const SizedBox(height: 24.0),

            _buildInputField(
              '再パスワード:',
              true,
              const BorderSide(color: _lightGreen, width: 2.0),
            ),
            const SizedBox(height: 40.0),

            // 3. 登録ボタン
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen, // ボタンの背景を濃い緑に
                  foregroundColor: Colors.white, // 文字色を白に
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // 角丸
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('登録'),
              ),
            ),

            // ボタンと下部テキストの間の余白
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),

            // 4. 下部のログインテキスト
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'アカウントをお持ちですか？',
                    style: TextStyle(color: _primaryGreen, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      // ログインページに戻る
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'ログイン',
                      style: TextStyle(
                        color: _primaryGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: _primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 入力フィールドを構築するためのヘルパー関数
  Widget _buildInputField(
    String label,
    bool isPassword,
    BorderSide borderSide,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(color: _primaryGreen, fontSize: 16)),
        const SizedBox(height: 8.0),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: _primaryGreen),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              borderSide: borderSide,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
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
