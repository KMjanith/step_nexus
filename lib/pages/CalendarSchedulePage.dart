import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:walking_nexus/components/BottomNavigationButton.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
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
        DateTime date = DateTime.parse(session['date']);
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
              defaultBuilder: (context, day, _) {
                return _buildDayCell(day, isSelected: false);
              },
              selectedBuilder: (context, day, _) {
                final isScheduled = scheduledDays.containsKey(_dayOnly(day));
                // If it’s a scheduled day, draw it like defaultBuilder to keep it green
                return _buildDayCell(day, isSelected: !isScheduled);
              },
            ),
          ),

          //bottom navbar
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Bottomnavigationbutton(
                      onPressed: () => _navigateToTargetSelection(
                          context, Activity.walking, false),
                      icon: Icons.nordic_walking,
                      iconDescription: "Walk",
                    ),
                    Bottomnavigationbutton(
                      onPressed: () => _navigateToTargetSelection(
                          context, Activity.cycling, false),
                      icon: Icons.pedal_bike,
                      iconDescription: "Cycle",
                    ),
                    Bottomnavigationbutton(
                      onPressed: () => _navigateToTargetSelection(
                          context, Activity.travelling, false),
                      icon: Icons.travel_explore,
                      iconDescription: "Travel",
                    ),
                    Bottomnavigationbutton(
                      onPressed: () => _navigateToTargetSelection(
                          context, Activity.travelling, true),
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
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TargetSelectionScreen(activity: activity),
      ),
    );
  }

  void _showScheduleDialog(DateTime date) {
    String? goalType;
    final TextEditingController valueController = TextEditingController();
    TimeOfDay? startTime;

    final existing = scheduledDays[_dayOnly(date)];
    if (existing != null) {
      goalType = existing['goal_type'];
      valueController.text = existing['goal_value'].toString();
      final timeParts = (existing['start_time'] as String).split(':');
      if (timeParts.length == 2) {
        startTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title:
              Text("Set schedule for ${DateFormat('EEE, MMM d').format(date)}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
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
              SizedBox(
                height: 10,
              ),
              if (goalType != null)
                TextFormField(
                  controller: valueController,
                  keyboardType: goalType == 'steps'
                      ? TextInputType.number
                      : const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                    border: Border.all(width: 1, color: const Color.fromARGB(255, 109, 109, 109)),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(startTime?.format(context) ?? "Time Not set",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 9, 148, 141),
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
                        child: const Text("Pick",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 178, 220, 255))),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            if (existing != null)
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 255, 204, 201)),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Schedule"),
                      content: const Text(
                          "Are you sure you want to delete this schedule?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await DatabaseHelper.instance
                        .deleteScheduledWalk(existing['id']);
                    await _loadScheduledSessions();
                    Navigator.pop(context); // close main dialog
                  }
                },
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ElevatedButton(
              onPressed: () async {
                if (goalType != null &&
                    valueController.text.isNotEmpty &&
                    startTime != null) {
                  final goalValue = double.tryParse(valueController.text);
                  if (goalValue == null) return;

                  final timeString =
                      "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}";

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

                  await DatabaseHelper.instance.insertScheduledWalk(data);
                  await _loadScheduledSessions();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 148, 141),
              ),
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
      bgColor = const Color.fromARGB(255, 139, 195, 241); // default blue for non-scheduled days
    }

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.only(right: 10, top:4, bottom: 4, left:10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          if (label != null)
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.black87)),
        ],
      ),
    );
  }
}
