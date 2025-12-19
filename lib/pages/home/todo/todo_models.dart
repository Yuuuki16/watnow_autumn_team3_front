class TaskItem {
  TaskItem({
    this.id,
    required this.title,
    this.isDone = false,
    this.deadline,
    this.expectedDate,
    this.repeat,
  });

  final String? id;

  final String title;
  bool isDone;
  final DateTime? deadline;
  final DateTime? expectedDate;
  final String? repeat;
}

class WeeklyTask {
  WeeklyTask({required this.dayLabel, required this.tasks});

  final String dayLabel;
  final List<TaskItem> tasks;
}
