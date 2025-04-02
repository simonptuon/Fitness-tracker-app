import 'dart:async';
import 'dart:math';
import 'package:fitness_app_capstone/views/pages/history_water_page.dart';
import 'package:fitness_app_capstone/views/widgets/enter_amount_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitness_app_capstone/views/widgets/waterPaintDroplet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WaterHomePage extends StatefulWidget {
  const WaterHomePage({super.key});

  @override
  _WaterHomePageState createState() => _WaterHomePageState();
}

class _WaterHomePageState extends State<WaterHomePage>
    with TickerProviderStateMixin {
  final int goal = 2500;
  int intake = 0;
  int lastEnteredAmount = 0;
  late AnimationController _waveController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool isPressed = false;

  // History list to store entries
  List<Map<String, dynamic>> history = [];
  final ValueNotifier<List<Map<String, dynamic>>> historyNotifier =
      ValueNotifier([]);

  double get progress => intake / goal;

  @override
  void initState() {
    super.initState();
    _waveController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: progress).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _loadHistory();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      intake = prefs.getInt('intake') ?? 0;
      _updateProgressAnimation();
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String historyJson = json.encode(history);
    await prefs.setString('history', historyJson);
    await prefs.setInt('intake', intake);
  }

  void drinkWater(int amount) {
    setState(() {
      final previousProgress = progress;

      if (intake + amount >= goal) {
        intake = goal;
      } else {
        intake += amount;
      }

      // Add to history
      final newEntry = {
        'name': 'Water',
        'image': 'assets/cup.png',
        'time': DateFormat('hh:mm a').format(DateTime.now()),
        'amount': '$amount mL',
      };
      history.add(newEntry);
      historyNotifier.value = List.from(history);

      _saveHistory();

      if (intake >= goal) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            intake = 0;
            _progressController.reset();
            _updateProgressAnimation();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Congratulations! You reached your goal!',
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        });
      }

      _updateProgressAnimation();
    });
  }

  void _updateProgressAnimation() {
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: progress.clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _progressController.forward(from: 0.0);
  }

  void _showEnterAmountDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset(
                  'assets/cup.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter mL",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final int? enteredAmount = int.tryParse(controller.text);
                      if (enteredAmount != null && enteredAmount > 0) {
                        setState(() {
                          drinkWater(enteredAmount);
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //Droplet and Indicator
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: double.infinity,
                  height: 450,
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                animation: false,
                                radius: 160,
                                lineWidth: 30.0,
                                percent: 1.0,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xFFEEEEEE),
                                backgroundColor: Colors.transparent,
                                startAngle: 200,
                                arcType: ArcType.FULL,
                              ),
                              CircularPercentIndicator(
                                animation: false,
                                radius: 160,
                                lineWidth: 30.0,
                                percent:
                                    _progressAnimation.value.clamp(0.0, 1.0),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: intake >= goal
                                    ? Colors.green
                                    : const Color.fromARGB(255, 55, 158, 255),
                                backgroundColor: Colors.transparent,
                                startAngle: 180,
                                arcType: ArcType.FULL,
                              ),
                              CustomPaint(
                                size: const Size(180, 180),
                                painter:
                                    WaterDropPainter(_waveController, progress),
                              ),
                            ],
                          );
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 280),
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "$intake",
                                style: GoogleFonts.inter(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "/$goal mL",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _showEnterAmountDialog(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (states) => isPressed
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 55, 158, 255),
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (states) => isPressed
                                        ? const Color.fromARGB(
                                            255, 55, 158, 255)
                                        : Colors.white,
                                  ),
                                  side: MaterialStateProperty.resolveWith<
                                      BorderSide>(
                                    (states) => BorderSide(
                                      color: isPressed
                                          ? const Color.fromARGB(
                                              255, 55, 158, 255)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                      vertical: 22.0,
                                      horizontal: 25.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  isPressed ? "Drinking..." : "Drink",
                                ),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EnterAmountDialog(
                                        onConfirm: (int enteredAmount) {
                                          setState(() {
                                            drinkWater(enteredAmount);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<CircleBorder>(
                                    CircleBorder(
                                      side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 195, 195, 195),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(8.0),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/cup.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //History
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HistoryPage(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.blueAccent,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(
                          color: Color.fromARGB(255, 195, 195, 195),
                          thickness: 1.0,
                        ),
                        ValueListenableBuilder(
                          valueListenable: historyNotifier,
                          builder: (context, history, child) {
                            if (history.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 50,
                                    color: Color.fromARGB(255, 195, 195, 195),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "You have no history of water intake today",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 195, 195, 195),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: List.generate(history.length, (index) {
                                final item = history[index];
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                item['image'],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  item['time'],
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              item['amount'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            PopupMenuButton<String>(
                                              icon: Icon(
                                                  Icons.more_vert_outlined),
                                              onSelected: (value) async {
                                                if (value == 'delete') {
                                                  setState(() {
                                                    history.removeAt(index);
                                                    historyNotifier.value =
                                                        List.from(history);
                                                  });
                                                  await _saveHistory();
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color.fromARGB(255, 195, 195, 195),
                                      thickness: 1.0,
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
