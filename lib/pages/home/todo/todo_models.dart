import "package:flutter/material.dart";

class TaskItem {
  TaskItem({
    required this.title,
    this.isDone = false,
    this.deadline,
    this.expectedDate,
  });

  final String title;
  bool isDone;
  final DateTime? deadline;
  final DateTime? expectedDate;
}

class WeeklyTask {
  WeeklyTask({required this.dayLabel, required this.tasks});

  final String dayLabel;
  final List<TaskItem> tasks;
}
