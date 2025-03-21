import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/utils/helper.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/presentation/components/sub_task_Item.dart';
import 'package:task_manager_app/presentation/providers/task_provider.dart';
import 'package:task_manager_app/presentation/screens/task_detail_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskTile({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTaskDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: task.color.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: task.color..withValues(alpha: 0.4),
              blurRadius: 2,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            task.subTasks.isNotEmpty
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: CircularProgressIndicator(
                        value: task.completionPercentage / 100,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                    Text(
                      "${task.completionPercentage.toInt()}%",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                )
                : GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                      color:
                          task.isCompleted ? Colors.green : Colors.transparent,
                    ),
                    child:
                        task.isCompleted
                            ? const Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: Colors.white,
                            )
                            : null,
                  ),
                ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration:
                          task.subTasks.isEmpty && task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskDetailScreen(task: task),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (task.subTasks.isEmpty) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: FlutterI18n.translate(context, "Task Details"),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: theme.secondaryHeaderColor.withAlpha(50),
                body: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        if (task.description.isNotEmpty) ...[
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              FlutterI18n.translate(
                                context,
                                "Due Date: {time}",
                                translationParams: {
                                  "time": Helper.formatTime(task.dueDate),
                                },
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1),
                        ElevatedButton.icon(
                          onPressed: () {
                            taskProvider.toggleTaskCompletion(task);
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            task.isCompleted ? Icons.close : Icons.check,
                            color: Colors.white,
                          ),
                          label: Text(
                            task.isCompleted
                                ? FlutterI18n.translate(
                                  context,
                                  "Not Completed",
                                )
                                : FlutterI18n.translate(
                                  context,
                                  "Mark as Completed",
                                ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                task.isCompleted ? Colors.red : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            FlutterI18n.translate(context, "Cancel"),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: FlutterI18n.translate(context, "Task Details"),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: theme.secondaryHeaderColor.withAlpha(50),
                body: SafeArea(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          if (task.description.isNotEmpty) ...[
                            Text(
                              task.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                FlutterI18n.translate(
                                  context,
                                  "Due Date: {time}",
                                  translationParams: {
                                    "time": Helper.formatTime(task.dueDate),
                                  },
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (task.subTasks.isNotEmpty) ...[
                            const Divider(thickness: 1),
                            const SizedBox(height: 5),
                            Text(
                              FlutterI18n.translate(context, "Subtask List"),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                itemCount: task.subTasks.length,
                                itemBuilder: (context, index) {
                                  final subTask = task.subTasks[index];
                                  return SubTaskItem(
                                    subTask: subTask,
                                    onToggleCompleted: (value) {
                                      setState(() {
                                        task.subTasks[index] = subTask.copyWith(
                                          isCompleted: value!,
                                        );
                                      });
                                      taskProvider.updateSubTask(
                                        task.subTasks[index],
                                      );
                                      if (task.subTasks.every(
                                        (st) => st.isCompleted,
                                      )) {
                                        taskProvider.updateTask(
                                          task.copyWith(isCompleted: true),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 15),

                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              FlutterI18n.translate(context, "Cancel"),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
