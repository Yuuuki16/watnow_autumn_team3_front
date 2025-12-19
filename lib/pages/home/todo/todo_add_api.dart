import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// 1. データモデル
// -----------------------------------------------------------------------------
class NewTaskInput {
  NewTaskInput({
    required this.title,
    this.deadline,
    this.expectedDate,
    this.repeat,
    this.day,
  });

  final String title;
  final DateTime? deadline;
  final DateTime? expectedDate;
  final String? repeat;
  final String? day; // 追加: 曜日ラベル（例: '月曜日'）
}

// -----------------------------------------------------------------------------
// 2. メイン画面：タスク一覧表示
// -----------------------------------------------------------------------------
class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<dynamic> _tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // 親で追加を受け取りローカル配列に保持する
  Future<void> _addLocalTask(NewTaskInput input) async {
    setState(() {
      _tasks.insert(0, {
        'title': input.title,
        'due_date': input.deadline?.toIso8601String(),
        'repeat': input.repeat,
        'category': '勉強',
      });
    });

    // 試しにバックエンドに POST する（失敗しても UI は保持される）
    final session = Supabase.instance.client.auth.currentSession;
    final jwt = session?.accessToken;
    if (jwt == null) return;

    try {
      await http.post(
        Uri.parse('http://localhost:8000/tasks/'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $jwt'},
        body: jsonEncode({
          'title': input.title,
          'due_date': input.deadline?.toUtc().toIso8601String(),
          'self_due_date': input.expectedDate?.toUtc().toIso8601String(),
          'priority': 1,
          'category': '勉強',
          'status': 'pending',
          'repeat': input.repeat,
        }),
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('バックエンド保存失敗: $e');
    }
  }

  // APIからタスク一覧を取得 (GET)
  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    final session = Supabase.instance.client.auth.currentSession;
    final jwt = session?.accessToken;

    // If no jwt available (dev env), populate with demo tasks instead of aborting
    if (jwt == null) {
      // provide demo fallback tasks so UI can be developed without backend
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _tasks = [
            {
              'title': 'デモ: レポートを書く',
              'due_date': DateTime.now().toIso8601String(),
              'repeat': null,
              'category': '勉強'
            },
            {
              'title': 'デモ: 30分勉強',
              'due_date': null,
              'repeat': '毎日',
              'category': '勉強'
            }
          ]);
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks/'),
        headers: {'Authorization': 'Bearer $jwt'},
      );

      if (response.statusCode == 200) {
        setState(() => _tasks = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint('❌ 一覧取得エラー: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0C6226);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('MY TASKS', style: TextStyle(fontFamily: 'Building', fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(onPressed: _fetchTasks, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _tasks.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) => _TaskCard(task: _tasks[index]),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TaskInputDialog(onSave: (input) => _addLocalTask(input)),
        ),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('追加する', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('タスクがありません', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. 一覧用のカードデザイン
// -----------------------------------------------------------------------------
class _TaskCard extends StatelessWidget {
  final dynamic task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final dueDateStr = task['due_date'] != null 
        ? task['due_date'].toString().substring(0, 10).replaceAll('-', '/') 
        : '期限なし';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.assignment_outlined, color: Color(0xFF0C6226)),
        ),
        title: Text(
          task['title'] ?? '無題のタスク',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1C3F2B)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(dueDateStr, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              if (task['repeat'] != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.repeat, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(task['repeat'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ]
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF0C6226).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(task['category'] ?? '勉強', style: const TextStyle(color: Color(0xFF0C6226), fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. 入力ダイアログ
// -----------------------------------------------------------------------------
class TaskInputDialog extends StatefulWidget {
  const TaskInputDialog({super.key, required this.onSave});
  final void Function(NewTaskInput input) onSave;

  @override
  State<TaskInputDialog> createState() => _TaskInputDialogState();
}

class _TaskInputDialogState extends State<TaskInputDialog> {
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _expectedController = TextEditingController();
  final _repeatController = TextEditingController();

  DateTime? _selectedDeadline;
  DateTime? _selectedExpected;

  void _handleSave() {
    if (_titleController.text.trim().isEmpty) return;
    final input = NewTaskInput(
      title: _titleController.text.trim(),
      deadline: _selectedDeadline,
      expectedDate: _selectedExpected,
      repeat: _repeatController.text.trim().isEmpty ? null : _repeatController.text.trim(),
      day: null,
    );
    Navigator.of(context).pop();
    // 親ウィジェットで保存・表示する
    widget.onSave(input);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0C6226);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('NEW TASK', style: TextStyle(fontFamily: 'Building', fontSize: 20, fontWeight: FontWeight.w900, color: primaryColor)),
              const SizedBox(height: 20),
              _buildInput('タスク名', _titleController, hint: '何に挑戦しますか？'),
              _buildDateInput('締め切り', _deadlineController, (date) => setState(() {
                _selectedDeadline = date;
                _deadlineController.text = "${date.year}/${date.month}/${date.day}";
              })),
              _buildDateInput('完了予定日', _expectedController, (date) => setState(() {
                _selectedExpected = date;
                _expectedController.text = "${date.year}/${date.month}/${date.day}";
              })),
              _buildInput('繰り返し', _repeatController, hint: '毎週 / 隔週 など'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('保存する', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0C6226), fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ]),
    );
  }

  Widget _buildDateInput(String label, TextEditingController controller, Function(DateTime) onPick) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
        if (d != null) onPick(d);
      },
      child: AbsorbPointer(child: _buildInput(label, controller, hint: '日付を選択')),
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';

// // --- 1. メイン画面のウィジェット ---
// class TodoListPage extends StatefulWidget {
//   const TodoListPage({super.key});

//   @override
//   State<TodoListPage> createState() => _TodoListPageState();
// }

// class _TodoListPageState extends State<TodoListPage> {
//   // APIを叩く関数：ダイアログの「保存」が押された後に実行される
//   Future<void> _addNewTask(NewTaskInput input) async {
//     // 【重要】保存ボタンが押された「後」に初めてJWTを取得しに行く
//     final session = Supabase.instance.client.auth.currentSession;
//     final jwt = session?.accessToken;

//     if (jwt == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('ログインセッションがありません。')),
//         );
//       }
//       return;
//     }

//     print('🚀 保存ボタンが押されました。通信を開始します: ${input.title}');

//     try {
//       // ⚠️ 環境に合わせてURLを書き換えてください
//       final url = Uri.parse('http://127.0.0.1:8000/tasks/');

//       final Map<String, dynamic> requestBody = {
//         "title": input.title,
//         "due_date": input.deadline?.toUtc().toIso8601String(),
//         "self_due_date": input.expectedDate?.toUtc().toIso8601String(),
//         "priority": 1, // 固定値（必要に応じてinputに追加）
//         "category": "勉強", // 固定値（必要に応じてinputに追加）
//         "status": "pending"
//       };

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $jwt',
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (mounted) {
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('タスクを追加しました！'), backgroundColor: Colors.green),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('エラー: ${response.statusCode}'), backgroundColor: Colors.red),
//           );
//         }
//       }
//     } catch (e) {
//       print('🛑 Error: $e');
//     }
//   }

//   void _showTaskInputDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => TaskInputDialog(
//         // ダイアログの「保存」ボタンが押された時の処理
//         onSave: (input) {
//           _addNewTask(input);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('タスク一覧'), backgroundColor: const Color(0xFF0C6226)),
//       body: const Center(child: Text('タスク一覧がここに表示されます')),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF0C6226),
//         onPressed: _showTaskInputDialog, // ここではダイアログを開くだけ
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

// // --- 2. データモデル ---
// class NewTaskInput {
//   NewTaskInput({
//     required this.dayLabel,
//     required this.title,
//     this.deadline,
//     this.expectedDate,
//     this.repeat,
//   });

//   final String dayLabel;
//   final String title;
//   final DateTime? deadline;
//   final DateTime? expectedDate;
//   final String? repeat;
// }

// // --- 3. UI：タスク入力ダイアログ（提供いただいたコードを適用） ---
// class TaskInputDialog extends StatefulWidget {
//   const TaskInputDialog({super.key, required this.onSave});

//   final void Function(NewTaskInput input) onSave;

//   @override
//   State<TaskInputDialog> createState() => _TaskInputDialogState();
// }

// class _TaskInputDialogState extends State<TaskInputDialog> {
//   final _titleController = TextEditingController();
//   final _deadlineController = TextEditingController();
//   final _expectedController = TextEditingController();
//   final _repeatController = TextEditingController();

//   DateTime? _selectedDeadline;
//   DateTime? _selectedExpected;

//   static const List<String> _weekdayLabels = [
//     '月曜日','火曜日','水曜日','木曜日','金曜日','土曜日','日曜日',
//   ];

//   late String _selectedDay;

//   static String _dayLabelFor(DateTime date) => _weekdayLabels[date.weekday - 1];

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _dayLabelFor(DateTime.now());
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _deadlineController.dispose();
//     _expectedController.dispose();
//     _repeatController.dispose();
//     super.dispose();
//   }

//   String _formatDate(DateTime date) {
//     final month = date.month.toString().padLeft(2, '0');
//     final day = date.day.toString().padLeft(2, '0');
//     return '${date.year}/$month/$day';
//   }

//   Future<void> _pickDate({
//     required DateTime initialDate,
//     required ValueChanged<DateTime> onSelected,
//   }) async {
//     final selected = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(DateTime.now().year + 5),
//     );
//     if (selected != null) onSelected(selected);
//   }

//   // ダイアログ内の保存ボタンから呼ばれる
//   void _handleSave() {
//     final title = _titleController.text.trim();
//     if (title.isEmpty) {
//       Navigator.of(context).pop();
//       return;
//     }

//     final daySource = _selectedExpected ?? _selectedDeadline;
//     final dayLabel = daySource != null ? _dayLabelFor(daySource) : _selectedDay;

//     // 親ウィジェットの _addNewTask を呼び出す
//     widget.onSave(
//       NewTaskInput(
//         dayLabel: dayLabel,
//         title: title,
//         deadline: _selectedDeadline,
//         expectedDate: _selectedExpected,
//         repeat: _repeatController.text.trim().isEmpty
//             ? null
//             : _repeatController.text.trim(),
//       ),
//     );

//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // --- デザイン設定 (省略せず提供されたものを適用) ---
//     const borderColor = Color(0xFF0C6226);
//     const labelColor = Color(0xFF0C6226);
//     const inputTextColor = Color(0xFF1C3F2B);
//     const hintColor = Color(0xFF789882);
//     const fieldRadius = 22.0;
//     const fontFamily = 'Building';

//     const labelStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: labelColor, fontFamily: fontFamily);
//     const fieldStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: inputTextColor, fontFamily: fontFamily);

//     return Dialog(
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(26),
//         side: const BorderSide(color: borderColor, width: 1.6),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _InputRow(label: 'タスク名', controller: _titleController, labelStyle: labelStyle, fieldStyle: fieldStyle, hintColor: hintColor, borderColor: borderColor, borderRadius: fieldRadius, hintText: 'タスク名を入力'),
//               _InputRow(
//                 label: '締め切り', 
//                 controller: _deadlineController, 
//                 labelStyle: labelStyle, 
//                 fieldStyle: fieldStyle, 
//                 hintColor: hintColor, 
//                 borderColor: borderColor, 
//                 borderRadius: fieldRadius, 
//                 hintText: 'YYYY/MM/DD', 
//                 readOnly: true, 
//                 onTap: () => _pickDate(initialDate: DateTime.now(), onSelected: (d) => setState(() { _selectedDeadline = d; _deadlineController.text = _formatDate(d); _selectedDay = _dayLabelFor(d); })),
//                 suffixIcon: const Icon(Icons.calendar_today, color: borderColor, size: 20)
//               ),
//               _InputRow(
//                 label: '完了予定日', 
//                 controller: _expectedController, 
//                 labelStyle: labelStyle, 
//                 fieldStyle: fieldStyle, 
//                 hintColor: hintColor, 
//                 borderColor: borderColor, 
//                 borderRadius: fieldRadius, 
//                 hintText: 'YYYY/MM/DD', 
//                 readOnly: true, 
//                 onTap: () => _pickDate(initialDate: DateTime.now(), onSelected: (d) => setState(() { _selectedExpected = d; _expectedController.text = _formatDate(d); _selectedDay = _dayLabelFor(d); })),
//                 suffixIcon: const Icon(Icons.calendar_today, color: borderColor, size: 20)
//               ),
//               Text('追加される曜日: $_selectedDay', style: labelStyle.copyWith(fontSize: 13)),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: 180,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: borderColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
//                   onPressed: _handleSave, // 保存ボタン！
//                   child: const Text('保存', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // 入力行のコンポーネント
// class _InputRow extends StatelessWidget {
//   const _InputRow({required this.label, required this.controller, required this.labelStyle, required this.fieldStyle, required this.hintColor, required this.borderColor, required this.borderRadius, this.hintText, this.readOnly = false, this.onTap, this.suffixIcon});
//   final String label;
//   final TextEditingController controller;
//   final TextStyle labelStyle;
//   final TextStyle fieldStyle;
//   final Color hintColor;
//   final Color borderColor;
//   final double borderRadius;
//   final String? hintText;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final Widget? suffixIcon;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(label, style: labelStyle),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           style: fieldStyle,
//           readOnly: readOnly,
//           onTap: onTap,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: fieldStyle.copyWith(color: hintColor),
//             suffixIcon: suffixIcon,
//             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor.withOpacity(0.7))),
//             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor)),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ⚠️ 環境に合わせてURLを確認してください（Androidエミュレータなら 10.0.2.2）
// // final url = Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks');



// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // // 1. データモデル
// // class NewTaskInput {
// //   final String dayLabel;
// //   final String title;
// //   final DateTime? deadline;
// //   final DateTime? expectedDate;
// //   final String? repeat;

// //   NewTaskInput({
// //     required this.dayLabel,
// //     required this.title,
// //     this.deadline,
// //     this.expectedDate,
// //     this.repeat,
// //   });
// // }

// // // 2. 通信ロジック（ここが重複していたはずです。1つに絞ります）
// // Future<void> _addNewTask(NewTaskInput input, BuildContext context) async {
// //   print('🚀 [API] タスク追加リクエストを開始します...');

// //   final session = Supabase.instance.client.auth.currentSession;
// //   final jwt = session?.accessToken;

// //   if (jwt == null) {
// //     print('❌ [API] エラー: JWTが取得できません。');
// //     if (context.mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('ログインセッションがありません。')),
// //       );
// //     }
// //     return;
// //   }

// //   try {
// //     final url = Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks');

// //     final Map<String, dynamic> requestBody = {
// //       "title": input.title,
// //       // .toUtc().toIso8601String() で "2024-12-20T00:00:00Z" 形式にする
// //       "due_date": input.deadline?.toUtc().toIso8601String(),
// //       "self_due_date": input.expectedDate?.toUtc().toIso8601String(),
// //       "priority": 1,
// //       "category": "勉強",
// //       "status": "pending"
// //     };

// //     print('📡 [API] 送信データ: ${jsonEncode(requestBody)}');

// //     final response = await http.post(
// //       url,
// //       headers: {
// //         'Content-Type': 'application/json',
// //         'Authorization': 'Bearer $jwt',
// //       },
// //       body: jsonEncode(requestBody),
// //     );

// //     print('📩 [API] ステータス: ${response.statusCode}');
// //     print('📄 [API] ボディ: ${response.body}');

// //     if (context.mounted) {
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('タスクを追加しました！'), backgroundColor: Colors.green),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('エラー: ${response.statusCode}'), backgroundColor: Colors.red),
// //         );
// //       }
// //     }
// //   } catch (e) {
// //     print('🛑 [API] 通信例外: $e');
// //   }
// // }

// // // 3. UI：タスク入力ダイアログ
// // class TaskInputDialog extends StatefulWidget {
// //   final void Function(NewTaskInput input) onSave;
// //   const TaskInputDialog({super.key, required this.onSave});

// //   @override
// //   State<TaskInputDialog> createState() => _TaskInputDialogState();
// // }

// // class _TaskInputDialogState extends State<TaskInputDialog> {
// //   final _titleController = TextEditingController();
// //   final _deadlineController = TextEditingController();
// //   final _expectedController = TextEditingController();
// //   final _repeatController = TextEditingController();

// //   DateTime? _selectedDeadline;
// //   DateTime? _selectedExpected;
// //   String _selectedDay = '未設定';

// //   static const List<String> _weekdayLabels = ['月曜日','火曜日','水曜日','木曜日','金曜日','土曜日','日曜日'];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _selectedDay = _weekdayLabels[DateTime.now().weekday - 1];
// //   }

// //   @override
// //   void dispose() {
// //     _titleController.dispose();
// //     _deadlineController.dispose();
// //     _expectedController.dispose();
// //     _repeatController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _pickDate(bool isDeadline) async {
// //     final selected = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2024),
// //       lastDate: DateTime(2030),
// //     );

// //     if (selected != null) {
// //       setState(() {
// //         final formatted = "${selected.year}/${selected.month.toString().padLeft(2,'0')}/${selected.day.toString().padLeft(2,'0')}";
// //         if (isDeadline) {
// //           _selectedDeadline = selected;
// //           _deadlineController.text = formatted;
// //         } else {
// //           _selectedExpected = selected;
// //           _expectedController.text = formatted;
// //         }
// //         _selectedDay = _weekdayLabels[selected.weekday - 1];
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     const primary = Color(0xFF0C6226);

// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Text('新規タスク', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
// //             const SizedBox(height: 16),
// //             TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'タスク名')),
// //             TextField(
// //               controller: _deadlineController,
// //               readOnly: true,
// //               onTap: () => _pickDate(true),
// //               decoration: const InputDecoration(labelText: '締め切り', suffixIcon: Icon(Icons.calendar_today)),
// //             ),
// //             TextField(
// //               controller: _expectedController,
// //               readOnly: true,
// //               onTap: () => _pickDate(false),
// //               decoration: const InputDecoration(labelText: '完了予定日', suffixIcon: Icon(Icons.calendar_today)),
// //             ),
// //             const SizedBox(height: 8),
// //             Align(alignment: Alignment.centerLeft, child: Text('追加される曜日: $_selectedDay', style: const TextStyle(fontSize: 12, color: Colors.grey))),
// //             TextField(controller: _repeatController, decoration: const InputDecoration(labelText: '繰り返し')),
// //             const SizedBox(height: 24),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
// //               onPressed: () {
// //                 if (_titleController.text.isNotEmpty) {
// //                   widget.onSave(NewTaskInput(
// //                     dayLabel: _selectedDay,
// //                     title: _titleController.text,
// //                     deadline: _selectedDeadline,
// //                     expectedDate: _selectedExpected,
// //                     repeat: _repeatController.text,
// //                   ));
// //                   Navigator.pop(context);
// //                 }
// //               },
// //               child: const Text('保存'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // 4. ダイアログ表示関数
// // void showTaskInputDialog(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (context) => TaskInputDialog(
// //       onSave: (input) => _addNewTask(input, context),
// //     ),
// //   );
// // }


// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:supabase_flutter/supabase_flutter.dart';

// // // // ----------------------------------------------------------------------
// // // // 1. データモデル：入力されたタスク情報をまとめるクラス
// // // // ----------------------------------------------------------------------
// // // class NewTaskInput {
// // //   final String dayLabel;
// // //   final String title;
// // //   final DateTime? deadline;
// // //   final DateTime? expectedDate;
// // //   final String? repeat;

// // //   NewTaskInput({
// // //     required this.dayLabel,
// // //     required this.title,
// // //     this.deadline,
// // //     this.expectedDate,
// // //     this.repeat,
// // //   });
// // // }

// // // // ----------------------------------------------------------------------
// // // // 2. 通信ロジック：自作APIサーバーにタスクをPOSTする
// // // // ----------------------------------------------------------------------
// // // Future<void> _addNewTask(NewTaskInput input, BuildContext context) async {
// // //   // Supabaseから最新のJWT（トークン）を取得
// // //   final session = Supabase.instance.client.auth.currentSession;
// // //   final jwt = session?.accessToken;

// // //   if (jwt == null) {
// // //     if (context.mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('ログインセッションがありません。再ログインしてください。')),
// // //       );
// // //     }
// // //     return;
// // //   }

// // //   try {
// // //     // 外部サーバー（Render）のエンドポイント
// // //     final url = Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks');

// // //     // JSONデータをPOST送信
// // //     final response = await http.post(
// // //       url,
// // //       headers: {
// // //         'Content-Type': 'application/json',
// // //         'Authorization': 'Bearer $jwt', // JWTをヘッダーにセット
// // //       },
// // //       body: jsonEncode({
// // //         "title": input.title,
// // //         "due_date": input.deadline?.toIso8601String(), // 締め切り
// // //         "self_due_date": input.expectedDate?.toIso8601String(), // 完了予定日
// // //         "priority": 1,
// // //         "category": "study",
// // //         "status": "pending",
// // //         "repeat": input.repeat,
// // //       }),
// // //     );

// // //     if (context.mounted) {
// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         print('タスク作成成功: ${response.body}');
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('タスクを追加しました！'), backgroundColor: Colors.green),
// // //         );
// // //       } else {
// // //         print('作成失敗: ${response.statusCode} / ${response.body}');
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text('エラー: ${response.statusCode}'), backgroundColor: Colors.red),
// // //         );
// // //       }
// // //     }
// // //   } catch (e) {
// // //     print('通信エラー: $e');
// // //     if (context.mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('通信に失敗しました: $e'), backgroundColor: Colors.red),
// // //       );
// // //     }
// // //   }
// // // }

