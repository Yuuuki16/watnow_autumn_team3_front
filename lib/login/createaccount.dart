import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watnow_autumn_team3_front/login/loginfirst.dart';

const Color _primaryGreen = Color(0xFF0B5B0D);
const Color _backgroundColor = Color(0xFFF6F5ED);

const TextStyle _titleStyle = TextStyle(
  fontFamily: 'Building',
  color: _primaryGreen,
  fontSize: 36,
  fontWeight: FontWeight.w900,
  letterSpacing: 2,
);

const TextStyle _labelStyle = TextStyle(
  fontFamily: 'Banana',
  color: _primaryGreen,
  fontSize: 14,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.7,
);

InputDecoration _inputDecoration() {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: _primaryGreen, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: _primaryGreen, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}

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

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードが一致しません')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'name': _usernameController.text.trim(),
          'chronotype': 'unknown',
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録完了しました')),
        );
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
    } catch (_) {
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
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                '新規登録',
                textAlign: TextAlign.center,
                style: _titleStyle,
              ),
              const SizedBox(height: 36),
              _buildInputField(
                label: 'ユーザーネーム：',
                controller: _usernameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 22),
              _buildInputField(
                label: 'メールアドレス：',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 22),
              _buildInputField(
                label: 'パスワード：',
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 22),
              _buildInputField(
                label: '再パスワード：',
                controller: _confirmPasswordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 36),
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Banana',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('登録'),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'アカウントをお持ちですか？',
                    style: TextStyle(
                      color: _primaryGreen,
                      fontFamily: 'Banana',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    child: const Text(
                      'ログイン',
                      style: TextStyle(
                        color: _primaryGreen,
                        fontFamily: 'Banana',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,
                        decorationColor: _primaryGreen,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          cursorColor: _primaryGreen,
          style: const TextStyle(
            color: _primaryGreen,
            fontFamily: 'Banana',
            fontWeight: FontWeight.w700,
          ),
          decoration: _inputDecoration(),
        ),
      ],
    );
  }
}
