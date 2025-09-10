import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // Insertar usuario
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Buscar usuario por email
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  // Validar login
  Future<User?> validateLogin(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }
}
