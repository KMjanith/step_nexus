import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

  void startSession() {
    setState(() {
      isSessionActive = true;
      // Reset session data
      distance = 0.0;
      steps = 0;
      caloriesBurned = 0.0;
      speed = 0.0;
    });
  }

  void stopSession() {
    setState(() {
      isSessionActive = false;
      // Save session data to local database (placeholder)
      print("Session data saved: Distance: $distance km, Steps: $steps");
    });
  }

  @override
  Widget build(BuildContext context) {
    double lastWalkProgress = lastWalkSteps / lastWalkGoal;
    return Scaffold(
      appBar: AppBar(
        title: Text("Walking/Running Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                percent: lastWalkProgress.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/Pasted_image-removebg-preview.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(
                      "$lastWalkSteps",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Last Walk",
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
            _buildSessionTile("Steps", "$steps"),
            _buildSessionTile(
                "Calories Burned", "${caloriesBurned.toStringAsFixed(2)} cal"),
            _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} km/h"),
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
