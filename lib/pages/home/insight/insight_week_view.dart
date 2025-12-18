import 'package:flutter/material.dart';
import 'insight_all_view.dart';

/// インサイト（週）画面。バックエンドの週次データを反映させる前提で、UIは全期間と共通。
class InsightWeekView extends StatelessWidget {
  InsightWeekView({super.key, InsightData? data})
      : data = data ?? InsightData.sampleWeek();

  final InsightData data;

  @override
  Widget build(BuildContext context) {
    return InsightScreen(
      data: data,
      isAllPeriodSelected: false,
    );
  }
}
