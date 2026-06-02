import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_flutter_b6/database/preference_handler.dart';
import 'package:project_flutter_b6/tugas1101.dart';
import 'package:project_flutter_b6/tugas9ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await PreferenceHandler.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool userSudahLogin = PreferenceHandler.isLogin;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userSudahLogin ? const AmomimusApp2() : const AmomimusApp5(),
    );
  }
}
