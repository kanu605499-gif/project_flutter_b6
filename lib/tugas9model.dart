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

  int resonateCount;
  int commentCount;

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
    required this.resonateCount,
    required this.commentCount,
  });

  static List<FeedModel> generateDummyData() {
    final Random random = Random();

    // Data unik untuk menghindari duplikasi
    final List<String> amoNames = [
      "Midnight Chaser",
      "Star Gazing",
      "Luna Aura",
    ];
    final List<String> amiNames = [
      "Summer Bunny",
      "Soft Petal",
      "Ocean Breeze",
    ];
    final List<String> amomNames = [
      "Silent Observer",
      "Digital Monk",
      "Void Architect",
    ];

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
      AccountType currentType = (index == 3)
          ? AccountType.user
          : [AccountType.amo, AccountType.ami, AccountType.amom][random.nextInt(
              3,
            )];

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
          themeColor = const Color(0xfff1c66a);
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
        resonateCount: random.nextInt(50) + 1,
        commentCount: random.nextInt(25) + 1,
      );
    });
  }
}
