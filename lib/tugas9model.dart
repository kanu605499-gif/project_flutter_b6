import 'dart:math';

import 'package:flutter/material.dart';

enum AccountType { amo, ami, amom, user }

class FeedModel {
  final String userName;
  final String id;
  final AccountType type;
  final String content;
  final String timeStamp;
  final IconData iconData;
  final Color themeColor;
  final TextStyle contentTextStyle;
  final TextStyle idTextStyle;
  final String? realAuthorId;
  final String? realAuthorName;

  List<String> resonatedBy;
  List<CommentModel> comments;

  FeedModel({
    required this.userName,
    required this.id,
    required this.type,
    required this.content,
    required this.timeStamp,
    required this.iconData,
    required this.themeColor,
    required this.contentTextStyle,
    required this.idTextStyle,
    this.realAuthorId,
    this.realAuthorName,
    List<String>? resonatedBy,
    List<CommentModel>? comments,
  }) : resonatedBy = resonatedBy ?? [],
       comments = comments ?? [];

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'id': id,
      'type': type.index,
      'content': content,
      'timeStamp': timeStamp,
      'iconData': iconData.codePoint,
      'themeColor': themeColor.value,
      'realAuthorId': realAuthorId,
      'realAuthorName': realAuthorName,
      'resonatedBy': resonatedBy,
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      userName: json['userName'],
      id: json['id'],
      type: AccountType.values[json['type']],
      content: json['content'],
      timeStamp: json['timeStamp'],
      iconData: IconData(json['iconData'], fontFamily: 'MaterialIcons'),
      themeColor: Color(json['themeColor']),
      contentTextStyle: const TextStyle(fontSize: 14, height: 1.4),
      idTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      realAuthorId: json['realAuthorId'],
      realAuthorName: json['realAuthorName'],
      resonatedBy: (json['resonatedBy'] as List?)?.map((e) => e as String).toList(),
      comments: (json['comments'] as List?)?.map((e) => CommentModel.fromJson(e)).toList(),
    );
  }

  static const List<String> amoNames = [
    "Midnight Chaser",
    "Star Gazing",
    "Luna Aura",
  ];
  static const List<String> amiNames = [
    "Summer Bunny",
    "Soft Petal",
    "Ocean Breeze",
  ];
  static const List<String> amomNames = [
    "Silent Observer",
    "Digital Monk",
    "Void Architect",
  ];

  static String getRandomName(String gender) {
    final random = Random();
    if (gender == "Amo") return amoNames[random.nextInt(amoNames.length)];
    if (gender == "Ami") return amiNames[random.nextInt(amiNames.length)];
    if (gender == "Amom") return amomNames[random.nextInt(amomNames.length)];
    return amoNames[random.nextInt(amoNames.length)];
  }

  static Color getGenderColor(String gender) {
    if (gender == "Amo") return const Color(0xFFB388FF); // Purple
    if (gender == "Ami") return Colors.grey.shade600; // Grey matching dummy data
    if (gender == "Amom") return const Color(0xFFFFD54F); // Yellow
    return const Color(0xff8c72c4); // Default
  }

  static IconData getGenderIcon(String gender) {
    if (gender == "Amo") return Icons.diamond;
    if (gender == "Ami") return Icons.water;
    if (gender == "Amom") return Icons.android;
    return Icons.account_circle_outlined;
  }

  static TextStyle getGenderTextStyle(String gender) {
    if (gender == "Amo") {
      return const TextStyle(letterSpacing: 1.5, fontSize: 14, fontWeight: FontWeight.w500);
    }
    if (gender == "Ami") {
      return const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    }
    if (gender == "Amom") {
      return const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w600);
    }
    return const TextStyle(fontWeight: FontWeight.w500, fontSize: 14); // Default
  }

  static List<FeedModel> generateDummyData() {
    final Random random = Random();

    // Use static lists from FeedModel directly

    const TextStyle uniformContentStyle = TextStyle(fontSize: 14, height: 1.4);

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
      AccountType currentType = [AccountType.amo, AccountType.ami, AccountType.amom][random.nextInt(3)];

      String id = "";
      String userName = "";
      IconData iconData;
      Color themeColor;
      TextStyle idStyle;

      switch (currentType) {
        case AccountType.user:
          id = "#YOU-${100 + index}";
          userName = "Shadow Walker";
          iconData = Icons.account_circle_outlined;
          themeColor = const Color(0xff8c72c4);
          idStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 14);
          break;

        case AccountType.amo:
          id = "#AMO-${100 + index}";
          userName = amoNames[random.nextInt(amoNames.length)];
          iconData = Icons.diamond_outlined;
          themeColor = const Color(0xff8c72c4);
          idStyle = const TextStyle(
            letterSpacing: 1.5,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          );
          break;

        case AccountType.ami:
          id = "#AMI-${100 + index}";
          userName = amiNames[random.nextInt(amiNames.length)];
          iconData = Icons.waves;
          themeColor = Colors.grey.shade600;
          idStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
          break;

        case AccountType.amom:
          id = "#AMOM-${100 + index}";
          userName = amomNames[random.nextInt(amomNames.length)];
          iconData = Icons.terminal;
          themeColor = const Color(0xFFFFD54F);
          idStyle = const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          );
          break;
      }

      return FeedModel(
        userName: userName,
        id: id,
        type: currentType,
        content: dummyContents[index],
        timeStamp: dummyTimes[index],
        iconData: iconData,
        themeColor: themeColor,
        contentTextStyle: uniformContentStyle,
        idTextStyle: idStyle,
        resonatedBy: List.generate(random.nextInt(5), (i) => "dummy_$i"),
      );
    });
  }
}

class CommentModel {
  final String authorId;
  final String authorName;
  final String text;
  final String timeStamp;

  CommentModel({
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'text': text,
      'timeStamp': timeStamp,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      authorId: json['authorId'],
      authorName: json['authorName'],
      text: json['text'],
      timeStamp: json['timeStamp'],
    );
  }
}
