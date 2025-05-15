import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalManager {
  static final List<String> goalPool = [
    'Reach 3500 Calories',
    'Drink 2 L Water',
    'Log a Workout',
    'Walk 10,000 Steps',
    'Sleep 8 Hours',
    'Log Food Intake',
    'Meditate for 10 Minutes',
    'Stretch for 5 Minutes',
    'Run 3 Miles',
    'Bike for 30 Minutes',
  ];

  static Future<void> assignDailyGoalsIfNeeded() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final goalsCol = userDoc.collection('dailyGoals');
    final dateKey = DateTime.now().toIso8601String().split('T').first;

    final snapshot = await goalsCol.doc(dateKey).get();
    if (snapshot.exists) return; // Already assigned today

    final random = Random();
    final selected = <String>{};

    while (selected.length < 3) {
      selected.add(goalPool[random.nextInt(goalPool.length)]);
    }

    await goalsCol.doc(dateKey).set({
      'goals': selected.toList(),
      'completed': List.generate(3, (_) => false),
      'timestamp': Timestamp.now(),
    });
  }

  static Future<Map<String, dynamic>?> getTodayGoals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final dateKey = DateTime.now().toIso8601String().split('T').first;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dailyGoals')
        .doc(dateKey)
        .get();

    if (!doc.exists) return null;
    return doc.data();
  }

  static Future<void> toggleGoalCompletion(int index, bool value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final dateKey = DateTime.now().toIso8601String().split('T').first;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dailyGoals')
        .doc(dateKey);

    final snapshot = await ref.get();
    if (!snapshot.exists) return;

    final completed = List<bool>.from(snapshot.data()!['completed']);
    completed[index] = value;

    await ref.update({'completed': completed});
  }
}
