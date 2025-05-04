import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activty Page',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF007D8C),
        primaryColor: const Color(0xFF00C9A7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00C9A7),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF333333)),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future<Map<String, dynamic>> fetchData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null)
      return {
        'stepCount': 0,
        'caloriesBurned': 0,
        'heartRate': 0,
        'waterConsumed': 0,
      };

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ??
        {
          'stepCount': 0,
          'caloriesBurned': 0,
          'heartRate': 0,
          'fullName': "",
          'waterConsumed': 0,
        };
  }

  @override
  Widget build(BuildContext context) {
    const stepGoal = 10000;
    const calorieGoal = 3500;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchData(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFFA2E4DC)),
                ),
              );
            }
            final data = snap.data!;
            final steps = data['stepCount'] as int;
            final calories = data['caloriesBurned'] as int;
            final hr = data['heartRate'] as int;
            final stepPct = (steps / stepGoal).clamp(0.0, 1.0);
            final calPct = (calories / calorieGoal).clamp(0.0, 1.0);
            final hrPct = (hr / 150).clamp(0.0, 1.0);
            final fullName = (data['fullName'] as String?) ?? '';
            final waterConsumed = (data['waterConsumed'] as num).toDouble();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome back, $fullName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.mic),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA2E4DC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.directions_run,
                          size: 32,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You're ${(stepPct * 100).toInt()}% to your step goal!",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Keep it up!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // first row: two stat cards side by side
                      Row(
                        children: [
                          _StatCard(
                            value: steps.toString(),
                            title: 'Steps',
                            percent: stepPct,
                            ringColor: const Color(0xFF00C9A7),
                            backgroundRingColor: const Color(0xFFA2E4DC),
                            heartIcon: Icons.favorite,
                            bottomLeftLabel: '${hr.toString()} bpm',
                            bottomRightPlaceholder: true,
                          ),
                          const SizedBox(width: 16),
                          _StatCard(
                            value: calories.toString(),
                            title: 'Calories',
                            percent: calPct,
                            ringColor: const Color(0xFF00C9A7),
                            backgroundRingColor: const Color(0xFFF0F0F0),
                            waterDrop: Icons.water_drop,
                            bottomLeftLabel: '$waterConsumed L',
                            bottomRightPlaceholder: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // second row: one stat card + badge panel
                      Row(
                        children: [
                          _StatCard(
                            value: hr.toString(),
                            title: 'Heart',
                            percent: hrPct,
                            ringColor: const Color(0xFF00C9A7),
                            backgroundRingColor: const Color(0xFFA2E4DC),
                            waterDrop: Icons.water_drop,
                            bottomLeftLabel: '$waterConsumed L',
                            bottomRightPlaceholder: true,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              _Badge(),
                              const SizedBox(
                                height: 8,
                              ),
                              _GoalTile([
                                "Reach 3500 Calories",
                                "Drink 2 L Water",
                                "Log a Workout"
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFF00C9A7)),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: const Color(0xFF00C9A7),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                color: Colors.grey,
                onPressed: () {},
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.track_changes),
                color: Colors.grey,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: Colors.grey,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double percent;
  final Color ringColor;
  final Color backgroundRingColor;
  final IconData? heartIcon;
  final IconData? waterDrop;
  final String bottomLeftLabel;
  final bool bottomRightPlaceholder;

  const _StatCard({
    required this.title,
    required this.value,
    required this.percent,
    required this.ringColor,
    required this.backgroundRingColor,
    this.waterDrop,
    this.heartIcon,
    required this.bottomLeftLabel,
    this.bottomRightPlaceholder = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10,
            percent: percent,
            center: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: '$value\n',
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  TextSpan(
                    text: '${(percent * 100).toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF00C9A7),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            progressColor: ringColor,
            backgroundColor: backgroundRingColor,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (heartIcon != null)
                    Icon(heartIcon, size: 16, color: Colors.red),
                  if (waterDrop != null)
                    Icon(waterDrop, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    bottomLeftLabel,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          // Badge 1
          Column(
            children: [
              CircleAvatar(
                radius: 16, // smaller
                backgroundColor: Color(0xFFFFF2E5),
                child: Icon(
                  Icons.directions_walk,
                  size: 16, // smaller
                  color: Color(0xFFFFA726),
                ),
              ),
              SizedBox(height: 4), // tighter spacing
              Text(
                '10K Steps',
                style: TextStyle(
                  fontSize: 10, // smaller
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          // Badge 2
          Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFFFF2E5),
                child: Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: Color(0xFFFFA726),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '7d Streak!',
                style: TextStyle(fontSize: 10, color: Color(0xFF333333)),
              ),
            ],
          ),
          // Badge 3
          Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFFFF2E5),
                child: Icon(
                  Icons.bolt,
                  size: 16,
                  color: Color(0xFFFFA726),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Pro',
                style: TextStyle(fontSize: 10, color: Color(0xFF333333)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final List<String> goals;
  const _GoalTile(this.goals, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Goals",
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...goals.map((goal) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_box,
                      size: 16,
                      color: Color(0xFFA2E4DC),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        goal,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
