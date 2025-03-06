import 'package:flutter/material.dart';

class WorkoutPlans extends StatefulWidget {
  @override
  _WorkoutPlansState createState() => _WorkoutPlansState();
}

class _WorkoutPlansState extends State<WorkoutPlans> {
  String dropdownValue = 'Exercises';
  List<String> items = [
    'Exercises', 'Beginner', 'Muscle Building', 'Fat Loss', 'Ab Workouts', 'Full Body',
    'Body Weight', 'At Home', 'Cardio', 'Chest Workout', 'Back Workout',
    'Bicep Workout', 'Shoulder Workout', 'Leg Workout', 'Tricep Workout'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans'),
      ),
      body: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
