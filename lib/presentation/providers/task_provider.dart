import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;

  TaskProvider(this._taskRepository);

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _taskRepository.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    await loadTasks();
  }
}
