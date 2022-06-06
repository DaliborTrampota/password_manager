import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade300,
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        onPrimary: Colors.white,
        primaryContainer: Colors.teal,
        secondary: Colors.white,
      ),
      textTheme: TextTheme(
        titleSmall: TextStyle(color: Colors.grey.shade900, fontSize: 18),
        titleMedium: TextStyle(color: Colors.grey.shade900, fontSize: 24),
        titleLarge: TextStyle(color: Colors.grey.shade900, fontSize: 32),
        labelMedium: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ));

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        onSurface: Colors.grey.shade300,
        primary: Colors.purple.shade900,
        onPrimary: Colors.grey.shade300, //grey.shade300
        primaryContainer: Colors.blueGrey,
        secondary: Colors.teal.shade700,
      ),
      textTheme: TextTheme(
        titleSmall: TextStyle(color: Colors.grey.shade300, fontSize: 18),
        titleMedium: TextStyle(color: Colors.grey.shade300, fontSize: 24),
        titleLarge: TextStyle(color: Colors.grey.shade300, fontSize: 32),
        labelMedium: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
      ));
}
