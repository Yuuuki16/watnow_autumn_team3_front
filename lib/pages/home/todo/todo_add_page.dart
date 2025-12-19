import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// 1. データモデル
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

  /// UI上は「リマインダー」を選んでいるが、
  /// 既存のフィールド名に合わせて repeat に入れている
  /// - expected_only / deadline_only / both / null(=none)
  final String? repeat;
}

/// 2. ダイアログ・ウィジェット
class TaskInputDialog extends StatefulWidget {
  const TaskInputDialog({
    super.key,
    required this.onSave,
    this.initialInput,
    this.onDelete,
  });

  final void Function(NewTaskInput input) onSave;
  final NewTaskInput? initialInput;
  final VoidCallback? onDelete;

  @override
  State<TaskInputDialog> createState() => _TaskInputDialogState();
}

class _TaskInputDialogState extends State<TaskInputDialog> {
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _expectedController = TextEditingController();
  final _reminderController = TextEditingController();

  DateTime? _selectedDeadline;
  DateTime? _selectedExpected;

  bool _isExpectedUndecided = false;

  /// - expected_only / deadline_only / both / null(=none)
  String? _selectedReminder;

  late String _selectedDay;
  late final bool _isEditing = widget.initialInput != null;

  static const List<String> _weekdayLabels = [
    '月曜日',
    '火曜日',
    '水曜日',
    '木曜日',
    '金曜日',
    '土曜日',
    '日曜日',
  ];

  static const List<Map<String, String>> _reminderOptions = [
    {'value': 'expected_only', 'label': '完了予定日だけ'},
    {'value': 'deadline_only', 'label': '締め切り日だけ'},
    {'value': 'both', 'label': '両方'},
    {'value': 'none', 'label': '設定しない'},
  ];

  static String _dayLabelFor(DateTime date) => _weekdayLabels[date.weekday - 1];

