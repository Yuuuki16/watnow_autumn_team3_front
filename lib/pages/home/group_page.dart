import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({
    super.key,
    required this.memberName,
    required this.weeklyTasks,
    required this.percent,
    required this.cactusImagePath,
    this.onTapSetting,
  });

  final String memberName;
  final List<WeeklyTask> weeklyTasks;
  final int percent;
  final String cactusImagePath;
  final VoidCallback? onTapSetting;

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xD9006400);
    const beige = Color(0xFFFAF9F6);

    return Scaffold(
      backgroundColor: beige,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 28, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'みんなのサボテン',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
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
                  GestureDetector(
                    onTap: onTapSetting,
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      'assets/icons/setting.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left, color: Colors.brown.shade300, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    memberName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown.shade400,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.chevron_right, color: Colors.brown.shade300, size: 28),
                ],
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(45, 0, 0, 0),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        cactusImagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '達成度',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      fontFamily: 'Building',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      fontFamily: 'Building',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _TaskList(weeklyTasks: weeklyTasks),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.weeklyTasks});

  final List<WeeklyTask> weeklyTasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeklyTasks
          .map(
            (day) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.dayLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: day.tasks.isNotEmpty ? Colors.grey.shade600 : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (day.tasks.isEmpty)
                    Icon(Icons.check_circle, color: Colors.grey.shade300, size: 20)
                  else
                    ...day.tasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(
                              task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: task.isDone ? const Color(0xD9006400) : Colors.grey.shade400,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withAlpha(task.isDone ? 255 : 204),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
