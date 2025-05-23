import 'package:flutter/material.dart';

class WorkoutPlans extends StatefulWidget {
  const WorkoutPlans({super.key});

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
    'Cardio': ['Running Cardio', 'Swimming', 'Cycling Cardio'],
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
    'Running Cardio': 'Running at a moderate to high intensity to improve cardiovascular health and endurance.',
    'Cycling': 'A low-impact exercise that improves cardiovascular health and strengthens the legs.',
    'Cycling Cardio': 'Cycling at a moderate to high intensity to improve cardiovascular health and endurance.' ,
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

  final Map<String, String> exerciseStrategies = {
    'Push-ups': 'Aim for 3 sets of 10-15 reps. Focus on proper form, keeping your body in a straight line.',
    'Squats': 'Perform 3 sets of 12-15 reps. Ensure your knees don\'t go past your toes and keep your back straight.',
    'Lunges': 'Do 3 sets of 10-12 reps per leg. Keep your front knee aligned with your ankle.',
    'Walking': 'Start with 30 minutes of brisk walking per day. Gradually increase the duration and intensity.',
    'Light Jogging': 'Jog for 20-30 minutes at a comfortable pace. Focus on maintaining steady breathing.',
    'Basic Yoga': 'Attend a beginner yoga class or follow a video tutorial. Hold each pose for 30 seconds, focusing on breathing.',
    'Bench Press': 'Perform 3 sets of 8-12 reps. Use a spotter if lifting heavy weights. Lower the bar slowly and push up explosively.',
    'Deadlifts': 'Do 1-3 sets of 5-8 reps. Maintain a straight back and engage your core. Start with lighter weights to perfect your form.',
    'Bicep Curls': 'Complete 3 sets of 10-15 reps. Keep your elbows close to your body and control the movement.',
    'HIIT': 'Alternate between 30 seconds of high-intensity exercise and 30 seconds of rest. Repeat for 15-20 minutes.',
    'Running': 'Start with a 20-30 minute run at a moderate pace. Gradually increase your distance and speed.',
    'Running Cardio': 'Run for 30-45 minutes at a moderate to high intensity. Include interval training for better results.',
    'Cycling': 'Cycle for 30-45 minutes at a moderate pace. Vary your speed and resistance.',
    'Cycling Cardio': 'Cycle for 45-60 minutes at a moderate to high intensity. Incorporate hills and sprints.',
    'Crunches': 'Do 3 sets of 15-20 reps. Focus on contracting your abdominal muscles and avoid pulling on your neck.',
    'Leg Raises': 'Perform 3 sets of 15-20 reps. Keep your legs straight and controlled.',
    'Plank': 'Hold for 30-60 seconds, repeat 3 times. Engage your core and maintain a straight line from head to heels.',
    'Burpees': 'Do 3 sets of 10-15 reps. Move quickly and focus on full-body engagement.',
    'Jumping Jacks': 'Perform for 30-60 seconds, repeat 3-5 times. Keep a steady pace and engage your entire body.',
    'Mountain Climbers': 'Do for 30-60 seconds, repeat 3-5 times. Alternate legs quickly and engage your core.',
    'Pull-ups': 'Aim for 3 sets of as many reps as possible. Use assisted pull-up bands if needed.',
    'Dips': 'Do 3 sets of 8-12 reps. Control the movement and focus on your triceps.',
    'Pistol Squats': 'Perform 3 sets of 5-8 reps per leg. Use assistance if needed and maintain balance.',
    'Yoga': 'Attend a yoga class or follow a video. Focus on your breathing and holding each pose.',
    'Pilates': 'Attend a class or follow a video. Focus on slow, controlled movements and core engagement.',
    'Bodyweight Circuit': 'Perform each exercise in the circuit for 30-60 seconds, with minimal rest between exercises. Repeat the circuit 3-5 times.',
    'Swimming': 'Swim for 30-45 minutes. Vary your strokes and intensity for a full-body workout.',
  };

  final String benchPressImagePath = 'images/Bench Press.webp';
  final String pushupsImagePath = 'images/Push-ups.webp';
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
                  pushupsImagePath,
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Squats')
                Image.asset(
                  'images/Squats.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Jumping Jacks')
                Image.asset(
                  'images/Jumping Jacks.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Running')
                Image.asset(
                  'images/Running.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Running Cardio')
                Image.asset(
                  'images/Running Cardio.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Cycling Cardio')
                Image.asset(
                  'images/Cycling Cardio.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Light Jogging')
                Image.asset(
                  'images/Light Jogging.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'HIIT')
                Image.asset(
                  'images/HIIT.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Yoga')
                Image.asset(
                  'images/Yoga.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Dips')
                Image.asset(
                  'images/Dips.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Burpees')
                Image.asset(
                  'images/Burpees.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Bicep Curls')
                Image.asset(
                  'images/Bicep Curls.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Lunges')
                Image.asset(
                  'images/Lunges.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Walking')
                Image.asset(
                  'images/Walking.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Basic Yoga')
                Image.asset(
                  'images/Basic Yoga.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Deadlifts')
                Image.asset(
                  'images/Deadlifts.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Cycling')
                Image.asset(
                  'images/Cycling.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Crunches')
                Image.asset(
                  'images/Crunches.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Leg Raises')
                Image.asset(
                  'images/Leg Raises.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Plank')
                Image.asset(
                  'images/Plank.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Mountain Climbers')
                Image.asset(
                  'images/Mountain Climbers.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Pull-ups')
                Image.asset(
                  'images/Pull-ups.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Pistol Squats')
                Image.asset(
                  'images/Pistol Squats.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Pilates')
                Image.asset(
                  'images/Pilates.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Bodyweight Circuit')
                Image.asset(
                  'images/Bodyweight Circuit.webp',
                  width: 200,
                  height: 150,
                ),
              if (exercise == 'Swimming')
                Image.asset(
                  'images/Swimming.webp',
                  width: 200,
                  height: 150,
                ),
              Text(exerciseDescriptions[exercise] ?? 'No description available.'),
              SizedBox(height: 10),
              Text('Recommended: ${exerciseStrategies[exercise] ?? 'No strategy available.'}', style: TextStyle(fontStyle: FontStyle.italic)),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, color: Colors.white),
                        SizedBox(width: 8),
                        Text(option, style: TextStyle(fontFamily: 'Roboto')),
                      ],
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