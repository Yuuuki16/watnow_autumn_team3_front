import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:watnow_autumn_team3_front/pages/home/todo/todo_models.dart';

const titleColor = Color(0xD9006400);

const Color _bg = Color(0xFFF7F6F2);
const Color _orange = Color(0xFFF49D2A);
const Color _purple = Color(0xFF8B4BE8);
const Color _cyan = Color(0xFF35C5E3);
const Color _lightBlue = Color(0xFF48A8F2);

/// インサイト（全期間）
class InsightAllView extends StatelessWidget {
  const InsightAllView({super.key, required this.data});

  final InsightData data;

  @override
  Widget build(BuildContext context) {
    // ここでは「全期間」表示として扱う
    return InsightScreen(data: data, isAllPeriodSelected: true);
  }
}

/// インサイト画面（週 / 全期間の表示切り替え共通）
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
    final weeklySections = <Widget>[
      _RecapCard(title: '今週の振り返り', text: data.recap),
      const SizedBox(height: 14),
      _CompletionRateCard(
        completionRate: data.completionRate,
        completed: data.completedCount,
        incomplete: data.incompleteCount,
        heading: '今週の状況',
        accentColor: titleColor,
        fontFamily: 'Building',
      ),
      const SizedBox(height: 16),
      _ProcrastinationCard(
        rate: data.procrastinationRate,
        completed: data.procrastinationDone,
        total: data.procrastinationTotal,
        accentColor: _orange,
        note: '後回しにしがちなタスクは、最初の5分だけでも着手すると進めやすくなります。',
      ),
      const SizedBox(height: 16),
      _HabitRhythmChartCard(
        goodDay: data.goodDay,
        focusDay: data.focusDay,
        bars: data.weeklyBars,
        labels: data.weeklyLabels,
        note: data.barNote,
        accentColor: titleColor,
      ),
      const SizedBox(height: 24),
    ];

    final allSections = <Widget>[
      _RecapCard(title: '全体の振り返り', text: data.recap),
      const SizedBox(height: 14),
      _LifeTypeCard(isMorning: data.isMorningType),
      const SizedBox(height: 14),
      _CompletionRateCard(
        completionRate: data.completionRate,
        completed: data.completedCount,
        incomplete: data.incompleteCount,
        heading: 'これまでの状況',
        accentColor: titleColor,
        fontFamily: 'Building',
      ),
      const SizedBox(height: 16),
      _ReminderSnoozeCard(
        rate: data.reminderSnoozeRate,
        snoozed: data.reminderDone,
        total: data.reminderTotal,
        accentColor: _purple,
      ),
      const SizedBox(height: 16),
      _CompletionTimingCard(timings: data.timingPatterns),
      const SizedBox(height: 16),
      _ProcrastinationCard(
        rate: data.procrastinationRate,
        completed: data.procrastinationDone,
        total: data.procrastinationTotal,
        accentColor: _orange,
        note: '後回しにしがちなタスクは、最初の5分だけでも着手すると進めやすくなります。',
      ),
      const SizedBox(height: 16),
      _HabitRhythmChartCard(
        goodDay: data.goodDay,
        focusDay: data.focusDay,
        bars: data.weeklyBars,
        labels: data.weeklyLabels,
        note: data.barNote,
        accentColor: titleColor,
      ),
      const SizedBox(height: 16),
      _FeedbackCard(text: data.feedback),
      const SizedBox(height: 32),
    ];

    final content = isAllPeriodSelected ? allSections : weeklySections;

    return Container(
      color: _bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        ),
      ),
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: titleColor,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF000000),
              fontFamily: 'Banana',
            ),
          ),
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
    final label = isMorning ? '朝型' : '夜型';
    final badge = isMorning ? const _SunBadge() : const _MoonBadge();

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'あなたの生活タイプ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: titleColor,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 16),
          Align(alignment: Alignment.center, child: badge),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: titleColor, width: 1.4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: titleColor,
                  fontFamily: 'Building',
                ),
              ),
            ),
          ),
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
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: _purple,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 12),
          ...timings.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C3F2B),
                          fontFamily: 'Banana',
                        ),
                      ),
                      Text(
                        '${t.percent}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: t.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: t.percent / 100,
                      minHeight: 12,
                      valueColor: AlwaysStoppedAnimation(t.color),
                      backgroundColor: t.color.withOpacity(0.18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '早めの着手で、期限に余裕を持った達成を目指しましょう。',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF4D4D4D),
              fontFamily: 'Banana',
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderSnoozeCard extends StatelessWidget {
  const _ReminderSnoozeCard({
    required this.rate,
    required this.snoozed,
    required this.total,
    required this.accentColor,
  });

  final int rate;
  final int snoozed;
  final int total;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final clamped = rate.clamp(0, 100);
    final value = clamped / 100;
    final hasData = total > 0;
    final countText = hasData ? 'スヌーズ $snoozed / $total件' : 'リマインドの記録はまだありません';

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'リマインドスヌーズ率',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$clamped%',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: 'Banana',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            countText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4D4D4D),
              fontFamily: 'Banana',
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation(accentColor),
              backgroundColor: accentColor.withOpacity(0.18),
            ),
          ),
          const SizedBox(height: 12),
          _TipNote(
            background: const Color(0xFFF1EAFE),
            iconColor: accentColor,
            text: hasData
                ? 'リマインドを繰り返しスヌーズするほど、締め切り前に追い込まれがちです。早めに着手できるものから片付けていきましょう。'
                : 'リマインドを上手く使うと、前倒しで着手しやすくなります。優先度の高いタスクから試してみましょう。',
            fontFamily: 'Banana',
          ),
        ],
      ),
    );
  }
}

