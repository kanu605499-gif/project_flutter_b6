import 'dart:convert';

class UserModelSql {
  final int? id;
  final String? fullName;
  final String? email;
  final String? favoriteCharacter;
  final String? password;

  UserModelSql({
    this.id,
    this.fullName,
    this.email,
    this.favoriteCharacter,
    this.password,
  });

  factory UserModelSql.fromMap(Map<String, dynamic> map) => UserModelSql(
    id: map['id'] as int?,
    fullName: map['full_name'] as String?,
    email: map['email'] as String?,
    favoriteCharacter: map['favorite_character'] as String?,
    password: map['password'] as String?,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'full_name': fullName,
      'email': email,
      'favorite_character': favoriteCharacter,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModelSql.fromJson(String source) =>
      UserModelSql.fromMap(json.decode(source) as Map<String, dynamic>);

  // 3. Ditambahkan copyWith agar mempermudah modifikasi/kloning data jika diperlukan
  UserModelSql copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? favoriteCharacter,

    String? password,
  }) {
    return UserModelSql(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      favoriteCharacter: favoriteCharacter ?? this.favoriteCharacter,
      password: password ?? this.password,
    );
  }
}
