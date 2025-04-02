import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CalorieData {
  CalorieData(this.date, this.calories);
  final String date;
  final double calories;
}

class CaloriesBurned extends StatelessWidget {
  final List<CalorieData> calorieData = [
    CalorieData('Mon', 200),
    CalorieData('Tue', 300),
    CalorieData('Wed', 250),
    CalorieData('Thu', 400),
    CalorieData('Fri', 350),
    CalorieData('Sat', 450),
    CalorieData('Sun', 500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calories Burned',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
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
                  // series: <ChartSeries>[
                  //   ColumnSeries<CalorieData, String>(
                  //     dataSource: calorieData,
                  //     xValueMapper: (CalorieData data, _) => data.date,
                  //     yValueMapper: (CalorieData data, _) => data.calories,
                  //     color: Colors.yellowAccent,
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(10),
                  //       topRight: Radius.circular(10),
                  //     ),
                  //   )
                  // ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}