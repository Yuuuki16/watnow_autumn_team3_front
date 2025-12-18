import 'package:flutter/material.dart';

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

  static const List<String> _weekdayLabels = [
    '月曜日','火曜日','水曜日','木曜日','金曜日','土曜日','日曜日',
  ];

  late String _selectedDay;

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

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}/$month/$day';
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

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final daySource = _selectedExpected ?? _selectedDeadline;
    final dayLabel = daySource != null ? _dayLabelFor(daySource) : _selectedDay;

    widget.onSave(
      NewTaskInput(
        dayLabel: dayLabel,
        title: title,
        deadline: _selectedDeadline,
        expectedDate: _selectedExpected,
        repeat: _repeatController.text.trim().isEmpty
            ? null
            : _repeatController.text.trim(),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF0C6226);
    const labelColor = Color(0xFF0C6226);
    const inputTextColor = Color(0xFF1C3F2B);
    const hintColor = Color(0xFF789882);
    const fieldRadius = 22.0;

    const fontFamily = 'Building';

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
      fontSize: 15,
      fontWeight: FontWeight.w800,
      letterSpacing: 2,
      fontFamily: fontFamily,
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
              suffixIcon: const Icon(Icons.calendar_today, color: borderColor, size: 20),
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
              suffixIcon: const Icon(Icons.calendar_today, color: borderColor, size: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '追加される曜日: $_selectedDay',
                  style: labelStyle.copyWith(fontSize: 13),
                ),
              ),
            ),
            _InputRow(
              label: '繰り返し',
              controller: _repeatController,
              labelStyle: labelStyle,
              fieldStyle: fieldStyle,
              hintColor: hintColor,
              borderColor: borderColor,
              borderRadius: fieldRadius,
              hintText: '毎週 / 隔週 など',
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
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  elevation: 0,
                ),
                onPressed: _handleSave,
                child: const Text('保存', style: buttonTextStyle),
              ),
            ),
          ],
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
            cursorColor: borderColor,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: fieldStyle.copyWith(
                color: hintColor,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor.withOpacity(0.7), width: 1.5),
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
