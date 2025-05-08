import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:walking_nexus/pages/SensorDataPage.dart';
import 'package:walking_nexus/services/CountingSteps.dart';

class WalkingRunningDashboard extends StatefulWidget {
  const WalkingRunningDashboard({super.key});

  @override
  _WalkingRunningDashboardState createState() =>
      _WalkingRunningDashboardState();
}

class _WalkingRunningDashboardState extends State<WalkingRunningDashboard> {
  bool isSessionActive = false;
  double distance = 0.0; // in kilometers
  int steps = 0;
  double caloriesBurned = 0.0;
  double speed = 0.0; // in km/h
  int totalSteps = 150000; // Example total step count
  int recordedDays = 30; // Example recorded days

  int lastWalkSteps = 3500; // Last recorded walk steps
  int lastWalkGoal = 5000; // Last walk goal

  StreamSubscription? _accelerometerSub;
  int windowSize = 20;
  DateTime? sessionStartTime;

  List<AccelerometerEvent> sensorData = [];
  StreamSubscription<AccelerometerEvent>? accelSub;

  List<String> countedMagnitudes = [];

  void startSensorCollection() {
    sensorData.clear();
    accelSub = accelerometerEvents.listen((AccelerometerEvent event) {
      sensorData.add(event);
    });
  }

  void stopSensorCollection() {
    accelSub?.cancel();
  }


  void startSession() {
    setState(() {
      isSessionActive = true;
      steps = 0;
      distance = 0.0;
      caloriesBurned = 0.0;
      speed = 0.0;
    });
    startSensorCollection();
  }

  void stopSession() {
    stopSensorCollection();
    print(sensorData);

    //int estimatedSteps = Countingsteps.countStepsFromData(sensorData);
    countedMagnitudes = Countingsteps.countStepsFromData(sensorData);

    int estimatedSteps = countedMagnitudes.length;

    setState(() {
      isSessionActive = false;
      steps = estimatedSteps;
      distance = steps * 0.0008; // example: 0.8 meters per step
      caloriesBurned = steps * 0.04; // example: 0.04 cal per step
      speed = 0.0;
    });
  }

  @override
  void dispose() {
    _accelerometerSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double lastWalkProgress = lastWalkSteps / lastWalkGoal;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Walking/Running Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 16.0,
                  percent: lastWalkProgress.clamp(0.0, 1.0),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/Pasted_image-removebg-preview.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "$lastWalkSteps",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "steps",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                  progressColor: Colors.green,
                  backgroundColor: Colors.lightGreen.shade100,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Session Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSessionTile("Distance", "${distance.toStringAsFixed(2)} km"),
              _buildSessionTile("Steps", "$steps"),
              _buildSessionTile(
                  "Calories Burned", "${caloriesBurned.toStringAsFixed(2)} cal"),
              _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} km/h"),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: isSessionActive ? stopSession : startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSessionActive ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(isSessionActive ? "Stop Session" : "Start Session"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SensorDataPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text("Store Sensor Data"),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  for (String magnitude in countedMagnitudes)
                    Text(
                      magnitude,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
