import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/sources/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.instance.deleteDatabaseFile(); // Only for development
  //insertDummySessions();
  //insertDummyCyclingSessions();
  //insertDummyTravellingSessions();
  runApp(MyApp());
}

final dummyWalkingSessions = [
  {
    'time_based': 1,
    'distance_based': 0,
    'step_based': 0,
    'target_steps': null,
    'target_distance': null,
    'target_time': 1800,
    'result_steps': 2400,
    'result_distance': 1.5,
    'result_avg_speed': 3.0,
    'burned_calories': 120.5,
    'time_spend': 4,
    'date': '2025-05-14',
  },
  {
    'time_based': 0,
    'distance_based': 1,
    'step_based': 0,
    'target_steps': null,
    'target_distance': 2.0,
    'target_time': null,
    'result_steps': 3200,
    'result_distance': 2.1,
    'result_avg_speed': 3.5,
    'burned_calories': 145.0,
    'time_spend': 2,
    'date': '2025-05-13',
  },
  {
    'time_based': 0,
    'distance_based': 0,
    'step_based': 1,
    'target_steps': 3000,
    'target_distance': null,
    'target_time': null,
    'result_steps': 3050,
    'result_distance': 2.3,
    'result_avg_speed': 4.2,
    'burned_calories': 155.3,
    'time_spend': 1,
    'date': '2025-05-12',
  },
];

void insertDummySessions() async {
  for (var session in dummyWalkingSessions) {
    await DatabaseHelper.instance.insertWalkingSession(session);
  }
  print('Dummy sessions inserted');
}

final dummycyclingSessions = [
  {
    'time_based': 1,
    'distance_based': 0,
    'target_distance': null,
    'target_time': 1800,
    'result_distance': 1.5,
    'result_avg_speed': 3.0,
    'time_spend': 4,
    'burned_calories': 120.5,
    'date': '2025-05-14',
  },
  {
    'time_based': 0,
    'distance_based': 1,
    'target_distance': 2.0,
    'target_time': null,
    'result_distance': 2.1,
    'result_avg_speed': 3.5,
    'time_spend': 2,
    'burned_calories': 145.0,
    'date': '2025-05-13',
  },
];

void insertDummyCyclingSessions() async {
  for (var session in dummycyclingSessions) {
    await DatabaseHelper.instance
        .insertCyclingOrTravellingSession(session, 'cycling');
  }
  print('Dummy sessions inserted');
}

final dummyTravellingSessions = [
  {
    'time_based': 1,
    'distance_based': 0,
    'target_distance': null,
    'target_time': 1800,
    'result_distance': 1.5,
    'result_avg_speed': 3.0,
    'time_spend': 4,
    'date': '2025-05-14',
  },
  {
    'time_based': 0,
    'distance_based': 1,
    'target_distance': 2.0,
    'target_time': null,
    'result_distance': 2.1,
    'result_avg_speed': 3.5,
    'time_spend': 2,
    'date': '2025-05-13',
  },
];

void insertDummyTravellingSessions() async {
  for (var session in dummyTravellingSessions) {
    await DatabaseHelper.instance.insertCyclingOrTravellingSession(session, '');
  }
  print('Dummy sessions inserted');
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
                  fontFamily: 'Poppins'
                ),
              ),
            ],
          ),
        ),
      ), // Load HomePage
    );
  }
}
