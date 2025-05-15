import 'package:fitness_app_capstone/pages/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({super.key});

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  String _steps = 'Loading...';
  int? _initialStepCount;
  int stepGoal = 10000;

  @override
  void initState() {
    super.initState();
    requestPermission().then((_) {
      initPedometer();
    });
  }

  Future<void> requestPermission() async {
    final status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      final result = await Permission.activityRecognition.request();
      if (!result.isGranted) {
        setState(() {
          _steps = 'Permission denied';
        });
      }
    }
  }

  void initPedometer() {
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } catch (e) {
      setState(() {
        _steps = 'Error initializing pedometer';
      });
    }
  }

  void onStepCount(StepCount event) async {
    if (_initialStepCount == null) {
      _initialStepCount = event.steps;
      return;
    }

    int stepsTaken = event.steps - _initialStepCount!;
    if (stepsTaken <= 0) return;

    if (!mounted) return;

    setState(() {
      _steps = (int.parse(_steps == 'Loading...' ? '0' : _steps) + stepsTaken).toString();
    });

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        final data = snapshot.data() ?? {};

        transaction.update(userRef, {
          'stepCount': (data['stepCount'] ?? 0) + stepsTaken,
          'weeklySteps': (data['weeklySteps'] ?? 0) + stepsTaken,
          'monthlySteps': (data['monthlySteps'] ?? 0) + stepsTaken,
          'yearlySteps': (data['yearlySteps'] ?? 0) + stepsTaken,
        });
      });

      _initialStepCount = event.steps;
    } catch (e) {
      print('Firestore update failed: $e');
    }
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    if (_steps != 'Loading...' && _steps != 'Permission denied' && _steps != 'Step Count not available') {
      progress = (int.parse(_steps) / stepGoal).clamp(0.0, 1.0);
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Step Counter'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1c2e65), Color(0xFF4e6cbb)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Today\'s Steps',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: progress,
                  center: Text(
                    _steps,
                    style: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      '${(progress * 100).toStringAsFixed(1)}% of $stepGoal steps',
                      style: const TextStyle(fontSize: 18.0, color: Colors.white70),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.greenAccent,
                  backgroundColor: Colors.white12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}