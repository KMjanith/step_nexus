import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
import 'package:walking_nexus/components/DashboardButton.dart';
import 'package:walking_nexus/sources/database_helper.dart';

enum Activity { walking, cycling, travelling }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notifications = [
    "You've been idle for 2 hours. Time to walk!",
    "Great job! You completed 80% of your weekly goal.",
    "New goal available: Walk 7000 steps today.",
    "Reminder: Stay hydrated while walking.",
    "Check your progress in the stats section."
  ];

  final dummySessions = [
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
      'time_spend': 1800,
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
      'time_spend': 1200,
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
      'time_spend': 1500,
      'date': '2025-05-12',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //insertDummySessions();
    //deleteData();
  }

  void insertDummySessions() async {
    for (var session in dummySessions) {
      await DatabaseHelper.instance.insertWalkingSession(session);
    }
    print('Dummy sessions inserted');
  }

  void deleteData() async {
    var lisstIds = [4, 5, 6];
    for (var id in lisstIds) {
      await DatabaseHelper.instance.deleteWalkingSession(id);
    }
  }

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
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 155, 255, 188),
                                  Color.fromARGB(255, 130, 255, 234),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Welcome to Step Nexus",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color:
                                          const Color.fromARGB(255, 26, 71, 0),
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          'Roboto'), // Example of a good font
                                ),
                                Icon(Icons.health_and_safety_outlined,
                                    color:
                                        const Color.fromARGB(255, 175, 88, 88),
                                    size: 35),
                              ],
                            ),
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
