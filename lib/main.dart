import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_flutter_b6/amomimusdark.dart';
import 'package:project_flutter_b6/chatmodel.dart';
import 'package:project_flutter_b6/account_manager.dart';
import 'package:project_flutter_b6/database/preference_handler.dart';
import 'package:project_flutter_b6/tugas1101.dart';
import 'package:project_flutter_b6/tugas9ui.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await PreferenceHandler.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AmomimusDarkTheme()),
        ChangeNotifierProvider(create: (context) => ChatModel()),
        ChangeNotifierProvider(create: (context) => AccountManager()..loadAccounts()),
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

          home: userSudahLogin ? const AmomimusApp2() : const AmomimusApp5(),
        );
      },
    );
  }
}
