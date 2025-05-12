import 'package:fitness_app_capstone/pages/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({super.key});

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  String _steps = 'Loading...';

  @override
  void initState() {
    super.initState();
    requestPermission().then((_) {
      initPedometer();
    });
  }

  // Request ACTIVITY_RECOGNITION permission on Android 10+
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
      print('Error initializing pedometer: $e');
      setState(() {
        _steps = 'Error initializing pedometer';
      });
    }
  }

  void onStepCount(StepCount event) {
    print('New step count: ${event.steps}');
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('Step Count Error: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
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
