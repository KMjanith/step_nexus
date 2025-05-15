import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
import 'package:walking_nexus/components/DashboardButton.dart';

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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //insertDummySessions();
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
                              border: Border.all(color: const Color.fromARGB(174, 76, 175, 79), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 128, 255, 228)
                                      .withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 7,
                                  offset: Offset(
                                      1, 1), // changes position of shadow
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
