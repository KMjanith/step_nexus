import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/services/NotificationHelper.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.instance.deleteDatabaseFile(); // Only for development
  tz.initializeTimeZones(); // Add this!
   tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Change to your timezone if needed

  await NotificationHelper.initialize();
  // Request notification permission
  bool permissionGranted = await NotificationHelper.requestPermission();
  if (!permissionGranted) {
    print('Notification permission not granted.');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 4000.0,
        backgroundColor: Colors.black,
        nextScreen: HomePage(),
        splash: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
              ),
              Image.asset(
                'images/startup_anime.gif',
              ),
              const Text(
                'STEP NEXUS',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ), // Load HomePage
    );
  }
}
