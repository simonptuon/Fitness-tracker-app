import 'package:flutter/material.dart';
import 'package:fitness_app_capstone/pie_chart.dart';

class CaloriesBurned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calories Burned',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
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
            children: <Widget>[
              Text(
                'Calories Burned',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
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
                child: PieChart(
                values: [100, 300, 200, 200, 100],
                colors: [
                  Colors.yellow,
                  Colors.green,
                  Colors.red,
                  Colors.blue,
                  Colors.grey,
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CaloriesBurned extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calories Burned'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Calories Burned:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CaloriesBurned extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calories Burned'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Calories Burned',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             SizedBox(height: 20),
//             BarChart(
//               BarChartData(
//                 barGroups: [
//                   BarChartGroupData(
//                     x: 0,
//                     barRods: [
//                       BarChartRodData(y: 100, colors: [Colors.yellow]),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 1,
//                     barRods: [
//                       BarChartRodData(y: 300, colors: [Colors.green]),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 2,
//                     barRods: [
//                       BarChartRodData(y: 200, colors: [Colors.red]),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 3,
//                     barRods: [
//                       BarChartRodData(y: 200, colors: [Colors.blue]),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 4,
//                     barRods: [
//                       BarChartRodData(y: 100, colors: [Colors.grey]),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }