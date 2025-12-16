import 'package:flutter/material.dart';
import '../insight/insight_all_view.dart' as all_view;
import '../insight/insight_week_view.dart' as week_view;

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text('インサイト', style: TextStyle(color: Colors.black)),
          bottom: const TabBar(
            tabs: [Tab(text: '全体'), Tab(text: '週間')],
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
          ),
        ),
        body: TabBarView(
          children: [
            const all_view.VerticalPageViewScreen(),
            const week_view.VerticalPageViewScreen(),
          ],
        ),
      ),
    );
  }
}
