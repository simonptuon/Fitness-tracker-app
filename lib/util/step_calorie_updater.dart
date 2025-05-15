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
    final int oldSteps = data['lastStepUpdate'] ?? 0;
    final int currentSteps = data['stepCount'] ?? 0;

    final int newSteps = currentSteps - oldSteps;
    if (newSteps <= 0) return;

    final int additionalCalories = (newSteps * 0.04).round();
    final int totalCalories = (currentSteps * 0.04).round();

    await userRef.update({
      'caloriesBurned': totalCalories,
      'weeklyCaloriesBurned': (data['weeklyCaloriesBurned'] ?? 0) + additionalCalories,
      'monthlyCaloriesBurned': (data['monthlyCaloriesBurned'] ?? 0) + additionalCalories,
      'yearlyCaloriesBurned': (data['yearlyCaloriesBurned'] ?? 0) + additionalCalories,
      'lastStepUpdate': currentSteps,
    });
  }
}
