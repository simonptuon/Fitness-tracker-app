import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepTrackerService extends ChangeNotifier {
  int _steps = 0;
  int? _initial;
  late Stream<StepCount> _stream;

  int get steps => _steps;

  StepTrackerService() {
    _initialize();
  }

  void _initialize() {
    _stream = Pedometer.stepCountStream;
    _stream.listen(_onStep, onError: _onError);
  }

  void _onStep(StepCount count) async {
    if (_initial == null) {
      _initial = count.steps;
      return;
    }

    final diff = count.steps - _initial!;
    if (diff <= 0) return;

    _steps += diff;
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final doc = await tx.get(userRef);
        final data = doc.data() ?? {};

        tx.update(userRef, {
          'stepCount': (data['stepCount'] ?? 0) + diff,
          'weeklySteps': (data['weeklySteps'] ?? 0) + diff,
          'monthlySteps': (data['monthlySteps'] ?? 0) + diff,
          'yearlySteps': (data['yearlySteps'] ?? 0) + diff,
        });
      });
    }

    _initial = count.steps;
  }

  void _onError(error) {
    debugPrint('Pedometer error: $error');
  }
}
