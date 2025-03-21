import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager_app/core/constants/tables.dart';

abstract class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), DBConstants.DATABASE_NAME);
    return await openDatabase(
      path,
      version: DBConstants.VER,
      onCreate: (db, version) => onCreate(db),
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < DBConstants.VER) {
          return onUpgrade(db, oldVersion, newVersion);
        }
      },
    );
  }

  void onCreate(Database db);
  void onUpgrade(Database db, int oldVersion, int newVersion);

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  static Future<void> clearDatabase() async {
    final dbPath = join(await getDatabasesPath(), DBConstants.DATABASE_NAME);
    await deleteDatabase(dbPath);
    print("📢 Database cleared! It will be recreated on next launch.");
  }
}
