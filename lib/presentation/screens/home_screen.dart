import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/presentation/components/task_tile.dart';
import 'package:task_manager_app/presentation/providers/theme_provider.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme(
                !(themeProvider.themeMode == ThemeMode.dark),
              );
            },
            icon:
                themeProvider.themeMode == ThemeMode.dark
                    ? Icon(Icons.sunny)
                    : Icon(Icons.dark_mode),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Text(
                "Chưa có công việc nào",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return Dismissible(
                key: Key('${task.id ?? index}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 28,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await _confirmDelete(context, taskProvider, task);
                },
                onDismissed: (direction) {
                  taskProvider.deleteTask(task.id!);
                },
                child: TaskTile(
                  task: task,
                  onTap: () => taskProvider.toggleTaskCompletion(task),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              taskProvider.moveTask(oldIndex, newIndex);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskDetailScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Xác nhận"),
                content: Text(
                  "Bạn có chắc chắn muốn xóa công việc '${task.title}'?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "Xóa",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
