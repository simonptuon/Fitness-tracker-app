import 'package:fitness_app_capstone/pages/Login.dart';
import 'package:fitness_app_capstone/pages/ActivitiesScreen.dart';
import 'package:fitness_app_capstone/pages/Water.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ActivitiesScreen(),
      routes: {
        '/login': (context) => Login(),
        '/activities': (context) => ActivitiesScreen(),
        '/consumption': (context) => Water(),
      },
    );
  }
}