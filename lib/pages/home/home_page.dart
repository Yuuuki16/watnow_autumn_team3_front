import 'package:flutter/material.dart';
import 'package:watnow_autumn_team3_front/pages/settings/settings_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'サボテン成長度：$percent%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Image.asset(
              imagePath,
              width: 180,
              height: 180,
            ),
          ],
        ),
      ),
    );
  }
}
