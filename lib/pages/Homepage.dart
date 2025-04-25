import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/CyclingDashboard.dart';
import 'package:walking_nexus/pages/TravellingDashbaord.dart';
import 'package:walking_nexus/sources/UserMenu.dart';
import 'package:walking_nexus/componants/DashboardButton.dart';
import 'package:walking_nexus/pages/SensorDataPage.dart';
import 'package:walking_nexus/pages/WalkingRunningDashboard.dart';

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
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => UserMenu()),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue,
              //       foregroundColor: Colors.white,
              //       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //     ),
              //     child: Text("Database Data"),
              //   ),
              // ),

              // SizedBox(height: 20),

              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(195, 223, 223, 223),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly, // Adjust spacing
                      children: [
                        Dashboardbutton(
                          navigaationPage: WalkingRunningDashboard(),
                          imagePath: 'images/walking-homepage.png',
                          buttondescription: 'Walking',
                        ),
                        Dashboardbutton(
                          navigaationPage: CyclingDashboard(),
                          imagePath: 'images/cycling.png',
                          buttondescription: "Cycling",
                        ),
                        Dashboardbutton(
                          navigaationPage: TravellingDashboard(),
                          imagePath: 'images/travelling.png',
                          buttondescription: "Travelling",
                        ),
                      ],
                    ),
                  ),
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
}
