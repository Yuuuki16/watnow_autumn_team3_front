import 'package:flutter/material.dart';

/// インサイト（全期間）画面。バックエンドから渡されたユーザーデータを描画する想定。
class InsightAllView extends StatelessWidget {
  InsightAllView({super.key, InsightData? data})
      : data = data ?? InsightData.sampleAll();

  final InsightData data;

  @override
  Widget build(BuildContext context) {
    return InsightScreen(
      data: data,
      isAllPeriodSelected: true,
    );
  }
}

/// 汎用インサイト画面。週 / 全期間の違いはデータとトグル状態で表現。
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              decoration: BoxDecoration(
                color: const Color(0xFFE7E7E7),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SegmentChip(label: '週', selected: !isAllPeriodSelected),
                  const SizedBox(width: 6),
                  _SegmentChip(label: '全期間', selected: isAllPeriodSelected),
                ],
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline, color: Colors.grey.shade600, size: 28),
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
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color.fromARGB(40, 0, 0, 0),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '全体の振り返り',
            style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1F8C3C)),
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(height: 1.6)),
        ],
      ),
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
    final color = isMorning ? Colors.orange : Colors.amber.shade700;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'あなたの生活タイプ',
            style: TextStyle(fontWeight: FontWeight.w800, color: green),
          ),
          const SizedBox(height: 12),
          Center(child: Icon(icon, size: 96, color: color)),
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: green, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {},
              child: Text(
                label,
                style: const TextStyle(
                  color: green,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusNoteCard extends StatelessWidget {
  const _StatusNoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
        ],
      ),
    );
  }
}

class _CompletionTimingCard extends StatelessWidget {
  const _CompletionTimingCard({required this.timings});

