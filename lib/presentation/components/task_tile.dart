import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: Checkbox(value: task.isCompleted, onChanged: (value) {}),
    );
  }
}
