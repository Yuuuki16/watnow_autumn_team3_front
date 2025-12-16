import 'package:flutter/material.dart';

// メインアプリケーション
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertical PageView Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFFBFBF5), // 背景色を薄いベージュ/グレーに設定
      ),
      home: const VerticalPageViewScreen(),
    );
  }
}

// 縦スクロールのPageViewを持つ画面
class VerticalPageViewScreen extends StatelessWidget {
  const VerticalPageViewScreen({super.key});

  // ご提示の画面に対応する3つのウィジェットを作成（ここでは仮のウィジェット）
  final List<Widget> pages = const [
    PageOne(),   // 左の画面（インサイト/今週の振り返りなど）
    PageTwo(),   // 中央の画面（習慣リズム/グラフなど）
    PageThree(), // 右の画面（フィードバックなど）
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // ステータスバーなどの領域を避ける
        child: PageView(
          // 💡 これを 'Axis.vertical' に設定することで縦スクロールになります
          scrollDirection: Axis.vertical, 
          
          // スムーズなアニメーション制御はPageViewが自動で行ってくれます
          // 必要に応じて PageController を使用し、プログラムからページ遷移を制御できます (animateToPage, jumpToPageなど)

          children: pages, // ページとして表示するウィジェットのリスト
        ),
      ),
    );
  }
}

// --- 以下、各ページのダミーウィジェット ---

// 1ページ目 (左の画面に対応)
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
            _buildInsightCard('インサイト', '今週の振り返り', '今週は月曜日と火曜日にタスクをやり遂げており、良いスタートを切れています。一方、水曜日以降になると少しタスクが溜まりやすい傾向が見られます。', Colors.green),
            _buildStatusCircle(25, 2, 6),
            _buildFailureRate(30, 3, 10),
          ],
        ),
      ),
    );
  }
}

// 2ページ目 (中央の画面に対応)
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
            _buildBarChart(), // グラフの部分はダミーです
            const SizedBox(height: 30),
            const Text('💡 今週の達成率は平均ですが、水曜日以降に完了できたタスクが少し伸び悩んでおります。週の中盤に小休憩と食と、簡単な軽いパフォーマンを維持すべきかもしれません。', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

// 3ページ目 (右の画面に対応)
class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildFeedbackCard('フィードバック', '効率的でタスクが溜りがちな傾向があるので、タスク間のハードルを下げる工夫が効果的です。たとえば、「聞くだけ」を「タイトルだけ書く」など、「0→1の小さな行動」を水曜日の目標にすると、自然と取りかかりやすくなります。'),
      ),
    );
  }
}

// --- 以下、画面のコンポーネントを再現するためのダミー関数（実際のロジックは省略） ---

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
      Text('先延ばし率', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  // 実際のグラフ描画は external package (e.g., fl_chart) が必要ですが、ここではダミーとして画像をトリガーします。
  // ユーザーが意図する「グラフ」のイメージを伝えるために画像タグを使用します。
  return Center(child:       );
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