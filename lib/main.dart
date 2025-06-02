import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/services/NotificationHelper.dart';
import 'package:walking_nexus/sources/database_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.instance.deleteDatabaseFile(); // Only for development

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
