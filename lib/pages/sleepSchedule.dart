import 'package:flutter/material.dart';

// TEst

class SleepSchedule extends StatelessWidget {
  const SleepSchedule({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Luis Hernandez,", style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  Text("Good Morning ",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text("🌞", style: TextStyle(fontSize: 24)),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF9779F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "You have slept 09:30 that is above your recommendation",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(Icons.close, color: Colors.white),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Your Sleep Calendar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(6, (index) {
                  List<String> days = [
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun"
                  ];
                  List<String> dates = ["22", "23", "24", "25", "26", "27"];
                  bool isSelected = dates[index] == "24";

                  return Column(
                    children: [
                      Text(days[index],
                          style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey)),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          dates[index],
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: SleepCard(
                          title: "Bed time",
                          duration: "7H and 28Min",
                          icon: Icons.bed)),
                  SizedBox(width: 16),
                  Expanded(
                      child: SleepCard(
                          title: "Alarm",
                          duration: "16H and 18Min",
                          icon: Icons.alarm)),
                ],
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEFEFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Have a problem",
                              style: TextStyle(color: Colors.grey)),
                          Text("Sleeping?",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD1CCF7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("Consult an expert",
                                style: TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                          "assets/sleeping_girl.png"), // Make sure this asset exists
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class SleepCard extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;

  SleepCard({required this.title, required this.duration, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.purple),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(duration),
          SizedBox(height: 8),
          Switch(value: true, onChanged: (_) {}),
        ],
      ),
    );
  }
}
