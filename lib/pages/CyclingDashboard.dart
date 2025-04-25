import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer/speedometer.dart';
import 'dart:async';

class CyclingDashboard extends StatefulWidget {
  const CyclingDashboard({super.key});

  @override
  _CyclingDashboardState createState() => _CyclingDashboardState();
}

class SessionDetails extends StatelessWidget {
  final double speed;
  final double distance;
  final double caloriesBurned;

  const SessionDetails({
    required this.speed,
    required this.distance,
    required this.caloriesBurned,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSessionTile("Distance", "${distance.toStringAsFixed(2)} km"),
        _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} km/h"),
        _buildSessionTile(
          "Calories Burned",
          "${caloriesBurned.toStringAsFixed(2)} cal",
        ),
      ],
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

class _CyclingDashboardState extends State<CyclingDashboard> {
  bool isSessionActive = false;
  double distance = 0.0; // in kilometers
  double speed = 0.0; // in km/h
  double caloriesBurned = 0.0;

  int lastCycleDistance = 1; // kilometers
  int lastCycleTarget = 6; // kilometers

  StreamSubscription<Position>? positionStream;
  final PublishSubject<double> speedSubject = PublishSubject<double>();

  final int start = 0; // Minimum speed
  final int end = 50; // Maximum speed
  final int _lowerValue = 10; // Example lower highlight value
  final int _upperValue = 40; // Example upper highlight value
  final Duration _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    if (isSessionActive) {
      _startTrackingSpeed();
    }

    // Example of dummy stream of data for testing
    Stream.periodic(Duration(seconds: 1), (count) {
      // Simulating speed data and explicitly casting to double
      double simulatedSpeed = (count % 50).toDouble();
      speedSubject.add(simulatedSpeed); // Updating the stream
    }).listen((data) {
      // Cast the 'data' as double explicitly
      double simulatedSpeed = (data as double); // Cast Object? to double
      setState(() {
        speed = simulatedSpeed; // Update the speed value
      });
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    speedSubject.close();
    super.dispose();
  }

  void startSession() {
    setState(() {
      isSessionActive = true;
      distance = 0.0;
      speed = 0.0;
      caloriesBurned = 0.0;
    });
    _startTrackingSpeed();
  }

  void stopSession() {
    setState(() {
      isSessionActive = false;
    });
    positionStream?.cancel();
  }

  void _startTrackingSpeed() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen((Position position) {
      setState(() {
        speed = position.speed * 3.6; // Convert m/s to km/h
      });
      speedSubject.add(speed);
    });
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
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: 30),
              // Speedometer
              Center(
                child: SizedBox(
                  width: 250, // Set the desired width
                  height: 250, // Set the desired height
                  child: SpeedOMeter(
                    start: start,
                    end: end,
                    highlightStart: (_lowerValue / end),
                    highlightEnd: (_upperValue / end),
                    themeData: Theme.of(context),
                    eventObservable: speedSubject,
                    animationDuration: _animationDuration,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Session Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Use the SessionDetails widget
              SessionDetails(
                speed: speed,
                distance: distance,
                caloriesBurned: caloriesBurned,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: isSessionActive ? stopSession : startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSessionActive ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child:
                      Text(isSessionActive ? "Stop Session" : "Start Session"),
                ),
              ),
            ],
          ),
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
