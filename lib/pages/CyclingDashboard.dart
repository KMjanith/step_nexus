import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math' show cos, sqrt, asin, pi;

import 'package:walking_nexus/pages/TargetSelectionScreen.dart';

class CyclingDashboard extends StatefulWidget {
  final Target target;

  const CyclingDashboard({required this.target, super.key});

  @override
  _CyclingDashboardState createState() => _CyclingDashboardState();
}

class _CyclingDashboardState extends State<CyclingDashboard> {
  bool isSessionActive = false;
  double distance = 0.0; // in kilometers
  double speed = 0.0; // in km/h
  double caloriesBurned = 0.0;
  double weight = 70.0; // Default weight in kg
  Position? lastPosition;

  int lastCycleDistance = 1; // kilometers
  int lastCycleTarget = 6; // kilometers

  StreamSubscription<Position>? positionStream;
  Timer? calorieTimer;

  DateTime? sessionStartTime;

  // Timer-related variables
  Duration elapsedTime = Duration.zero;
  Timer? timer;

  void startSession() async {
    bool hasPermission = await _requestPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location permission is required to start the session.')),
      );
      return;
    }
    setState(() {
      isSessionActive = true;
      distance = 0.0;
      speed = 0.0;
      caloriesBurned = 0.0;
      sessionStartTime = DateTime.now();
    });

    // Start the timer
    timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      setState(() {
        int milliseconds = elapsedTime.inMilliseconds + 10;
        if (milliseconds % 1000 == 0) {
          // Increment seconds when milliseconds reach 1000
          elapsedTime = Duration(seconds: elapsedTime.inSeconds + 1);
        } else {
          // Update milliseconds manually
          elapsedTime = Duration(
            seconds: elapsedTime.inSeconds,
            milliseconds: milliseconds % 1000,
          );
        }
      });
    });

    _startTrackingSpeed();
    _startCalorieCalculation();
  }

  void stopSession() {
    // Stop the timer
    timer?.cancel();
    setState(() {
      isSessionActive = false;

      speed = 0.0;
      // Save session data to local database (placeholder)
      print(
        "Cycling session saved: Distance: $distance km, Speed: $speed km/h, Calories: $caloriesBurned cal",
      );
    });
    positionStream?.cancel();
    calorieTimer?.cancel();
  }

  Future<bool> _requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  void _startTrackingSpeed() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen((Position position) {
      setState(() {
        speed = position.speed * 3.6; // Convert m/s to km/h
        if (lastPosition != null) {
          double distanceMeters = Geolocator.distanceBetween(
            lastPosition!.latitude,
            lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          distance += distanceMeters / 1000.0; // Convert to km
        }
        lastPosition = position;
      });
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error tracking location: $error')),
      );
    });
  }

  void _startCalorieCalculation() {
    const double met = 6.0; // MET for moderate cycling
    calorieTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (!isSessionActive) {
        timer.cancel();
        return;
      }
      final durationHours =
          DateTime.now().difference(sessionStartTime!).inSeconds / 3600.0;
      setState(() {
        caloriesBurned = met * weight * durationHours;
      });
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        (duration.inMilliseconds.remainder(1000) ~/ 10)
            .toString()
            .padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    double lastCycleProgress = lastCycleDistance / lastCycleTarget;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cycling Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Progress (Last Walk)
            Center(
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 16.0,
                percent: lastCycleProgress.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'images/cycling.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(
                      "$lastCycleDistance",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "km",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
                progressColor: Colors.green,
                backgroundColor: Colors.lightGreen.shade100,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            //timer
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  formatDuration(elapsedTime),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),
            // Speed Display
            Center(
              child: Column(
                children: [
                  const Text(
                    "Current Speed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${speed.toStringAsFixed(2)} km/h",
                    style: const TextStyle(fontSize: 30, color: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Session Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSessionTile("Distance", "${distance.toStringAsFixed(2)} km"),
            _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} km/h"),
            _buildSessionTile(
              "Calories Burned",
              "${caloriesBurned.toStringAsFixed(2)} cal",
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isSessionActive ? stopSession : startSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSessionActive ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(isSessionActive ? "Stop Session" : "Start Session"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }
}
