import 'package:flutter/material.dart';
import '../insight/insight_all_view.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    // insight_all_view.dart の VerticalPageViewScreen をそのまま表示する
    return const VerticalPageViewScreen();
  }
}
