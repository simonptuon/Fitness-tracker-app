import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_capstone/data/notifiers.dart';
import 'package:fitness_app_capstone/pages/custom_drawer.dart';
import 'package:fitness_app_capstone/pages/history_water_page.dart';
import 'package:fitness_app_capstone/pages/report_water_page.dart';
import 'package:fitness_app_capstone/pages/water_home_page.dart';
import 'package:flutter/material.dart';

import '../pages/widgets/navbar.dart';
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
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          'Water Consumption',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
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
