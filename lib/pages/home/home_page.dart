import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  final int percent;
  final VoidCallback? onTapSetting;

  const HomePage({
    super.key,
    required this.percent,
    this.onTapSetting,
  });

  String _assetForPercent() {
    if (percent >= 100) return 'assets/images/100per.png';
    if (percent >= 90) return 'assets/images/90per.png';
    if (percent >= 70) return 'assets/images/70per.png';
    if (percent >= 50) return 'assets/images/50per.png';
    if (percent >= 30) return 'assets/images/30per.png';
    if (percent >= 20) return 'assets/images/20per.png';
    if (percent >= 10) return 'assets/images/10per.png';
    if (percent >= 5) return 'assets/images/5per.png';
    return 'assets/images/0per.png';
  }

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xD9006400);
    final imagePath = _assetForPercent();

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
              top: 32,
              left: 28,
              right: 28,
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
                  GestureDetector(
                    onTap: onTapSetting,
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      'assets/icons/setting.svg',
                      width: 32,
                      height: 32,
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
