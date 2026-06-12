import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_request_model.dart';

class ChatRequestManager extends ChangeNotifier {
  List<ChatRequest> _requests = [];
  String? _currentUserId;

  static const String _storageKey = 'amomimus_chat_requests';

  ChatRequestManager() {
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null && data.isNotEmpty) {
      try {
        final List decoded = jsonDecode(data);
        _requests = decoded.map((e) => ChatRequest.fromJson(e)).toList();
      } catch (e) {
        _requests = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_requests.map((e) => e.toJson()).toList()));
  }

  void setCurrentUser(String userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      notifyListeners();
    }
  }

  List<ChatRequest> get incomingRequests {
    if (_currentUserId == null) return [];
    return _requests.where((r) => r.receiverId == _currentUserId && r.status == RequestStatus.pending).toList();
  }

  List<ChatRequest> get outgoingRequests {
    if (_currentUserId == null) return [];
    return _requests.where((r) => r.senderId == _currentUserId).toList();
  }

  bool hasPendingRequestWith(String targetId) {
    if (_currentUserId == null) return false;
    return _requests.any((r) => 
      ((r.senderId == _currentUserId && r.receiverId == targetId) || 
       (r.receiverId == _currentUserId && r.senderId == targetId)) && 
      r.status == RequestStatus.pending
    );
  }

  bool isChatAllowed(String targetId) {
    if (_currentUserId == null) return false;
    return _requests.any((r) => 
      ((r.senderId == _currentUserId && r.receiverId == targetId) || 
       (r.receiverId == _currentUserId && r.senderId == targetId)) && 
      r.status == RequestStatus.accepted
    );
  }

  void sendRequest(String targetId, String targetName, String senderName) {
    if (_currentUserId == null) return;
    
    // Check if already requested
    if (hasPendingRequestWith(targetId) || isChatAllowed(targetId)) return;

    final newReq = ChatRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId!,
      senderName: senderName,
      receiverId: targetId,
      receiverName: targetName,
      timestamp: DateTime.now().toIso8601String(),
    );

    _requests.add(newReq);
    _saveRequests();
    notifyListeners();
  }

  void acceptRequest(String requestId) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx].status = RequestStatus.accepted;
      _saveRequests();
      notifyListeners();
    }
  }

  void rejectRequest(String requestId) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx].status = RequestStatus.rejected;
      _saveRequests();
      notifyListeners();
    }
  }

  void deleteRequestWith(String targetId) {
    if (_currentUserId == null) return;
    _requests.removeWhere((r) => 
      ((r.senderId == _currentUserId && r.receiverId == targetId) || 
       (r.receiverId == _currentUserId && r.senderId == targetId))
    );
    _saveRequests();
    notifyListeners();
  }
}
