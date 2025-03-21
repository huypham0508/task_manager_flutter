import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/presentation/components/sub_task_item.dart';

class SubTaskListWidget extends StatefulWidget {
  final List<SubTask> subTasks;
  final Function(int) onDeleteSubTask;

  const SubTaskListWidget({
    super.key,
    required this.subTasks,
    required this.onDeleteSubTask,
  });

  @override
  State<SubTaskListWidget> createState() => _SubTaskListWidgetState();
}

class _SubTaskListWidgetState extends State<SubTaskListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Danh sách công việc phụ:",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.subTasks.length,
          itemBuilder: (context, index) {
            return SubTaskItem(
              subTask: widget.subTasks[index],
              onToggleCompleted: (value) {
                setState(() {
                  widget.subTasks[index] = widget.subTasks[index].copyWith(
                    isCompleted: value!,
                  );
                });
              },
              onTitleChanged: (value) {
                setState(() {
                  widget.subTasks[index] = widget.subTasks[index].copyWith(
                    title: value,
                  );
                });
              },
              onDelete: () => widget.onDeleteSubTask(index),
            );
          },
        ),
      ],
    );
  }
}
