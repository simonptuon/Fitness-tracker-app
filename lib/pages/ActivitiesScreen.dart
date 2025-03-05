import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                title: Text('Activities', style: TextStyle(color: Colors.black)),
                titleTextStyle: TextStyle(
                  color: Colors.white,
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
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
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
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: selectedFilter == filter
                              ? LinearGradient(
                            colors: [testColor2, testColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                          child: Text(
                            filter,
                            style: TextStyle(
                                color: textColor,
                                fontWeight: selectedFilter == filter ? FontWeight.bold : FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0, // Changed to 1.0 to make the cards square
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return _buildActivityCard(
                            icon: index == 0
                                ? Icons.directions_walk_outlined
                                : index == 1
                                ? Icons.bedtime_outlined
                                : index == 2
                                ? Icons.favorite_outline
                                : Icons.local_fire_department_outlined,
                            title: index == 0
                                ? 'Steps'
                                : index == 1
                                ? 'Sleep'
                                : index == 2
                                ? 'Heart'
                                : 'Kcal',
                            value: index == 0
                                ? '5,375'
                                : index == 1
                                ? '8:00'
                                : index == 2
                                ? '72'
                                : '375',
                            unit: index == 0
                                ? 'steps'
                                : index == 1
                                ? 'h'
                                : index == 2
                                ? 'bpm'
                                : 'kcal',
                            height: index == 0
                                ? 240.0
                                : index == 1
                                ? 150.0
                                : index == 2
                                ? 180.0
                                : 240.0, // Adjust these values as needed
                            titleColor: index == 1 ? Colors.white : null,
                            colorIcon: index == 1 ? Colors.white : null,
                            iconColorBG: index == 1 ? Colors.white : null,
                            circularIndicator: index == 0 || index == 3 ? CircularPercentIndicator(
                              radius: 50.0,
                              lineWidth: 4.0,
                              percent: 0.40,
                              center: const Text(
                                "42%\nSteps",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor),
                              ),
                              progressColor: iconColor,
                              backgroundColor: Colors.white24,
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                              animationDuration: 1200,
                            ) : null, // Add CircularPercentIndicator for Steps and Heart cards
                          );
                        },
                      ),
                      SizedBox(height: 0),
                      _buildMealCard(),
                      SizedBox(height: 5),
                      _buildMealCard(),
                    ],
                  ),
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
      height: height, // Set the height here
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: title == 'Sleep'
            ? LinearGradient(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: title == 'Sleep' ? Colors.white : titleColor)), // Title on the left
                Container( // Icon on the right
                  decoration: BoxDecoration(
                    color: title == 'Sleep' ? Colors.white : iconColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Icon(icon, size: 32, color: title == 'Sleep' ? Colors.black : Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (circularIndicator != null) ...[
              Expanded(
                child: circularIndicator,
              ),
              SizedBox(height: 8),
            ] else ...[
              Row(
                children: [
                  Text(value, style: TextStyle(fontSize: 25, color: title == 'Sleep' ? Colors.white : colorIcon)),
                  SizedBox(width: 4),
                  Text(unit, style: TextStyle(color: title == 'Sleep' ? Colors.white : null)),
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
              offset: Offset(0, 3),
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
                  Text('Daily Meals', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
                  Icon(Icons.restaurant_menu_outlined, color: iconColor, size: 32),
                ],
              ),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}