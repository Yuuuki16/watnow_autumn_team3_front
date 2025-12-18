import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final int percent;
  final String imagePath;

  const HomePage({
    super.key,
    required this.percent,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xD9006400);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 140),
                  const Text(
                    '達成度',
                    style: TextStyle(
                      fontSize: 55,
                      color: titleColor,
                      fontFamily: 'Building',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$percent%',
                    semanticsLabel: '達成度$percentパーセント',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                      fontFamily: 'Building',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 28,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ホーム',
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      fontFamily: 'Building',
                      shadows: [
                        Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: Image.asset(
                      'assets/images/aikon.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
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
}