// // // // ----------------------------------------------------------------------
// // // // 3. UI：タスク入力ダイアログ
// // // // ----------------------------------------------------------------------
// // // class TaskInputDialog extends StatefulWidget {
// // //   final void Function(NewTaskInput input) onSave;
// // //   const TaskInputDialog({super.key, required this.onSave});

// // //   @override
// // //   State<TaskInputDialog> createState() => _TaskInputDialogState();
// // // }

// // // class _TaskInputDialogState extends State<TaskInputDialog> {
// // //   final _titleController = TextEditingController();
// // //   final _deadlineController = TextEditingController();
// // //   final _expectedController = TextEditingController();
// // //   final _repeatController = TextEditingController();

// // //   DateTime? _selectedDeadline;
// // //   DateTime? _selectedExpected;
// // //   String _selectedDay = '未設定';

// // //   static const List<String> _weekdayLabels = ['月曜日','火曜日','水曜日','木曜日','金曜日','土曜日','日曜日'];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _selectedDay = _weekdayLabels[DateTime.now().weekday - 1];
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _titleController.dispose();
// // //     _deadlineController.dispose();
// // //     _expectedController.dispose();
// // //     _repeatController.dispose();
// // //     super.dispose();
// // //   }

// // //   // 日付選択カレンダーを表示
// // //   Future<void> _pickDate(bool isDeadline) async {
// // //     final selected = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime(2024),
// // //       lastDate: DateTime(2030),
// // //     );

