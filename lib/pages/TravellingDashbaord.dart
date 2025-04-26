import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class TravellingDashboard extends StatefulWidget {
  const TravellingDashboard({super.key});

  @override
  _TravellingDashboardState createState() => _TravellingDashboardState();
}

class _TravellingDashboardState extends State<TravellingDashboard> {
  bool isSessionActive = false;
  double distance = 0.0; // in kilometers
  double speed = 0.0; // in km/h
  Position? _lastPosition;

  int currentTravelDistance = 2; // kilometers
  int currentTravelTarget = 20; // kilometers

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    // Check if location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Request location permission using permission_handler
    PermissionStatus status = await Permission.location.request();

    if (status.isDenied) {
      // Permission denied, show a message or handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Location permission is required to track travel.")),
      );
      return;
    }

    if (status.isPermanentlyDenied) {
      // Permission permanently denied, guide user to app settings
      openAppSettings();
      return;
    }
  }

  void startSession() {
    print("Hello from Travelling Dashboard");
    setState(() {
      isSessionActive = true;
      distance = 0.0;
      speed = 0.0;
    });
    _startTracking();
  }

  void stopSession() {
    setState(() {
      isSessionActive = false;
    });
    Geolocator.getPositionStream()
        .listen(null); // Stop listening to location updates
    print("Travel session saved: Distance: $distance km, Speed: $speed km/h");
  }

  void _startTracking() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimum distance (in meters) to trigger updates
      ),
    ).listen((Position position) {
      if (_lastPosition != null) {
        // Check if the change in latitude and longitude is significant enough (e.g., > 0.0001 degrees)
        double latChange = (position.latitude - _lastPosition!.latitude).abs();
        double lonChange =
            (position.longitude - _lastPosition!.longitude).abs();

        // Set a threshold for significant change in location
        if (latChange > 0.0001 || lonChange > 0.0001) {
          // Calculate distance only if the change is significant
          double distanceInMeters = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );

          // Only update distance if it is significant (e.g., greater than 10 meters)
          if (distanceInMeters > 10) {
            setState(() {
              distance += distanceInMeters;
            });
          }

          // Handle speed updates: If speed is below a threshold, set it to 0
          double currentSpeed = position.speed; // Speed in meters per second
          if (currentSpeed < 0.1) {
            currentSpeed = 0; // Treat small speed values as zero
          }

          setState(() {
            speed = currentSpeed;
          });

          print(
              "Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
          print("Distance Traveled: ${distanceInMeters.toStringAsFixed(2)} m");
          print("Current Speed: ${currentSpeed.toStringAsFixed(2)} m/s");
        }
      } else {
        // Log the initial position
        print(
            "Initial Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      }

      // Update last position to the current one
      _lastPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentTravelProgress = currentTravelDistance / currentTravelTarget;
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Travel Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Progress (Current Travel)
            Center(
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 16.0,
                percent: currentTravelProgress.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'images/travelling.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(
                      "${distance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "m",
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
            Text(
              "Session Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // _buildSessionTile("Distance", "${distance.toStringAsFixed(2)} km"),
            // _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} km/h"),
            _buildSessionTile("Distance", "${distance.toStringAsFixed(2)} m"),
            _buildSessionTile("Speed", "${speed.toStringAsFixed(2)} m/s"),
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
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
