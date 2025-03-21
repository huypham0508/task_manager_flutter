import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_colors.dart';
import 'package:task_manager_app/data/models/sub_task_model.dart';

class SubTaskItem extends StatelessWidget {
  final SubTask subTask;
  final Function(bool?) onToggleCompleted;
  final Function(String)? onTitleChanged;
  final VoidCallback? onDelete;

  const SubTaskItem({
    super.key,
    required this.subTask,
    required this.onToggleCompleted,
    this.onTitleChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Checkbox(
            shape: const CircleBorder(),
            checkColor: AppColors.darkText,
            activeColor: AppColors.green,
            value: subTask.isCompleted,
            onChanged: onToggleCompleted,
          ),
          Expanded(
            child: TextFormField(
              readOnly: onTitleChanged == null,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              initialValue: subTask.title,
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: onTitleChanged,
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.red),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