// // //     if (selected != null) {
// // //       setState(() {
// // //         final formatted = "${selected.year}/${selected.month.toString().padLeft(2,'0')}/${selected.day.toString().padLeft(2,'0')}";
// // //         if (isDeadline) {
// // //           _selectedDeadline = selected;
// // //           _deadlineController.text = formatted;
// // //         } else {
// // //           _selectedExpected = selected;
// // //           _expectedController.text = formatted;
// // //         }
// // //         _selectedDay = _weekdayLabels[selected.weekday - 1];
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     const primary = Color(0xFF0C6226);

// // //     return Dialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(20),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             const Text('新規タスク', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
// // //             const SizedBox(height: 16),
// // //             TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'タスク名')),
// // //             TextField(
// // //               controller: _deadlineController,
// // //               readOnly: true,
// // //               onTap: () => _pickDate(true),
// // //               decoration: const InputDecoration(labelText: '締め切り', suffixIcon: Icon(Icons.calendar_today)),
// // //             ),
// // //             TextField(
// // //               controller: _expectedController,
// // //               readOnly: true,
// // //               onTap: () => _pickDate(false),
// // //               decoration: const InputDecoration(labelText: '完了予定日', suffixIcon: Icon(Icons.calendar_today)),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             Align(alignment: Alignment.centerLeft, child: Text('追加される曜日: $_selectedDay', style: const TextStyle(fontSize: 12, color: Colors.grey))),
// // //             TextField(controller: _repeatController, decoration: const InputDecoration(labelText: '繰り返し (例: 毎週)')),
// // //             const SizedBox(height: 24),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
// // //               onPressed: () {
// // //                 if (_titleController.text.isNotEmpty) {
// // //                   widget.onSave(NewTaskInput(
// // //                     dayLabel: _selectedDay,
// // //                     title: _titleController.text,
// // //                     deadline: _selectedDeadline,
// // //                     expectedDate: _selectedExpected,
// // //                     repeat: _repeatController.text,
// // //                   ));
// // //                   Navigator.pop(context);
// // //                 }
// // //               },
// // //               child: const Text('保存'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ----------------------------------------------------------------------
// // // // 4. エントリポイント：ダイアログを表示する関数
// // // // ----------------------------------------------------------------------
// // // void showTaskInputDialog(BuildContext context) {
// // //   showDialog(
// // //     context: context,
// // //     builder: (context) => TaskInputDialog(
// // //       onSave: (input) => _addNewTask(input, context),
// // //     ),
// // //   );
// // // }

