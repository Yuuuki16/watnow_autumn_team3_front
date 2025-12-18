import 'package:flutter/material.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';

/// インサイト（全期間）
class InsightAllView extends StatelessWidget {
  const InsightAllView({super.key, required this.data});

  final InsightData data;

  @override
  Widget build(BuildContext context) {
    return InsightScreen(
      data: data,
      isAllPeriodSelected: true,
    );
  }
}

/// 共通インサイト画面（全期間 / 週）
class InsightScreen extends StatelessWidget {
  const InsightScreen({
    super.key,
    required this.data,
    required this.isAllPeriodSelected,
  });

  final InsightData data;
  final bool isAllPeriodSelected;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAF9F6);

    final weeklySections = <Widget>[
      _RecapCard(text: data.recap),
      const SizedBox(height: 18),
      _CompletionRateCard(
        completionRate: data.completionRate,
        completed: data.completedCount,
        incomplete: data.incompleteCount,
      ),
      const SizedBox(height: 18),
      _ProcrastinationCard(
        rate: data.procrastinationRate,
        completed: data.procrastinationDone,
        total: data.procrastinationTotal,
      ),
      const SizedBox(height: 12),
      const _ProcrastinationNote(),
      const SizedBox(height: 18),
      _HabitRhythmCard(goodDay: data.goodDay, focusDay: data.focusDay),
      const SizedBox(height: 18),
      _BarChartCard(
        bars: data.weeklyBars,
        labels: data.weeklyLabels,
        note: data.barNote,
      ),
      const SizedBox(height: 32),
    ];

    final allSections = <Widget>[
      _RecapCard(text: data.recap),
      const SizedBox(height: 18),
      _LifeTypeCard(isMorning: data.isMorningType),
      const SizedBox(height: 18),
      _StatusNoteCard(text: data.statusNote),
      const SizedBox(height: 18),
      _CompletionTimingCard(timings: data.timingPatterns),
      const SizedBox(height: 18),
      _HabitRhythmCard(goodDay: data.goodDay, focusDay: data.focusDay),
      const SizedBox(height: 18),
      _CompletionRateCard(
        completionRate: data.completionRate,
        completed: data.completedCount,
        incomplete: data.incompleteCount,
      ),
      const SizedBox(height: 18),
      _ProcrastinationCard(
        rate: data.procrastinationRate,
        completed: data.procrastinationDone,
        total: data.procrastinationTotal,
      ),
      const SizedBox(height: 18),
      _ReminderCard(
        rate: data.reminderSnoozeRate,
        done: data.reminderDone,
        total: data.reminderTotal,
      ),
      const SizedBox(height: 18),
      _BarChartCard(
        bars: data.weeklyBars,
        labels: data.weeklyLabels,
        note: data.barNote,
      ),
      const SizedBox(height: 18),
      _FeedbackCard(text: data.feedback),
      const SizedBox(height: 32),
    ];

    final content = isAllPeriodSelected ? allSections : weeklySections;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(isAllPeriodSelected: isAllPeriodSelected),
              const SizedBox(height: 14),
              ...content,
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isAllPeriodSelected});

  final bool isAllPeriodSelected;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F8C3C);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'インサイト',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: green,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E7E7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _SegmentChip(label: '週', selected: !isAllPeriodSelected),
              const SizedBox(width: 6),
              _SegmentChip(label: '全期間', selected: isAllPeriodSelected),
            ]),
          ),
        ]),
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline, color: Colors.grey, size: 28),
        ),
      ],
    );
  }
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F8C3C);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? green : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          '全体の振り返り',
          style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1F8C3C)),
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(height: 1.6)),
      ]),
    );
  }
}

class _LifeTypeCard extends StatelessWidget {
  const _LifeTypeCard({required this.isMorning});
  final bool isMorning;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F8C3C);
    final label = isMorning ? '朝型' : '夜型';
    final icon = isMorning ? Icons.wb_sunny : Icons.nightlight_round;

    return _CardShell(
      child: Column(children: [
        const Text('あなたの生活タイプ',
            style: TextStyle(fontWeight: FontWeight.w800, color: green)),
        const SizedBox(height: 12),
        Icon(icon, size: 80),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _StatusNoteCard extends StatelessWidget {
  const _StatusNoteCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return _CardShell(child: Text(text));
  }
}

class _CompletionTimingCard extends StatelessWidget {
  const _CompletionTimingCard({required this.timings});
  final List<CompletionTiming> timings;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('完了タイミング',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...timings.map((t) => Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.label),
                  Text('${t.percent}%',
                      style: TextStyle(color: t.color)),
                ],
              ),
              LinearProgressIndicator(
                value: t.percent / 100,
                valueColor: AlwaysStoppedAnimation(t.color),
              ),
              const SizedBox(height: 10),
            ])),
        const Text(
          '早めに着手すると、余裕を持って達成できます。',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ]),
    );
  }
}

