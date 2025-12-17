import 'package:flutter/material.dart';
import 'package:watnow_autumn_team3_front/models/todo_popup.dart';

class Todo {
  final String title;
  bool isDone;

  Todo(this.title, {this.isDone = false});
}
//

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBFBF5), // 背景色を再現
        fontFamily: 'sans-serif',
      ),
      home: const WeeklyTaskScreen(),
    );
  }
}

class WeeklyTaskScreen extends StatelessWidget {
  const WeeklyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー部分
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '今週のタスク',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF386641), // 深い緑
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF386641),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),

            // タスクリスト部分
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildDaySection('月曜日', [
                    _TaskItem(title: '英語SW 課題', isCompleted: true),
                  ]),
                  _buildDaySection('火曜日', [
                    _TaskItem(title: '経済学入門', isCompleted: true),
                    _TaskItem(title: '', isCompleted: false),
                  ]),
                  _buildDaySection('水曜日', [
                    _TaskItem(title: '', isCompleted: false),
                    _TaskItem(title: '', isCompleted: false),
                    _TaskItem(title: '', isCompleted: false),
                  ]),
                  _buildDaySection('木曜日', [
                    _TaskItem(title: '', isCompleted: false),
                  ]),
                  _buildDaySection('金曜日', []),
                  _buildDaySection('土曜日', [
                    _TaskItem(title: '', isCompleted: false),
                  ]),
                  _buildDaySection('日曜日', []),
                ],
              ),
            ),

            // ボトムナビゲーションバー
            // _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // 曜日ごとのセクション
  Widget _buildDaySection(String day, List<_TaskItem> tasks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC0C0C0), // 薄いグレー
            ),
          ),
          const SizedBox(height: 8),
          ...tasks.map((task) => Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                // タスク名をタップしたら編集画面を開く
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const TaskEditScreen(),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      task.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                      color: task.isCompleted ? const Color(0xFF386641) : const Color(0xFFD0D0D0),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })).toList(),
        ],
      ),
    );
  }

  // // カスタムボトムナビゲーションバー
  // Widget _buildBottomNav() {
  //   return Container(
  //     height: 80,
  //     decoration: const BoxDecoration(
  //       color: Color(0xFF6A994E), // 画像の緑色
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _navIcon(Icons.people_outline),
  //         _navIcon(Icons.home_outlined),
  //         _navIcon(Icons.list_alt, isSelected: true),
  //         _navIcon(Icons.thermostat_outlined),
  //       ],
  //     ),
  //   );
  // }

  Widget _navIcon(IconData icon, {bool isSelected = false}) {
    return Icon(
      icon,
      color: Colors.white,
      size: 32,
    );
  }
}

// タスクのデータモデル
class _TaskItem {
  final String title;
  final bool isCompleted;

  _TaskItem({required this.title, required this.isCompleted});
}