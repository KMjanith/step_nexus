import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:walking_nexus/services/NotificationHelper.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

/// ← This annotation is required so that android_alarm_manager_plus can
///     invoke the callback from native code.
///
/// See: https://github.com/dart-lang/sdk/blob/master/runtime/docs/compiler/aot/entry_point_pragma.md
@pragma('vm:entry-point')
void alarmCallback() {
  NotificationHelper.showNotification(
    title: "Walk Reminder",
    body: "Your scheduled walk is about to start!",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Initialize timezone data
  tz.initializeTimeZones();
  String currentTz = tz.local.name;
  try {
    currentTz = await FlutterTimezone.getLocalTimezone();
  } catch (_) {
    // fallback if plugin fails
  }
  tz.setLocalLocation(tz.getLocation(currentTz));

  // 2) Initialize NotificationHelper (creates channels, etc.)
  await NotificationHelper.initialize();

  // 3) Initialize the Android Alarm Manager
  await AndroidAlarmManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
