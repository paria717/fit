import 'package:fitapp/model/step_entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StepDatabase {
  static final StepDatabase instance = StepDatabase._init();
  static Database? _database;
  StepDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database == _initDB('steps.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE steps (
        id INTEGER PRIMARY KEY,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL)  
        ''');
  }

  Future<void> insertOrUpdateSteps(int steps, String date) async {
    final db = await instance.database;
    final existing = await db.query('steps', where: 'date =?', whereArgs: [date]);
    if (existing.isNotEmpty) {
      await db.update('steps', {'steps': steps}, where: 'date=?', whereArgs: [date]);
    } else {
      db.insert('steps', {'steps': steps, 'date': date});
    }
  }

  Future<StepEntryModel?> getStepsForDate(String date) async {
    final db = await instance.database;
    final result = await db.query('steps', where: 'date=?', whereArgs: [date]);
    if (result.isNotEmpty) {
      return StepEntryModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<StepEntryModel>> getLast7Days() async {
    final db = await instance.database;
    final result = await db.query('steps', orderBy: 'date DESC', limit: 7);
    return result
        .map(
          (e) => StepEntryModel.fromMap(e),
        )
        .toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
