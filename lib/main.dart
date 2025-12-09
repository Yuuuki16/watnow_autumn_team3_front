import 'package:flutter/material.dart'; // ✅ import（外部ライブラリ読み込み）
import 'package:flutter_svg/flutter_svg.dart'; // ✅ import

/// ① Todoクラス（データの形だけ決める）
class Todo {
  // ✅ クラス定義
  final String title; // ✅ インスタンス変数（インスタンス変数）
  bool isDone; // ✅ インスタンス変数

  Todo(this.title, {this.isDone = false}); // ✅ コンストラクタ
}

void main() {
  // ✅ top-level 関数
  runApp(const MyApp()); // ✅ MyApp のインスタンス生成＋関数呼び出し
}

/// ② アプリの入口（ここまでは今までとほぼ同じ）
class MyApp extends StatelessWidget {
  // ✅ クラス定義（StatelessWidget）
  const MyApp({super.key}); // ✅ コンストラクタ

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド（build関数）
    return const MaterialApp(
      // ✅ MaterialApp のインスタンス生成
      debugShowCheckedModeBanner: false,
      home: AppState(), // ✅ AppState のインスタンス生成
    );
  }
}

/// ③ アプリ全体の「親StatefulWidget」
class AppState extends StatefulWidget {
  // ✅ クラス定義（StatefulWidget 本体）
  const AppState({super.key}); // ✅ コンストラクタ

  @override
  State<AppState> createState() => _AppStateState(); // ✅ メソッド（Stateインスタンスを作る“工場”）
}

class _AppStateState extends State<AppState> {
  // ✅ クラス定義（状態を持つクラス）
  int _currentIndex = 1; // ✅ インスタンス変数（状態：どのタブか）

  final List<Todo> _todos = [
    // ✅ インスタンス変数（状態：Todoリスト）
    Todo('レポートを1つ終わらせる'), // ✅ コンストラクタ呼び出し＝インスタンス生成
    Todo('30分勉強する'),
    Todo('課題を1つ提出する'),
  ];

  /// 完了率（0〜100の生の％）
  int get _rawPercent {
    // ✅ getter（値を返す“関数”）
    if (_todos.isEmpty) return 0;
    final done = _todos.where((t) => t.isDone).length; // ✅ ローカル変数
    return ((done / _todos.length) * 100).round();
  }

