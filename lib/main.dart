import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:fitness_app_capstone/CaloriesBurned.dart';
import 'package:fitness_app_capstone/pie_chart.dart';
import 'package:fitness_app_capstone/pages/signup.dart';
import 'package:fitness_app_capstone/views/pages/Login.dart';
import 'package:fitness_app_capstone/views/pages/ActivitiesScreen.dart';
import 'package:fitness_app_capstone/views/pages/Water.dart';
import 'WorkoutPlans.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Apply Poppins font globally
        fontFamily: 'Cera Pro',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: SignUpPage(),
      routes: {
        '/login': (context) => Login(),
        '/activities': (context) => ActivitiesScreen(),
        '/consumption': (context) => Water(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PieChart(
          values: [100, 300, 200, 200, 100],
          colors: [
            Colors.yellow,
            Colors.green,
            Colors.red,
            Colors.blue,
            Colors.grey,
          ],
        ),
      ),
    );
  }
}
