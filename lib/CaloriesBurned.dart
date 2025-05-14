import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';

class CaloriesBurned extends StatefulWidget {
  const CaloriesBurned({super.key});

  @override
  State<CaloriesBurned> createState() => _CaloriesBurnedState();
}

class _CaloriesBurnedState extends State<CaloriesBurned> {
  int stepCount = 0;
  double caloriesBurned = 0.0;

  @override
  void initState() {
    super.initState();
    fetchStepCount();
  }

  Future<void> fetchStepCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    final steps = data?['stepCount'] ?? 0;

    setState(() {
      stepCount = steps;
      caloriesBurned = calculateCaloriesFromSteps(steps);
    });
  }

  double calculateCaloriesFromSteps(int steps) {
    // Approx: 0.04 calories per step (varies by height/weight/activity)
    return steps * 0.04;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Calories Burned"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          const Text(
          'Today\'s Summary',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        Text(
          'Steps Taken: $stepCount',
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 20),
        Text(
          'Calories Burned: ${caloriesBurned.toStringAsFixed(2)} kcal',
          style: const TextStyle(fontSize: 22, color: Colors.deepOrange),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: fetchStepCount,
          child: const Text('Refresh'),
        )
        ],
      ),
    ),
    ),
    );
  }
}