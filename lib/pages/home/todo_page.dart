import 'package:flutter/material.dart';
import 'package:watnow_autumn_team3_front/models/todo.dart';

class TodoPage extends StatelessWidget {
  final List<Todo> todos;
  final void Function(int, bool?) onToggle;

  const TodoPage({
    super.key,
    required this.todos,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return CheckboxListTile(
          title: Text(todo.title),
          value: todo.isDone,
          onChanged: (v) => onToggle(index, v),
        );
      },
    );
  }
}
