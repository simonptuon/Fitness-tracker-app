import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({super.key});

  @override
  State<SleepTrackerPage> createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  TimeOfDay? _sleepTime;
  TimeOfDay? _wakeTime;
  String? _duration;

  Future<void> saveSleepData() async {
    if (_sleepTime == null || _wakeTime == null) return;

    final sleepDateTime = DateTime(0, 0, 0, _sleepTime!.hour, _sleepTime!.minute);
    final wakeDateTime = DateTime(0, 0, _wakeTime!.hour < _sleepTime!.hour ? 1 : 0, _wakeTime!.hour, _wakeTime!.minute);
    final duration = wakeDateTime.difference(sleepDateTime);

    setState(() {
      _duration = duration.inHours.toString().padLeft(2, '0') + ':' + (duration.inMinutes % 60).toString().padLeft(2, '0');
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'sleep': _duration,
    });
  }

  Future<void> pickTime(bool isSleep) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isSleep) {
          _sleepTime = picked;
        } else {
          _wakeTime = picked;
        }
      });
      saveSleepData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log Your Sleep',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => pickTime(true),
              child: Text(_sleepTime == null
                  ? 'Select Sleep Time'
                  : 'Sleep Time: ${_sleepTime!.format(context)}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickTime(false),
              child: Text(_wakeTime == null
                  ? 'Select Wake Time'
                  : 'Wake Time: ${_wakeTime!.format(context)}'),
            ),
            const SizedBox(height: 30),
            if (_duration != null)
              Text(
                'You slept for $_duration hours',
                style: const TextStyle(fontSize: 20, color: Colors.purple),
              )
          ],
        ),
      ),
    );
  }
}