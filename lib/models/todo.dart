import 'package:flutter/material.dart';

// --- 1. データモデルの定義 ---
class Todo {
  final String title;
  bool isDone;
  String day;

  Todo({required this.title, required this.isDone, required this.day});
}

void main() {
  runApp(const MyApp());
}

// --- 2. アプリ全体の基本設定 ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBFBF5),
        fontFamily: 'sans-serif',
      ),
      home: const WeeklyTaskScreen(),
    );
  }
}

// --- 3. メイン画面の定義 (StatefulWidget) ---
class WeeklyTaskScreen extends StatefulWidget {
  const WeeklyTaskScreen({super.key});

  @override
  State<WeeklyTaskScreen> createState() => _WeeklyTaskScreenState();
}

// --- 4. 画面の状態と動きを管理するクラス ---
class _WeeklyTaskScreenState extends State<WeeklyTaskScreen> {
  // タスクのデータリスト
  final List<Todo> _tasks = [
    Todo(title: '英語SW 課題', isDone: true, day: '月曜日'),
    Todo(title: '経済学入門', isDone: true, day: '火曜日'),
    Todo(title: '数学の宿題', isDone: false, day: '水曜日'),
  ];

  final TextEditingController _controller = TextEditingController();
  String _selectedDay = '月曜日';
  final List<String> _daysList = ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日'];

  // チェック切り替え
  void _toggleTask(Todo task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  // タスク削除
  void _deleteTask(Todo task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  // タスク追加ダイアログ
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('新しいタスクを追加'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "タスク名を入力"),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedDay,
                    isExpanded: true,
                    items: _daysList.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setDialogState(() {
                        _selectedDay = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _tasks.add(Todo(
                          title: _controller.text,
                          isDone: false,
                          day: _selectedDay,
                        ));
                      });
                      _controller.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('追加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 削除確認ダイアログ
  void _showDeleteDialog(Todo task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクの削除'),
        content: Text('「${task.title}」を削除しますか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          TextButton(
            onPressed: () {
              _deleteTask(task);
              Navigator.pop(context);
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: _daysList.map((day) {
                  final dayTasks = _tasks.where((t) => t.day == day).toList();
                  return _buildDaySection(day, dayTasks);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('今週のタスク',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF386641))),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showAddTaskDialog,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: const Color(0xFF386641), borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
          const CircleAvatar(radius: 24, child: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _buildDaySection(String day, List<Todo> tasks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFC0C0C0))),
          const SizedBox(height: 8),
          if (tasks.isEmpty)
            const Text('タスクなし', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ...tasks.map((task) => GestureDetector(
            onTap: () => _toggleTask(task),
            onLongPress: () => _showDeleteDialog(task),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    task.isDone ? Icons.check_circle : Icons.check_circle_outline,
                    color: task.isDone ? const Color(0xFF386641) : const Color(0xFFD0D0D0),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                      color: task.isDone ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
