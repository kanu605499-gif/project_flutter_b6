/// Categories for user/chat reports in the Amomimus app.
enum ReportCategory {
  spamHarassment,
  inappropriateContent,
  hateSpeech,
}

/// Helper for [ReportCategory] serialization and display labels.
class ReportCategoryHelper {
  ReportCategoryHelper._();

  static const Map<ReportCategory, String> _labels = {
    ReportCategory.spamHarassment: 'Spam / Harassment',
    ReportCategory.inappropriateContent: 'Inappropriate Content',
    ReportCategory.hateSpeech: 'Hate Speech',
  };

  static const Map<ReportCategory, String> _values = {
    ReportCategory.spamHarassment: 'spam_harassment',
    ReportCategory.inappropriateContent: 'inappropriate_content',
    ReportCategory.hateSpeech: 'hate_speech',
  };

  /// Display-friendly label for the category.
  static String getLabel(ReportCategory category) => _labels[category]!;

  /// Storable string value for the category.
  static String toValue(ReportCategory category) => _values[category]!;

  /// Parses a stored string back into a [ReportCategory].
  static ReportCategory fromValue(String value) {
    switch (value) {
      case 'inappropriate_content':
        return ReportCategory.inappropriateContent;
      case 'hate_speech':
        return ReportCategory.hateSpeech;
      case 'spam_harassment':
      default:
        return ReportCategory.spamHarassment;
    }
  }

  /// Returns all categories as a list (useful for building picker UIs).
  static List<ReportCategory> get all => ReportCategory.values;
}

/// Report model for the Amomimus app.
///
/// Supports both **user-level reports** and **per-chat-bubble reports**.
/// - For a user-level report, leave [reportedMessageId] null.
/// - For a chat bubble report, set [reportedMessageId] to the message's ID.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class ReportModel {
  final String? id;
  final String reporterId;
  final String reportedUserId;
  final ReportCategory category;
  final String description;
  final String? reportedMessageId; // null = user report, set = chat bubble report
  final String? roomId;            // which chat room the message belongs to
  final String? createdAt;

  ReportModel({
    this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.category,
    this.description = '',
    this.reportedMessageId,
    this.roomId,
    this.createdAt,
  });

  /// Whether this report targets a specific chat message.
  bool get isChatBubbleReport => reportedMessageId != null;

  /// Firestore-ready: converts this [ReportModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'category': ReportCategoryHelper.toValue(category),
      'description': description,
      'reportedMessageId': reportedMessageId,
      'roomId': roomId,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Firestore-ready: creates a [ReportModel] from a [Map].
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],
      reporterId: map['reporterId'],
      reportedUserId: map['reportedUserId'],
      category: ReportCategoryHelper.fromValue(map['category'] ?? 'spam_harassment'),
      description: map['description'] ?? '',
      reportedMessageId: map['reportedMessageId'],
      roomId: map['roomId'],
      createdAt: map['createdAt'],
    );
  }
}
