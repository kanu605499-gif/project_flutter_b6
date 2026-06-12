/// Chat message model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class ChatMessage {
  final String? id;
  final String? roomId;
  final String text;
  final String senderId;
  final String timeStamp;
  final bool isTyping;
  final String? senderName;
  final String? replyMessageId;
  final String? createdAt;

  ChatMessage({
    this.id,
    this.roomId,
    required this.text,
    required this.senderId,
    required this.timeStamp,
    this.isTyping = false,
    this.senderName,
    this.replyMessageId,
    this.createdAt,
  });

  /// Firestore-ready: converts this [ChatMessage] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'text': text,
      'senderId': senderId,
      'timeStamp': timeStamp,
      'senderName': senderName,
      'replyMessageId': replyMessageId,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Firestore-ready: creates a [ChatMessage] from a [Map].
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      roomId: map['roomId'],
      text: map['text'],
      senderId: map['senderId'],
      timeStamp: map['timeStamp'],
      senderName: map['senderName'],
      replyMessageId: map['replyMessageId'],
      createdAt: map['createdAt'],
    );
  }

  /// Backward-compatible JSON aliases.
  Map<String, dynamic> toJson() => toMap();
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      ChatMessage.fromMap(json);
}