class _HabitRhythmCard extends StatelessWidget {
  const _HabitRhythmCard({required this.goodDay, required this.focusDay});
  final String goodDay;
  final String focusDay;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('習慣リズム',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('調子が良い日: $goodDay'),
        Text('集中しやすい日: $focusDay'),
      ]),
    );
  }
}

class _CompletionRateCard extends StatelessWidget {
  const _CompletionRateCard({
    required this.completionRate,
    required this.completed,
    required this.incomplete,
  });

  final int completionRate;
  final int completed;
  final int incomplete;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(children: [
        Text('$completionRate%',
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.w800)),
        Text('完了: $completed / 未完了: $incomplete'),
      ]),
    );
  }
}

class _ProcrastinationCard extends StatelessWidget {
  const _ProcrastinationCard({
    required this.rate,
    required this.completed,
    required this.total,
  });

  final int rate;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(children: [
        const Text('先延ばし率',
            style: TextStyle(fontWeight: FontWeight.w800)),
        Text('$rate% ($completed / $total)'),
      ]),
    );
  }
}

class _ProcrastinationNote extends StatelessWidget {
  const _ProcrastinationNote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '小さなタスクから始めると、作業の流れに乗りやすくなります。',
      style: TextStyle(fontSize: 12),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.rate,
    required this.done,
    required this.total,
  });

  final int rate;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(children: [
        const Text('リマインドのスヌーズ率',
            style: TextStyle(fontWeight: FontWeight.w800)),
        Text('$rate% ($done / $total)'),
        const Text(
          '過去のリマインドはタスク管理に効果的です。',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ]),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({
    required this.bars,
    required this.labels,
    required this.note,
  });

  final List<int> bars;
  final List<String> labels;
  final String note;

  @override
  Widget build(BuildContext context) {
    return _CardShell(child: Text(note));
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return _CardShell(child: Text(text));
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// ===== データ =====

class InsightData {
  InsightData({
    required this.userName,
    required this.isMorningType,
    required this.completionRate,
    required this.procrastinationRate,
    required this.reminderSnoozeRate,
    required this.completedCount,
    required this.incompleteCount,
    required this.timingPatterns,
    required this.goodDay,
    required this.focusDay,
    required this.weeklyBars,
    required this.weeklyLabels,
    required this.recap,
    required this.statusNote,
    required this.feedback,
    required this.barNote,
    required this.procrastinationDone,
    required this.procrastinationTotal,
    required this.reminderDone,
    required this.reminderTotal,
  });

  static const weekdayLongLabels = [
    '月曜日','火曜日','水曜日','木曜日','金曜日','土曜日','日曜日'
  ];
  static const weekdayShortLabels = ['月','火','水','木','金','土','日'];

  final String userName;
  final bool isMorningType;
  final int completionRate;
  final int procrastinationRate;
  final int reminderSnoozeRate;
  final int completedCount;
  final int incompleteCount;
  final List<CompletionTiming> timingPatterns;
  final String goodDay;
  final String focusDay;
  final List<int> weeklyBars;
  final List<String> weeklyLabels;
  final String recap;
  final String statusNote;
  final String feedback;
  final String barNote;
  final int procrastinationDone;
  final int procrastinationTotal;
  final int reminderDone;
  final int reminderTotal;

  factory InsightData.fromTasks(List<WeeklyTask> weeklyTasks) {
    return InsightData(
      userName: 'ユーザー',
      isMorningType: true,
      completionRate: 70,
      procrastinationRate: 30,
      reminderSnoozeRate: 15,
      completedCount: 10,
      incompleteCount: 5,
      timingPatterns: const [],
      goodDay: '月曜日',
      focusDay: '火曜日',
      weeklyBars: const [10, 20, 30, 40, 50, 60, 70],
      weeklyLabels: weekdayShortLabels,
      recap: '今週は安定してタスクを進められました。',
      statusNote: '無理のないペースを意識しましょう。',
      feedback: 'とても良い調子です。',
      barNote: '週の後半に集中力が高まっています。',
      procrastinationDone: 2,
      procrastinationTotal: 10,
      reminderDone: 5,
      reminderTotal: 20,
    );
  }
}

class CompletionTiming {
  const CompletionTiming({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent;
  final Color color;
}
