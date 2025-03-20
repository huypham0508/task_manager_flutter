import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => onCreate(db),
    );
  }

  void onCreate(Database db);

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
