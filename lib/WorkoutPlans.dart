import 'package:flutter/material.dart';

class WorkoutPlans extends StatefulWidget {
  @override
  _WorkoutPlansState createState() => _WorkoutPlansState();
}

class _WorkoutPlansState extends State<WorkoutPlans> {
  String dropdownValue = 'Exercises';
  static const List<String> workoutCategories = [
    'Exercises',
    'Beginner',
    'Muscle Building',
    'Fat Loss',
    'Ab Workouts',
    'Full Body',
    'Body Weight',
    'At Home',
    'Cardio',
  ];

  final Map<String, List<String>> categoryButtonOptions = {
    'Exercises': ['Push-ups', 'Squats', 'Lunges'],
    'Beginner': ['Walking', 'Light Jogging', 'Basic Yoga'],
    'Muscle Building': ['Bench Press', 'Deadlifts', 'Bicep Curls'],
    'Fat Loss': ['HIIT', 'Running', 'Cycling'],
    'Ab Workouts': ['Crunches', 'Leg Raises', 'Plank'],
    'Full Body': ['Burpees', 'Jumping Jacks', 'Mountain Climbers'],
    'Body Weight': ['Pull-ups', 'Dips', 'Pistol Squats'],
    'At Home': ['Yoga', 'Pilates', 'Bodyweight Circuit'],
    'Cardio': ['Running', 'Swimming', 'Cycling'],
  };

  List<String> currentButtonOptions = [];

  @override
  void initState() {
    super.initState();
    currentButtonOptions = categoryButtonOptions[dropdownValue] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward, color: Colors.deepPurple),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      currentButtonOptions =
                          categoryButtonOptions[dropdownValue] ?? [];
                    });
                  },
                  items: workoutCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: currentButtonOptions.map((option) {
                  return ElevatedButton(
                    onPressed: () {
                      print('Button pressed: $option');
                    },
                    child: Text(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}