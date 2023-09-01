import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // If the database is not yet initialized, create and open it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'registration.db');

    return await openDatabase(dbPath, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE registration(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dob TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertRegistration(Map<String, dynamic> registration) async {
    final db = await database;
    return await db.insert('registration', registration);
  }

  Future<List<Map<String, dynamic>>> getAllRegistrations() async {
    final db = await database;
    return await db.query('registration');
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('registration');
  }

  Future<Map<String, dynamic>?> getRegistrationByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'registration',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }
}
