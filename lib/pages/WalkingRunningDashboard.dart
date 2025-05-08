import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:walking_nexus/pages/SensorDataPage.dart';

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
  List<double> _magnitudes = [];
  int windowSize = 20;
  DateTime? sessionStartTime;

  List<AccelerometerEvent> sensorData = [];
  StreamSubscription<AccelerometerEvent>? accelSub;

  void startSensorCollection() {
    sensorData.clear();
    accelSub = accelerometerEvents.listen((AccelerometerEvent event) {
      sensorData.add(event);
    });
  }

  void stopSensorCollection() {
    accelSub?.cancel();
  }

  int countStepsFromData(List<AccelerometerEvent> data) {
    int steps = 0;
    double threshold = 11; // Adjust this based on testing
    bool wasAbove = false;

    for (final event in data) {
     double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);


      if (magnitude > threshold) {
        if (!wasAbove) {
          steps++;
          wasAbove = true;
        }
      } else {
        wasAbove = false;
      }
    }
    return steps;
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
    int estimatedSteps = countStepsFromData(sensorData);

    setState(() {
      isSessionActive = false;
      steps = estimatedSteps;
      distance = steps * 0.0008; // example: 0.8 meters per step
      caloriesBurned = steps * 0.04; // example: 0.04 cal per step
      speed = 0.0;
    });
  }

  void _processMagnitude(double magnitude) {
    _magnitudes.add(magnitude);
    if (_magnitudes.length > windowSize) {
      _magnitudes.removeAt(0);
    }

    double mean = _magnitudes.reduce((a, b) => a + b) / _magnitudes.length;
    double stdDev = sqrt(
        _magnitudes.map((m) => pow(m - mean, 2)).reduce((a, b) => a + b) /
            _magnitudes.length);

    if (magnitude > mean + stdDev * 1.2) {
      steps++;
      distance = steps * 0.0008; // ~0.8 meters per step
      caloriesBurned = steps * 0.04; // ~0.04 cal per step

      if (sessionStartTime != null) {
        Duration elapsed = DateTime.now().difference(sessionStartTime!);
        double hours = elapsed.inSeconds / 3600.0;
        if (hours > 0) {
          speed = distance / hours;
        }
      }

      setState(() {});
    }
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
      body: Padding(
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
            const Text(
              "Session Logs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sessionLogs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      sessionLogs[index],
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
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
          ],
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
