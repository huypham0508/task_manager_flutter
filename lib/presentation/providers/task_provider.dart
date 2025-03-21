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
    final existingSubTasks = await _taskRepository.getSubTasks(task.id!);
    final deletedSubTasks =
        existingSubTasks
            .where(
              (oldSubTask) =>
                  !task.subTasks.any(
                    (newSubTask) => newSubTask.id == oldSubTask.id,
                  ),
            )
            .toList();

    for (var subTask in deletedSubTasks) {
      await _taskRepository.deleteSubTask(subTask.id!);
    }

    for (var subTask in task.subTasks) {
      if (subTask.id == null) {
        await _taskRepository.insertSubTask(subTask.copyWith(taskId: task.id));
      } else {
        await _taskRepository.updateSubTask(subTask);
      }
    }

    await _taskRepository.updateTask(task);
    await loadTasks();
    notifyListeners();
  }

  void updateSubTask(SubTask subTask) async {
    await _taskRepository.updateSubTask(subTask);
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    updateTask(updatedTask);
  }

  void moveTask(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i] = _tasks[i].copyWith(position: i);
      await _taskRepository.updateTask(_tasks[i]);
    }
    notifyListeners();
  }
}
