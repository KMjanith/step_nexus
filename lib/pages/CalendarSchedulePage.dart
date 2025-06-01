import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:walking_nexus/components/BottomNavigationButton.dart';
import 'package:walking_nexus/main.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
import 'package:walking_nexus/services/NotificationHelper.dart';
import 'package:walking_nexus/sources/database_helper.dart';

class CalendarSchedulePage extends StatefulWidget {
  const CalendarSchedulePage({super.key});
  @override
  State<CalendarSchedulePage> createState() => _CalendarSchedulePageState();
}

class _CalendarSchedulePageState extends State<CalendarSchedulePage> {
  final Map<DateTime, Map<String, dynamic>> scheduledDays = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadScheduledSessions();
  }

  Future<void> _loadScheduledSessions() async {
    final sessions = await DatabaseHelper.instance.getAllScheduledWalks();
    setState(() {
      scheduledDays.clear();
      for (var session in sessions) {
        final date = DateTime.parse(session['date']);
        scheduledDays[_dayOnly(date)] = session;
      }
    });
  }

  DateTime _dayOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Walking Schedule')),
      body: Stack(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showScheduleDialog(selectedDay);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) =>
                  _buildDayCell(day, isSelected: false),
              selectedBuilder: (context, day, _) {
                final isScheduled = scheduledDays.containsKey(_dayOnly(day));
                return _buildDayCell(day, isSelected: !isScheduled);
              },
            ),
          ),

          // bottom navigation bar
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 104, 122),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Bottomnavigationbutton(
                      onPressed: () =>
                          _navigateToTargetSelection(context, Activity.walking, false),
                      icon: Icons.nordic_walking,
                      iconDescription: "Walk",
                    ),
                    Bottomnavigationbutton(
                      onPressed: () =>
                          _navigateToTargetSelection(context, Activity.cycling, false),
                      icon: Icons.pedal_bike,
                      iconDescription: "Cycle",
                    ),
                    Bottomnavigationbutton(
                      onPressed: () =>
                          _navigateToTargetSelection(context, Activity.travelling, false),
                      icon: Icons.travel_explore,
                      iconDescription: "Travel",
                    ),
                    Bottomnavigationbutton(
                      onPressed: () =>
                          _navigateToTargetSelection(context, Activity.travelling, true),
                      icon: Icons.home,
                      iconDescription: "home",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTargetSelection(
      BuildContext context, Activity activity, bool home) {
    Navigator.pop(context);
    if (home) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TargetSelectionScreen(activity: activity)),
    );
  }

  void _showScheduleDialog(DateTime date) {
    String? goalType;
    final valueController = TextEditingController();
    TimeOfDay? startTime;

    final existing = scheduledDays[_dayOnly(date)];
    if (existing != null) {
      goalType = existing['goal_type'];
      valueController.text = existing['goal_value'].toString();
      final parts = (existing['start_time'] as String).split(':');
      if (parts.length == 2) {
        startTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(
            "Set schedule for ${DateFormat('EEE, MMM d').format(date)}",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: goalType,
                hint: const Text("Select Goal Type"),
                onChanged: (value) {
                  setModalState(() {
                    goalType = value!;
                    valueController.clear();
                  });
                },
                items: ["time", "distance", "steps"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 10),
              if (goalType != null)
                TextFormField(
                  controller: valueController,
                  keyboardType: goalType == 'steps'
                      ? TextInputType.number
                      : const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: goalType == "time"
                        ? "Duration (minutes)"
                        : goalType == "distance"
                            ? "Distance (km)"
                            : "Steps",
                  ),
                ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 109, 109, 109),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startTime?.format(context) ?? "Time Not set",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 104, 122),
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: startTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setModalState(() {
                              startTime = picked;
                            });
                          }
                        },
                        child: const Text(
                          "Pick",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 178, 220, 255),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 104, 122),
              ),
              onPressed: () async {
                if (goalType != null &&
                    valueController.text.isNotEmpty &&
                    startTime != null) {
                  final goalValue = double.tryParse(valueController.text);
                  if (goalValue == null) return;

                  final timeString =
                      "${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}";

                  final data = {
                    'date': DateFormat('yyyy-MM-dd').format(date),
                    'goal_type': goalType!,
                    'goal_value': goalValue,
                    'start_time': timeString,
                  };

                  if (existing != null) {
                    await DatabaseHelper.instance
                        .deleteScheduledWalk(existing['id']);
                  }

                  // 1) Save to database
                  final newId =
                      await DatabaseHelper.instance.insertScheduledWalk(data);

                  // 2) Calculate "10 minutes before" the chosen startTime
                  final scheduledDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    startTime!.hour,
                    startTime!.minute,
                  );
                  final fireDate =
                      scheduledDateTime.subtract(const Duration(minutes: 10));

                  // 3) Schedule the alarm for that “fireDate”
                  await AndroidAlarmManager.oneShotAt(
                    fireDate,
                    newId,         // unique alarm ID
                    alarmCallback, // top-level function (marked with @pragma)
                    exact: true,
                    wakeup: true,
                  );

                  // 4) Refresh UI and close dialog
                  await _loadScheduledSessions();
                  Navigator.pop(context);
                }
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, {required bool isSelected}) {
    final dayKey = _dayOnly(day);
    final session = scheduledDays[dayKey];

    String? label;
    if (session != null) {
      final goal = session['goal_type'];
      label = goal == 'steps'
          ? 'S'
          : goal == 'distance'
              ? 'D'
              : 'T';
    }

    Color? bgColor;
    if (session != null) {
      bgColor = Colors.green[200];
    } else if (isSelected) {
      bgColor = const Color.fromARGB(255, 139, 195, 241);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.only(right: 10, top: 4, bottom: 4, left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          if (label != null) Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
