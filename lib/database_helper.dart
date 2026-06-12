import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserAccount {
  final int? id;
  final String email;
  final String realUsername;
  final String anonymousUsername;
  final String amomimusId;
  final String gender;
  final String registrationDate;
  final bool isDemo;

  UserAccount({
    this.id,
    required this.email,
    required this.realUsername,
    required this.anonymousUsername,
    required this.amomimusId,
    required this.gender,
    required this.registrationDate,
    required this.isDemo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'realUsername': realUsername,
      'anonymousUsername': anonymousUsername,
      'amomimusId': amomimusId,
      'gender': gender,
      'registrationDate': registrationDate,
      'isDemo': isDemo ? 1 : 0,
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'],
      email: map['email'],
      realUsername: map['realUsername'],
      anonymousUsername: map['anonymousUsername'],
      amomimusId: map['amomimusId'],
      gender: map['gender'],
      registrationDate: map['registrationDate'],
      isDemo: map['isDemo'] == 1,
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('amomimus_accounts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  realUsername TEXT NOT NULL,
  anonymousUsername TEXT NOT NULL,
  amomimusId TEXT NOT NULL,
  gender TEXT NOT NULL,
  registrationDate TEXT NOT NULL,
  isDemo INTEGER NOT NULL
)
''');

    // Seed 10 dummy accounts
    List<UserAccount> dummies = [
      UserAccount(email: 'dummy1@amomimus.com', realUsername: 'DummyOne', anonymousUsername: 'Ghost1', amomimusId: '#AMM-101', gender: 'Amo', registrationDate: '01/01/2026', isDemo: false),
      UserAccount(email: 'dummy2@amomimus.com', realUsername: 'DummyTwo', anonymousUsername: 'Shadow2', amomimusId: '#AMM-102', gender: 'Amom', registrationDate: '02/01/2026', isDemo: false),
      UserAccount(email: 'dummy3@amomimus.com', realUsername: 'DummyThree', anonymousUsername: 'Specter3', amomimusId: '#AMM-103', gender: 'Ami', registrationDate: '03/01/2026', isDemo: false),
      UserAccount(email: 'dummy4@amomimus.com', realUsername: 'DummyFour', anonymousUsername: 'Phantom4', amomimusId: '#AMM-104', gender: 'Amo', registrationDate: '04/01/2026', isDemo: false),
      UserAccount(email: 'dummy5@amomimus.com', realUsername: 'DummyFive', anonymousUsername: 'Spirit5', amomimusId: '#AMM-105', gender: 'Amom', registrationDate: '05/01/2026', isDemo: false),
      UserAccount(email: 'dummy6@amomimus.com', realUsername: 'DummySix', anonymousUsername: 'Wraith6', amomimusId: '#AMM-106', gender: 'Ami', registrationDate: '06/01/2026', isDemo: false),
      UserAccount(email: 'dummy7@amomimus.com', realUsername: 'DummySeven', anonymousUsername: 'Ghoul7', amomimusId: '#AMM-107', gender: 'Amo', registrationDate: '07/01/2026', isDemo: false),
      UserAccount(email: 'dummy8@amomimus.com', realUsername: 'DummyEight', anonymousUsername: 'Banshee8', amomimusId: '#AMM-108', gender: 'Amom', registrationDate: '08/01/2026', isDemo: false),
      UserAccount(email: 'dummy9@amomimus.com', realUsername: 'DummyNine', anonymousUsername: 'Poltergeist9', amomimusId: '#AMM-109', gender: 'Ami', registrationDate: '09/01/2026', isDemo: false),
      UserAccount(email: 'dummy10@amomimus.com', realUsername: 'DummyTen', anonymousUsername: 'Apparition10', amomimusId: '#AMM-110', gender: 'Amo', registrationDate: '10/01/2026', isDemo: false),
    ];

    for (var dummy in dummies) {
      await db.insert('users', dummy.toMap());
    }
  }

  Future<int> createUser(UserAccount user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<UserAccount>> getAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users', orderBy: 'id ASC');
    return result.map((json) => UserAccount.fromMap(json)).toList();
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('users');
  }
}
