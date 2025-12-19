import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'todo_models.dart';
import 'todo_page.dart';
import 'todo_add_page.dart';

class TodoManager extends StatefulWidget {
  const TodoManager({Key? key}) : super(key: key);

  @override
  _TodoManagerState createState() => _TodoManagerState();
}

class _TodoManagerState extends State<TodoManager> {
  List<WeeklyTask> weeklyTasks = [];

  /// ★ デバッグログ付き：タスク更新 + 植物成長 API
  Future<void> _updateTaskAndGrowPlant({
    required String? taskId,
    required String title,
    required bool isDone,
    required int dayIndex,
    required int taskIndex,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('\n--- 📝 [API Request Start] $timestamp ---');
    debugPrint('📍 Target: DayIdx[$dayIndex], TaskIdx[$taskIndex], Title: $title');

    final session = Supabase.instance.client.auth.currentSession;
    final jwt = session?.accessToken;

    if (jwt == null) {
      debugPrint('⚠️ [Auth Warning] JWTがありません。認証が必要です。');
      return;
    }

    if (taskId == null) {
      debugPrint('ℹ️ [Local Notice] TaskIDがnullのため、サーバー更新をスキップします。');
      return;
    }

    final String statusString = isDone ? "completed" : "pending";
    final url = Uri.parse('http://localhost:8000/tasks/$taskId');

    try {
      debugPrint('🔗 [URL] PUT $url');
      debugPrint('📦 [Body] {"title": "$title", "status": "$statusString"}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode({
          "title": title,
          "status": statusString,
        }),
      ).timeout(const Duration(seconds: 10)); // タイムアウト監視

      debugPrint('📥 [Response Status] ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newLevel = data['plant_level'];
        debugPrint('✅ [Success] Server updated. New Plant Level: $newLevel');

        if (isDone && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('植物が成長しました！ (Lv.$newLevel)')),
          );
        }
      } else {
        debugPrint('❌ [Server Error] Status: ${response.statusCode} / Body: ${response.body}');
        _rollbackUI(dayIndex, taskIndex, 'サーバーエラー: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🛑 [Fatal Error] $e');
      _rollbackUI(dayIndex, taskIndex, e.toString());
    } finally {
      debugPrint('--- 🏁 [API Request End] ---\n');
    }
  }

  /// ロールバック時にもログを残す
  void _rollbackUI(int dIdx, int tIdx, String reason) {
    if (!mounted) return;
    debugPrint('🔄 [Rollback] $reason に基づき、UIの状態を元に戻します。');
    setState(() {
      final task = weeklyTasks[dIdx].tasks[tIdx];
      task.isDone = !task.isDone;
    });
  }

  /// UIイベント発火ログ
  void _onToggleTask(int dayIndex, int taskIndex, bool newValue) {
    debugPrint('🖱️ [UI Interaction] Checkbox Toggled: NewValue = $newValue');
    final task = weeklyTasks[dayIndex].tasks[taskIndex];

    setState(() {
      task.isDone = newValue;
    });

    _updateTaskAndGrowPlant(
      taskId: task.id,
      title: task.title,
      isDone: newValue,
      dayIndex: dayIndex,
      taskIndex: taskIndex,
    );
  }

  void _openTaskEditor(int dayIndex, int taskIndex) {
    final task = weeklyTasks[dayIndex].tasks[taskIndex];
    final dayLabel = weeklyTasks[dayIndex].dayLabel;
    final initial = NewTaskInput(
      dayLabel: dayLabel,
      title: task.title,
      deadline: task.deadline,
      expectedDate: task.expectedDate,
      repeat: task.repeat,
    );

    showDialog(
      context: context,
      builder: (_) => TaskInputDialog(
        initialInput: initial,
        onSave: (input) {
          // replace task with new values, keep id and isDone
          final newTask = TaskItem(
            id: task.id,
            title: input.title,
            isDone: task.isDone,
            deadline: input.deadline ?? task.deadline,
            expectedDate: input.expectedDate ?? task.expectedDate,
            repeat: input.repeat ?? task.repeat,
          );
          setState(() {
            weeklyTasks[dayIndex].tasks[taskIndex] = newTask;
          });
          Navigator.of(context).pop();
        },
        onDelete: () {
          setState(() {
            weeklyTasks[dayIndex].tasks.removeAt(taskIndex);
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TodoPage(
      weeklyTasks: weeklyTasks,
      onToggleTask: _onToggleTask,
      onTapAdd: () { 
        debugPrint('➕ [UI Interaction] Add Task Button Tapped');
      },
  onLongPressTask: (dayIndex, taskIndex) => _openTaskEditor(dayIndex, taskIndex),
    );
  }
}