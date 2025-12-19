import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';
import '../insight/insight_all_view.dart' as all_view;
import '../insight/insight_week_view.dart' as week_view;

class InsightPage extends StatelessWidget {
  const InsightPage({super.key, required this.weeklyTasks, this.onTapSetting});

  final List<WeeklyTask> weeklyTasks;
  final VoidCallback? onTapSetting;

  @override
  Widget build(BuildContext context) {
    final data = all_view.InsightData.fromTasks(weeklyTasks);

    const bg = Color(0xFFF7F6F2);
    const titleColor = Color(0xD9006400);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(
            children: [
              // ===== Header =====
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 28, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'インサイト',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Building',
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Color(0x2E000000),
                            offset: Offset(0, 2),
                            blurRadius: 4,
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
              ),

              // ===== TabBar Wrapper =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  // 外側：白フチ＋影
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Container(
                    // 内側：グレー背景＋囲い線（ここが「線」）
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(28),
                      
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.transparent,

                      labelColor: Colors.white,
                      unselectedLabelColor:
                          const Color.fromARGB(255, 115, 116, 114),

                      labelStyle: const TextStyle(
                        fontFamily: 'Banana',
                        fontSize: 22,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Banana',
                        fontSize: 22,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),

                      indicator: BoxDecoration(
                        color: titleColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33006400),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,

                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          WidgetStateProperty.all(Colors.transparent),

                      tabs: const [
                        Tab(text: '週'),
                        Tab(text: '全期間'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // ===== Content =====
              Expanded(
                child: TabBarView(
                  children: [
                    week_view.InsightWeekView(data: data),
                    all_view.InsightAllView(data: data),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
