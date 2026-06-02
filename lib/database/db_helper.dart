import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/tugas11_user_register_sql.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'amomimus.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            full_name TEXT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            favorite_character TEXT
          )
        ''');
      },
    );
  }

  Future<bool> registerUser(UserModelSql pengguna) async {
    final db = await database;
    try {
      print(
        "==== DEBUG DB: Mencoba mendaftarkan email: ${pengguna.email} ====",
      );

      // Proses insert CUMA SEKALI saja
      final int result = await db.insert('users', pengguna.toMap());

      if (result > 0) {
        print("==== DEBUG DB: Registrasi BERHASIL dimasukkan ke SQLite ====");
        return true;
      } else {
        print("==== DEBUG DB: Registrasi GAGAL dimasukkan ke SQLite ====");
        return false;
      }
    } catch (e) {
      // Kalau ada error (misal nama kolom salah di toMap), bakal ketahuan di sini
      print("Error saat register: $e");
      return false;
    }
  }

  Future<UserModelSql?> loginUser(String email, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> allUsers = await db.query('users');
    print('==== DEBUG: ISI DATABASE USERS ====');
    print(allUsers);
    print('===================================');
    print('Input Login -> Email: $email | Password: $password');

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return UserModelSql.fromMap(results.first);
    }
    return null;
  }

  Future<List<UserModelSql>> getAllUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return UserModelSql.fromMap(maps[i]);
    });
  }
}
