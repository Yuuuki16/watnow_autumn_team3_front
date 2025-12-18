// lib/app/app_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watnow_autumn_team3_front/pages/home/home_page.dart';
import 'package:watnow_autumn_team3_front/pages/home/insight/insight_page.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo_page.dart';
import 'package:watnow_autumn_team3_front/pages/home/group_page.dart';

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  int _currentIndex = 1;

  final List<WeeklyTask> _weeklyTasks = [
    WeeklyTask(
      dayLabel: '月曜日',
      tasks: [
        TaskItem(title: '英語ＳＷ　課題', isDone: true),
      ],
    ),
    WeeklyTask(
      dayLabel: '火曜日',
      tasks: [
        TaskItem(title: '経済学入門', isDone: true),
      ],
    ),
    WeeklyTask(dayLabel: '水曜日', tasks: []),
    WeeklyTask(dayLabel: '木曜日', tasks: []),
    WeeklyTask(dayLabel: '金曜日', tasks: []),
    WeeklyTask(dayLabel: '土曜日', tasks: []),
    WeeklyTask(dayLabel: '日曜日', tasks: []),
  ];

  int get _rawPercent {
    final total =
        _weeklyTasks.fold<int>(0, (sum, day) => sum + day.tasks.length);
    if (total == 0) return 0;
    final done = _weeklyTasks.fold<int>(
      0,
      (sum, day) => sum + day.tasks.where((t) => t.isDone).length,
    );
    return ((done / total) * 100).round();
  }

  int get _cactusPercent {
    const levels = [0, 5, 10, 20, 30, 50, 90, 100];
    int closest = levels.first;
    int minDiff = (levels.first - _rawPercent).abs();

    for (final level in levels) {
      final diff = (level - _rawPercent).abs();
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
    final dayIndex =
        _weeklyTasks.indexWhere((element) => element.dayLabel == input.dayLabel);
    setState(() {
      if (dayIndex == -1) {
        _weeklyTasks.add(
          WeeklyTask(
            dayLabel: input.dayLabel,
            tasks: [TaskItem(title: input.title)],
          ),
        );
      } else {
        _weeklyTasks[dayIndex].tasks.add(TaskItem(title: input.title));
      }
    });
  }

  void _openTaskInput(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TaskInputDialog(onSave: _addTask),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return GroupPage(
          memberName: 'サボテン さん',
          weeklyTasks: _weeklyTasks,
          percent: _cactusPercent,
          cactusImagePath: _cactusImagePath,
        );
      case 1:
        return HomePage(
          percent: _cactusPercent,
          imagePath: _cactusImagePath,
        );
      case 2:
        return TodoPage(
          weeklyTasks: _weeklyTasks,
          onToggleTask: _toggleTask,
          onTapAdd: () => _openTaskInput(context),
        );
      case 3:
        return const InsightPage();
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
          color: const Color(0xA8006400),
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_group.svg',
                activeAssetPath: 'assets/icons/active_group.svg',
                isActive: _currentIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              const SizedBox(width: 34),
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
      child: Container(
        padding: const EdgeInsets.all(6),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          child: SvgPicture.asset(pathToUse, width: 48, height: 48),
        ),
      ),
    );
  }
}
