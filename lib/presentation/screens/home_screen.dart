import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/constants/app_colors.dart';
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
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, themeProvider),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return taskProvider.tasks.isEmpty
              ? _buildEmptyState(context, theme)
              : _buildTaskList(taskProvider, isDarkMode);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskDetailScreen()),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeProvider themeProvider) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(FlutterI18n.translate(context, "Task Manager")),
      actions: [
        _buildFilterMenu(context),
        IconButton(
          onPressed:
              () => themeProvider.toggleTheme(
                themeProvider.themeMode != ThemeMode.dark,
              ),
          icon: Icon(
            themeProvider.themeMode == ThemeMode.dark
                ? Icons.sunny
                : Icons.dark_mode,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterMenu(BuildContext context) {
    return PopupMenuButton<TaskFilter>(
      onSelected: (value) => context.read<TaskProvider>().updateFilter(value),
      itemBuilder:
          (context) => [
            _buildFilterMenuItem(context, TaskFilter.all, "All tasks"),
            _buildFilterMenuItem(
              context,
              TaskFilter.incomplete,
              "Incomplete tasks",
            ),
            _buildFilterMenuItem(
              context,
              TaskFilter.completed,
              "Completed tasks",
            ),
          ],
      icon: const Icon(Icons.filter_list),
    );
  }

  PopupMenuItem<TaskFilter> _buildFilterMenuItem(
    BuildContext context,
    TaskFilter value,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Text(FlutterI18n.translate(context, label)),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Text(
        FlutterI18n.translate(context, "No tasks available"),
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget _buildTaskList(TaskProvider taskProvider, bool isDarkMode) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return _buildDismissibleTask(
          context,
          taskProvider,
          task,
          index,
          isDarkMode,
        );
      },
      onReorder: taskProvider.moveTask,
    );
  }

  Widget _buildDismissibleTask(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
    int index,
    bool isDarkMode,
  ) {
    return Dismissible(
      key: Key('${task.id ?? index}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(isDarkMode),
      confirmDismiss:
          (direction) => _confirmDelete(context, taskProvider, task),
      onDismissed: (direction) => taskProvider.deleteTask(task.id!),
      child: TaskTile(
        task: task,
        onTap: () => taskProvider.toggleTaskCompletion(task),
      ),
    );
  }

  Widget _buildDismissBackground(bool isDarkMode) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        Icons.delete,
        color: isDarkMode ? AppColors.darkText : Colors.black,
        size: 28,
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
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      FlutterI18n.translate(context, "Remove"),
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