// // // import 'package:flutter/material.dart';
// // // import 'todo_add_page.dart';
// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import 'package:supabase_flutter/supabase_flutter.dart';

// // // // --- 1. タスク追加を行う関数 (整理後) ---
// // // // 重複していたものを1つにまとめ、BuildContextを受け取るようにしました
// // // Future<void> _addNewTask(NewTaskInput input, BuildContext context) async {
// // //   final session = Supabase.instance.client.auth.currentSession;
// // //   final jwt = session?.accessToken;

// // //   if (jwt == null) {
// // //     if (context.mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('ログインセッションがありません。ログインし直してください。'))
// // //       );
// // //     }
// // //     return;
// // //   }

// // //   try {
// // //     final url = Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks');

// // //     final response = await http.post(
// // //       url,
// // //       headers: {
// // //         'Content-Type': 'application/json',
// // //         'Authorization': 'Bearer $jwt',
// // //       },
// // //       body: jsonEncode({
// // //         "title": input.title,
// // //         "due_date": input.deadline?.toIso8601String(),
// // //         "self_due_date": input.expectedDate?.toIso8601String(),
// // //         "priority": 1,
// // //         "category": "study",
// // //         "status": "pending",
// // //         "repeat": input.repeat,
// // //       }),
// // //     );

// // //     if (context.mounted) {
// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         final createdTask = jsonDecode(response.body);
// // //         print('タスク作成成功: $createdTask');
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('タスクを追加しました！'))
// // //         );
// // //       } else {
// // //         print('作成失敗: ${response.statusCode} / ${response.body}');
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text('エラーが発生しました: ${response.statusCode}'))
// // //         );
// // //       }
// // //     }
// // //   } catch (e) {
// // //     print('通信エラーが発生しました: $e');
// // //     if (context.mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('通信に失敗しました: $e'))
// // //       );
// // //     }
// // //   }
// // // }

