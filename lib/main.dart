import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            // 下のレイヤー：今までの Column（ちょっとだけ上の余白を増やす）
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 140), // ← タイトル行ぶん少し多めに空ける

                const Text(
                  "達成度",
                  style: TextStyle(
                    fontSize: 55,
                    color: Color(0xD9006400),
                    fontFamily: 'Building',
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "0%",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xD9006400),
                    fontFamily: 'Building',
                  ),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('assets/images/0per.png'),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 40, // ← 上からの距離
              left: 28, // ← 左からの距離
              right: 16, // ← 右まで使う（Rowの両端に配置したいのでrightも指定）
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ホーム",
                    style: TextStyle(
                      color: Color(0xD9006400),
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      fontFamily: 'Building',
                      shadows: const [
                        Shadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.25),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/aikon.png',
                    width: 42, // ← FigmaのW
                    height: 42, // ← FigmaのH
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //フッターの設定これで統一してほしい
      bottomNavigationBar: SafeArea(
        child: Container(
          color: const Color(0xA8006400),
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 左の余白
              SvgPicture.asset(
                'assets/icons/icon_group.svg',
                width: 53,
                height: 53,
              ),

              const SizedBox(width: 34),

              SvgPicture.asset(
                'assets/icons/icon_home.svg',
                width: 50,
                height: 50,
              ),

              const SizedBox(width: 34),

              SvgPicture.asset(
                'assets/icons/icon_list.svg',
                width: 50,
                height: 50,
              ),

              const SizedBox(width: 34),

              SvgPicture.asset(
                'assets/icons/icon_insight.svg',
                width: 50,
                height: 50,
              ),
              // 右の余白
            ],
          ),
        ),
      ),
    );
  }
}
