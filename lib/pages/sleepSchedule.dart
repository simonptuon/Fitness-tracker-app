import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alarm/alarm.dart';

class SleepSchedule extends StatefulWidget {
  const SleepSchedule({super.key});

  @override
  State<SleepSchedule> createState() => _SleepScheduleState();
}

class _SleepScheduleState extends State<SleepSchedule> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay bedtime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay alarmTime = const TimeOfDay(hour: 6, minute: 30);

  List<DateTime> getWeekDates() {
    final now = DateTime.now();
    return List.generate(14, (i) => now.add(Duration(days: i - 3)));
  }

  String getSleepDuration() {
    final now = DateTime.now();
    final bed =
        DateTime(now.year, now.month, now.day, bedtime.hour, bedtime.minute);
    final alarm = DateTime(
        now.year, now.month, now.day, alarmTime.hour, alarmTime.minute);
    final duration = alarm.isBefore(bed)
        ? alarm.add(const Duration(days: 1)).difference(bed)
        : alarm.difference(bed);
    return "\${duration.inHours}H \${duration.inMinutes.remainder(60)}Min";
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good morning 🌞";
    if (hour >= 12 && hour < 18) return "Good afternoon ☀️";
    if (hour >= 18 && hour < 22) return "Good evening 🌙";
    return "Good night 🌌";
  }

  Future<void> _scheduleAlarm(TimeOfDay newTime) async {
    final now = DateTime.now();
    var scheduled =
        DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final settings = AlarmSettings(
      id: 0,
      dateTime: scheduled,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: false,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: Duration(seconds: 1),
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'Alarm',
        body: 'Time to wake up!',
        stopButton: 'Stop Alarm',
      ),
    );

    await Alarm.set(alarmSettings: settings);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Alarm set for \${DateFormat.jm().format(scheduled)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = getWeekDates();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome back!", style: TextStyle(color: Colors.grey)),
              Text(getGreeting(),
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF9779F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("Planned sleep: \${getSleepDuration()}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                    const Icon(Icons.nightlight_round, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Your Sleep Calendar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekDates.length,
                  itemBuilder: (context, index) {
                    final date = weekDates[index];
                    final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                    return GestureDetector(
                      onTap: () => setState(() => selectedDate = date),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Text(DateFormat('E').format(date),
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(DateFormat('d').format(date),
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SleepCard(
                      title: "Bed time",
                      icon: Icons.bed,
                      time: bedtime,
                      onTimeChanged: (newTime) =>
                          setState(() => bedtime = newTime),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SleepCard(
                      title: "Alarm",
                      icon: Icons.alarm,
                      time: alarmTime,
                      onTimeChanged: (newTime) {
                        setState(() => alarmTime = newTime);
                        _scheduleAlarm(newTime);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Have a problem",
                              style: TextStyle(color: Colors.grey)),
                          const Text("Sleeping?",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              final Uri url =
                                  Uri.parse('https://www.sleepfoundation.org/');
                              if (await canLaunchUrl(url))
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1CCF7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Consult an expert",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("assets/yawning_baby.jpg")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SleepCard extends StatelessWidget {
  final String title;
  final TimeOfDay time;
  final IconData icon;
  final Function(TimeOfDay) onTimeChanged;

  const SleepCard({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.onTimeChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) onTimeChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = time.format(context);
    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F4FF),
            borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(formattedTime)
        ]),
      ),
    );
  }
}
