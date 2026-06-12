/// Represents a notification type in the app.
enum NotificationType { resonate, comment, reply }

/// Notification model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class NotificationModel {
  final String id;
  final String targetUserId;
  final String actorName;
  final NotificationType type;
  final String feedId;
  final String message;
  final String createdAt;
  bool isRead;

  NotificationModel({
    String? id,
    required this.targetUserId,
    required this.actorName,
    required this.type,
    required this.feedId,
    required this.message,
    String? createdAt,
    this.isRead = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now().toIso8601String();

  /// Firestore-ready: converts this [NotificationModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'targetUserId': targetUserId,
      'actorName': actorName,
      'type': type.index,
      'feedId': feedId,
      'message': message,
      'createdAt': createdAt,
      'isRead': isRead
          ? 1
          : 0, // 1 for true, 0 for false (SQLite/Firestore compatible)
    };
  }

  /// Firestore-ready: creates a [NotificationModel] from a [Map].
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      targetUserId: map['targetUserId'] ?? '',
      actorName: map['actorName'] ?? '',
      type: NotificationType.values[map['type'] ?? 0],
      feedId: map['feedId'] ?? '',
      message: map['message'] ?? '',
      createdAt: map['createdAt'],
      isRead: map['isRead'] == 1 || map['isRead'] == true,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel.fromMap(json);
}
