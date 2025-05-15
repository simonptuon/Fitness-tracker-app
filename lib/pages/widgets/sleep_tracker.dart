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
  List<Map<String, dynamic>> sleepLogs = [];

  @override
  void initState() {
    super.initState();
    fetchSleepLogs();
  }

  Future<void> fetchSleepLogs() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sleepLogs')
        .orderBy('timestamp', descending: true)
        .get();

    final logs = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'sleepTime': data['sleepTime'],
        'wakeTime': data['wakeTime'],
        'duration': data['duration'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
      };
    }).toList();

    setState(() {
      sleepLogs = logs;
    });
  }

  Future<void> saveSleepData() async {
    if (_sleepTime == null || _wakeTime == null) return;

    final now = DateTime.now();
    final sleepDateTime = DateTime(now.year, now.month, now.day, _sleepTime!.hour, _sleepTime!.minute);
    final wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day + (_wakeTime!.hour < _sleepTime!.hour ? 1 : 0),
      _wakeTime!.hour,
      _wakeTime!.minute,
    );
    final duration = wakeDateTime.difference(sleepDateTime);

    final durationStr = '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final timestamp = DateTime.now();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'sleep': durationStr,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sleepLogs')
        .add({
      'sleepTime': _sleepTime!.format(context),
      'wakeTime': _wakeTime!.format(context),
      'duration': durationStr,
      'timestamp': timestamp,
    });

    setState(() {
      _duration = durationStr;
      sleepLogs.insert(0, {
        'sleepTime': _sleepTime!.format(context),
        'wakeTime': _wakeTime!.format(context),
        'duration': durationStr,
        'timestamp': timestamp,
      });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
              ),
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sleep Log',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ...sleepLogs.map((log) => ListTile(
              leading: const Icon(Icons.bedtime, color: Colors.deepPurple),
              title: Text('${log['sleepTime']} → ${log['wakeTime']}'),
              subtitle: Text('Slept for ${log['duration']} on ${DateFormat('MMM d, yyyy').format(log['timestamp'])}'),
            )),
            if (sleepLogs.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'No sleep entries yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
