import 'package:flutter/material.dart';
import 'package:password_manager/Helper/AppTheme.dart';
import 'package:password_manager/Helper/Storage.dart';

import './Pages/LoginPage.dart';
import 'Helper/AppTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: 'Password Manager',
      home: const LoginPage(),
    );
  }
}
