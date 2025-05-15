import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepCalorieUpdater {
  static Future<void> updateCaloriesFromSteps() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final int steps = data['stepCount'] ?? 0;
    final int calories = (steps * 0.04).round();

    await userRef.update({'caloriesBurned': calories});
  }
}
