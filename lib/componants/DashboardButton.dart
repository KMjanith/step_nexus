import 'package:flutter/material.dart';

class Dashboardbutton extends StatelessWidget {
  Widget navigaationPage;
  String imagePath;
  String buttondescription;

  Dashboardbutton(
      {required this.navigaationPage,
      required this.imagePath,
      required this.buttondescription,
      super.key});

  @override
  Widget build(BuildContext context) {
    // This widget is a button that navigates to the WalkingRunningDashboard page when tapped.
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigaationPage),
        );
      },
      child: Container(
        width: 350,
        margin: EdgeInsets.only(bottom: 8, top: 8),
        height: 105,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple], // Gradient colors
            begin: Alignment.topLeft, // Gradient start position
            end: Alignment.bottomRight, // Gradient end position
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 8, // How soft the shadow is
              offset: Offset(4, 4), // Position of the shadow (x, y)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 4, 217, 255),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath, // Replace with the walking image
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Text(
              buttondescription,
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward, // Right arrow icon
              color: const Color.fromARGB(255, 255, 255, 255),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
