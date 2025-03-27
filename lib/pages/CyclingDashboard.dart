import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CyclingDashboard extends StatefulWidget {
  const CyclingDashboard({super.key});

  @override
  _CyclingDashboardState createState() => _CyclingDashboardState();
}

class _CyclingDashboardState extends State<CyclingDashboard> {
  bool isSessionActive = false;
  double distance = 0.0; // in kilometers
  double speed = 0.0; // in km/h
  double caloriesBurned = 0.0;

  int lastCycleDistance = 1; // kilometers
  int lastCycleTarget = 6; // kilometers

  void startSession() {
    setState(() {
      isSessionActive = true;
      distance = 0.0;
      speed = 0.0;
      caloriesBurned = 0.0;
    });
  }

  void stopSession() {
    setState(() {
      isSessionActive = false;
      // Save session data to local database (placeholder)
      print(
          "Cycling session saved: Distance: $distance km, Speed: $speed km/h, Calories: $caloriesBurned cal");
    });
  }

  @override
  Widget build(BuildContext context) {
    double lastCycleProgress = lastCycleDistance / lastCycleTarget;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cycling Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Progress (Last Walk)
            Center(
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 16.0,
                percent: lastCycleProgress.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/cycling.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(
                      "$lastCycleDistance",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "km",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
                progressColor: Colors.green,
                backgroundColor: Colors.lightGreen.shade100,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Session Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSessionTile("Distance", "${distance.toStringAsFixed(2)} km"),
            _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} km/h"),
            _buildSessionTile(
                "Calories Burned", "${caloriesBurned.toStringAsFixed(2)} cal"),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isSessionActive ? stopSession : startSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSessionActive ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(isSessionActive ? "Stop Session" : "Start Session"),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
