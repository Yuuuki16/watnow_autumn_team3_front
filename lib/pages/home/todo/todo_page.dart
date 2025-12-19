import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';

const titleColor = Color(0xD9006400);

class TodoPage extends StatelessWidget {
  const TodoPage({
    super.key,
    required this.weeklyTasks,
    required this.onToggleTask,
    required this.onTapAdd,
    required this.onLongPressTask,
    this.onTapSetting,
  });

  final List<WeeklyTask> weeklyTasks;
  final void Function(int dayIndex, int taskIndex, bool value) onToggleTask;
  final VoidCallback onTapAdd;
  final void Function(int dayIndex, int taskIndex) onLongPressTask;
  final VoidCallback? onTapSetting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 16),
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
                          onLongPress: (taskIndex) =>
                              onLongPressTask(index, taskIndex),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 28,
              child: GestureDetector(
                onTap: onTapSetting,
                child: SvgPicture.asset(
                  'assets/icons/setting.svg',
                  width: 32,
                  height: 32,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '今週のタスク',
          style: const TextStyle(
            fontSize: 37,
            fontWeight: FontWeight.w500,
            color: titleColor,
            letterSpacing: 2,
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
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTapAdd,
          child: Padding(
            padding: const EdgeInsets.only(top: 6), // move icon slightly lower
            child: SvgPicture.asset(
              'assets/icons/todo_add_box.svg',
              width: 38,
              height: 38,
            ),
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
    required this.onLongPress,
  });

  final WeeklyTask day;
  final int dayIndex;
  final void Function(int taskIndex, bool value) onToggle;
  final void Function(int taskIndex) onLongPress;

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
              fontFamily: 'Banana',
              fontWeight: FontWeight.w400,
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
                      child: SvgPicture.asset(
                        task.isDone
                            ? 'assets/icons/todo_active.svg'
                            : 'assets/icons/todo_noactive.svg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () => onLongPress(taskIndex),
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Banana',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
