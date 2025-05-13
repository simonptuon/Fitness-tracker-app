import 'package:fitness_app_capstone/pages/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  int dailyGoal = 2500; // in mL
  int currentIntake = 0;

  @override
  void initState() {
    super.initState();
    fetchCurrentIntake();
  }

  Future<void> fetchCurrentIntake() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    setState(() {
      currentIntake = data?['waterConsumed'] ?? 0;
    });
  }

  Future<void> addWater(int amount) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newAmount = currentIntake + amount;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'waterConsumed': newAmount,
    });

    setState(() {
      currentIntake = newAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIntake / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Daily Goal: $dailyGoal mL',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 10),
            Text(
              '$currentIntake mL consumed',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => addWater(250),
              child: const Text('Add 250 mL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => addWater(500),
              child: const Text('Add 500 mL'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}