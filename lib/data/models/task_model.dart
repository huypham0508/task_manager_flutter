import 'package:intl/intl.dart';

class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  DateTime createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': isCompleted ? 1 : 0,
      'due_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dueDate),
      'created_at': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(createdAt),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['status'] == 1,
      dueDate: DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['due_date']),
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['created_at']),
    );
  }
}
