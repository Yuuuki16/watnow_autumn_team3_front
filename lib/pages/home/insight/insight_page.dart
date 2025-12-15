import 'package:flutter/material.dart';
import 'insight_week_view.dart';
import 'insight_all_view.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insight')),
      body: _index == 0
          ? const InsightWeekView()
          : const InsightAllView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: '週',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: '全体',
          ),
        ],
      ),
    );
  }
}
