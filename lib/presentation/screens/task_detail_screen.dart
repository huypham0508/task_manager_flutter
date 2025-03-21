import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/utils/custom_snackbar.dart';
import 'package:task_manager_app/core/utils/helper.dart';
import 'package:task_manager_app/presentation/components/color_picker.dart';
import 'package:task_manager_app/presentation/components/subtask_list.dart';

import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? task;
  const TaskDetailScreen({super.key, this.task});
  @override
  TaskDetailScreenState createState() => TaskDetailScreenState();
}

class TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDueDate;
  late Color _selectedColor;
  bool _isCompleted = false;
  List<SubTask> _subTasks = [];

  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.deepPurple,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDueDate = widget.task?.dueDate ?? DateTime.now();
    _isCompleted = widget.task?.isCompleted ?? false;
    _subTasks = widget.task?.subTasks ?? [];
    _selectedColor = widget.task?.color ?? Colors.blue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _addSubTask() {
    setState(() {
      _subTasks.add(SubTask(title: "Công việc phụ mới", isCompleted: false));
    });
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTasks.removeAt(index);
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final existingSubTasks = widget.task?.subTasks ?? [];

      final deletedSubTasks =
          existingSubTasks
              .where(
                (oldSubTask) =>
                    !_subTasks.any(
                      (newSubTask) => newSubTask.id == oldSubTask.id,
                    ),
              )
              .toList();

      for (var subTask in deletedSubTasks) {
        taskProvider.deleteTask(subTask.id!);
      }

      final task = Task(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted:
            _subTasks.isEmpty
                ? _isCompleted
                : _subTasks.every((st) => st.isCompleted),
        dueDate: _selectedDueDate,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        subTasks: _subTasks,
        color: _selectedColor,
      );

      if (widget.task == null) {
        taskProvider.addTask(task);
        CustomSnackbar.show(context, 'Công việc đã được thêm!');
      } else {
        taskProvider.updateTask(task);
        CustomSnackbar.show(context, 'Công việc đã được cập nhật!');
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null
              ? FlutterI18n.translate(context, "Add Task")
              : FlutterI18n.translate(context, "Edit Task"),
        ),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).deleteTask(widget.task!.id!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: FlutterI18n.translate(
                      context,
                      "Write a title...",
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.black.withValues(alpha: 0.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return FlutterI18n.translate(
                        context,
                        "Title cannot be empty",
                      );
                    }
                    if (value.length < 3) {
                      return FlutterI18n.translate(
                        context,
                        "Title must be at least 3 characters",
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: FlutterI18n.translate(context, "Write a note..."),
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.black.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return FlutterI18n.translate(
                        context,
                        "Description cannot be empty",
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    FlutterI18n.translate(context, "Choose color"),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ColorPicker(
                  selectedColor: _selectedColor,
                  colorOptions: _colorOptions,
                  onColorSelected: _selectColor,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      FlutterI18n.translate(context, "Due date"),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDueDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              Helper.formatTime(_selectedDueDate),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,

                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SubTaskListWidget(
                  subTasks: _subTasks,
                  onDeleteSubTask: _removeSubTask,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _addSubTask,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        FlutterI18n.translate(context, "Add a subtask"),
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: Text(FlutterI18n.translate(context, "Save")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