  /// サボテン用の段階に丸めた％
  int get _cactusPercent {
    // ✅ getter（関数）
    const levels = [0, 5, 10, 20, 30, 50, 90, 100]; // ✅ ローカル定数
    int closest = levels.first;
    int minDiff = (levels.first - _rawPercent).abs();

    for (final level in levels) {
      // ✅ ループ処理
      final diff = (level - _rawPercent).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = level;
      }
    }
    return closest;
  }

  /// 画像パス
  String get _cactusImagePath => // ✅ getter（1行の式＝関数）
      'assets/images/${_cactusPercent}per.png';

  /// ToDoのチェックが変わったとき
  void _toggleTodo(int index, bool? value) {
    // ✅ メソッド（関数）
    setState(() {
      // ✅ 関数呼び出し（状態更新＋再build）
      _todos[index].isDone = value ?? false;
    });
  }

  /// タブがタップされたとき
  void _onTabTapped(int index) {
    // ✅ メソッド（関数）
    setState(() {
      _currentIndex = index;
    });
  }

  /// 今のタブに応じてページを返す
  Widget _buildCurrentPage() {
    // ✅ メソッド（関数：Widgetを返す）
    switch (_currentIndex) {
      case 0:
        return const GroupPage(); // ✅ GroupPage インスタンス
      case 1:
        return HomePage(
          // ✅ HomePage インスタンス
          percent: _cactusPercent,
          imagePath: _cactusImagePath,
        );
      case 2:
        return TodoPage(
          // ✅ TodoPage インスタンス
          todos: _todos,
          onToggle: _toggleTodo,
        );
      case 3:
        return const InsightPage(); // ✅ InsightPage インスタンス
      default:
        return const SizedBox.shrink(); // ✅ SizedBox インスタンス
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド（AppState全体のUIを作る関数）
    return Scaffold(
      // ✅ Scaffold インスタンス生成
      body: _buildCurrentPage(), // ✅ 関数呼び出しの結果（Widget）を渡している

      bottomNavigationBar: SafeArea(
        // ✅ SafeArea インスタンス
        child: Container(
          // ✅ Container インスタンス
          color: const Color(0xA8006400),
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            // ✅ Row インスタンス
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BottomNavIcon(
                // ✅ _BottomNavIcon インスタンス（タブ1つ分）
                assetPath: 'assets/icons/icon_group.svg',
                activeAssetPath: 'assets/icons/active_group.svg',
                isActive: _currentIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              const SizedBox(width: 34), // ✅ SizedBox インスタンス
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_home.svg',
                activeAssetPath: 'assets/icons/active_home.svg',
                isActive: _currentIndex == 1,
                onTap: () => _onTabTapped(1),
              ),
              const SizedBox(width: 34),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_list.svg',
                activeAssetPath: 'assets/icons/active_list.svg',
                isActive: _currentIndex == 2,
                onTap: () => _onTabTapped(2),
              ),
              const SizedBox(width: 34),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_insight.svg',
                activeAssetPath: 'assets/icons/active_insight.svg',
                isActive: _currentIndex == 3,
                onTap: () => _onTabTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// フッターのアイコン用の小さい部品
class _BottomNavIcon extends StatelessWidget {
  // ✅ クラス定義（Widget部品）
  final String assetPath; // ✅ インスタンス変数
  final String activeAssetPath;
  final bool isActive; // ✅ インスタンス変数
  final VoidCallback onTap; // ✅ インスタンス変数（関数型の変数）
  final double size;

  const _BottomNavIcon({
    // ✅ コンストラクタ
    super.key,
    required this.assetPath,
    required this.activeAssetPath,
    required this.isActive,
    required this.onTap,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド（UIを返す関数）

    final String pathToUse = isActive ? activeAssetPath : assetPath; // ✅ ローカル変数

    final Color iconColor =
        isActive // ✅ ローカル変数（※今は未使用）
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(217, 255, 255, 255);

    return GestureDetector(
      // ✅ GestureDetector インスタンス
      onTap: onTap, // ✅ インスタンス変数に渡されてきた関数を呼ぶ設定
      child: Container(
        padding: const EdgeInsets.all(6), // アイコンの周りの余白
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          child: SvgPicture.asset(
            // ✅ SVG画像Widgetのインスタンス
            pathToUse,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}

/// ④ ホーム画面
class HomePage extends StatelessWidget {
  // ✅ クラス定義
  final int percent; // ✅ インスタンス変数（表示用データ）
  final String imagePath; // ✅ インスタンス変数

  const HomePage({
    // ✅ コンストラクタ
    super.key,
    required this.percent,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド（UI用関数）
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          // ✅ Stack インスタンス
          children: [
            Column(
              // ✅ Column インスタンス
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 140),
                const Text(
                  // ✅ Text インスタンス
                  "達成度",
                  style: TextStyle(
                    fontSize: 55,
                    color: Color(0xD9006400),
                    fontFamily: 'Building',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // ✅ Text インスタンス
                  "$percent%",
                  style: const TextStyle(
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
                    child: Image.asset(imagePath), // ✅ Image.asset インスタンス
                  ),
                ),
              ],
            ),
            Positioned(
              // ✅ Positioned インスタンス
              top: 40,
              left: 28,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ホーム",
                    style: const TextStyle(
                      color: Color(0xD9006400),
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
                  Image.asset(
                    // ✅ Imageインスタンス
                    'assets/images/aikon.png',
                    width: 42,
                    height: 42,
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

/// ⑤ TodoPage
class TodoPage extends StatelessWidget {
  // ✅ クラス定義
  final List<Todo> todos; // ✅ インスタンス変数
  final void Function(int index, bool? value) onToggle; // ✅ インスタンス変数（関数型）

  const TodoPage({
    // ✅ コンストラクタ
    super.key,
    required this.todos,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        // ✅ AppBar インスタンス
        title: const Text('ToDoリスト'),
        backgroundColor: const Color(0xD9006400),
      ),
      body: ListView.builder(
        // ✅ ListView.builder インスタンス
        itemCount: todos.length,
        itemBuilder: (context, index) {
          // ✅ 無名関数（コールバック）
          final todo = todos[index]; // ✅ ローカル変数
          return CheckboxListTile(
            // ✅ CheckboxListTile インスタンス
            title: Text(todo.title),
            value: todo.isDone,
            onChanged: (v) => onToggle(index, v),
          );
        },
      ),
    );
  }
}

/// ⑥ 仮画面たち
class GroupPage extends StatelessWidget {
  // ✅ クラス定義
  const GroupPage({super.key}); // ✅ コンストラクタ

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド
    return const Scaffold(body: Center(child: Text('グループ画面（あとで実装）')));
  }
}

class InsightPage extends StatelessWidget {
  // ✅ クラス定義
  const InsightPage({super.key}); // ✅ コンストラクタ

  @override
  Widget build(BuildContext context) {
    // ✅ メソッド
    return const Scaffold(body: Center(child: Text('インサイト画面（あとで実装）')));
  }
}
