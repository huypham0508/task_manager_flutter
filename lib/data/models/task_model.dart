import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubTask {
  int? id;
  int? taskId;
  String title;
  bool isCompleted;

  SubTask({
    this.id,
    this.taskId,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      id: map['id'],
      taskId: map['task_id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  SubTask copyWith({String? title, int? taskId, bool? isCompleted}) {
    return SubTask(
      id: id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  DateTime createdAt;
  Color color;
  List<SubTask> subTasks;
  int position;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
    required this.createdAt,
    this.color = const Color(0xFF2196F3),
    this.subTasks = const [],
    this.position = 0,
  });

  double get completionPercentage {
    if (subTasks.isEmpty) return isCompleted ? 100.0 : 0.0;
    int completed = subTasks.where((subTask) => subTask.isCompleted).length;
    return (completed / subTasks.length) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': isCompleted ? 1 : 0,
      'due_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dueDate),
      'created_at': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(createdAt),
      'color': color.toARGB32(),
      'position': position,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['status'] == 1,
      dueDate: DateTime.parse(map['due_date']),
      createdAt: DateTime.parse(map['created_at']),
      color: Color(map['color'] ?? 0xFF2196F3),
      position: map['position'] ?? 0,
      subTasks: [],
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
    Color? color,
    List<SubTask>? subTasks,
    int? position,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      subTasks: subTasks ?? this.subTasks,
      position: position ?? this.position,
    );
  }
}
