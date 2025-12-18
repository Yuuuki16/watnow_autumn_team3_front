import 'package:flutter/material.dart';

/// 週間インサイトの縦スクロールページ群
class VerticalPageViewScreen extends StatelessWidget {
  const VerticalPageViewScreen({super.key});

  final List<Widget> pages = const [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          scrollDirection: Axis.vertical,
          children: pages,
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInsightCard(
              'インサイト',
              '今週の振り返り',
              '今週は月曜日と火曜日にタスクをやり遂げており、良いスタートを切れています。一方、水曜日以降になると少しタスクが溜まりやすい傾向が見られます。',
              Colors.green,
            ),
            _buildStatusCircle(25, 2, 6),
            _buildFailureRate(30, 3, 10),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHabitRhythmCard(),
            const SizedBox(height: 30),
            _buildBarChart(),
            const SizedBox(height: 30),
            const Text(
              '💡 今週の達成率は平均ですが、水曜日以降に完了できたタスクが少し伸び悩んでおります。週の中盤に小休憩と食と、簡単な軽いパフォーマンを維持すべきかもしれません。',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildFeedbackCard(
          'フィードバック',
          '効率的でタスクが溜りがちな傾向があるので、タスク間のハードルを下げる工夫が効果的です。たとえば、「聞くだけ」を「タイトルだけ書く」など、「0→1の小さな行動」を水曜日の目標にすると、自然と取りかかりやすくなります。',
        ),
      ),
    );
  }
}

// --- コンポーネント ---

Widget _buildInsightCard(String title, String subtitle, String content, Color color) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const Spacer(),
              const CircleAvatar(child: Icon(Icons.person, size: 20)),
            ],
          ),
          const Divider(),
          Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}

Widget _buildStatusCircle(int percentage, int completed, int incomplete) {
  return Column(
    children: [
      const Text('今週の状況', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            Text('$percentage%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text('完了: $completed件 / 未完了: $incomplete件'),
    ],
  );
}

Widget _buildFailureRate(int percentage, int completed, int total) {
  return Column(
    children: [
      const Text('先延ばし率', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text('$percentage%', style: const TextStyle(fontSize: 32, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
      Text('$completed / $total', style: const TextStyle(fontSize: 14)),
    ],
  );
}

Widget _buildHabitRhythmCard() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('習慣リズム', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20)),
                child: Text('✅ 習慣の作りやすい日', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)),
                child: Text('⚠️ 習慣に集中したい日', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('小さなタスクで満たすと調子が取りやすいです', style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    ),
  );
}

Widget _buildBarChart() {
  return Center(
    child: SizedBox(
      width: 260,
      height: 140,
      child: Card(
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.bar_chart, size: 48, color: Colors.green),
              SizedBox(height: 8),
              Text('グラフのプレースホルダ', style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildFeedbackCard(String title, String content) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          const Divider(),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}

