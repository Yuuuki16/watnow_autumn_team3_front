import 'package:flutter/material.dart';
// import 'package:watnow_autumn_team3_front/pages/settings/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.percent,
    required this.imagePath,
  });

  final int percent;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFF386641), // 背景（今までの緑系に合わせる）
        width: double.infinity,
        child: Stack(
          children: [
            // 右上：設定アイコン（アカウント設定へ）
            // Positioned(
            //   top: 12,
            //   right: 12,
            //   child: IconButton(
            //     icon: const Icon(Icons.person_outline, color: Colors.white),
            //     onPressed: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(builder: (_) => const SettingsPage()),
            //       );
            //     },
            //   ),
            // ),

            // 中央：成長度テキスト + サボテン画像
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'サボテン成長度：$percent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    imagePath,
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
