import 'package:flutter/material.dart';

class AmomimusDarkTheme {
  static const Color primaryPurple = Color(0xff8c72c4);
  static const Color backgroundDark = Color(0xff121212);
  static const Color surfaceDark = Color(0xff1e1e1e);
  static const Color policeLineYellow = Color(0xFFFFD700);

  static const Color textPrimary = Color(0xfff5f5f5);
  static const Color textSecondary = Color(0xffb3b3b3);
  static const Color dividerDark = Color(0xff2d2d2d);
  static const Color shadowColor = Colors.black;

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryPurple,
          fontSize: 20,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.black,
        elevation: 6,
        shape: CircleBorder(),
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: surfaceDark,
        elevation: 0,
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: backgroundDark,
        elevation: 16,
      ),

      dividerTheme: const DividerThemeData(
        color: dividerDark,
        thickness: 1,
        space: 1,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: policeLineYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        horizontalTitleGap: 12,
      ),
    );
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: surfaceDark,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static Color get blurOverlayColor => backgroundDark.withOpacity(0.75);
}