// // // // --- 2. 入力ダイアログを表示する関数 (整理後) ---
// // // // こちらも重複を削除し、一つにまとめました
// // // void _showTaskInputDialog(BuildContext context) { 
// // //   showDialog(
// // //     context: context,
// // //     builder: (dialogContext) => TaskInputDialog(
// // //       onSave: (NewTaskInput input) {
// // //         _addNewTask(input, context); // addNewTaskを呼び出す
// // //       },
// // //     ),
// // //   );
// // // }

// // // import 'package:flutter/material.dart';
// // // import 'todo_add_page.dart';
// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import 'package:supabase_flutter/supabase_flutter.dart';

// // // // ... 中略 ...

// // // Future<void> _addNewTask(NewTaskInput input) async {
// // //   // 1. Supabaseから最新のJWT（トークン）を取得
// // //   final session = Supabase.instance.client.auth.currentSession;
// // //   final jwt = session?.accessToken;

// // //   if (jwt == null) {
// // //     print("ログインセッションがありません");
// // //     return;
// // //   }

// // //   try {
// // //     // 2. APIエンドポイントの設定（ローカルサーバーの場合）
// // //     // Androidシミュレータの場合は 10.0.2.2、実機の場合はPCのIPアドレスに書き換えてください
// // //     final url = Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks');

