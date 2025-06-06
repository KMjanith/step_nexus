import 'package:flutter/material.dart';
// import 'package:timezone/timezone.dart' as tz;
import 'package:walking_nexus/components/BottomNavigationButton.dart';
import 'package:walking_nexus/pages/CalendarSchedulePage.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
import 'package:walking_nexus/components/DashboardButton.dart';
// import 'package:walking_nexus/services/NotificationHelper.dart';

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

                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Create Schedule"),
                            content: Text(
                                "Do you want to create your own schedule now?"),
                            actions: [
                              TextButton(
                                child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 30, 148, 0)),
                                    child: Center(
                                        child: Text("Next",
                                            style: TextStyle(
                                                color: Colors.white)))),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CalendarSchedulePage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 37, 204, 190),
                              Color.fromARGB(255, 0, 136, 136)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Make Your own schedule",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Icon(Icons.schedule, color: Colors.white, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
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

          // Positioned(
          //   top: 50,
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.green,
          //       foregroundColor: Colors.white,
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //     ),
          //     icon: Icon(Icons.notifications_active),
          //     label: Text("Trigger Notification"),
          //     onPressed: () async {
          //       bool granted = await NotificationHelper.requestPermission();
          //       if (granted) {
          //         await NotificationHelper.showNotification(
          //           title: "Test Notification",
          //           body:
          //               "This is a test notification triggered by button click.",
          //         );
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(
          //               content: Text("Notification permission not granted")),
          //         );
          //       }
          //     },
          //   ),
          // ),

          //           Positioned(
          //   top: 100,
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.green,
          //       foregroundColor: Colors.white,
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //     ),
          //     icon: Icon(Icons.notifications_active),
          //     label: Text("Trigger Notification"),
          //     onPressed: () async {
          //       bool granted = await NotificationHelper.requestPermission();
          //       if (granted) {
          //         await NotificationHelper.scheduleNotification(
          //           id: 1,
          //           title: "asas",
          //           body: "This is a scheduled notification.",
          //           hour: 19,
          //           minute: 15,
          //         );
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(
          //               content: Text("Notification permission not granted")),
          //         );
          //       }
          //     },
          //   ),
          // ),

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
