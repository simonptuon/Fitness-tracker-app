import 'dart:convert';
import 'dart:io';

import 'package:fitness_app_capstone/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CalorieData {
  CalorieData(this.date, this.calories);
  final String date;
  final double calories;
}
// Future<List<CalorieData>> loadCalorieData() async {
//   try {
//     final file = File('calorie_data.json');
//     if (!await file.exists()) {
//       await file.create();
//       await file.writeAsString(jsonEncode([])); // Write an empty list as initial content
//     }
//
//     final String response = await file.readAsString();
//     final data = await json.decode(response);
//     List<CalorieData> calorieData = [];
//
//     for (var entry in data) {
//       calorieData.add(CalorieData(entry['date'], entry['calories'].toDouble()));
//     }
//     return calorieData;
//   } catch (e) {
//     print('Error loading calorie data: $e');
//     return []; // Return an empty list in case of an error
//   }
// }

Future<List<CalorieData>> loadCalorieData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return []; // Return an empty list if no user is logged in
  }

  try {
    List<CalorieData> calorieData = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('calorieData').doc(user.uid).collection('weeklyData').get();
    for (var doc in snapshot.docs) {
      calorieData.add(CalorieData(doc['date'], doc['calories'].toDouble()));
    }
    return calorieData;
  } catch (e) {
    print('Error loading calorie data: $e');
    return []; // Return an empty list in case of an error
  }
}

class CaloriesBurned extends StatefulWidget {
  @override
  _CaloriesBurnedState createState() => _CaloriesBurnedState();
}

class _CaloriesBurnedState extends State<CaloriesBurned> {
  List<CalorieData> calorieData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }
/*
  const CaloriesBurned({super.key});
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calories Burned',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(
            Icons.home, color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(16.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Weekly Calories Burned'),
                  series: <ColumnSeries<CalorieData, String>>[
                    ColumnSeries<CalorieData, String>(
                      dataSource: calorieData,
                      xValueMapper: (CalorieData data, _) => data.date,
                      yValueMapper: (CalorieData data, _) => data.calories,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _loadData() async {
    List<CalorieData> data = await loadCalorieData();
    setState(() {
      calorieData = data;
    });
  }
}
