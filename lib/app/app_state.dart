// lib/app/app_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:watnow_autumn_team3_front/pages/home/home_page.dart';
import 'package:watnow_autumn_team3_front/pages/home/insight/insight_page.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_add_page.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_page.dart';
import 'package:watnow_autumn_team3_front/pages/setting/setting_page.dart';

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  /// 0: Todo, 1: Home, 2: Insight
  int _currentIndex = 1;

  final List<WeeklyTask> _weeklyTasks = [
    WeeklyTask(
      dayLabel: '月曜日',
      tasks: [TaskItem(title: '経済学入門　課題', isDone: true)],
    ),
    WeeklyTask(
      dayLabel: '火曜日',
      tasks: [TaskItem(title: '英語AI', isDone: true)],
    ),
    WeeklyTask(dayLabel: '水曜日', tasks: []),
    WeeklyTask(dayLabel: '木曜日', tasks: []),
    WeeklyTask(dayLabel: '金曜日', tasks: []),
    WeeklyTask(dayLabel: '土曜日', tasks: []),
    WeeklyTask(dayLabel: '日曜日', tasks: []),
  ];

  /// 完了率（0〜100）
  int get _completionPercent {
    final total =
        _weeklyTasks.fold<int>(0, (sum, day) => sum + day.tasks.length);
    if (total == 0) return 0;

    final done = _weeklyTasks.fold<int>(
      0,
      (sum, day) => sum + day.tasks.where((t) => t.isDone).length,
    );

    return ((done / total) * 100).round();
  }

  /// サボテン画像に合わせた段階％（0,5,10,20,30,50,70,90,100 のどれか）
  int get _cactusPercent {
    const levels = [0, 5, 10, 20, 30, 50, 70, 90, 100];
    int closest = levels.first;
    int minDiff = (levels.first - _completionPercent).abs();

    for (final level in levels) {
      final diff = (level - _completionPercent).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = level;
      }
    }
    return closest;
  }

  String get _cactusImagePath => 'assets/images/${_cactusPercent}per.png';

  void _toggleTask(int dayIndex, int taskIndex, bool value) {
    setState(() {
      _weeklyTasks[dayIndex].tasks[taskIndex].isDone = value;
    });
  }

  void _addTask(NewTaskInput input) {
    final dayLabel = input.dayLabel;
    final dayIndex = _weeklyTasks.indexWhere((e) => e.dayLabel == dayLabel);

    final task = TaskItem(
      title: input.title,
      deadline: input.deadline,
      expectedDate: input.expectedDate,
      repeat: input.repeat,
    );

    setState(() {
      if (dayIndex == -1) {
        _weeklyTasks.add(WeeklyTask(dayLabel: dayLabel, tasks: [task]));
      } else {
        _weeklyTasks[dayIndex].tasks.add(task);
      }
    });
  }

  /// ✅ 編集（曜日変更にも対応）
  void _editTask({
    required int dayIndex,
    required int taskIndex,
    required NewTaskInput input,
  }) {
    final originalTask = _weeklyTasks[dayIndex].tasks[taskIndex];

    final updatedTask = TaskItem(
      title: input.title,
      isDone: originalTask.isDone,
      deadline: input.deadline,
      expectedDate: input.expectedDate,
      repeat: input.repeat,
    );

    setState(() {
      final originalDayLabel = _weeklyTasks[dayIndex].dayLabel;

      // 同じ曜日なら上書き
      if (input.dayLabel == originalDayLabel) {
        _weeklyTasks[dayIndex].tasks[taskIndex] = updatedTask;
        return;
      }

      // 曜日が変わったら移動
      _weeklyTasks[dayIndex].tasks.removeAt(taskIndex);

      final targetDayIndex =
          _weeklyTasks.indexWhere((e) => e.dayLabel == input.dayLabel);

      if (targetDayIndex == -1) {
        _weeklyTasks.add(
          WeeklyTask(dayLabel: input.dayLabel, tasks: [updatedTask]),
        );
      } else {
        _weeklyTasks[targetDayIndex].tasks.add(updatedTask);
      }
    });
  }

  /// ✅ 削除
  void _deleteTask(int dayIndex, int taskIndex) {
    setState(() {
      _weeklyTasks[dayIndex].tasks.removeAt(taskIndex);
    });
  }

  /// ✅ 追加ダイアログ（引数なし）
  void _openTaskInput() {
    showDialog(
      context: context,
      builder: (_) => TaskInputDialog(onSave: _addTask),
    );
  }

  void _openTaskEditor(int dayIndex, int taskIndex) {
    final task = _weeklyTasks[dayIndex].tasks[taskIndex];
    final dayLabel = _weeklyTasks[dayIndex].dayLabel;

    final initial = NewTaskInput(
      dayLabel: dayLabel,
      title: task.title,
      deadline: task.deadline,
      expectedDate: task.expectedDate,
      repeat: task.repeat,
    );

    showDialog(
      context: context,
      builder: (_) => TaskInputDialog(
        initialInput: initial,
        onSave: (input) => _editTask(
          dayIndex: dayIndex,
          taskIndex: taskIndex,
          input: input,
        ),
        onDelete: () => _deleteTask(dayIndex, taskIndex),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _openSetting() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingPage()),
    );
  }

Widget _buildCurrentPage() {
  switch (_currentIndex) {
    case 0:
      return TodoPage(
        weeklyTasks: _weeklyTasks,
        onToggleTask: _toggleTask,
        onTapAdd: _openTaskInput,
        onLongPressTask: (dayIndex, taskIndex) =>
            _openTaskEditor(dayIndex, taskIndex),
        onTapSetting: _openSetting,
      );

    case 1:
      return HomePage(
        percent: _cactusPercent,
        imagePath: _cactusImagePath,
        onTapSetting: _openSetting,
      );

    case 2:
      return InsightPage(
        weeklyTasks: _weeklyTasks,
        onTapSetting: _openSetting,
      );

    default:
      return const SizedBox.shrink();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: const Color.fromARGB(148, 116, 186, 116),
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_list.svg',
                activeAssetPath: 'assets/icons/active_list.svg',
                isActive: _currentIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_home.svg',
                activeAssetPath: 'assets/icons/active_home.svg',
                isActive: _currentIndex == 1,
                onTap: () => _onTabTapped(1),
              ),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_insight.svg',
                activeAssetPath: 'assets/icons/active_insight.svg',
                isActive: _currentIndex == 2,
                onTap: () => _onTabTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({
    required this.assetPath,
    required this.activeAssetPath,
    required this.isActive,
    required this.onTap,
  });

  final String assetPath;
  final String activeAssetPath;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pathToUse = isActive ? activeAssetPath : assetPath;

    final Color iconColor = isActive
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(217, 255, 255, 255);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          child: SvgPicture.asset(pathToUse, width: 44, height: 44),
        ),
      ),
    );
  }
}
