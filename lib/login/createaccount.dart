import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// デザインに合わせて色を定義
// 前回使用したものと同じ色を再定義
const Color _primaryGreen = Color(0xFF386641); // 濃い緑の背景色（ボタン・テキスト）
const Color _lightGreen = Color(0xFF6A994E);  // 薄い緑色（ボーダーやテキスト）
const Color _backgroundColor = Color(0xFFF7F7F0); // 薄いベージュの背景色

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Page Mockup',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        // 全体の背景色を薄いベージュに設定
        scaffoldBackgroundColor: _backgroundColor, 
        primaryColor: _primaryGreen,
        
        // テキストフィールドのテーマ設定
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // TextFieldの内部は白
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          // ボーダーを角丸で、薄い緑色に設定
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: _lightGreen, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: _lightGreen, width: 2.0),
          ),
          // 最初のフィールド(ユーザーネーム)に合わせて、focusedBorderは青色にする
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.blue, width: 2.0), 
          ),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // キーボード表示でリサイズを許可
      body: SingleChildScrollView( // スクロール可能にする
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            // 上部の余白
            const SizedBox(height: 80), 
            
            // 1. タイトル
            const Text(
              '新規登録',
              style: TextStyle(
                color: _primaryGreen, // 濃い緑色
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // タイトルとフォームの間の余白
            const SizedBox(height: 50),

            // 2. フォームセクション
            _buildInputField('ユーザーネーム:', false, const BorderSide(color: Colors.blue, width: 2.0)), // ユーザーネームは青枠
            const SizedBox(height: 24.0),
            _buildInputField('メールアドレス:', false, const BorderSide(color: _lightGreen, width: 2.0)),
            const SizedBox(height: 24.0),
            _buildInputField('パスワード:', true, const BorderSide(color: _lightGreen, width: 2.0)),
            const SizedBox(height: 24.0),
            _buildInputField('再パスワード:', true, const BorderSide(color: _lightGreen, width: 2.0)),
            const SizedBox(height: 40.0),

            // 3. 登録ボタン
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // 登録処理をここに記述
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen, // ボタンの背景を濃い緑に
                  foregroundColor: Colors.white,   // 文字色を白に
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // 角丸を強くする
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
                      // ログインページへの遷移処理
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
  Widget _buildInputField(String label, bool isPassword, BorderSide borderSide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: _primaryGreen, fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: _primaryGreen),
          decoration: InputDecoration(
            // `focusedBorder`と`enabledBorder`をここでオーバーライドし、画像に合わせて個別に設定
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              borderSide: borderSide,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              borderSide: borderSide,
            ),
          ),
        ),
      ],
    );
  }
}