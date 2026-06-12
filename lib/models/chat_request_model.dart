/// Status of a chat request.
enum RequestStatus { pending, accepted, rejected }

/// Chat request model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class ChatRequest {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  RequestStatus status;
  final String timestamp;
  final String? createdAt;

  ChatRequest({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    this.status = RequestStatus.pending,
    required this.timestamp,
    this.createdAt,
  });

  /// Firestore-ready: converts this [ChatRequest] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'status': status.index,
      'timestamp': timestamp,
      'createdAt': createdAt ?? timestamp,
    };
  }

  /// Firestore-ready: creates a [ChatRequest] from a [Map].
  factory ChatRequest.fromMap(Map<String, dynamic> map) {
    return ChatRequest(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      receiverId: map['receiverId'],
      receiverName: map['receiverName'],
      status: RequestStatus.values[map['status'] ?? 0],
      timestamp: map['timestamp'],
      createdAt: map['createdAt'],
    );
  }

  /// Backward-compatible JSON aliases.
  Map<String, dynamic> toJson() => toMap();
  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      ChatRequest.fromMap(json);
}
