import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Get device timezone string (e.g., "Asia/Kolkata")
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    // Set local timezone
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initializationSettings);

    const androidChannel = AndroidNotificationChannel(
      'walk_channel_id',
      'Walk Schedule',
      description: 'Scheduled walk reminders',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'idling_channel', // Channel ID
      'Idling Notifications', // Channel name
      channelDescription: 'Notifications for idling detection',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformDetails,
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    const androidDetails = AndroidNotificationDetails(
      'walk_channel_id', // Must match your notification channel
      'Walk Schedule', // Channel name
      channelDescription: 'Scheduled walk reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      notificationDetails, // ✅ fixed here
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("Notification scheduled for $scheduleDate");
  }
}
