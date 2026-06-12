import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationManager extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  static const String _notificationsKey = 'amomimus_app_notifications';

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_notificationsKey);

    if (data != null && data.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        _notifications = decoded.map((json) => NotificationModel.fromJson(json)).toList();
      } catch (e) {
        print('Error decoding notifications: \$e');
        _notifications = [];
      }
    } else {
      _notifications = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationsKey, jsonEncode(_notifications.map((e) => e.toJson()).toList()));
  }

  Future<void> addNotification(NotificationModel notification) async {
    _notifications.insert(0, notification);
    notifyListeners();
    await _saveNotifications();
  }

  List<NotificationModel> getNotificationsForUser(String userId) {
    return _notifications.where((n) => n.targetUserId == userId).toList()
      ..sort((a, b) => DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
  }

  int getUnreadCountForUser(String userId) {
    return _notifications.where((n) => n.targetUserId == userId && !n.isRead).length;
  }

  Future<void> markAllAsReadForUser(String userId) async {
    bool hasChanges = false;
    for (var n in _notifications) {
      if (n.targetUserId == userId && !n.isRead) {
        n.isRead = true;
        hasChanges = true;
      }
    }
    if (hasChanges) {
      notifyListeners();
      await _saveNotifications();
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
    _notifications.clear();
    notifyListeners();
  }
}
