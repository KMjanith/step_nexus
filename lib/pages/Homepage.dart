import 'package:flutter/material.dart';
import 'package:walking_nexus/components/BottomNavigationButton.dart';
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
          AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Welcome to Step Nexus",
                  style: TextStyle(
                      fontSize: 22,
                      color: const Color.fromARGB(255, 26, 71, 0),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'), // Example of a good font
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
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
                            imagePath: 'images/walking_anime.gif',
                            buttondescription: 'Walking',
                          ),
                          Dashboardbutton(
                            onPressed: () => _navigateToTargetSelection(
                                context, Activity.cycling),
                            imagePath: 'images/cycling_anime.gif',
                            buttondescription: 'Cycling',
                          ),
                          Dashboardbutton(
                            onPressed: () => _navigateToTargetSelection(
                                context, Activity.travelling),
                            imagePath: 'images/travel_anime.gif',
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
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 104, 122),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Bottomnavigationbutton(
                          onPressed: () => _navigateToTargetSelection(
                              context, Activity.walking),
                          icon: Icons.nordic_walking,
                          iconDescription: "Walk"),
                      Bottomnavigationbutton(
                          onPressed: () => _navigateToTargetSelection(
                              context, Activity.cycling),
                          icon: Icons.pedal_bike,
                          iconDescription: "Cycle"),
                      Bottomnavigationbutton(
                          onPressed: () => _navigateToTargetSelection(
                              context, Activity.travelling),
                          icon: Icons.travel_explore,
                          iconDescription: "Travel"),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
