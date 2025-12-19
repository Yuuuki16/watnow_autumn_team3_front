

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. データモデル
class NewTaskInput {
  NewTaskInput({
    required this.dayLabel,
    required this.title,
    this.deadline,
    this.expectedDate,
    this.repeat,
  });

  final String dayLabel;
  final String title;
  final DateTime? deadline;
  final DateTime? expectedDate;
  final String? repeat;
}

// 2. ダイアログ・ウィジェット
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
  late String _selectedDay;

  static const List<String> _weekdayLabels = [
    '月曜日','火曜日','水曜日','木曜日','金曜日','土曜日','日曜日',
  ];

  static String _dayLabelFor(DateTime date) => _weekdayLabels[date.weekday - 1];

  @override
  void initState() {
    super.initState();
    _selectedDay = _dayLabelFor(DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
    _expectedController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  // --- デバッグ機能付き保存ロジック ---
  Future<void> _saveToDatabase(NewTaskInput input) async {
    print('🛠️ [DEBUG] 保存プロセス開始...');

    // 1. JWT取得デバッグ
    final session = Supabase.instance.client.auth.currentSession;
    final jwt = session?.accessToken;

    if (jwt == null) {
      print('❌ [DEBUG] JWTがnullです。ログインしていないかセッションが切れています。');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログインセッションが見つかりません')),
        );
      }
      return;
    }
    print('✅ [DEBUG] JWT取得成功 (先頭10文字): ${jwt.substring(0, 10)}...');

    try {
      // URL設定（環境に合わせて切り替えやすいように変数化）
      const String baseUrl = 'http://localhost:8000'; 
      final url = Uri.parse('$baseUrl/tasks/');

      // 2. リクエストボディのデバッグ
      final Map<String, dynamic> requestBody = {
        "title": input.title,
        "due_date": input.deadline?.toUtc().toIso8601String(),
        "self_due_date": input.expectedDate?.toUtc().toIso8601String(),
        "priority": 1,
        "category": "勉強",
        "status": "pending",
        "repeat": input.repeat,
      };

      print('📡 [DEBUG] 送信先: $url');
      print('📦 [DEBUG] 送信データ: ${jsonEncode(requestBody)}');

      // 3. 通信実行
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 10)); // タイムアウト追加

      // 4. レスポンスデバッグ
      print('📥 [DEBUG] レスポンス状況コード: ${response.statusCode}');
      print('📄 [DEBUG] レスポンスボディ: ${response.body}');

      if (mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('🎉 [DEBUG] 保存成功！');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('タスクを保存しました！'), backgroundColor: Colors.green),
          );
          widget.onSave(input);
        } else if (response.statusCode == 401) {
          print('⚠️ [DEBUG] 401認証エラー: バックエンドのSECRETとSupabaseのJWT Secretが一致しているか確認してください。');
          _showErrorSnackBar('認証に失敗しました(401)');
        } else {
          _showErrorSnackBar('サーバーエラー (${response.statusCode})');
        }
      }
    } catch (e) {
      print('🛑 [DEBUG] 通信中に例外発生: $e');
      if (e.toString().contains('Connection refused')) {
        print('💡 ヒント: バックエンドサーバーが起動していないか、IPアドレス(10.0.2.2)が間違っている可能性があります。');
      }
      if (mounted) _showErrorSnackBar('通信エラーが発生しました');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _handleSave() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      print('ℹ️ [DEBUG] タイトルが空のため保存を中止しました');
      Navigator.of(context).pop();
      return;
    }

    final input = NewTaskInput(
      dayLabel: (_selectedExpected != null || _selectedDeadline != null)
          ? _dayLabelFor(_selectedExpected ?? _selectedDeadline!)
          : _selectedDay,
      title: title,
      deadline: _selectedDeadline,
      expectedDate: _selectedExpected,
      repeat: _repeatController.text.trim().isEmpty ? null : _repeatController.text.trim(),
    );

    Navigator.of(context).pop();
    await _saveToDatabase(input);
  }

  // --- UI補助メソッド (変更なし) ---
  String _formatDate(DateTime date) => '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate({required DateTime initialDate, required ValueChanged<DateTime> onSelected}) async {
    final selected = await showDatePicker(context: context, initialDate: initialDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (selected != null) onSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF0C6226);
    const labelColor = Color(0xFF0C6226);
    const inputTextColor = Color(0xFF1C3F2B);
    const hintColor = Color(0xFF789882);
    const fieldRadius = 22.0;
    const fontFamily = 'Building';

    const labelStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: labelColor, fontFamily: fontFamily, letterSpacing: 0.5);
    const fieldStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: inputTextColor, fontFamily: fontFamily, letterSpacing: 0.3);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26), side: const BorderSide(color: borderColor, width: 1.6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InputRow(label: 'タスク名', controller: _titleController, labelStyle: labelStyle, fieldStyle: fieldStyle, hintColor: hintColor, borderColor: borderColor, borderRadius: fieldRadius, hintText: 'タスク名を入力'),
              _InputRow(label: '締め切り', controller: _deadlineController, labelStyle: labelStyle, fieldStyle: fieldStyle, hintColor: hintColor, borderColor: borderColor, borderRadius: fieldRadius, hintText: 'YYYY/MM/DD', readOnly: true, onTap: () => _pickDate(initialDate: DateTime.now(), onSelected: (date) => setState(() { _selectedDeadline = date; _deadlineController.text = _formatDate(date); _selectedDay = _dayLabelFor(date); })), suffixIcon: const Icon(Icons.calendar_today, color: borderColor, size: 20)),
              _InputRow(label: '完了予定日', controller: _expectedController, labelStyle: labelStyle, fieldStyle: fieldStyle, hintColor: hintColor, borderColor: borderColor, borderRadius: fieldRadius, hintText: 'YYYY/MM/DD', readOnly: true, onTap: () => _pickDate(initialDate: DateTime.now(), onSelected: (date) => setState(() { _selectedExpected = date; _expectedController.text = _formatDate(date); _selectedDay = _dayLabelFor(date); })), suffixIcon: const Icon(Icons.calendar_today, color: borderColor, size: 20)),
              Padding(padding: const EdgeInsets.only(left: 2, bottom: 6), child: Align(alignment: Alignment.centerLeft, child: Text('追加される曜日: $_selectedDay', style: labelStyle.copyWith(fontSize: 13)))),
              _InputRow(label: '繰り返し', controller: _repeatController, labelStyle: labelStyle, fieldStyle: fieldStyle, hintColor: hintColor, borderColor: borderColor, borderRadius: fieldRadius, hintText: '毎週 / 隔週 など'),
              const SizedBox(height: 16),
              SizedBox(width: 180, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: borderColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)), padding: const EdgeInsets.symmetric(vertical: 12), elevation: 0), onPressed: _handleSave, child: const Text('保存', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 2, fontFamily: fontFamily)))),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({required this.label, required this.controller, required this.labelStyle, required this.fieldStyle, required this.hintColor, required this.borderColor, required this.borderRadius, this.hintText, this.readOnly = false, this.onTap, this.suffixIcon});
  final String label; final TextEditingController controller; final TextStyle labelStyle; final TextStyle fieldStyle; final Color hintColor; final Color borderColor; final double borderRadius; final String? hintText; final bool readOnly; final VoidCallback? onTap; final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 6),
        TextField(controller: controller, style: fieldStyle, readOnly: readOnly, onTap: onTap, decoration: InputDecoration(hintText: hintText, hintStyle: fieldStyle.copyWith(color: hintColor), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), suffixIcon: suffixIcon, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor.withOpacity(0.7), width: 1.5)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor, width: 1.8)))),
      ]),
    );
  }
}

