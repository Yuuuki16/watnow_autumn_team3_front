import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watnow_autumn_team3_front/app/app_state.dart';
import 'createaccount.dart';

const Color _backgroundGreen = Color(0xFF0B5B0D);

// Theme applied from main.dart for the login flow.
final ThemeData loginTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _backgroundGreen),
  scaffoldBackgroundColor: _backgroundGreen,
  fontFamily: 'Banana',
  useMaterial3: true,
);

const TextStyle _labelStyle = TextStyle(
  fontFamily: 'Banana',
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.7,
);

InputDecoration _loginInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Colors.white70,
      fontFamily: 'Banana',
      fontWeight: FontWeight.w700,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
    filled: false,
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppState()),
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
          const SnackBar(
            content: Text('予期せぬエラーが発生しました'),
            backgroundColor: Colors.red,
          ),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 36),
                    Image.asset(
                      'assets/images/image14.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('メールアドレス：', style: _labelStyle),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Banana',
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: _loginInputDecoration('メールアドレスを入力'),
                        ),
                        const SizedBox(height: 24),
                        Text('パスワード：', style: _labelStyle),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Banana',
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: _loginInputDecoration('パスワードを入力'),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: _backgroundGreen,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Banana',
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 0.8,
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: _backgroundGreen,
                                    ),
                                  )
                                : const Text('ログイン'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'アカウントをお持ちでない方は',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Banana',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CreateAccountPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            child: const Text(
                              'こちら',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Banana',
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
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
          },
        ),
      ),
    );
  }
}
