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
