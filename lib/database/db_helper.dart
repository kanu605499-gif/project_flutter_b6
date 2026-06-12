import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/tugas11_user_register_sql.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static const String _usersKey = 'amomimus_users';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<List<UserModelSql>> getAllUsers() async {
    final prefs = await _prefs;
    final String? usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(usersJson);
      return decodedList.map((item) => UserModelSql.fromMap(item)).toList();
    } catch (e) {
      print('Error decoding users: $e');
      return [];
    }
  }

  Future<bool> registerUser(UserModelSql pengguna) async {
    try {
      print("==== DEBUG DB: Mencoba mendaftarkan email: ${pengguna.email} ====");
      
      final users = await getAllUsers();
      
      // Check if email already exists
      if (users.any((u) => u.email == pengguna.email)) {
        print("==== DEBUG DB: Registrasi GAGAL - Email sudah terdaftar ====");
        return false;
      }

      // Assign an ID based on the current length + 1
      final newUser = pengguna.copyWith(id: users.length + 1);
      users.add(newUser);

      final prefs = await _prefs;
      final success = await prefs.setString(
        _usersKey, 
        jsonEncode(users.map((u) => u.toMap()).toList())
      );

      if (success) {
        print("==== DEBUG DB: Registrasi BERHASIL dimasukkan ke SharedPreferences ====");
        return true;
      } else {
        print("==== DEBUG DB: Registrasi GAGAL disimpan ====");
        return false;
      }
    } catch (e) {
      print("Error saat register: $e");
      return false;
    }
  }

  Future<UserModelSql?> loginUser(String email, String password) async {
    final users = await getAllUsers();
    
    print('==== DEBUG: ISI DATABASE USERS ====');
    print(users.map((u) => u.toMap()).toList());
    print('===================================');
    print('Input Login -> Email: $email | Password: $password');

    try {
      return users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      // firstWhere throws StateError if no element is found
      return null;
    }
  }

  Future<int> deleteUser(String email) async {
    final users = await getAllUsers();
    final initialLength = users.length;
    
    users.removeWhere((u) => u.email == email);
    
    if (users.length < initialLength) {
      final prefs = await _prefs;
      await prefs.setString(
        _usersKey, 
        jsonEncode(users.map((u) => u.toMap()).toList())
      );
      return 1; // 1 row deleted
    }
    return 0; // 0 rows deleted
  }
}
