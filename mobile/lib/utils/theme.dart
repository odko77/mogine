import 'package:flutter/material.dart';

abstract class MyAppTheme {
  // Colors (RGBA)
  static const Color primaryColor = Color.fromRGBO(29, 32, 45, 1);
  static const Color grayColor = Color.fromRGBO(217, 217, 217, 1);
  static const Color bgColor = Color.fromRGBO(15, 18, 25, 1);
  static const Color textColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color cardColor = Color.fromRGBO(34, 40, 56, 1);
  static const Color secondaryColor = Color.fromRGBO(254, 181, 76, 1);
  static const Color backdropColor = Color.fromRGBO(0, 0, 0, 0.49);

  static ThemeData themeData = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: bgColor,
    primaryColor: primaryColor,
    cardColor: cardColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: bgColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: textColor,
      secondary: secondaryColor,
      onSecondary: primaryColor,
      error: Colors.red,
      onError: textColor,
      background: bgColor,
      onBackground: textColor,
      surface: cardColor,
      onSurface: textColor,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      bodySmall: TextStyle(color: textColor),
      titleLarge: TextStyle(color: textColor),
      titleMedium: TextStyle(color: textColor),
      titleSmall: TextStyle(color: textColor),
      labelLarge: TextStyle(color: textColor),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: secondaryColor),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStatePropertyAll(secondaryColor),
      trackColor: MaterialStatePropertyAll(grayColor),
    ),
  );
}
