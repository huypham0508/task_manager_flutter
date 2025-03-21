import 'package:sqflite/sqflite.dart';
import 'package:task_manager_app/core/constants/tables.dart';
import 'package:task_manager_app/core/services/database_service.dart';
import 'package:task_manager_app/data/models/sub_task_model.dart';
import '../models/task_model.dart';

class TaskRepository extends DatabaseService {
  final _taskName = DBConstants.task.tableName;
  final _subTasksName = DBConstants.subTasks.tableName;

  @override
  void onCreate(Database db) async {
    db.execute(DBConstants.subTasks.createTableQuery);
    db.execute(DBConstants.task.createTableQuery);
    //dummy data
    await db.execute('''
    INSERT INTO tasks (title, description, status, due_date, created_at, color, position)
    VALUES
      ('Task 1', 'Description for Task 1', 0, '2025-03-25T12:00:00.000', '2025-03-21T10:08:08.764', 0xFF2196F3, 0),
      ('Task 2', 'Description for Task 2', 1, '2025-03-26T15:30:00.000', '2025-03-21T11:00:00.000', 0xFFE91E63, 1),
      ('Task 3', 'Description for Task 3', 0, '2025-03-27T09:45:00.000', '2025-03-21T12:30:00.000', 0xFFFF9800, 2);
  ''');

    await db.execute('''
    INSERT INTO subtasks (task_id, title, isCompleted)
    VALUES
      (1, 'Subtask 1 for Task 1', 0),
      (1, 'Subtask 2 for Task 1', 1),
      (2, 'Subtask 1 for Task 2', 0),
      (3, 'Subtask 1 for Task 3', 1),
      (3, 'Subtask 2 for Task 3', 0);
  ''');
  }

  @override
  void onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(
      'ALTER TABLE $_taskName ADD COLUMN color INTEGER NOT NULL DEFAULT 4280391411',
    );
    final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='subtasks'",
    );
    await db.execute(
      'ALTER TABLE tasks ADD COLUMN position INTEGER NOT NULL DEFAULT 0',
    );

    if (result.isEmpty) {
      await db.execute(DBConstants.subTasks.createTableQuery);
    }
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query(_taskName, orderBy: 'position ASC');
    List<Task> tasks = result.map((json) => Task.fromMap(json)).toList();

    for (var task in tasks) {
      task.subTasks = await getSubTasks(task.id!);
    }
    return tasks;
  }

  Future<List<SubTask>> getSubTasks(int taskId) async {
    final db = await database;
    final result = await db.query(
      _subTasksName,
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
    return result.map((json) => SubTask.fromMap(json)).toList();
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    int taskId = await db.insert(_taskName, task.toMap());
    for (var subTask in task.subTasks) {
      await insertSubTask(subTask.copyWith(taskId: taskId));
    }
  }

  Future<void> insertSubTask(SubTask subTask) async {
    final db = await database;
    await db.insert(_subTasksName, subTask.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      _taskName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> updateSubTask(SubTask subTask) async {
    final db = await database;
    await db.update(
      _subTasksName,
      subTask.toMap(),
      where: 'id = ?',
      whereArgs: [subTask.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(_taskName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteSubTask(int id) async {
    final db = await database;
    await db.delete(_subTasksName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getFilteredTasks({bool? isCompleted}) async {
    final db = await database;
    final result = await db.query(
      DBConstants.task.tableName,
      where: isCompleted != null ? 'status = ?' : null,
      whereArgs: isCompleted != null ? [isCompleted ? 1 : 0] : null,
      orderBy: 'position ASC',
    );
    List<Task> tasks = result.map((json) => Task.fromMap(json)).toList();

    for (var task in tasks) {
      task.subTasks = await getSubTasks(task.id!);
    }
    return tasks;
  }
}