  @override
  void initState() {
    super.initState();

    final initial = widget.initialInput;

    _selectedDay = initial?.dayLabel ?? _dayLabelFor(DateTime.now());

    if (initial != null) {
      _titleController.text = initial.title;

      if (initial.deadline != null) {
        _selectedDeadline = initial.deadline;
        _deadlineController.text = _formatDate(initial.deadline!);
      }

      if (initial.expectedDate != null) {
        _selectedExpected = initial.expectedDate;
        _expectedController.text = _formatDate(initial.expectedDate!);
      } else {
        _isExpectedUndecided = true;
        _expectedController.text = '未定';
      }

      _selectedReminder = initial.repeat;
      _reminderController.text = _labelForReminder(initial.repeat);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
    _expectedController.dispose();
    _reminderController.dispose();
    super.dispose();
  }

  // =========================
  // UI補助
  // =========================

  String _formatDate(DateTime date) =>
      '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

  String _labelForReminder(String? value) {
    if (value == null) return '';
    final option = _reminderOptions.firstWhere(
      (element) => element['value'] == value,
      orElse: () => const {'value': '', 'label': ''},
    );
    return option['label'] ?? '';
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (selected != null) onSelected(selected);
  }

  void _onDeadlineTap() {
    _pickDate(
      initialDate: _selectedDeadline ?? DateTime.now(),
      onSelected: (date) {
        setState(() {
          _selectedDeadline = date;
          _deadlineController.text = _formatDate(date);
          _selectedDay = _dayLabelFor(date);
        });
      },
    );
  }

  void _onExpectedTap() {
    setState(() {
      _isExpectedUndecided = false;
    });

    _pickDate(
      initialDate: _selectedExpected ?? _selectedDeadline ?? DateTime.now(),
      onSelected: (date) {
        setState(() {
          _selectedExpected = date;
          _expectedController.text = _formatDate(date);
          _selectedDay = _dayLabelFor(date);
        });
      },
    );
  }

  void _setExpectedUndecided() {
    setState(() {
      _isExpectedUndecided = true;
      _selectedExpected = null;
      _expectedController.text = '未定';
    });
  }

  Future<void> _selectReminder() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: _reminderOptions.map((option) {
            return ListTile(
              title: Text(
                option['label']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C3F2B),
                  fontFamily: 'Building',
                ),
              ),
              onTap: () => Navigator.of(context).pop(option['value']),
            );
          }).toList(),
        );
      },
    );

    if (selected == null) return;

    final selectedLabel = _reminderOptions
        .firstWhere((element) => element['value'] == selected)['label'];

    setState(() {
      _selectedReminder = selected == 'none' ? null : selected;
      _reminderController.text = selectedLabel ?? '';
    });
  }

  void _handleDelete() {
    widget.onDelete?.call();
    Navigator.of(context).pop();
  }

  // =========================
  // 保存（JWT + POST）
  // =========================

  Future<void> _saveToDatabase(NewTaskInput input) async {
    print('🛠️ [DEBUG] 保存プロセス開始...');

    final session = Supabase.instance.client.auth.currentSession;
    final jwt = session?.accessToken;

    if (jwt == null) {
      print('❌ [DEBUG] JWTがnullです。ログインしていないかセッションが切れています。');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ログインセッションが見つかりません')),
      );
      return;
    }

    print('✅ [DEBUG] JWT取得成功 (先頭10文字): ${jwt.substring(0, 10)}...');

    try {
      // TODO: 実機/エミュレータ/WEBでURLが変わるので必要に応じて調整
      const String baseUrl = 'http://localhost:8000';
      final url = Uri.parse('$baseUrl/tasks/');

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

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $jwt',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 [DEBUG] レスポンス状況コード: ${response.statusCode}');
      print('📄 [DEBUG] レスポンスボディ: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('🎉 [DEBUG] 保存成功！');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('タスクを保存しました！'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSave(input);
      } else if (response.statusCode == 401) {
        print(
          '⚠️ [DEBUG] 401認証エラー: バックエンドのSECRETとSupabaseのJWT Secretが一致しているか確認してください。',
        );
        _showErrorSnackBar('認証に失敗しました(401)');
      } else {
        _showErrorSnackBar('サーバーエラー (${response.statusCode})');
      }
    } catch (e) {
      print('🛑 [DEBUG] 通信中に例外発生: $e');
      if (e.toString().contains('Connection refused')) {
        print(
          '💡 ヒント: バックエンドサーバーが起動していないか、端末に合ったURL(例: Android Emulatorなら10.0.2.2)が違う可能性があります。',
        );
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

    // ✅ 安全な曜日決定（! を使わない）
    final daySource = _selectedExpected ?? _selectedDeadline;
    final dayLabel = daySource != null ? _dayLabelFor(daySource) : _selectedDay;

    final input = NewTaskInput(
      dayLabel: dayLabel,
      title: title,
      deadline: _selectedDeadline,
      expectedDate: _selectedExpected,
      repeat: _selectedReminder,
    );

    Navigator.of(context).pop();
    await _saveToDatabase(input);
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF0C6226);
    const labelColor = Color(0xFF0C6226);
    const inputTextColor = Color(0xFF1C3F2B);
    const hintColor = Color(0xFF789882);
    const fieldRadius = 22.0;
    const fontFamily = 'Building';
    const banana = 'Banana';

    const labelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: labelColor,
      fontFamily: fontFamily,
      letterSpacing: 0.5,
    );

    const fieldStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: inputTextColor,
      fontFamily: fontFamily,
      letterSpacing: 0.3,
    );

    const buttonTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 10,
      fontFamily: banana,
      color: Colors.white,
    );

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: const BorderSide(color: borderColor, width: 1.6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InputRow(
                label: 'タスク名',
                controller: _titleController,
                labelStyle: labelStyle,
                fieldStyle: fieldStyle,
                hintColor: hintColor,
                borderColor: borderColor,
                borderRadius: fieldRadius,
                hintText: 'タスク名を入力',
              ),
              _InputRow(
                label: '締め切り',
                controller: _deadlineController,
                labelStyle: labelStyle,
                fieldStyle: fieldStyle,
                hintColor: hintColor,
                borderColor: borderColor,
                borderRadius: fieldRadius,
                hintText: 'YYYY/MM/DD',
                readOnly: true,
                onTap: _onDeadlineTap,
                suffixIcon: const Icon(Icons.calendar_today,
                    color: borderColor, size: 20),
              ),
              _InputRow(
                label: '完了予定日',
                controller: _expectedController,
                labelStyle: labelStyle,
                fieldStyle: fieldStyle,
                hintColor: hintColor,
                borderColor: borderColor,
                borderRadius: fieldRadius,
                hintText: 'YYYY/MM/DD',
                readOnly: true,
                onTap: _onExpectedTap,
                suffixIcon: const Icon(Icons.calendar_today,
                    color: borderColor, size: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: borderColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                    ),
                    onPressed: _setExpectedUndecided,
                    icon:
                        const Icon(Icons.do_disturb_on_outlined, size: 18),
                    label: Text(
                      _isExpectedUndecided ? '未定に設定済み' : '未定にする',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              _InputRow(
                label: 'リマインダー',
                controller: _reminderController,
                labelStyle: labelStyle,
                fieldStyle: fieldStyle,
                hintColor: hintColor,
                borderColor: borderColor,
                borderRadius: fieldRadius,
                hintText: '完了予定日 / 締め切り日 / 両方',
                readOnly: true,
                onTap: _selectReminder,
                suffixIcon:
                    const Icon(Icons.expand_more, color: borderColor, size: 22),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: borderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8),
                    elevation: 0,
                  ),
                  onPressed: _handleSave,
                  child: const Text('保存', style: buttonTextStyle),
                ),
              ),
              if (_isEditing && widget.onDelete != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton(
                    onPressed: _handleDelete,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      '削除',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: banana,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.label,
    required this.controller,
    required this.labelStyle,
    required this.fieldStyle,
    required this.hintColor,
    required this.borderColor,
    required this.borderRadius,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final TextStyle labelStyle;
  final TextStyle fieldStyle;
  final Color hintColor;
  final Color borderColor;
  final double borderRadius;

  final String? hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: fieldStyle,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: fieldStyle.copyWith(color: hintColor),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor.withOpacity(0.7),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor, width: 1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
