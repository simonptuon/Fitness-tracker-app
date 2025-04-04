import 'package:fitness_app_capstone/data/notifiers.dart';
import 'package:fitness_app_capstone/views/pages/history_water_page.dart';
import 'package:fitness_app_capstone/views/pages/report_water_page.dart';
import 'package:fitness_app_capstone/views/pages/water_home_page.dart';
import 'package:flutter/material.dart';

import '../widgets/navbar.dart';
import 'account.dart';

List<Widget> pages = [
  WaterHomePage(),
  HistoryPage(),
  ReportPage(),
  AccountPage()
];

class Water extends StatelessWidget {
  const Water({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Consumption',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.water_drop,
          color: Colors.blueAccent,
        ),
        actions: [
          // Icon(Icons.more_vert_outlined),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5), // Set the background color to #F5F5F5
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
