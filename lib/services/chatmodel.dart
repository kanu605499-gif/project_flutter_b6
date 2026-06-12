import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message_model.dart';
import '../models/chat_room_model.dart';

// UI Adapter
class ChatPreview {
  final String name;
  final String username;
  final String initialLastMessage;
  final String initialTime;
  final bool isOnline;
  final List<ChatMessage> messages;
  int unreadCount;

  ChatPreview({
    required this.name,
    required this.username,
    required this.initialLastMessage,
    required this.initialTime,
    required this.isOnline,
    required this.messages,
    required this.unreadCount,
  });

  String get lastMessage =>
      messages.isNotEmpty ? messages.last.text : initialLastMessage;
  String get time =>
      messages.isNotEmpty ? messages.last.timeStamp : initialTime;
}

class ChatModel extends ChangeNotifier {
  List<ChatSession> _sessions = [];
  String? _currentUserId;
  String? _currentUserName;

  static const String _storageKey = 'amomimus_global_chats';

  ChatModel() {
    loadChats();
  }

  Future<void> loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null && data.isNotEmpty) {
      try {
        final List decoded = jsonDecode(data);
        _sessions = decoded.map((e) => ChatSession.fromJson(e)).toList();
      } catch (e) {
        _sessions = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_sessions.map((e) => e.toJson()).toList()),
    );
  }

  void setCurrentUser(String userId, [String? userName]) {
    bool changed = false;
    if (_currentUserId != userId) {
      _currentUserId = userId;
      changed = true;
    }
    if (_currentUserName != userName) {
      _currentUserName = userName;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  String _getChatId(String id1, String id2) {
    final ids = [id1, id2];
    ids.sort();
    return ids.join('_');
  }

  List<ChatPreview> get chatList {
    if (_currentUserId == null) return [];

    return _sessions
        .where(
          (s) =>
              (s.user1Id == _currentUserId || s.user2Id == _currentUserId) &&
              s.messages.isNotEmpty,
        )
        .map((s) {
          final isUser1 = s.user1Id == _currentUserId;
          final targetId = isUser1 ? s.user2Id : s.user1Id;
          final targetName = isUser1 ? s.user2Name : s.user1Name;

          return ChatPreview(
            name: targetName,
            username: targetId,
            initialLastMessage: "",
            initialTime: "",
            isOnline: true,
            messages: s.messages,
            unreadCount: s.unreadCounts[_currentUserId!] ?? 0,
          );
        })
        .toList();
  }

  bool get hasUnreadMessages {
    if (_currentUserId == null) return false;
    return _sessions.any((s) {
      if (s.user1Id != _currentUserId && s.user2Id != _currentUserId) {
        return false;
      }
      return (s.unreadCounts[_currentUserId!] ?? 0) > 0;
    });
  }

  ChatPreview getChatByUsername(
    String targetUserId, {
    String targetName = "Unknown",
  }) {
    if (_currentUserId == null) {
      return ChatPreview(
        name: targetName,
        username: targetUserId,
        initialLastMessage: "",
        initialTime: "",
        isOnline: false,
        messages: [],
        unreadCount: 0,
      );
    }

    final chatId = _getChatId(_currentUserId!, targetUserId);
    var session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );

    if (session == null) {
      session = ChatSession(
        id: chatId,
        user1Id: _currentUserId!,
        user1Name: _currentUserName ?? _currentUserId!,
        user2Id: targetUserId,
        user2Name: targetName,
        messages: [],
        unreadCounts: {_currentUserId!: 0, targetUserId: 0},
      );
      _sessions.add(session);
      // Don't persist empty sessions — only save when a message is actually sent
    }

    final isUser1 = session.user1Id == _currentUserId;
    return ChatPreview(
      name: isUser1 ? session.user2Name : session.user1Name,
      username: targetUserId,
      initialLastMessage: "",
      initialTime: "",
      isOnline: true,
      messages: session.messages,
      unreadCount: session.unreadCounts[_currentUserId!] ?? 0,
    );
  }

  void sendMessage(
    String targetUserId,
    String text, {
    String? senderName,
    String? targetName,
    String? replyMessageId,
  }) {
    if (_currentUserId == null) return;

    final chatId = _getChatId(_currentUserId!, targetUserId);
    var session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );

    if (session == null) {
      session = ChatSession(
        id: chatId,
        user1Id: _currentUserId!,
        user1Name: senderName ?? _currentUserName ?? _currentUserId!,
        user2Id: targetUserId,
        user2Name: targetName ?? targetUserId,
        messages: [],
        unreadCounts: {_currentUserId!: 0, targetUserId: 0},
      );
      _sessions.add(session);
    }

    final now = DateTime.now();
    final hourVal = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeStr = "$hourVal:${now.minute.toString().padLeft(2, '0')} $period";

    session.messages.add(
      ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_$_currentUserId',
        text: text,
        senderId: _currentUserId!,
        senderName: senderName,
        timeStamp: timeStr,
        replyMessageId: replyMessageId,
      ),
    );

    session.unreadCounts[targetUserId] =
        (session.unreadCounts[targetUserId] ?? 0) + 1;

    notifyListeners();
    _saveChats();
  }

  void markAsRead(String targetUserId) {
    if (_currentUserId == null) return;

    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );

    if (session != null && (session.unreadCounts[_currentUserId!] ?? 0) > 0) {
      session.unreadCounts[_currentUserId!] = 0;
      notifyListeners();
      _saveChats();
    }
  }

  void deleteChat(String targetUserId) {
    if (_currentUserId == null) return;

    final chatId = _getChatId(_currentUserId!, targetUserId);
    _sessions.removeWhere((s) => s.id == chatId);
    notifyListeners();
    _saveChats();
  }

  // ── Memories (Pinned Messages) ────────────────────────

  bool isPinned(String targetUserId, String messageId) {
    if (_currentUserId == null) return false;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return false;
    return session.pinnedMessageIds.contains(messageId);
  }

  bool pinMessage(String targetUserId, String messageId) {
    if (_currentUserId == null) return false;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return false;

    if (session.pinnedMessageIds.length >= 9) {
      return false; // Limit reached
    }

    if (!session.pinnedMessageIds.contains(messageId)) {
      // We need to reassign since the list might be unmodifiable if it's the default const []
      final updatedPins = List<String>.from(session.pinnedMessageIds);
      updatedPins.add(messageId);

      // Update session with new pins
      final index = _sessions.indexWhere((s) => s.id == chatId);
      if (index != -1) {
        // ChatSession is immutable, so we must recreate or we need to change it
        // Wait, looking at chatmodel.dart, session.messages.add() was used, so it's not immutable in practice or it is?
        // Wait, in chatmodel.dart lines 177: session.messages.add(...)
        // Let's modify ChatSession to have non-final pinnedMessageIds, OR we replace the session.
        // Actually, we can just replace the session in the list.
        _sessions[index] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: updatedPins,
          createdAt: session.createdAt,
        );
        notifyListeners();
        _saveChats();
        return true;
      }
    }
    return false;
  }

  void unpinMessage(String targetUserId, String messageId) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return;

    if (session.pinnedMessageIds.contains(messageId)) {
      final updatedPins = List<String>.from(session.pinnedMessageIds)
        ..remove(messageId);
      final index = _sessions.indexWhere((s) => s.id == chatId);
      if (index != -1) {
        _sessions[index] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: updatedPins,
          createdAt: session.createdAt,
        );
        notifyListeners();
        _saveChats();
      }
    }
  }

  List<ChatMessage> getPinnedMessages(String targetUserId) {
    if (_currentUserId == null) return [];
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return [];

    return session.messages
        .where((m) => session.pinnedMessageIds.contains(m.id))
        .toList();
  }
}
