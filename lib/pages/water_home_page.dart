import 'dart:async';
import 'dart:math';
import 'package:fitness_app_capstone/pages/history_water_page.dart';
import 'package:fitness_app_capstone/pages/widgets/enter_amount_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WaterDropPainter extends CustomPainter {
  final Animation<double> animation;
  final double progress;

  WaterDropPainter(this.animation, this.progress) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 55, 158, 255)
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double waveHeight = 8.0;
    final double progressHeight = size.height * (1.0 - progress);
    final double waveSpeed = animation.value * size.width;

    path.moveTo(0, size.height);
    for (double i = 0.0; i <= size.width; i++) {
      double y = waveHeight * sin((i + waveSpeed) * 2 * pi / size.width) + progressHeight;
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

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

  List<Map<String, dynamic>> history = [];
  final ValueNotifier<List<Map<String, dynamic>>> historyNotifier =
  ValueNotifier([]);

  double get progress => intake / goal;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2)
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _progressAnimation = Tween<double>(
        begin: 0.0,
        end: progress
    ).animate(
      CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeInOut
      ),
    );

    _progressController.forward();
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

      final historyString = prefs.getString('history');
      if (historyString != null) {
        try {
          final List<dynamic> decodedHistory = json.decode(historyString);
          history = List<Map<String, dynamic>>.from(decodedHistory);
          historyNotifier.value = List.from(history);
        } catch (e) {
          history = [];
          historyNotifier.value = [];
        }
      }

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
      if (intake + amount >= goal) {
        intake = goal;
      } else {
        intake += amount;
      }

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
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.water_drop, color: Colors.blue);
                  },
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 380,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 160,
                      lineWidth: 30.0,
                      percent: _progressAnimation.value.clamp(0.0, 1.0),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: intake >= goal ? Colors.green : const Color.fromARGB(255, 55, 158, 255),
                      backgroundColor: const Color(0xFFEEEEEE),
                      animation: true,
                    ),
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CustomPaint(
                        painter: WaterDropPainter(_waveController, progress),
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Text("$intake", style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.black)),
                        Text("/$goal mL", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _showEnterAmountDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 158, 255),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    ),
                    child: const Text("Drink"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: historyNotifier,
                builder: (context, history, child) {
                  if (history.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.history, size: 50, color: Color.fromARGB(255, 195, 195, 195)),
                        SizedBox(height: 10),
                        Text("You have no history of water intake today", textAlign: TextAlign.center),
                      ],
                    );
                  }
                  return Column(
                    children: history.map((item) {
                      return ListTile(
                        leading: Image.asset(
                          item['image'],
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.water_drop, color: Colors.blue);
                          },
                        ),
                        title: Text(item['name']),
                        subtitle: Text(item['time']),
                        trailing: Text(item['amount']),
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
