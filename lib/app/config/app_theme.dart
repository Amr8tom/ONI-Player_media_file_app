import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColorDark = Color(0xFF0277BD);
  static MaterialColor primaryColor = const MaterialColor(0xFF008FF9, {
    50: Color(0xFFE1F5FE),
    100: Color(0xFFB3E5FC),
    200: Color(0xFF81D4FA),
    300: Color(0xFF4FC3F7),
    400: Color(0xFF29B6F6),
    500: Color(0xFF03A9F4),
    600: Color(0xFF039BE5),
    700: Color(0xFF0288D1),
    800: Color(0xFF0277BD),
    900: Color(0xFF01579B),
  });
  static const Color dangerColor = Colors.redAccent;
  static const Color backgroundColor = Colors.black;
  static const Color backgroundColorLight = Color(0xFF0F0F0F);
  static const Color textColor = Colors.white54;
  static const Color textColorLight = Colors.white;
  static Color playerOverlaysColor = Colors.black.withOpacity(0.9);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primarySwatch: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: Colors.white70,
      background: backgroundColor,
    ),
    highlightColor: const Color(0xFF131313),
    splashColor: const Color.fromARGB(255, 59, 58, 65),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColorLight,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedIconTheme: IconThemeData(color: primaryColor),
      selectedLabelStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w300,
      ),
      selectedItemColor: primaryColor,
      unselectedIconTheme: const IconThemeData(color: Colors.white),
      unselectedLabelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      enableFeedback: true,
    ),
  );
}
