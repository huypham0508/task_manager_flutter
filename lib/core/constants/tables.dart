import 'package:task_manager_app/data/models/database_model.dart';

abstract class DBConstants {
  static const String DATABASE_NAME = "task_manager.db";
  static const int VER = 4;

  //task
  static const String _tableTasks = 'tasks';
  static DatabaseModel get task => DatabaseModel(
    tableName: _tableTasks,
    createTableQuery: '''
          CREATE TABLE $_tableTasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            status INTEGER,
            due_date TEXT,
            created_at TEXT,
            color INTEGER NOT NULL DEFAULT 4280391411,
            position INTEGER NOT NULL DEFAULT 0
          )
        ''',
  );

  //sub tasks
  static const String _tableSubTasks = 'subtasks';
  static DatabaseModel get subTasks => DatabaseModel(
    tableName: _tableSubTasks,
    createTableQuery: '''
          CREATE TABLE $_tableSubTasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY(task_id) REFERENCES tasks(id) ON DELETE CASCADE
          )
        ''',
  );
}
