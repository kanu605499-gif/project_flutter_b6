import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_flutter_b6/tugas9model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String timeStamp;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timeStamp,
    this.isTyping = false,
  });
}

class ChatPreview {
  final String name;
  final String username;
  final String initialLastMessage;
  final String initialTime;
  final int initialUnreadCount;
  final bool isOnline;
  final List<ChatMessage> messages;

  int unreadCount;

  ChatPreview({
    required this.name,
    required this.username,
    required this.initialLastMessage,
    required this.initialTime,
    required this.initialUnreadCount,
    required this.isOnline,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [],
       unreadCount = initialUnreadCount;

  String get lastMessage {
    if (messages.isNotEmpty) {
      return messages.last.text;
    }
    return initialLastMessage;
  }

  String get time {
    if (messages.isNotEmpty) {
      return messages.last.timeStamp;
    }
    return initialTime;
  }
}

class ChatModel extends ChangeNotifier {
  late List<ChatPreview> _chatList;

  ChatModel() {
    final initialPreviews = [
      ChatPreview(
        name: "Partner",
        username: "@partner_dev",
        initialLastMessage:
            "Katanya peforma tim lagi turun, jadi agak kesentil aja sih.",
        initialTime: "11:51 PM",
        initialUnreadCount: 2,
        isOnline: true,
        messages: [
          ChatMessage(text: "P", isUser: true, timeStamp: "11:30 PM"),
          ChatMessage(text: "Oi, belum tidur lu?", isUser: false, timeStamp: "11:31 PM"),
          ChatMessage(text: "Belum nih, mata masih seger banget wkwk", isUser: true, timeStamp: "11:31 PM"),
          ChatMessage(text: "Sama, tumben amat begadang. Ada masalah kah?", isUser: false, timeStamp: "11:32 PM"),
          ChatMessage(text: "Eh, iya nih. Susah banget mau tidur. Kebanyakan pikiran.", isUser: false, timeStamp: "11:46 PM"),
          ChatMessage(text: "Sama banget, aku juga kepikiran soal deadline besok.", isUser: true, timeStamp: "11:47 PM"),
          ChatMessage(text: "Aku malah kepikiran pembicaraan tadi siang sama bos. 😩", isUser: false, timeStamp: "11:49 PM"),
          ChatMessage(text: "Emang bos billing apa emangnya?", isUser: true, timeStamp: "11:50 PM"),
          ChatMessage(text: "Katanya peforma tim lagi turun, jadi agak kesentil aja sih.", isUser: false, timeStamp: "11:51 PM"),
          ChatMessage(text: "Oalah santai, yang penting lu udah maksimal kerja kok.", isUser: true, timeStamp: "11:52 PM"),
          ChatMessage(text: "Makasih ya jas, agak tenang dikit denger lu ngomong gitu.", isUser: false, timeStamp: "11:53 PM"),
          ChatMessage(text: "Yoi, jangan terlalu dipikirin, ntar malah sakit.", isUser: true, timeStamp: "11:54 PM"),
          ChatMessage(text: "Btw lu udah kelar ngerjain revisi yang kemarin belum?", isUser: false, timeStamp: "11:55 PM"),
          ChatMessage(text: "Udah dong, makanya ini begadang tinggal santainya aja.", isUser: true, timeStamp: "11:55 PM"),
          ChatMessage(text: "Anjay mantap, bagi resepnya dong biar cepet kelar.", isUser: false, timeStamp: "11:56 PM"),
          ChatMessage(text: "Kampang", isUser: true, timeStamp: "11:57 PM"),
          ChatMessage(text: "Yeee goblok lu", isUser: false, timeStamp: "11:58 PM"),
          ChatMessage(text: "Dongo", isUser: false, timeStamp: "11:59 PM"),
        ],
      ),
      ChatPreview(
        name: "Justin Mason",
        username: "@justin_m",
        initialLastMessage: "Yoi, jangan terlalu dipikirin, ntar malah sakit.",
        initialTime: "11:54 PM",
        initialUnreadCount: 0,
        isOnline: false,
        messages: [
          ChatMessage(text: "Bro, ready for tomorrow?", isUser: true, timeStamp: "11:50 PM"),
          ChatMessage(text: "Yoi, jangan terlalu dipikirin, ntar malah sakit.", isUser: false, timeStamp: "11:54 PM"),
        ],
      ),
      ChatPreview(
        name: "Bos Billing",
        username: "@the_boss",
        initialLastMessage: "Besok pagi kita meeting revisi yang kemarin ya.",
        initialTime: "10:15 PM",
        initialUnreadCount: 0,
        isOnline: true,
        messages: [
          ChatMessage(text: "Halo Bos", isUser: true, timeStamp: "10:00 PM"),
          ChatMessage(text: "Besok pagi kita meeting revisi yang kemarin ya.", isUser: false, timeStamp: "10:15 PM"),
        ],
      ),
      ChatPreview(
        name: "Amomimus Dev",
        username: "@amomimus",
        initialLastMessage: "Gimana partikel background nya? Udah sesuai vibes?",
        initialTime: "09:30 AM",
        initialUnreadCount: 5,
        isOnline: false,
        messages: [
          ChatMessage(text: "Gimana partikel background nya? Udah sesuai vibes?", isUser: false, timeStamp: "09:30 AM"),
        ],
      ),
    ];

    List<FeedModel> feeds;
    try {
      feeds = FeedModel.generateDummyData();
    } catch (_) {
      feeds = [];
    }

    final feedPreviews = feeds.where((f) => f.type != AccountType.user).map((feed) {
      return ChatPreview(
        name: feed.userName,
        username: feed.id,
        initialLastMessage: feed.content,
        initialTime: feed.timeStamp,
        initialUnreadCount: 0,
        isOnline: Random().nextBool(),
        messages: [
          ChatMessage(
            text: feed.content,
            isUser: false,
            timeStamp: feed.timeStamp,
          ),
        ],
      );
    }).toList();

    _chatList = [...initialPreviews, ...feedPreviews];
  }

  List<ChatPreview> get chatList => _chatList;

  ChatPreview getChatByUsername(String username) {
    return _chatList.firstWhere(
      (chat) => chat.username == username,
      orElse: () {
        final newChat = ChatPreview(
          name: username.replaceAll('@', ''),
          username: username,
          initialLastMessage: "",
          initialTime: "",
          initialUnreadCount: 0,
          isOnline: false,
        );
        _chatList.add(newChat);
        return newChat;
      },
    );
  }

  void sendMessage(String username, String text) {
    final chat = getChatByUsername(username);
    final now = DateTime.now();
    final hourVal = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeStr = "$hourVal:${now.minute.toString().padLeft(2, '0')} $period";
    
    chat.messages.add(
      ChatMessage(
        text: text,
        isUser: true,
        timeStamp: timeStr,
      ),
    );
    notifyListeners();
  }

  void markAsRead(String username) {
    final chat = getChatByUsername(username);
    if (chat.unreadCount > 0) {
      chat.unreadCount = 0;
      notifyListeners();
    }
  }
}
