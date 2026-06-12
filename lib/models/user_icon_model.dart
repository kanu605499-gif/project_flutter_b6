/// Model representing a selectable user avatar icon in the Amomimus app.
///
/// Each icon belongs to a specific gender type (Amo, Ami, Amom) and uses
/// Flutter's built-in Material Icons. Firestore-ready with [fromMap]/[toMap].
class UserIconModel {
  final String id;
  final String name;
  final String gender; // 'Amo', 'Ami', or 'Amom'
  final int iconCodePoint;
  final String iconFontFamily;

  const UserIconModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.iconCodePoint,
    this.iconFontFamily = 'MaterialIcons',
  });

  /// Firestore-ready: creates a [UserIconModel] from a [Map].
  factory UserIconModel.fromMap(Map<String, dynamic> map) {
    return UserIconModel(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      iconCodePoint: map['iconCodePoint'],
      iconFontFamily: map['iconFontFamily'] ?? 'MaterialIcons',
    );
  }

  /// Firestore-ready: converts this [UserIconModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
    };
  }
}
