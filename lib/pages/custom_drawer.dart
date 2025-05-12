import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override

  Widget build(BuildContext context) {
    const Color backgroundColor2 = Color(0xFF4e6cbb);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor2,
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
            leading: Icon(Icons.fitness_center),
            title: Text('Activities'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/activities');
            },
          ),
          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text('Water Tracker'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/consumption');
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_walk),
            title: Text('Pedometer'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/pedometer');
            },
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Workout Plans'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/workoutplans');
            },
          ),
          ListTile(
            leading: Icon(Icons.fireplace),
            title: Text('Calories Burned'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/calories');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