class _HabitRhythmChartCard extends StatelessWidget {
  const _HabitRhythmChartCard({
    required this.goodDay,
    required this.focusDay,
    required this.bars,
    required this.labels,
    required this.note,
    required this.accentColor,
  });

  final String goodDay;
  final String focusDay;
  final List<int> bars;
  final List<String> labels;
  final String note;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final focusAccent = Colors.teal.shade700;
    final hasBars = bars.isNotEmpty && labels.isNotEmpty;
    final maxValue = hasBars ? bars.reduce(max).clamp(1, 100) : 1;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '習慣リズム',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PillStat(
                  title: '調子が良い日',
                  value: goodDay,
                  icon: Icons.trending_up,
                  accent: accentColor,
                  fontFamily: 'Banana',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillStat(
                  title: '停滞しやすい日',
                  value: focusDay,
                  icon: Icons.trending_down,
                  accent: focusAccent,
                  fontFamily: 'Banana',
                ),
              ),
            ],
          ),
          if (hasBars) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 170,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('100%', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A7A), fontFamily: 'Banana')),
                      Text('75%', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A7A), fontFamily: 'Banana')),
                      Text('50%', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A7A), fontFamily: 'Banana')),
                      Text('25%', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A7A), fontFamily: 'Banana')),
                      Text('0%', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A7A), fontFamily: 'Banana')),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(bars.length, (index) {
                        final value = bars[index];
                        final height = 140 * (value / maxValue);
                        final color = _barColor(value, index);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 18,
                              height: height,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              labels[index],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1C3F2B),
                                fontFamily: 'Banana',
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          _TipNote(
            background: const Color(0xFFF8EFE2),
            iconColor: accentColor,
            text: note,
            fontFamily: 'Banana',
          ),
        ],
      ),
    );
  }

  static Color _barColor(int percent, int index) {
    // Keep Monday at the original color; others darken based on percentage.
    const mondayColor = Color(0xFFB0C8B3); // Monday / 100%
    const high = Color(0xFF6EB57D); // ~75-99%
    const mid = Color(0xFF499360); // ~50-74%
    const lowMid = Color(0xFF3F7E54); // ~26-49%
    const dark = Color(0xFF316642); // <=25%

    if (index == 0) return mondayColor;

    final value = percent.clamp(0, 100);
    if (value >= 75) return high;
    if (value >= 50) return mid;
    if (value >= 25) return lowMid;
    return dark;
  }
}

class _CompletionRateCard extends StatelessWidget {
  const _CompletionRateCard({
    required this.completionRate,
    required this.completed,
    required this.incomplete,
    required this.heading,
    required this.accentColor,
    this.fontFamily,
  });

  final int completionRate;
  final int completed;
  final int incomplete;
  final String heading;
  final Color accentColor;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    final percent = completionRate.clamp(0, 100) / 100;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 12,
                          valueColor: AlwaysStoppedAnimation(accentColor),
                          backgroundColor: const Color(0xFFE0E0E0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatusRow(
                        color: accentColor,
                        label: '完了: $completed件',
                        isBold: true,
                      ),
                      const SizedBox(height: 8),
                      _StatusRow(
                        color: const Color(0xFFBFBFBF),
                        label: '未完了: $incomplete件',
                        textColor: const Color(0xFF6B6B6B),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 18,
            thickness: 1,
            color: Color(0xFFE6E6E6),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '完了率',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7A7A7A),
                  fontFamily: 'Building',
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$completionRate%',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.color,
    required this.label,
    this.isBold = false,
    this.textColor = const Color(0xFF1C3F2B),
  });

  final Color color;
  final String label;
  final bool isBold;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: textColor,
            fontFamily: 'Banana',
          ),
        ),
      ],
    );
  }
}

