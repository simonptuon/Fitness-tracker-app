import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Metrics Overview"),
        backgroundColor: const Color(0xFF006d77),
      ),
      backgroundColor: const Color(0xFFedf6f9),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _metricTile("Steps", data['stepCount'], data['weeklySteps'], data['monthlySteps'], data['yearlySteps']),
              _metricTile("Calories", data['caloriesBurned'], data['weeklyCaloriesBurned'], data['monthlyCaloriesBurned'], data['yearlyCaloriesBurned']),
              _metricTile("Water", data['waterConsumed'], data['weeklyWaterConsumed'], data['monthlyWaterConsumed'], data['yearlyWaterConsumed']),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, size: 30),
            Icon(Icons.show_chart, size: 30),
            SizedBox(width: 48),
            Icon(Icons.settings, size: 30),
            Icon(Icons.person, size: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _metricTile(String label, int daily, int weekly, int monthly, int yearly) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text("Daily: $daily"),
            Text("Weekly: $weekly"),
            Text("Monthly: $monthly"),
            Text("Yearly: $yearly"),
          ],
        ),
      ),
    );
  }
}
