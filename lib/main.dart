
import 'package:fitness_app_capstone/CaloriesBurned.dart';
import 'package:fitness_app_capstone/pages/pedometer.dart';
import 'package:fitness_app_capstone/pages/widgets/sleep_tracker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app_capstone/pie_chart.dart';
import 'package:fitness_app_capstone/pages/signup.dart';
import 'package:fitness_app_capstone/pages/loginui.dart';
import 'package:fitness_app_capstone/pages/ActivitiesScreen.dart';
import 'package:fitness_app_capstone/pages/Water.dart';
import 'WorkoutPlans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await resetUserMetricsIfNeeded();

  runApp(const MyApp());
}

Future<void> resetUserMetricsIfNeeded() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await userRef.get();

  if (!snapshot.exists) return;
  final data = snapshot.data()!;

  final now = Timestamp.now();
  final nowDate = now.toDate();

  final lastDaily = (data['lastDailyUpdate'] as Timestamp?)?.toDate();
  final lastWeekly = (data['lastWeeklyUpdate'] as Timestamp?)?.toDate();
  final lastMonthly = (data['lastMonthlyUpdate'] as Timestamp?)?.toDate();
  final lastYearly = (data['lastYearlyUpdate'] as Timestamp?)?.toDate();


  final updates = <String, dynamic>{};

  if (lastDaily == null || !_isSameDay(nowDate, lastDaily)) {
    updates.addAll({
      'caloriesBurned': 0,
      'waterConsumed': 0,
      'heartRate': 0,
      'stepCount': 0,
      'sleep': '0:00',
      'lastDailyUpdate': now,
    });
  }

  if (lastWeekly == null || !_isSameWeek(nowDate, lastWeekly)) {
    updates.addAll({
      'weeklyCaloriesBurned': 0,
      'weeklyWaterConsumed': 0,
      'weeklyHeartRate': 0,
      'weeklySteps': 0,
      'weeklySleep': '0:00',
      'lastWeeklyUpdate': now,
    });
  }

  if (lastMonthly == null || !_isSameMonth(nowDate, lastMonthly)) {
    updates.addAll({
      'monthlyCaloriesBurned': 0,
      'monthlyWaterConsumed': 0,
      'monthlyHeartRate': 0,
      'monthlySteps': 0,
      'monthlySleep': '0:00',
      'lastMonthlyUpdate': now,
    });
  }

  if (lastYearly == null || !_isSameYear(nowDate, lastYearly)) {
    updates.addAll({
      'yearlyCaloriesBurned': 0,
      'yearlyWaterConsumed': 0,
      'yearlyHeartRate': 0,
      'yearlySteps': 0,
      'yearlySleep': '0:00',
      'lastYearlyUpdate': now,
    });
  }


  if (updates.isNotEmpty) {
    await userRef.update(updates);
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool _isSameWeek(DateTime a, DateTime b) {
  final aWeek = a.subtract(Duration(days: a.weekday));
  final bWeek = b.subtract(Duration(days: b.weekday));
  return _isSameDay(aWeek, bWeek);
}

bool _isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

bool _isSameYear(DateTime a, DateTime b) => a.year == b.year;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
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
        '/login': (context) => const Login(),
        '/activities': (context) => ActivitiesScreen(),
        '/consumption': (context) => const WaterTrackerPage(),
        '/pedometer': (context) => const PedometerPage(),
        '/workoutplans': (context) => WorkoutPlans(),
        '/calories': (context) => CaloriesBurned(),
        '/sleep': (context) => const SleepTrackerPage(),
      },
    );
  }
}
