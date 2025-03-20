import 'package:sqflite/sqflite.dart';
import 'package:task_manager_app/core/constants/tables.dart';
import 'package:task_manager_app/core/services/database_service.dart';
import '../models/task_model.dart';

class TaskRepository extends DatabaseService {
  final _tableName = DBConstants.task.tableName;

  @override
  void onCreate(Database db) {
    db.execute(DBConstants.task.createTableQuery);
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(_tableName, task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
