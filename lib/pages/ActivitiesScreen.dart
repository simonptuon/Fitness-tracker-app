import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';
import 'package:fitness_app_capstone/pages/MetricsPage.dart';
import 'package:provider/provider.dart';

import '../util/step_tracker_service.dart';
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final steps = context.watch<StepTrackerService>().steps;

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFF006d77),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006d77),
        elevation: 0,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('Welcome back!', style: TextStyle(color: Colors.white));
            }
            final fullName = snapshot.data!.get('fullName') ?? "";
            return Text('Welcome back, $fullName', style: const TextStyle(color: Colors.white));
          },
        ),
        actions: const [
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final steps = data['stepCount'] ?? 0;
          final calories = (steps * 0.04).round();
          final water = data['waterConsumed'] ?? 0;

          final stepProgress = (steps / 10000).clamp(0.0, 1.0);
          final calorieProgress = (calories / 3500).clamp(0.0, 1.0);
          final waterProgress = (water / 2500).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text("You're ${(stepProgress * 100).toStringAsFixed(0)}% to your step goal!\nKeep it up!",
                      style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _metricCard("Steps", steps, stepProgress, Colors.cyan),
                    _metricCard("Calories", calories, calorieProgress, Colors.green),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _metricCard("Water", water, waterProgress, Colors.blue),
                    _achievementCard(),
                  ],
                ),
                const SizedBox(height: 16),
                _goalsCard(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.home, size: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MetricsPage()),
                );
              },
              child: const Icon(Icons.show_chart, size: 30),
            ),
            const Icon(Icons.settings, size: 30),
            const Icon(Icons.person, size: 30),
          ],
        ),
      ),
    );
  }


  Widget _metricCard(String title, int value, double progress, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 6.0,
              percent: progress,
              center: Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              progressColor: color,
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("${(progress * 100).toStringAsFixed(0)}%", style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _achievementCard() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: const [
            Icon(Icons.directions_walk, color: Colors.orange),
            Text("10K Steps"),
            SizedBox(height: 8),
            Icon(Icons.flash_on, color: Colors.amber),
            Text("7d Streak!"),
            SizedBox(height: 8),
            Icon(Icons.star, color: Colors.purple),
            Text("Pro"),
          ],
        ),
      ),
    );
  }

  Widget _goalsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Today's Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          CheckboxListTile(
            value: true,
            onChanged: null,
            title: Text("Reach 3500 Calories"),
          ),
          CheckboxListTile(
            value: true,
            onChanged: null,
            title: Text("Drink 2 L Water"),
          ),
          CheckboxListTile(
            value: true,
            onChanged: null,
            title: Text("Log a Workout"),
          ),
        ],
      ),
    );
  }
}
