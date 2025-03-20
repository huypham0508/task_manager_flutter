import 'package:task_manager_app/data/models/database_model.dart';

abstract class DBConstants {
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
            created_at TEXT
          )
        ''',
  );
}
