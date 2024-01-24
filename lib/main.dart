import 'package:api_rest_front/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/task_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


void main() {
  Intl.defaultLocale = 'fr_FR'; // or your desired default locale
  initializeDateFormatting(); // No arguments needed
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo List App',
      initialRoute: '/',
      routes: {
        '/': (context) => TaskScreen(),
      },
    );
  }
}
