import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/CyclingDashboard.dart';
import 'package:walking_nexus/pages/WalkingDashboard.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Dashboards",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.directions_walk, color: Colors.green),
              title: Text("Walking/Running"),
              onTap: () {
                // Navigate to Walking/Running Dashboard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WalkingRunningDashboard()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.directions_bike, color: Colors.blue),
              title: Text("Cycling"),
              onTap: () {
                // Navigate to Cycling Dashboard
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CyclingDashboard()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.directions_car, color: Colors.orange),
              title: Text("Travelling in a Vehicle"),
              onTap: () {
                // Navigate to Travelling in a Vehicle Dashboard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlaceholderPage("Vehicle Dashboard")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder page for dashboards
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "$title is under construction!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
