import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Bottomnavigationbutton extends StatelessWidget {
  final VoidCallback onPressed;
  IconData icon;
  String iconDescription;
  Bottomnavigationbutton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.iconDescription});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 219, 219, 219), size: 28),
          Text(
            iconDescription,
            style: TextStyle(
              fontSize: 10,
              color: const Color.fromARGB(255, 219, 219, 219),
            ),
          ),
        ],
      ),
    );
  }
}
