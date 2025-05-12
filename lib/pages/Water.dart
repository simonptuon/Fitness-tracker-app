import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_capstone/data/notifiers.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.teal, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Activities'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/activities');
              },
            ),
            ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text('Water Tracker'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Pedometer'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/pedometer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
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
