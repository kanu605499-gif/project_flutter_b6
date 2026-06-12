import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_flutter_b6/amomimusdark.dart';
import 'package:project_flutter_b6/services/chatmodel.dart';
import 'package:project_flutter_b6/services/account_manager.dart';
import 'package:project_flutter_b6/database/preference_handler.dart';
import 'package:project_flutter_b6/screens/tugas1101.dart';
import 'package:project_flutter_b6/screens/tugas9ui.dart';
import 'package:project_flutter_b6/screens/tugas11a.dart'; // Add SplashScreen
import 'package:provider/provider.dart';

import 'package:project_flutter_b6/services/feed_manager.dart';
import 'package:project_flutter_b6/services/chat_request_manager.dart';
import 'package:project_flutter_b6/services/notification_manager.dart';
import 'package:project_flutter_b6/language/language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await PreferenceHandler.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageManager()),
        ChangeNotifierProvider(create: (context) => AmomimusDarkTheme()),
        ChangeNotifierProvider(create: (context) => AccountManager()..loadAccounts()),
        ChangeNotifierProxyProvider<AccountManager, ChatModel>(
          create: (context) => ChatModel(),
          update: (context, auth, chatModel) {
            if (auth.currentUser != null) {
              chatModel!.setCurrentUser(auth.currentUser!.amomimusId, auth.currentUser!.anonymousUsername);
            }
            return chatModel!;
          },
        ),
        ChangeNotifierProxyProvider<AccountManager, ChatRequestManager>(
          create: (context) => ChatRequestManager(),
          update: (context, auth, reqModel) {
            if (auth.currentUser != null) {
              reqModel!.setCurrentUser(auth.currentUser!.amomimusId);
            }
            return reqModel!;
          },
        ),
        ChangeNotifierProvider(create: (context) => FeedManager()..loadFeeds()),
        ChangeNotifierProvider(create: (context) => NotificationManager()..loadNotifications()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool userSudahLogin = PreferenceHandler.isLogin;

    // FIXED: Wrap MaterialApp in a Consumer to guarantee responsive UI updates
    return Consumer<AmomimusDarkTheme>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // FIXED: Use the dynamic instance getter we fixed earlier!
          theme: themeProvider.currentThemeData,

          // Always start with SplashScreen to handle proper session checking
          home: const SplashScreen(),
        );
      },
    );
  }
}