class _ProcrastinationCard extends StatelessWidget {
  const _ProcrastinationCard({
    required this.rate,
    required this.completed,
    required this.total,
    required this.accentColor,
    this.note,
  });

  final int rate;
  final int completed;
  final int total;
  final Color accentColor;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : rate.clamp(0, 100) / 100;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '先延ばし率',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$rate%',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: 'Banana',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '後回しにしたタスク $completed / $total件',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4D4D4D),
              fontFamily: 'Banana',
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation(accentColor),
              backgroundColor: accentColor.withOpacity(0.18),
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8EFE2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                note!,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: Color(0xFF4D4D4D),
                  fontFamily: 'Banana',
                ),
              ),
            ),
          ],
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
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'フィードバック',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: titleColor,
              fontFamily: 'Building',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              height: 1.6,
              color: Color(0xFF1C3F2B),
              fontFamily: 'Banana',
            ),
          ),
        ],
      ),
    );
  }
}

class _TipNote extends StatelessWidget {
  const _TipNote({
    required this.background,
    required this.iconColor,
    required this.text,
    this.fontFamily,
  });

  final Color background;
  final Color iconColor;
  final String text;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF4D4D4D),
              ).copyWith(fontFamily: fontFamily),
            ),
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PillStat extends StatelessWidget {
  const _PillStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    this.fontFamily,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF7A7A7A),
                  fontWeight: FontWeight.w700,
                  fontFamily: fontFamily,
                ),
              ),
              Icon(icon, size: 18, color: const Color(0xFF7A7A7A)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: accent,
              fontFamily: fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class _SunBadge extends StatelessWidget {
  const _SunBadge();

  @override
  Widget build(BuildContext context) {
    // assets/images/sun.svg の中に data:image/png;base64,... が埋め込まれている前提
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('assets/images/sun.svg'),
      builder: (context, snapshot) {
        final raw = snapshot.data ?? '';
        final match = RegExp(r'data:image/png;base64,([^"\\)]+)').firstMatch(raw);
        if (match == null) return const SizedBox(width: 132, height: 132);

        final bytes = base64Decode(match.group(1)!);
        return Image.memory(bytes, width: 132, height: 132, fit: BoxFit.contain);
      },
    );
  }
}

class _MoonBadge extends StatelessWidget {
  const _MoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFFE89E), Color(0xFFFFC94A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC94A),
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              right: 6,
              top: 10,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F6F2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===== データモデル =====

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
    '月曜日',
    '火曜日',
    '水曜日',
    '木曜日',
    '金曜日',
    '土曜日',
    '日曜日',
  ];

  static const weekdayShortLabels = ['月', '火', '水', '木', '金', '土', '日'];

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
    // TODO: weeklyTasks から集計する。今はダミー値
    return InsightData(
      userName: 'ユーザー',
      isMorningType: true,
      completionRate: 25,
      procrastinationRate: 30,
      reminderSnoozeRate: 15,
      completedCount: 2,
      incompleteCount: 6,
      timingPatterns: const [
        CompletionTiming(label: 'しめきり1日前', percent: 25, color: _purple),
        CompletionTiming(label: 'しめきり3日前', percent: 30, color: _cyan),
        CompletionTiming(label: 'しめきり3日前以前', percent: 45, color: _lightBlue),
      ],
      goodDay: '月曜日',
      focusDay: '日曜日',
      weeklyBars: const [90, 70, 80, 55, 65, 75, 30],
      weeklyLabels: weekdayShortLabels,
      recap: '今週は月曜日と火曜日にタスクをしっかり完了できています。水曜日以降に少しタスクが溜まりやすい傾向が見られます。',
      statusNote: '全体的に安定していますが、中盤のペース維持がカギです。少しずつ進めることで先延ばしを防ぎましょう。',
      feedback:
          'これまでのデータを見ると、タスクの多くが締め切り直前に完了する傾向があります。最初の5分だけでも着手する習慣を身につけ、長期的に安定した進行を目指しましょう。',
      barNote:
          '週の前半は好調ですが、水曜日以降に完了率が下がる傾向があります。週の中盤に小休憩を挟むと、後半も高いパフォーマンスを維持できるかもしれません。',
      procrastinationDone: 3,
      procrastinationTotal: 10,
      reminderDone: 8,
      reminderTotal: 50,
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
