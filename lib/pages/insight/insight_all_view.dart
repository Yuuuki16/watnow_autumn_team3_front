import 'package:flutter/material.dart';

// 縦スクロールのPageViewを持つ画面
class VerticalPageViewScreen extends StatelessWidget {
  const VerticalPageViewScreen({super.key});

  // ご提示の画面に対応する5つのウィジェットを作成
  final List<Widget> pages = const [
    PageInsight1Morning(), // インサイト全体1 (朝)
    PageInsight1Night(),   // インサイト全体1 (夜)
    PageInsight2(),        // インサイト2 (達成率、先延ばし率)
    PageInsight3(),        // インサイト3 (改善サイクルの比率、習慣リズム)
    PageInsight4(),        // インサイト4 (グラフ、フィードバック)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 画面下部のナビゲーションバーを再現（ここではダミーのアイコンを使用）
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // 例として3番目のアイテムを選択状態に
        type: BottomNavigationBarType.fixed, // アイコンが多い場合はこれを使う
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'カレンダー'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'インサイト'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'タスク'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
        onTap: (index) {
          // ナビゲーションバーがタップされたときの処理
        },
      ),
      
      body: SafeArea(
        // PageViewを設定
        child: PageView(
          // 💡 これを 'Axis.vertical' に設定することで縦スクロールになります
          scrollDirection: Axis.vertical, 
          
          // PageViewが画面全体を占有し、スムーズにページを切り替えます
          children: pages, 
        ),
      ),
    );
  }
}

// --- 以下、各ページのダミーウィジェット ---
// 実際のコンテンツの再現は複雑なため、主要な要素を配置したシンプルなカードとして表現します。

// 1. インサイト全体1 (朝)
class PageInsight1Morning extends StatelessWidget {
  const PageInsight1Morning({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('インサイト', '週間', '全期間'),
          _buildCard(
            title: '今週の振り返り',
            content: '今週は月曜日と火曜日にタスクをやり遂げており、良いスタートを切れています。一方、水曜日以降になると少しタスクが溜まりやすい傾向が見られます。',
          ),
          const Spacer(),
          _buildSunMoonCard('あなたの基礎タイプ', '朝型', Icons.wb_sunny, Colors.orange),
          const SizedBox(height: 20),
          Center(child: Text('ココをタップすると理解', style: TextStyle(color: Colors.green.shade700))),
        ],
      ),
    );
  }
}

// 2. インサイト全体1 (夜)
class PageInsight1Night extends StatelessWidget {
  const PageInsight1Night({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('インサイト', '週間', '全期間'),
          _buildCard(
            title: '今週の振り返り',
            content: '今週は月曜日と火曜日にタスクをやり遂げており、良いスタートを切れています。一方、水曜日以降になると少しタスクが溜まりやすい傾向が見られます。',
          ),
          const Spacer(),
          _buildSunMoonCard('あなたの基礎タイプ', '夜型', Icons.nightlight_round, Colors.amber),
          const SizedBox(height: 20),
          Center(child: Text('ココをタップすると理解', style: TextStyle(color: Colors.green.shade700))),
        ],
      ),
    );
  }
}

// 3. インサイト2 (達成率、先延ばし率)
class PageInsight2 extends StatelessWidget {
  const PageInsight2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDonutChart(75, 24, 8),
          const SizedBox(height: 30),
          _buildFailureRate(30, 3, 10),
          const SizedBox(height: 30),
          _buildPatternScore(15, 8, 50),
        ],
      ),
    );
  }
}

// 4. インサイト3 (改善サイクルの比率、習慣リズム)
class PageInsight3 extends StatelessWidget {
  const PageInsight3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressTile('改善サイクル (1週間)', 25, Colors.purple),
          _buildProgressTile('改善サイクル (2週間)', 30, Colors.blue),
          _buildProgressTile('改善サイクル (4週間)', 45, Colors.green),
          const SizedBox(height: 40),
          _buildHabitRhythm(),
        ],
      ),
    );
  }
}

// 5. インサイト4 (グラフ、フィードバック)
class PageInsight4 extends StatelessWidget {
  const PageInsight4({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBarChartPlaceholder(),
          const SizedBox(height: 20),
          _buildFeedbackCard(),
        ],
      ),
    );
  }
}

// --- 再利用可能なコンポーネント関数 ---

Widget _buildHeader(String title, String tab1, String tab2) {
  return Row(
    children: [
      Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
      const SizedBox(width: 20),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(tab1, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ),
      const SizedBox(width: 5),
      Text(tab2, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
    ],
  );
}

Widget _buildCard({required String title, required String content}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    ),
  );
}

Widget _buildSunMoonCard(String typeTitle, String type, IconData icon, Color color) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(typeTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Icon(icon, size: 80, color: color),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(type, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDonutChart(int percentage, int completed, int incomplete) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Text('$percentage%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('完了: $completed件', style: TextStyle(color: Colors.green.shade700)),
              Text('未完了: $incomplete件', style: TextStyle(color: Colors.red.shade700)),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget _buildFailureRate(int percentage, int completed, int total) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('先延ばし率', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Row(
        children: [
          Text('$percentage%', style: const TextStyle(fontSize: 32, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text('$completed / $total 件', style: const TextStyle(fontSize: 14)),
        ],
      ),
      const SizedBox(height: 10),
      // ダミーの小さなタスクアイコン
      Row(
        children: List.generate(5, (index) => const Padding(
          padding: EdgeInsets.only(right: 5),
          child: Icon(Icons.check_circle, color: Colors.grey, size: 20),
        )),
      ),
    ],
  );
}

Widget _buildPatternScore(int percentage, int score, int total) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('バイオリズムスコア', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Row(
        children: [
          Text('$percentage%', style: const TextStyle(fontSize: 32, color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text('$score / $total ポイント改善', style: const TextStyle(fontSize: 14)),
        ],
      ),
    ],
  );
}

Widget _buildProgressTile(String label, int percentage, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
            const SizedBox(width: 10),
            Text('$percentage%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}

Widget _buildHabitRhythm() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('習慣リズム', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(15)),
                child: Text('✅ 習慣の作りやすい日', style: TextStyle(color: Colors.green.shade800, fontSize: 12)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(15)),
                child: Text('⚠️ 習慣に集中したい日', style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildBarChartPlaceholder() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('日別の達成率', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          // グラフのプレースホルダー
          Container(
            height: 150,
            color: Colors.grey.shade100,
            child: const Center(child: Text('ここに棒グラフが表示されます')),
          ),
          const SizedBox(height: 10),
          const Text('詳細な情報と日別のデータ', style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    ),
  );
}

Widget _buildFeedbackCard() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('フィードバック', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          const Divider(),
          const SizedBox(height: 8),
          const Text('これまでタスクを頑張り、タスクが溜まり切り直前に完了する傾向があります。もっと早めに着手しやすい環境を作り、先延ばしを防ぎましょう。うるおいのタスクでモチベーションを確保し「習慣の場所と時間」を作ってあげることと、「これを聞き終わったらすぐ着手」など、週間の目標を「0→1の小さな行動」に変えていくことです。日曜日が最も先延ばしリスクがあるため、まずココから対策を始めましょう。', style: TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}