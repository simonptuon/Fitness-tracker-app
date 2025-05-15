import 'dart:math';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage>
    with SingleTickerProviderStateMixin {
  final int dailyGoal = 2500;
  int currentIntake = 0;
  late AnimationController _controller;
  List<Map<String, dynamic>> dailyLogs = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentIntake();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchCurrentIntake() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = userDoc.data();
    setState(() {
      currentIntake = userData?['waterConsumed'] ?? 0;
    });

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayStartTimestamp = Timestamp.fromDate(todayStart);

    final logsQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('waterLogs')
        .where('timestamp', isGreaterThanOrEqualTo: todayStartTimestamp)
        .orderBy('timestamp', descending: true)
        .get();

    final logs = logsQuery.docs.map((doc) {
      final data = doc.data();
      return {
        'amount': data['amount'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
      };
    }).toList();

    setState(() {
      dailyLogs = logs;
    });
  }

  Future<void> addWater(int amount) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final timestamp = Timestamp.now();
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final data = snapshot.data() ?? {};

      final updatedWater = (data['waterConsumed'] ?? 0) + amount;
      final updatedWeekly = (data['weeklyWaterConsumed'] ?? 0) + amount;
      final updatedMonthly = (data['monthlyWaterConsumed'] ?? 0) + amount;
      final updatedYearly = (data['yearlyWaterConsumed'] ?? 0) + amount;

      transaction.update(userRef, {
        'waterConsumed': updatedWater,
        'weeklyWaterConsumed': updatedWeekly,
        'monthlyWaterConsumed': updatedMonthly,
        'yearlyWaterConsumed': updatedYearly,
      });

      setState(() {
        currentIntake = updatedWater;
        dailyLogs.insert(0, {
          'amount': amount,
          'timestamp': timestamp.toDate(),
        });
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('waterLogs')
        .add({
      'amount': amount,
      'timestamp': timestamp,
    });
  }


  @override
  Widget build(BuildContext context) {
    double progress = (currentIntake / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Daily Water Intake',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 400,
                child: ClipPath(
                  clipper: BottleClipper(),
                  child: CustomPaint(
                    painter: WaterBottlePainter(
                      progress: progress,
                      waveAnimation: _controller,
                    ),
                    child: Container(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${(progress * 100).toInt()}% of goal ($currentIntake / $dailyGoal mL)',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Water intake buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _waterButton(250),
                  _waterButton(500),
                  _waterButton(750),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Log',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    dailyLogs.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No water intake logged today',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : Column(
                      children: dailyLogs
                          .where((log) {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        return log['timestamp'].isAfter(today);
                      })
                          .map((log) => ListTile(
                        leading: const Icon(Icons.local_drink, color: Colors.blueAccent),
                        title: Text('+${log['amount']} mL'),
                        subtitle: Text(DateFormat('hh:mm a').format(log['timestamp'])),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _waterButton(int amount) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: currentIntake >= dailyGoal ? null : () => addWater(amount),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '+${amount} mL',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class WaterBottlePainter extends CustomPainter {
  final double progress;
  final Animation<double> waveAnimation;

  WaterBottlePainter({required this.progress, required this.waveAnimation})
      : super(repaint: waveAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final double waterTop = size.height * (1 - progress);
    final double waveHeight = 8.0;
    final double waveLength = size.width;
    final double waveSpeed = waveAnimation.value * 2 * pi;

    final path = Path();
    path.moveTo(0, waterTop);

    for (double i = 0; i <= size.width; i++) {
      double y = waveHeight * sin((i / waveLength * 2 * pi) + waveSpeed) + waterTop;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BottleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width * 0.35, 0);
    path.lineTo(width * 0.65, 0);
    path.quadraticBezierTo(width * 0.7, height * 0.1, width * 0.7, height * 0.2);
    path.lineTo(width * 0.8, height * 0.8);
    path.quadraticBezierTo(width * 0.8, height * 0.95, width * 0.6, height);
    path.lineTo(width * 0.4, height);
    path.quadraticBezierTo(width * 0.2, height * 0.95, width * 0.2, height * 0.8);
    path.lineTo(width * 0.3, height * 0.2);
    path.quadraticBezierTo(width * 0.3, height * 0.1, width * 0.35, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}