  final List<CompletionTiming> timings;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '完了タイミングパターン',
            style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1F8C3C)),
          ),
          const SizedBox(height: 12),
          ...timings.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${t.percent}%', style: TextStyle(color: t.color, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: t.percent / 100,
                      minHeight: 12,
                      backgroundColor: t.color.withAlpha(40),
                      valueColor: AlwaysStoppedAnimation<Color>(t.color),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '早めの着手で期限前に余裕を持った達成を目指しましょう',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _HabitRhythmCard extends StatelessWidget {
  const _HabitRhythmCard({required this.goodDay, required this.focusDay});

  final String goodDay;
  final String focusDay;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F8C3C);
    const blue = Color(0xFF3D91CE);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '習慣リズム',
            style: TextStyle(fontWeight: FontWeight.w800, color: green),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _Pill(label: '調子の良い日', value: goodDay, color: green),
              _Pill(label: '停滞しやすい日', value: focusDay, color: blue),
            ],
          ),
        ],
      ),
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
    const green = Color(0xFF1F8C3C);
    return _CardShell(
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: completionRate / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(green),
                ),
                Text('$completionRate%', style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 6, backgroundColor: green),
                  const SizedBox(width: 6),
                  Text('完了: $completed件'),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  CircleAvatar(radius: 6, backgroundColor: Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Text('未完了: $incomplete件'),
                ],
              ),
            ],
          ),
        ],
      ),
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
    const orange = Color(0xFFE67E22);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '先延ばし率',
            style: TextStyle(fontWeight: FontWeight.w800, color: orange),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('$rate%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: orange)),
              const SizedBox(width: 12),
              Text('$completed / $total', style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              10,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  i < completed ? Icons.timer : Icons.timer_outlined,
                  size: 18,
                  color: i < completed ? orange : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcrastinationNote extends StatelessWidget {
  const _ProcrastinationNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '小さなタスクから始めると流れに乗りやすいです',
        style: TextStyle(color: Colors.black87, fontSize: 12),
      ),
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
    const purple = Color(0xFF9B59B6);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'リマインドスヌーズ率',
            style: TextStyle(fontWeight: FontWeight.w800, color: purple),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('$rate%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: purple)),
              const SizedBox(width: 12),
              Text('$done / $total件', style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('過密なリマインドはタスク管理に効果的です', style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
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
    const green = Color(0xFF1F8C3C);
    final maxVal = (bars.isEmpty ? 100 : bars.reduce((a, b) => a > b ? a : b)).clamp(1, 100);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (i) {
                final height = 120 * (bars[i] / maxVal);
                final barColor = i == 0 ? Colors.grey.shade300 : green.withAlpha(160 - (i * 6).clamp(0, 80));
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(labels[i], style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.lightbulb_outline, color: green, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(note, style: const TextStyle(height: 1.4))),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F8C3C);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('フィードバック', style: TextStyle(fontWeight: FontWeight.w800, color: green)),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

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

  factory InsightData.sampleAll() {
    return InsightData(
      userName: 'サボテン さん',
      isMorningType: false,
      completionRate: 75,
      procrastinationRate: 30,
      reminderSnoozeRate: 15,
      completedCount: 34,
      incompleteCount: 16,
      timingPatterns: const [
        CompletionTiming(label: 'しめきり1日前', percent: 25, color: Color(0xFF9B59B6)),
        CompletionTiming(label: 'しめきり3日前', percent: 30, color: Color(0xFF34B9E7)),
        CompletionTiming(label: 'しめきり3日前以前', percent: 45, color: Color(0xFF2C95D8)),
      ],
      goodDay: '月曜日',
      focusDay: '水曜日',
      weeklyBars: const [95, 78, 45, 55, 60, 70, 40],
      weeklyLabels: const ['月', '火', '水', '木', '金', '土', '日'],
      recap: '今週は月曜日と火曜日に課題を完了できています！素晴らしい進捗です。ただし、水曜日以降にタスクが溜まっている傾向が見られます。毎日少しずつ進めることで、先延ばしを防ぐことができます。',
      statusNote: '過密なリマインドはタスク管理に効果的です',
      feedback:
          'これまでのデータを見ると、タスクの多くが締め切り直前に完了する傾向があり、計画よりも若干遅れやすい特徴があります。もし負担を感じたなら、タスクの大きさに関わらず「最初の1回だけ」と手をつけることを意識するのがおすすめです。最初の5分だけでも着手の習慣が身につくと、全体の進行が安定し、ストレスが大きく減るはずです。',
      barNote: '週の前半は好調ですが、水曜日以降に完了率が下がる傾向があります。週の中盤に小休憩と食事、簡単な軽作業を挟むことで、後半も高いパフォーマンスを維持できそうです。',
      procrastinationDone: 3,
      procrastinationTotal: 10,
      reminderDone: 8,
      reminderTotal: 50,
    );
  }

  factory InsightData.sampleWeek() {
    return InsightData(
      userName: 'サボテン さん',
      isMorningType: true,
      completionRate: 25,
      procrastinationRate: 30,
      reminderSnoozeRate: 18,
      completedCount: 2,
      incompleteCount: 6,
      timingPatterns: const [
        CompletionTiming(label: 'しめきり1日前', percent: 20, color: Color(0xFF9B59B6)),
        CompletionTiming(label: 'しめきり3日前', percent: 35, color: Color(0xFF34B9E7)),
        CompletionTiming(label: 'しめきり3日前以前', percent: 45, color: Color(0xFF2C95D8)),
      ],
      goodDay: '火曜日',
      focusDay: '木曜日',
      weeklyBars: const [100, 90, 35, 55, 65, 75, 10],
      weeklyLabels: const ['月', '火', '水', '木', '金', '土', '日'],
      recap: '今週は月曜日と火曜日にタスクをしっかり完了できており、良いスタートを切れていますね。一方で、水曜日以降になると少しタスクが溜まりやすい傾向が見られます。',
      statusNote: '小さなタスクから始めると流れに乗りやすいです',
      feedback:
          '週のデータでは、タスク着手が後半にずれ込みがちです。小さいタスクから始めて勢いをつけると、全体の完了率が安定します。特に水曜〜木曜に短いセッションを挟むと先延ばし防止に役立ちます。',
      barNote: '週の前半は好調ですが、水曜日以降に完了率が下がる傾向があります。週の中盤に小休憩と軽いタスクを挟むことで、後半も高いパフォーマンスを維持できそうです。',
      procrastinationDone: 3,
      procrastinationTotal: 10,
      reminderDone: 6,
      reminderTotal: 34,
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
