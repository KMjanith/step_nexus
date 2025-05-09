import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/CyclingDashboard.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
import 'package:walking_nexus/pages/TravellingDashboard.dart';
import 'package:walking_nexus/components/DashboardButton.dart';
import 'package:walking_nexus/pages/WalkingRunningDashboard.dart';

enum Activity { walking, cycling, travelling }

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

  void _navigateToTargetSelection(BuildContext context, Activity activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TargetSelectionScreen(activity: activity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),

      // Stack for background and content
      body: Stack(
        children: [
          // Background
          // Positioned(
          //     child: Container(
          //   height: 550,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //         const Color.fromARGB(255, 204, 237, 253),
          //         const Color.fromARGB(255, 166, 223, 252),
          //         const Color.fromARGB(255, 73, 180, 233),
          //       ],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(70),
          //       bottomRight: Radius.circular(70),
          //     ),
          //   ),
          // )),

          // Scrollable Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          "Welcome to Walking Nexus",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Dashboardbutton(
                            onPressed: () => _navigateToTargetSelection(
                                context, Activity.walking),
                            imagePath: 'images/walking-homepage.png',
                            buttondescription: 'Walking',
                          ),
                          Dashboardbutton(
                            onPressed: () => _navigateToTargetSelection(
                                context, Activity.cycling),
                            imagePath: 'images/cycling.png',
                            buttondescription: 'Cycling',
                          ),
                          Dashboardbutton(
                            onPressed: () => _navigateToTargetSelection(
                                context, Activity.travelling),
                            imagePath: 'images/travelling.png',
                            buttondescription: 'Travelling',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Notifications Header
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // Notifications ListView
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading:
                              Icon(Icons.notifications, color: Colors.green),
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
        ],
      ),
    );
  }
}
