import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/report_model.dart';
import '../helpers/benevolent_calculator.dart';

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

    try {
      _accounts = await DatabaseHelper.instance.getAllUsers();
    } catch (e) {
      // sqflite not supported on web — use empty list
      print("==== DB LOAD SKIPPED (possibly web): $e ====");
      _accounts = [];
    }
    
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
    try {
      int id = await DatabaseHelper.instance.createUser(newUser);
      await loadAccounts();
      
      // Set the newly created user as the active user
      final createdUser = _accounts.firstWhere((acc) => acc.id == id, orElse: () => _accounts.last);
      switchAccount(createdUser);
    } catch (e) {
      // sqflite not supported on web — create temporary in-memory account
      print("==== DB REGISTER SKIPPED (possibly web): $e ====");
      _currentUser = newUser;
      _accounts.add(newUser);
      notifyListeners();
    }
  }

  void switchAccount(UserAccount account) {
    _currentUser = account;
    notifyListeners();
  }

  Future<void> deleteAccount(String email) async {
    try {
      await DatabaseHelper.instance.deleteUser(email);
    } catch (e) {
      print("==== DB DELETE SKIPPED (possibly web): $e ====");
    }
    
    await loadAccounts();
    if (_currentUser?.email == email) {
      if (_accounts.isNotEmpty) {
        _currentUser = _accounts.first;
      } else {
        _currentUser = null;
      }
      notifyListeners();
    }
  }

  Future<void> updateBio(String newBio) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(bio: newBio);

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
  }

  Future<void> updateCoins(int amountDelta, {bool updateTimestamp = false}) async {
    if (_currentUser == null) return;
    
    final newCoins = (_currentUser!.coins + amountDelta).clamp(0, 999999);
    UserAccount updatedUser = _currentUser!.copyWith(coins: newCoins);
    
    if (updateTimestamp) {
      updatedUser = updatedUser.copyWith(lastRedeemed: DateTime.now().toIso8601String());
    }
    
    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }
    
    _currentUser = updatedUser;
    
    // Update the list as well
    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }
    
    notifyListeners();
  }

  Future<void> submitReport(String targetId, ReportCategory category, {bool isChatBubbleReport = false}) async {
    String normalizedTargetId = targetId;
    final match = RegExp(r'#(?:YOU|AMO|AMI|AMOM)-(\d+)').firstMatch(targetId);
    if (match != null) {
      int num = int.parse(match.group(1)!);
      if (num == 100) num = 110;
      normalizedTargetId = '#AMM-$num';
    } else {
      normalizedTargetId = targetId.replaceAll(RegExp(r'#AM[OMI]+-'), '#AMM-');
    }
    final userIndex = _accounts.indexWhere((acc) => acc.amomimusId == targetId || acc.amomimusId == normalizedTargetId || acc.id.toString() == targetId);
    if (userIndex != -1) {
      var user = _accounts[userIndex];
      
      final newStatus = BenevolentCalculator.addReportToUser(
        currentPoints: user.benevolentPoints,
        category: category,
        isChatBubbleReport: isChatBubbleReport,
        currentIndicator: user.indicator,
      );
      
      final updatedUser = user.copyWith(
        reportedCount: user.reportedCount + 1,
        benevolentPoints: newStatus.points,
        indicator: newStatus.indicator.name,
      );
      
      try {
        await DatabaseHelper.instance.updateUser(updatedUser);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: $e ====");
      }
      
      _accounts[userIndex] = updatedUser;
      
      if (_currentUser?.id == updatedUser.id) {
        _currentUser = updatedUser;
      }
      
      notifyListeners();
    }
  }

  Future<void> blockUser(String userId) async {
    if (_currentUser == null) return;
    
    if (!_currentUser!.blockedUsers.contains(userId)) {
      final updatedList = List<String>.from(_currentUser!.blockedUsers)..add(userId);
      final updatedUser = _currentUser!.copyWith(blockedUsers: updatedList);
      
      try {
        await DatabaseHelper.instance.updateUser(updatedUser);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: $e ====");
      }
      
      _currentUser = updatedUser;
      
      final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
      if (index != -1) {
        _accounts[index] = updatedUser;
      }
      
      notifyListeners();
    }
  }

  Future<void> hideFeed(String feedId) async {
    if (_currentUser == null) return;
    
    if (!_currentUser!.hiddenFeeds.contains(feedId)) {
      final updatedList = List<String>.from(_currentUser!.hiddenFeeds)..add(feedId);
      final updatedUser = _currentUser!.copyWith(hiddenFeeds: updatedList);
      
      try {
        await DatabaseHelper.instance.updateUser(updatedUser);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: $e ====");
      }
      
      _currentUser = updatedUser;
      
      final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
      if (index != -1) {
        _accounts[index] = updatedUser;
      }
      
      notifyListeners();
    }
  }

  Future<void> incrementChatRequestCount() async {
    if (_currentUser == null) return;
    
    final today = DateTime.now().toIso8601String().split('T').first;
    final lastReqDate = _currentUser!.lastChatRequestDate?.split('T').first;
    int newCount = _currentUser!.dailyChatRequestsSent;
    
    if (lastReqDate != today) {
      newCount = 1;
    } else {
      newCount += 1;
    }
    
    final updatedUser = _currentUser!.copyWith(
      dailyChatRequestsSent: newCount,
      lastChatRequestDate: DateTime.now().toIso8601String(),
    );
    
    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }
    
    _currentUser = updatedUser;
    
    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }
    
    notifyListeners();
  }
}
