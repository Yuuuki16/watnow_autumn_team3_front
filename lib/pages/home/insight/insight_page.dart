import 'package:flutter/material.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';
import '../insight/insight_all_view.dart' as all_view;
import '../insight/insight_week_view.dart' as week_view;

class InsightPage extends StatelessWidget {
  const InsightPage({super.key, required this.weeklyTasks});

  final List<WeeklyTask> weeklyTasks;

  @override
  Widget build(BuildContext context) {
    final data = all_view.InsightData.fromTasks(weeklyTasks);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            'インサイト',
            style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: '全期間'),
              Tab(text: '週'),
            ],
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
          ),
        ),
        body: TabBarView(
          children: [
            all_view.InsightAllView(data: data),
            week_view.InsightWeekView(data: data),
          ],
        ),
      ),
    );
  }
}
