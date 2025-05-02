import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Activitiesscreen extends StatelessWidget {
  const Activitiesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        primaryColor: const Color(0xFF00C9A7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00C9A7),
          foregroundColor: Color(0xFFFFFFFF),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF333333)),
        ),
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future<Map<String, dynamic>> fetchData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null)
      return {'stepCount': 0, 'caloriesBurned': 0, 'heartRate': 0};

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {'stepCount': 0, 'caloriesBurned': 0, 'heartRate': 0};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome back 👋')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final steps = data['stepCount'] as int;
          final calories = data['caloriesBurned'] as int;
          final heartRate = data['heartRate'] as int;

          final stepGoal = 10000;
          final calorieGoal = 750;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA2E4DC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "You're ${(steps / stepGoal * 100).toInt()}% to your step goal!",
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xFF333333)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularIndicator(
                        title: 'Steps', value: steps, goal: stepGoal),
                    CircularIndicator(
                        title: 'Calories', value: calories, goal: calorieGoal),
                  ],
                ),
                const SizedBox(height: 20),
                HeartIndicator(heartRate: heartRate),
                const SizedBox(height: 20),
                const GoalChecklist(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CircularIndicator extends StatelessWidget {
  final String title;
  final int value;
  final int goal;

  const CircularIndicator(
      {required this.title,
      required this.value,
      required this.goal,
      super.key});

  @override
  Widget build(BuildContext context) {
    final percent = (value / goal).clamp(0.0, 1.0);
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 10.0,
      percent: percent,
      center: Text('$value\n$title',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF333333))),
      progressColor: const Color(0xFF00C9A7),
      backgroundColor: const Color(0xFFA2E4DC),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}

class HeartIndicator extends StatelessWidget {
  final int heartRate;

  const HeartIndicator({required this.heartRate, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Heart Rate', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          percent: (heartRate / 150).clamp(0.0, 1.0),
          center: Text('$heartRate\nBPM',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF333333))),
          progressColor: Colors.red,
          backgroundColor: const Color(0xFFA2E4DC),
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    );
  }
}

class GoalChecklist extends StatelessWidget {
  const GoalChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Today’s Goals',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333))),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Walk 7,500 steps',
              style: TextStyle(color: Color(0xFF666666))),
          tileColor: Color(0xFFFFFFFF),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Drink 2 L water',
              style: TextStyle(color: Color(0xFF666666))),
          tileColor: Color(0xFFFFFFFF),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title:
              Text('Log a workout', style: TextStyle(color: Color(0xFF666666))),
          tileColor: Color(0xFFFFFFFF),
        ),
      ],
    );
  }
}
