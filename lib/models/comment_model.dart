/// Comment model for posts in the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class CommentModel {
  final String? id;
  final String? postId;
  final String authorId;
  final String authorName;
  final String text;
  final String timeStamp;
  final String? createdAt;
  final String? replyToName;
  final String? replyToText;

  CommentModel({
    this.id,
    this.postId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.timeStamp,
    this.createdAt,
    this.replyToName,
    this.replyToText,
  });

  /// Firestore-ready: converts this [CommentModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'text': text,
      'timeStamp': timeStamp,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
      'replyToName': replyToName,
      'replyToText': replyToText,
    };
  }

  /// Firestore-ready: creates a [CommentModel] from a [Map].
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postId: map['postId'],
      authorId: map['authorId'],
      authorName: map['authorName'],
      text: map['text'],
      timeStamp: map['timeStamp'],
      createdAt: map['createdAt'],
      replyToName: map['replyToName'],
      replyToText: map['replyToText'],
    );
  }

  /// Backward-compatible JSON alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  /// Backward-compatible JSON alias for [fromMap].
  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      CommentModel.fromMap(json);
}
