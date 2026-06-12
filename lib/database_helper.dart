import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';
export 'models/user_model.dart';
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static const String _accountsKey = 'amomimus_app_accounts';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<void> _seedDummiesIfNeeded(SharedPreferences prefs) async {
    final String? data = prefs.getString(_accountsKey);
    if (data == null || data.isEmpty) {
      List<UserAccount> dummies = [
        UserAccount(id: 1, email: 'dummy1@amomimus.com', realUsername: 'DummyOne', anonymousUsername: 'Ghost1', customUsername: null, amomimusId: '#AMM-101', gender: 'Amo', registrationDate: '01/01/2026', isDemo: false),
        UserAccount(id: 2, email: 'dummy2@amomimus.com', realUsername: 'DummyTwo', anonymousUsername: 'Shadow2', customUsername: null, amomimusId: '#AMM-102', gender: 'Amom', registrationDate: '02/01/2026', isDemo: false),
        UserAccount(id: 3, email: 'dummy3@amomimus.com', realUsername: 'DummyThree', anonymousUsername: 'Specter3', customUsername: null, amomimusId: '#AMM-103', gender: 'Ami', registrationDate: '03/01/2026', isDemo: false),
        UserAccount(id: 4, email: 'dummy4@amomimus.com', realUsername: 'DummyFour', anonymousUsername: 'Phantom4', customUsername: null, amomimusId: '#AMM-104', gender: 'Amo', registrationDate: '04/01/2026', isDemo: false),
        UserAccount(id: 5, email: 'dummy5@amomimus.com', realUsername: 'DummyFive', anonymousUsername: 'Spirit5', customUsername: null, amomimusId: '#AMM-105', gender: 'Amom', registrationDate: '05/01/2026', isDemo: false),
        UserAccount(id: 6, email: 'dummy6@amomimus.com', realUsername: 'DummySix', anonymousUsername: 'Wraith6', customUsername: null, amomimusId: '#AMM-106', gender: 'Ami', registrationDate: '06/01/2026', isDemo: false),
        UserAccount(id: 7, email: 'dummy7@amomimus.com', realUsername: 'DummySeven', anonymousUsername: 'Ghoul7', customUsername: null, amomimusId: '#AMM-107', gender: 'Amo', registrationDate: '07/01/2026', isDemo: false),
        UserAccount(id: 8, email: 'dummy8@amomimus.com', realUsername: 'DummyEight', anonymousUsername: 'Banshee8', customUsername: null, amomimusId: '#AMM-108', gender: 'Amom', registrationDate: '08/01/2026', isDemo: false),
        UserAccount(id: 9, email: 'dummy9@amomimus.com', realUsername: 'DummyNine', anonymousUsername: 'Poltergeist9', customUsername: null, amomimusId: '#AMM-109', gender: 'Ami', registrationDate: '09/01/2026', isDemo: false),
        UserAccount(id: 10, email: 'dummy10@amomimus.com', realUsername: 'DummyTen', anonymousUsername: 'Apparition10', customUsername: null, amomimusId: '#AMM-110', gender: 'Amo', registrationDate: '10/01/2026', isDemo: false),
      ];
      await prefs.setString(_accountsKey, jsonEncode(dummies.map((e) => e.toMap()).toList()));
    }
  }

  Future<int> createUser(UserAccount user) async {
    final prefs = await _prefs;
    await _seedDummiesIfNeeded(prefs);
    
    final accounts = await getAllUsers();
    final int newId = (accounts.isEmpty ? 0 : accounts.last.id ?? 0) + 1;
    
    final newUser = user.copyWith(id: newId);
    accounts.add(newUser);
    
    await prefs.setString(_accountsKey, jsonEncode(accounts.map((e) => e.toMap()).toList()));
    return newId;
  }

  Future<void> deleteUser(String email) async {
    final prefs = await _prefs;
    final accounts = await getAllUsers();
    
    // Remove the user matching the email
    accounts.removeWhere((acc) => acc.email == email);
    
    await prefs.setString(_accountsKey, jsonEncode(accounts.map((e) => e.toMap()).toList()));
  }

  Future<void> updateUser(UserAccount user) async {
    final prefs = await _prefs;
    final accounts = await getAllUsers();
    final index = accounts.indexWhere((acc) => acc.email == user.email);
    if (index != -1) {
      accounts[index] = user;
      await prefs.setString(_accountsKey, jsonEncode(accounts.map((e) => e.toMap()).toList()));
    }
  }

  Future<List<UserAccount>> getAllUsers() async {
    final prefs = await _prefs;
    await _seedDummiesIfNeeded(prefs);
    
    final String? data = prefs.getString(_accountsKey);
    if (data == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((json) => UserAccount.fromMap(json)).toList();
    } catch (e) {
      print('Error decoding accounts: $e');
      return [];
    }
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(_accountsKey);
  }
}
