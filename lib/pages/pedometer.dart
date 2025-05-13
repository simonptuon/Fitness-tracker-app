import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({super.key});

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  String _steps = 'Loading...';
  int? _initialStepCount;

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
      _steps = event.steps.toString();
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
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Step Counter'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Steps Taken: $_steps',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
