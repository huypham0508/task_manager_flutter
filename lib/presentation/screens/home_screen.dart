import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/enum/task_filter.dart';
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
        title: Text(FlutterI18n.translate(context, "Task Manager")),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (value) {
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).updateFilter(value);
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: TaskFilter.all,
                    child: Text(FlutterI18n.translate(context, "All tasks")),
                  ),
                  PopupMenuItem(
                    value: TaskFilter.incomplete,
                    child: Text(
                      FlutterI18n.translate(context, "Incomplete tasks"),
                    ),
                  ),
                  PopupMenuItem(
                    value: TaskFilter.completed,
                    child: Text(
                      FlutterI18n.translate(context, "Completed tasks"),
                    ),
                  ),
                ],
            icon: const Icon(Icons.filter_list),
          ),
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
                FlutterI18n.translate(context, "No tasks available"),
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
                title: Text(FlutterI18n.translate(context, "Confirm")),
                content: Text(
                  FlutterI18n.translate(
                    context,
                    "Are you sure you want to delete the task {taskTitle}?",
                    translationParams: {"taskTitle": task.title},
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(FlutterI18n.translate(context, "Cancel")),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      FlutterI18n.translate(context, "Remove"),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
