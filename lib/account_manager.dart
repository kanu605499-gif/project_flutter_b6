import 'package:flutter/material.dart';
import 'database_helper.dart';

class AccountManager extends ChangeNotifier {
  List<UserAccount> _accounts = [];
  UserAccount? _currentUser;
  bool _isLoading = true;

  List<UserAccount> get accounts => _accounts;
  UserAccount? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> loadAccounts() async {
    _isLoading = true;
    notifyListeners();

    _accounts = await DatabaseHelper.instance.getAllUsers();
    
    // Auto-select the first account if none is selected
    if (_accounts.isNotEmpty && _currentUser == null) {
      // By default, select the first demo account if available, else first dummy
      _currentUser = _accounts.firstWhere((acc) => acc.isDemo, orElse: () => _accounts.first);
    } else if (_currentUser != null) {
      // Refresh current user object from the loaded list
      final matchingAccounts = _accounts.where((acc) => acc.id == _currentUser!.id);
      if (matchingAccounts.isNotEmpty) {
        _currentUser = matchingAccounts.first;
      } else {
        _currentUser = _accounts.isNotEmpty ? _accounts.first : null;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerAndLogin(UserAccount newUser) async {
    int id = await DatabaseHelper.instance.createUser(newUser);
    await loadAccounts();
    
    // Set the newly created user as the active user
    final createdUser = _accounts.firstWhere((acc) => acc.id == id, orElse: () => _accounts.last);
    switchAccount(createdUser);
  }

  void switchAccount(UserAccount account) {
    _currentUser = account;
    notifyListeners();
  }
}
