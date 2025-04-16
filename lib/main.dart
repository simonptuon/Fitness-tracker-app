import 'package:fitness_app_capstone/views/pages/Login.dart';
import 'package:fitness_app_capstone/views/pages/ActivitiesScreen.dart';
import 'package:fitness_app_capstone/views/pages/Water.dart';
import 'package:fitness_app_capstone/views/pages/sleepSchedule.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: SleepSchedule(),
      routes: {
        '/login': (context) => Login(),
        '/activities': (context) => ActivitiesScreen(),
        '/consumption': (context) => Water(),
      },
    );
  }
}
