import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('farm_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        status TEXT
      )
    ''');
  }

  // Activity operations
  Future<int> createActivity(Activity activity) async =>
      await _database!.insert('activities', activity.toMap());
  Future<List<Activity>> getActivities() async =>
      (await _database!.query(
        'activities',
      )).map((e) => Activity.fromMap(e)).toList();
  Future<int> updateActivity(Activity activity) async =>
      await _database!.update(
        'activities',
        activity.toMap(),
        where: 'id = ?',
        whereArgs: [activity.id],
      );
  Future<int> deleteActivity(int id) async =>
      await _database!.delete('activities', where: 'id = ?', whereArgs: [id]);
}
