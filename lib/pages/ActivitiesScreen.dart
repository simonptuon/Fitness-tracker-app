import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}
const Color backgroundColor = Color(0xFF7D8DE2);
const Color backgroundColor2 = Color(0xFF00A1FF);

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Activities'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              '',
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActivityCard(
                    icon: Icons.directions_walk,
                    title: 'Steps',
                    value: '5,375',
                    unit: 'steps',
                  ),
                  _buildActivityCard(
                    icon: Icons.bedtime,
                    title: 'Sleep',
                    value: '8:00',
                    unit: 'h',
                  ),
                  _buildActivityCard(
                    icon: Icons.local_fire_department,
                    title: 'Kcal',
                    value: '375',
                    unit: 'kcal',
                  ),
                  _buildActivityCard(
                    icon: Icons.favorite,
                    title: 'Heart',
                    value: '72',
                    unit: 'bpm',
                  ),
                  _buildMealCard(),
                  _buildMealCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Text(value, style: TextStyle(fontSize: 20)),
                SizedBox(width: 4),
                Text(unit),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daily Meals', style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.more_vert),
              ],
            ),
            SizedBox(height: 8),
            Text('Breakfast - Eggs & Toast'),
            Text('Lunch - Salad'),
          ],
        ),
      ),
    );
  }
}