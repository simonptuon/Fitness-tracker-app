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

  final Map<String, String> exerciseDescriptions = {
    'Push-ups': 'A basic exercise that works the chest, shoulders, and triceps.',
    'Squats': 'A lower body exercise that targets the thighs, hips, and buttocks.',
    'Lunges': 'An exercise that works the legs and glutes.',
    'Walking': 'A simple and effective way to get moving and improve cardiovascular health.',
    'Light Jogging': 'A gentle form of running that helps build endurance.',
    'Basic Yoga': 'A series of poses that improve flexibility and strength.',
    'Bench Press': 'A compound exercise that targets the chest, shoulders, and triceps.',
    'Deadlifts': 'A full-body exercise that primarily targets the back and legs.',
    'Bicep Curls': 'An isolation exercise that targets the biceps.',
    'HIIT': 'High-Intensity Interval Training, a form of cardio that alternates between intense bursts of activity and fixed periods of less-intense activity or rest.',
    'Running': 'A cardiovascular exercise that improves endurance and burns calories.',
    'Cycling': 'A low-impact exercise that improves cardiovascular health and strengthens the legs.',
    'Crunches': 'An abdominal exercise that targets the rectus abdominis.',
    'Leg Raises': 'An exercise that targets the lower abdominal muscles.',
    'Plank': 'An isometric core exercise that involves maintaining a position similar to a push-up for the maximum possible time.',
    'Burpees': 'A full-body exercise that combines a squat, push-up, and jump.',
    'Jumping Jacks': 'A cardio exercise that involves jumping to a position with the legs spread wide and the hands touching overhead.',
    'Mountain Climbers': 'A full-body workout that increases heart rate and strengthens the core.',
    'Pull-ups': 'An upper body exercise that targets the back and biceps.',
    'Dips': 'An exercise that targets the triceps, chest, and shoulders.',
    'Pistol Squats': 'A single-leg squat that targets the legs and glutes.',
    'Yoga': 'A series of poses that improve flexibility and strength.',
    'Pilates': 'A form of low-impact exercise that aims to strengthen muscles while improving postural alignment and flexibility.',
    'Bodyweight Circuit': 'A series of exercises performed in sequence with minimal rest, using only body weight for resistance.',
    'Swimming': 'A full-body workout that improves cardiovascular health and builds muscle strength.',
  };

  final String benchPressImagePath = 'images/Bench Press.webp';
  final String PushupsImagePath = 'images/Push-ups.webp';
  List<String> currentButtonOptions = [];

  @override
  void initState() {
    super.initState();
    currentButtonOptions = categoryButtonOptions[dropdownValue] ?? [];
  }

  void showExerciseDialog(String exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (exercise == 'Bench Press')
                Image.asset(
                  benchPressImagePath,
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Push-ups')
                Image.asset(
                  PushupsImagePath,
                  width: 200,
                  height: 150,
                ),
              Text(exerciseDescriptions[exercise] ?? 'No description available.'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Exercise Background Image.webp'),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            Center(
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
                  style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontFamily: 'Roboto'),
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
                      showExerciseDialog(option);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, color: Colors.white),
                        SizedBox(width: 8),
                        Text(option, style: TextStyle(fontFamily: 'Roboto')),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  );
                }).toList(),
            ),
            ],

          ),
        ),]
      ));
  }
}