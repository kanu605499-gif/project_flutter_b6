import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_flutter_b6/database/preference_handler.dart';
import 'package:project_flutter_b6/login.dart';
import 'package:project_flutter_b6/tugas9ui.dart';
// pastikan mengimport halaman utama kamu juga, contoh:
// import 'package:project_flutter_b6/home.dart';

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
    // Cek status login user
    bool userSudahLogin = PreferenceHandler.isLogin;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Jika sudah login ke AmomimusApp2, jika belum ke LoginPage
      home: userSudahLogin ? const AmomimusApp5() : const AmomimusApp2(),
    );
  }
}
