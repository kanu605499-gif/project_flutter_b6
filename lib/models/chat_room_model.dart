import 'message_model.dart';

/// Chat room (session) model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class ChatSession {
  final String id;
  final String user1Id;
  final String user1Name;
  final String user2Id;
  final String user2Name;
  final List<ChatMessage> messages;
  final Map<String, int> unreadCounts;
  final List<String> pinnedMessageIds; // Memories — max 9
  final String? createdAt;

  /// Convenience getter: returns participant IDs as a list.
  List<String> get participants => [user1Id, user2Id];

  ChatSession({
    required this.id,
    required this.user1Id,
    required this.user1Name,
    required this.user2Id,
    required this.user2Name,
    required this.messages,
    required this.unreadCounts,
    this.pinnedMessageIds = const [],
    this.createdAt,
  });

  /// Firestore-ready: converts this [ChatSession] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user1Name': user1Name,
      'user2Id': user2Id,
      'user2Name': user2Name,
      'participants': participants,
      'messages': messages.map((m) => m.toMap()).toList(),
      'unreadCounts': unreadCounts,
      'pinnedMessageIds': pinnedMessageIds,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Firestore-ready: creates a [ChatSession] from a [Map].
  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'],
      user1Id: map['user1Id'],
      user1Name: map['user1Name'],
      user2Id: map['user2Id'],
      user2Name: map['user2Name'],
      messages: (map['messages'] as List)
          .map((m) => ChatMessage.fromMap(m))
          .toList(),
      unreadCounts: Map<String, int>.from(map['unreadCounts']),
      pinnedMessageIds: (map['pinnedMessageIds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: map['createdAt'],
    );
  }

  /// Backward-compatible JSON aliases.
  Map<String, dynamic> toJson() => toMap();
  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      ChatSession.fromMap(json);
}
