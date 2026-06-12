import 'dart:math';

import 'comment_model.dart';
import '../data/anonymous_names.dart';

/// Enum for the three anonymous account types in Amomimus.
enum AccountType { amo, ami, amom, user }

/// Feed post model for the Amomimus app.
///
/// This is the pure data model. UI-specific properties (icon, color, textStyle)
/// are resolved at display time via `GenderHelpers`.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class FeedModel {
  final String userName;
  final String id;
  final AccountType type;
  final String content;
  final String timeStamp;
  final String? realAuthorId;
  final String? realAuthorName;
  final String? createdAt;

  List<String> resonatedBy;
  List<CommentModel> comments;

  FeedModel({
    required this.userName,
    required this.id,
    required this.type,
    required this.content,
    required this.timeStamp,
    this.realAuthorId,
    this.realAuthorName,
    String?
    createdAt, // Diubah jadi parameter biasa agar bisa di-intercept otomatis
    List<String>? resonatedBy,
    List<CommentModel>? comments,
  }) : // Otomatis isi waktu ISO saat ini jika dari UI kosong (Solusi anti-hilang filter 24 jam)
       createdAt = createdAt ?? DateTime.now().toIso8601String(),

       // Otomatis masukkan amomimusId pembuat ke list agar langsung muncul di Recent Resonates
       resonatedBy = resonatedBy ?? [],

       comments = comments ?? [];

  /// Firestore-ready: converts this [FeedModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'id': id,
      'type': type
          .index, // Disimpan sebagai int (index enum) karena Firestore tidak dukung objek Enum murni
      'content': content,
      'timeStamp': timeStamp,
      'realAuthorId': realAuthorId,
      'realAuthorName': realAuthorName,
      'createdAt': createdAt,
      'resonatedBy':
          resonatedBy, // List<String> aman didukung langsung oleh Firestore Array
      'comments': comments
          .map((e) => e.toMap())
          .toList(), // Pastikan CommentModel juga punya toMap()
    };
  }

  /// Firestore-ready: creates a [FeedModel] from a [Map].
  factory FeedModel.fromMap(Map<String, dynamic> map) {
    return FeedModel(
      userName: map['userName'] ?? '',
      id: map['id'] ?? '',

      // Mengonversi kembali data int dari Firestore menjadi Enum AccountType Flutter kamu
      type: AccountType.values[map['type'] ?? 0],

      content: map['content'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
      realAuthorId: map['realAuthorId'],
      realAuthorName: map['realAuthorName'],
      createdAt: map['createdAt'],

      // REVISI KRUSIAL UNTUK FIREBASE & SHARED PREFERENCES:
      // Memaksa data array dari database (yang tipenya List<dynamic>) dicasting menjadi List<String> secara aman.
      resonatedBy: map['resonatedBy'] != null
          ? List<String>.from(map['resonatedBy'])
          : [], // Biarkan null agar di-handle default-nya oleh constructor di atas

      comments: (map['comments'] as List?)
          ?.map((e) => CommentModel.fromMap(e))
          .toList(),
    );
  }

  /// Backward-compatible JSON alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  /// Backward-compatible JSON alias for [fromMap].
  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      FeedModel.fromMap(json);

  /// Generates seed/dummy feed data for first launch.
  static List<FeedModel> generateDummyData() {
    final Random random = Random();

    List<String> dummyContents = [
      "Ada yang lagi overthinking juga malam ini? Chat dong...",
      "Lega banget akhirnya tugas kelar! Saatnya tidur 12 jam.",
      "Menemukan ketenangan di tengah hiruk pikuk kota ini. 🌊",
      "Mencoba fitur posting baru di Amomimus app! #Tugas8",
      "Kadang rasanya pengen menghilang sebentar dari internet.",
      "Gak sengaja denger lagu lama, langsung keinget memori 3 tahun lalu.",
      "Sistem error mulu dari tadi, emang boleh secape ini coding? 🤖",
      "Malam ini langitnya bagus banget, sedih ga ada yang bisa diajak liat bareng.",
      "Fokus ke diri sendiri dulu, drama orang lain skip dulu deh.",
      "Ternyata makin gede, makin sadar kalau temen dikit itu lebih tenang.",
    ];

    List<String> dummyTimes = [
      "2m ago",
      "5m ago",
      "12m ago",
      "20m ago",
      "45m ago",
      "1h ago",
      "3h ago",
      "5h ago",
      "1d ago",
      "2d ago",
    ];

    return List.generate(10, (index) {
      AccountType currentType = [
        AccountType.amo,
        AccountType.ami,
        AccountType.amom,
      ][random.nextInt(3)];

      String id = "";
      String userName = "";

      switch (currentType) {
        case AccountType.user:
          id = "#YOU-${100 + index}";
          userName = "Shadow Walker";
          break;
        case AccountType.amo:
          id = "#AMO-${100 + index}";
          userName = AnonymousNames
              .amoNames[random.nextInt(AnonymousNames.amoNames.length)];
          break;
        case AccountType.ami:
          id = "#AMI-${100 + index}";
          userName = AnonymousNames
              .amiNames[random.nextInt(AnonymousNames.amiNames.length)];
          break;
        case AccountType.amom:
          id = "#AMOM-${100 + index}";
          userName = AnonymousNames
              .amomNames[random.nextInt(AnonymousNames.amomNames.length)];
          break;
      }

      return FeedModel(
        userName: userName,
        id: id,
        type: currentType,
        content: dummyContents[index],
        timeStamp: dummyTimes[index],
        createdAt: DateTime.now()
            .subtract(Duration(minutes: index * 15))
            .toIso8601String(),
        resonatedBy: List.generate(random.nextInt(5), (i) => "dummy_$i"),
      );
    });
  }
}
