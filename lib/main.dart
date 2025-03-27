import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/pages/Optionspage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OptionsPage(), // Load HomePage
    );
  }
}
