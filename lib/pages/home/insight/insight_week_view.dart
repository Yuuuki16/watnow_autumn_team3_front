import 'package:flutter/material.dart';
import 'insight_all_view.dart';

/// インサイト（週表示）
/// UI は InsightScreen を使い回して、フラグで週/全期間を切り替える
class InsightWeekView extends StatelessWidget {
  const InsightWeekView({super.key, required this.data});

  final InsightData data;

  @override
  Widget build(BuildContext context) {
    return InsightScreen(
      data: data,
      isAllPeriodSelected: false,
    );
  }
}

