import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/Homepage.dart';
//import 'package:walking_nexus/sources/database_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.instance.deleteDatabaseFile(); // Only for development
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Load HomePage
    );
  }
}
