import 'package:fitness_app_capstone/pages/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

const Color backgroundColor = Color(0xFF1c2e65);
const Color backgroundColor2 = Color(0xFF4e6cbb);
const Color testColor = Color(0xFF3D78EA);
const Color testColor2 = Color(0xFF1D66AA);
const Color backgroundColorCard = Color(0xFF483867);
const Color backgroundColorCard2 = Color(0xFF3D78EA);

const Color textColor = Color(0xFF0C0C0C);
const Color textColor2 = Color(0xFFF9F6EE);
const Color iconColor = Color(0xFF583867);

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String selectedFilter = 'Daily';
  final List<String> filters = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  bool showStepsProgress = true;

  // Helper method to get data based on selected time period
  Map<String, dynamic> _getTimePeriodData(Map<String, dynamic> data) {
    switch (selectedFilter) {
      case 'Weekly':
        return {
          'steps': data['weeklySteps'] ?? 0,
          'sleep': data['weeklySleep'] ?? '56:00',
          'heartRate': data['weeklyHeartRate'] ?? 72,
          'calories': data['weeklyCaloriesBurned'] ?? 2625,
          'goalSteps': 70000,
          'goalCalories': 21000,
        };
      case 'Monthly':
        return {
          'steps': data['monthlySteps'] ?? 0,
          'sleep': data['monthlySleep'] ?? '240:00',
          'heartRate': data['monthlyHeartRate'] ?? 72,
          'calories': data['monthlyCaloriesBurned'] ?? 11250,
          'goalSteps': 300000,
          'goalCalories': 90000,
        };
      case 'Yearly':
        return {
          'steps': data['yearlySteps'] ?? 0,
          'sleep': data['yearlySleep'] ?? '2920:00',
          'heartRate': data['yearlyHeartRate'] ?? 72,
          'calories': data['yearlyCaloriesBurned'] ?? 136875,
          'goalSteps': 3650000,
          'goalCalories': 1095000,
        };
      case 'Daily':
      default:
        return {
          'steps': data['stepCount'] ?? 0,
          'sleep': data['sleep'] ?? '8:00',
          'heartRate': data['heartRate'] ?? 72,
          'calories': data['caloriesBurned'] ?? 375,
          'goalSteps': 10000,
          'goalCalories': 3000,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [backgroundColor, backgroundColor2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('$selectedFilter Activities', style: const TextStyle(color: Colors.black)),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.teal),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: selectedFilter == filter
                              ? const LinearGradient(
                            colors: [testColor2, testColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: selectedFilter == filter ? FontWeight.bold : FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final periodData = _getTimePeriodData(data);

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showStepsProgress = !showStepsProgress;
                                  });
                                },
                                child: _buildActivityCard(
                                  icon: Icons.directions_walk_outlined,
                                  title: 'Steps',
                                  value: periodData['steps'].toString(),
                                  unit: 'steps',
                                  height: 240,
                                  circularIndicator: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return ScaleTransition(scale: animation, child: child);
                                    },
                                    child: showStepsProgress
                                        ? CircularPercentIndicator(
                                      key: const ValueKey('progress'),
                                      radius: 40.0,
                                      lineWidth: 4.0,
                                      percent: (periodData['steps'] / periodData['goalSteps']).clamp(0.0, 1.0),
                                      center: Text(
                                        "${((periodData['steps'] / periodData['goalSteps']) * 100).toInt()}%\nSteps",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: iconColor),
                                      ),
                                      progressColor: iconColor,
                                      backgroundColor: Colors.white24,
                                      circularStrokeCap: CircularStrokeCap.round,
                                      animation: true,
                                      animationDuration: 1200,
                                    )
                                        : Column(
                                      key: const ValueKey('count'),
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${periodData['steps']}',
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: iconColor,
                                          ),
                                        ),
                                        Text(
                                          '/ ${periodData['goalSteps']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: iconColor,
                                          ),
                                        ),
                                        const Text(
                                          'steps',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: iconColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _buildActivityCard(
                                icon: Icons.bedtime_outlined,
                                title: 'Sleep',
                                value: periodData['sleep'].toString(),
                                unit: 'h',
                                height: 150,
                                titleColor: Colors.white,
                                colorIcon: Colors.white,
                                iconColorBG: Colors.white,
                              ),
                              _buildActivityCard(
                                icon: Icons.favorite_outline,
                                title: 'Heart',
                                value: periodData['heartRate'].toString(),
                                unit: 'bpm',
                                height: 180,
                              ),
                              _buildActivityCard(
                                icon: Icons.local_fire_department_outlined,
                                title: 'Kcal',
                                value: periodData['calories'].toString(),
                                unit: 'kcal',
                                height: 240,
                                circularIndicator: CircularPercentIndicator(
                                  radius: 40.0,
                                  lineWidth: 4.0,
                                  percent: (periodData['calories'] / periodData['goalCalories']).clamp(0.0, 1.0),
                                  center: Text(
                                    "${periodData['calories']}\nKcal",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: iconColor),
                                  ),
                                  progressColor: iconColor,
                                  backgroundColor: Colors.white24,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  animation: true,
                                  animationDuration: 1200,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          _buildMealCard(),
                          const SizedBox(height: 5),
                          _buildMealCard(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    double? height,
    Color? titleColor,
    Color? colorIcon,
    Color? iconColorBG,
    Widget? circularIndicator,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: title == 'Sleep'
            ? const LinearGradient(
          colors: [backgroundColorCard, backgroundColorCard2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: title == 'Sleep' ? null : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: title == 'Sleep' ? Colors.white : titleColor)),
                Container(
                  decoration: BoxDecoration(
                    color: title == 'Sleep' ? Colors.white : iconColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(icon,
                      size: 32,
                      color: title == 'Sleep' ? Colors.black : Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (circularIndicator != null)
              Expanded(child: Center(child: circularIndicator)),
            if (circularIndicator == null) ...[
              Row(
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 25,
                          color: title == 'Sleep' ? Colors.white : colorIcon)),
                  const SizedBox(width: 4),
                  Text(unit,
                      style: TextStyle(
                          color: title == 'Sleep' ? Colors.white : null)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$selectedFilter Meals',
                      style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
                  const Icon(Icons.restaurant_menu_outlined,
                      color: iconColor, size: 32),
                ],
              ),
              const SizedBox(height: 5),
              Text('No meals logged this $selectedFilter.toLowerCase().',
                  style: const TextStyle(color: Colors.black54))
            ],
          ),
        ),
      ),
    );
  }
}