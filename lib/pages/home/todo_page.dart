import 'package:flutter/material.dart';

class TaskItem {
  TaskItem({required this.title, this.isDone = false});

  final String title;
  bool isDone;
}

class WeeklyTask {
  WeeklyTask({required this.dayLabel, required this.tasks});

  final String dayLabel;
  final List<TaskItem> tasks;
}

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
  final String? deadline;
  final String? expectedDate;
  final String? repeat;
}

class TodoPage extends StatelessWidget {
  const TodoPage({
    super.key,
    required this.weeklyTasks,
    required this.onToggleTask,
    required this.onTapAdd,
  });

  final List<WeeklyTask> weeklyTasks;
  final void Function(int dayIndex, int taskIndex, bool value) onToggleTask;
  final VoidCallback onTapAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleRow(onTapAdd: onTapAdd),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      itemCount: weeklyTasks.length,
                      itemBuilder: (context, index) {
                        final day = weeklyTasks[index];
                        return _DaySection(
                          day: day,
                          dayIndex: index,
                          onToggle: (taskIndex, value) =>
                              onToggleTask(index, taskIndex, value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 28,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_outline,
                  color: Colors.grey.shade600,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.onTapAdd});

  final VoidCallback onTapAdd;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F8C3C);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '今週のタスク',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: green,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Color.fromARGB(80, 0, 0, 0),
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTapAdd,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(60, 0, 0, 0),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(color: green, width: 2),
            ),
            child: const Icon(Icons.add, color: green, size: 22),
          ),
        ),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.day,
    required this.dayIndex,
    required this.onToggle,
  });

  final WeeklyTask day;
  final int dayIndex;
  final void Function(int taskIndex, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    final hasTasks = day.tasks.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.dayLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: hasTasks ? Colors.grey.shade600 : Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 6),
          if (hasTasks)
            ...List.generate(day.tasks.length, (taskIndex) {
              final task = day.tasks[taskIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => onToggle(taskIndex, !task.isDone),
                      child: Icon(
                        task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task.isDone ? const Color(0xFF1F8C3C) : Colors.grey.shade400,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withAlpha(task.isDone ? 255 : 204),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey.shade300,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
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
  final _dayLabels = const ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日'];

  String _selectedDay = '月曜日';

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
    _expectedController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    widget.onSave(
      NewTaskInput(
        dayLabel: _selectedDay,
        title: title,
        deadline: _deadlineController.text.trim().isEmpty ? null : _deadlineController.text.trim(),
        expectedDate: _expectedController.text.trim().isEmpty ? null : _expectedController.text.trim(),
        repeat: _repeatController.text.trim().isEmpty ? null : _repeatController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF1F8C3C);
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InputRow(label: 'タスク名:', controller: _titleController),
            _InputRow(label: '締め切り:', controller: _deadlineController),
            _InputRow(label: '完了予定日:', controller: _expectedController),
            _InputRow(label: '繰り返し:', controller: _repeatController),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                value: _selectedDay,
                underline: const SizedBox.shrink(),
                iconEnabledColor: borderColor,
                items: _dayLabels
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedDay = value);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: borderColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                onPressed: _handleSave,
                child: const Text(
                  '保 存',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF1F8C3C);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: borderColor, width: 1.4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: borderColor, width: 1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