// // //     // 3. POSTリクエストの送信
// // //     final response = await http.post(
// // //       url,
// // //       headers: {
// // //         'Content-Type': 'application/json',
// // //         'Authorization': 'Bearer $jwt', // JWTをヘッダーにセット
// // //       },
// // //       body: jsonEncode({
// // //         "title": input.title,
// // //         "due_date": input.deadline?.toIso8601String(), // 締め切り
// // //         "self_due_date": input.expectedDate?.toIso8601String(), // 完了予定日
// // //         "priority": 1, // デフォルト値
// // //         "category": "study", // デフォルト値
// // //         "status": "pending", // デフォルト値
// // //         "repeat": input.repeat, // 繰り返し設定
// // //       }),
// // //     );

// // //     if (response.statusCode == 200 || response.statusCode == 201) {
// // //       final createdTask = jsonDecode(response.body);
// // //       print('タスク作成成功: $createdTask');
      
// // //       // 成功したら画面を更新する処理をここに書く
// // //     } else {
// // //       print('作成失敗: ${response.statusCode} / ${response.body}');
// // //     }
// // //   } catch (e) {
// // //     print('通信エラーが発生しました: $e');
// // //   }
// // // }

// // // // 修正前: void _showTaskInputDialog() {
// // // // 修正後: 引数に BuildContext context を追加します
// // // void _showTaskInputDialog(BuildContext context) { 
// // //   showDialog(
// // //     context: context, // ここで使うために引数が必要
// // //     builder: (context) => TaskInputDialog(
// // //       onSave: (NewTaskInput input) {
// // //         _addNewTask(input);
// // //       },
// // //     ),
// // //   );
// // // }
// // // // _addNewTask に BuildContext を渡せるように修正
// // // Future<void> _addNewTask(NewTaskInput input, BuildContext context) async {
// // //   final session = Supabase.instance.client.auth.currentSession;
// // //   final jwt = session?.accessToken;

// // //   if (jwt == null) {
// // //     if (context.mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ログインが必要です')));
// // //     }
// // //     return;
// // //   }

// // //   try {
// // //     final url = Uri.parse('https://watnow-team3-backend-2025.onrender.com/tasks');
// // //     final response = await http.post(
// // //       url,
// // //       headers: {
// // //         'Content-Type': 'application/json',
// // //         'Authorization': 'Bearer $jwt',
// // //       },
// // //       body: jsonEncode({
// // //         "title": input.title,
// // //         "due_date": input.deadline?.toIso8601String(),
// // //         "self_due_date": input.expectedDate?.toIso8601String(),
// // //         "priority": 1,
// // //         "category": "study",
// // //         "status": "pending",
// // //         "repeat": input.repeat,
// // //       }),
// // //     );

// // //     if (context.mounted) {
// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('タスクを追加しました！')));
// // //       } else {
// // //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('エラー: ${response.statusCode}')));
// // //       }
// // //     }
// // //   } catch (e) {
// // //     if (context.mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('通信に失敗しました: $e')));
// // //     }
// // //   }
// // // }
