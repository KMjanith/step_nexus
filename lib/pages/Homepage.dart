import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:walking_nexus/pages/SensorDataPage.dart';
import 'package:walking_nexus/pages/SetStepGoal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalSteps = 150000; // Example total step count
  int recordedDays = 30; // Example recorded days
  int caloriesBurned = 5200; // Example calorie count

  int lastWalkSteps = 3500; // Last recorded walk steps
  int lastWalkGoal = 5000; // Last walk goal

  List<String> notifications = [
    "You've been idle for 2 hours. Time to walk!",
    "Great job! You completed 80% of your weekly goal.",
    "New goal available: Walk 7000 steps today.",
    "Reminder: Stay hydrated while walking.",
    "Check your progress in the stats section."
  ];

  @override
  Widget build(BuildContext context) {
    double lastWalkProgress = lastWalkSteps / lastWalkGoal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Step Nexus'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,

      // Scrollable Content
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Text(
                "Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryTile("Total Steps", "$totalSteps"),
                  _buildSummaryTile("Recorded Days", "$recordedDays"),
                  _buildSummaryTile("Calories Burned", "$caloriesBurned cal"),
                ],
              ),
              SizedBox(height: 35),

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
                          'images/Pasted_image-removebg-preview.png',
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

              // Set Step Goal Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SetStepGoal()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text("Set Today's Goal"),
                ),
              ),
              SizedBox(height: 20),

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
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text("View Sensor Data"),
                ),
              ),

              // Notifications Header
              Text(
                "Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Notifications ListView (inside Column, with `shrinkWrap`)
              ListView.builder(
                shrinkWrap: true, // Ensures it takes only the space it needs
                physics:
                    NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.notifications, color: Colors.green),
                      title: Text(
                        notifications[index],
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create summary tiles
  Widget _buildSummaryTile(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
