import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:walking_nexus/components/walkingPastDetails.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/pages/TargetSelectionScreen.dart';
import 'package:walking_nexus/services/CountingSteps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walking_nexus/sources/database_helper.dart';

class WalkingRunningDashboard extends StatefulWidget {
  final Target target;

  const WalkingRunningDashboard({required this.target, super.key});

  @override
  _WalkingRunningDashboardState createState() =>
      _WalkingRunningDashboardState();
}

class _WalkingRunningDashboardState extends State<WalkingRunningDashboard> {
  bool isSessionActive = false;
  double distance = 0.0; // in kilometers
  int startWindow = 0;
  int endWindow = 100;
  int steps = 0;
  double caloriesBurned = 0.0;
  double weight = 70.0; // Default weight in kg
  Position? lastPosition;
  double speed = 0.0; // in km/h
  int totalSteps = 150000; // Example total step count
  int recordedDays = 30; // Example recorded days

  int lastWalkSteps = 3500; // Last recorded walk steps
  int lastWalkGoal = 5000; // Last walk goal

  StreamSubscription<Position>? positionStream;
  Timer? calorieTimer;

  StreamSubscription? _accelerometerSub;
  int windowSize = 20;
  DateTime? sessionStartTime;

  List<AccelerometerEvent> sensorData = [];
  StreamSubscription<AccelerometerEvent>? accelSub;

  List<String> countedMagnitudes = [];

  // Timer-related variables
  Duration elapsedTime = Duration.zero;
  Timer? timer;

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPastSessionData();
  }

  void _loadPastSessionData() async {
    final db = DatabaseHelper.instance;
    List<Map<String, dynamic>> latestSession = [];

    print(widget.target.type);
    switch (widget.target.type) {
      case 'steps':
        latestSession = await db.getStepBasedWalkingSessions();
        break;
      case 'distance':
        latestSession = await db.getDistanceBasedWalkingSessions();
        break;
      case 'time':
        latestSession = await db.getTimeBsedWalkingSessions();
        break;
    }

    setState(() {
      data = latestSession;
    });
  }

  void startSensorCollection() {
    sensorData.clear();
    accelSub = accelerometerEvents.listen((AccelerometerEvent event) {
      sensorData.add(event);
    });
  }

  void stopSensorCollection() {
    accelSub?.cancel();
  }

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
      steps = 0;
      distance = 0.0;
      caloriesBurned = 0.0;
      speed = 0.0;
      elapsedTime = Duration.zero;
      sessionStartTime = DateTime.now();
    });

    // Start the timer
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedTime += const Duration(seconds: 1);
      });
    });

    startSensorCollection();
    _startTrackingSpeed();
    _startCalorieCalculation();

    //loop to run every 4s
    Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (!isSessionActive) {
        t.cancel();
        return;
      }

      if (endWindow <= sensorData.length) {
        List<AccelerometerEvent> window =
            sensorData.sublist(startWindow, endWindow);
        int newSteps = Countingsteps.countSteps(window).length;
        setState(() {
          steps += newSteps;
        });
        startWindow = endWindow;
        endWindow += 100;
      }
    });
  }

  void stopSession() {
    stopSensorCollection();
    // Stop the timer
    timer?.cancel();

    //int estimatedSteps = Countingsteps.countStepsFromData(sensorData);
    List<AccelerometerEvent> window =
        sensorData.sublist(endWindow, sensorData.length);
    countedMagnitudes = Countingsteps.countSteps(window);

    int estimatedSteps = countedMagnitudes.length;

    setState(() {
      isSessionActive = false;
      steps = steps + estimatedSteps;
      distance = steps * 0.0008; // example: 0.8 meters per step
      caloriesBurned = steps * 0.04; // example: 0.04 cal per step
      speed = 0.0;
      startWindow = 0;
      endWindow = 100;
    });
    positionStream?.cancel();
    calorieTimer?.cancel();

    // Ask the user whether to save the data to the database
    _showSaveConfirmationDialog(context);
  }

  Future<void> _showSaveConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save your journey?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you done with your ride?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _saveSessionData();
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _saveSessionData() async {
    // Save the session data to the database
    final dbHelper = DatabaseHelper.instance;
    var type = widget.target.type;
    double value = widget.target.value;

    String formattedTime =
        "${elapsedTime.inHours.toString().padLeft(2, '0')}:${(elapsedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}";

    Map<String, dynamic> sessionData = {
      'time_based': type == 'time' ? 1 : 0,
      'distance_based': type == 'distance' ? 1 : 0,
      'step_based': type == 'steps' ? 1 : 0,
      'target_steps': type == 'steps' ? value : null,
      'target_distance': type == 'distance' ? value : null,
      'target_time': type == 'time' ? value : null,
      'result_steps': steps,
      'result_distance': distance,
      'result_avg_speed': speed,
      'burned_calories': caloriesBurned,
      'time_spend': formattedTime,
      'date': DateTime.now().toString().substring(0, 10),
    };

    await dbHelper.insertWalkingSession(sessionData);
    print('Session data saved to database');
    _loadPastSessionData();
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

  @override
  void dispose() {
    _accelerometerSub?.cancel();
    timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  double _calculateProgress() {
    if (widget.target.type == 'steps') {
      return (steps / widget.target.value).clamp(0.0, 1.0);
    } else if (widget.target.type == 'distance') {
      return (distance / widget.target.value).clamp(0.0, 1.0);
    } else if (widget.target.type == 'time') {
      if (sessionStartTime == null) return 0.0;
      double hoursElapsed =
          DateTime.now().difference(sessionStartTime!).inSeconds / 3600.0;
      return (hoursElapsed / widget.target.value).clamp(0.0, 1.0);
    }
    return 0.0;
  }

  void setNewTarget() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TargetSelectionScreen(
          activity: Activity.walking,
        ),
      ),
    );
  }

  void ondelete(int id) async {
    final db = DatabaseHelper.instance;
    await db.deleteWalkingSession(id);

    _loadPastSessionData();
    Navigator.pop(context);
  }

  // Function to build a session tile

  Widget _buildSessionTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _calculateProgress();
    bool isTargetAchieved = progress >= 1.0;

    String progressText;
    if (isTargetAchieved) {
      progressText = 'Target Achieved';
    } else {
      switch (widget.target.type) {
        case 'steps':
          progressText = '${steps.toInt()}';
          break;
        case 'distance':
          progressText = '${distance.toStringAsFixed(2)}';
          break;
        case 'time':
          double hoursElapsed = sessionStartTime != null
              ? DateTime.now().difference(sessionStartTime!).inMinutes / 60.0
              : 0.0;
          progressText = '${hoursElapsed.toStringAsFixed(2)}';
          break;
        default:
          progressText = 'N/A';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Walking/Running Dashboard"),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 16.0,
                  percent: progress,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/Pasted_image-removebg-preview.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        progressText,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.target.type == 'steps'
                            ? "steps"
                            : widget.target.type == 'distance'
                                ? "km"
                                : "hours",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                  progressColor: isTargetAchieved
                      ? Colors.amber.shade700
                      : Colors.green.shade700,
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
              // Center(
              //   child: Column(
              //     children: [
              //       const Text(
              //         "Current Speed",
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //       ),
              //       const SizedBox(height: 10),
              //       Text(
              //         "${speed.toStringAsFixed(2)} km/h",
              //         style: const TextStyle(fontSize: 30, color: Colors.green),
              //       ),
              //     ],
              //   ),
              // ),

              //target
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(109, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: _buildSessionTile(
                      "Target",
                      "${widget.target.value.toStringAsFixed(2)} ${widget.target.type == 'steps' ? 'steps' : widget.target.type == 'distance' ? 'km' : 'hours'}"),
                ),
              ),

              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: setNewTarget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(237, 255, 255, 255),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    //border raious
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //width 100%
                    minimumSize: Size(double.infinity, 50),
                    //border color
                    side: const BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Set New Target",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  //Text color
                ),
              ),

              //session details
              const SizedBox(height: 15),
              const Text(
                "Session Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(109, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      _buildSessionTile(
                          "Distance", "${distance.toStringAsFixed(2)} km"),
                      _buildSessionTile("Steps", "$steps"),
                      _buildSessionTile("Calories Burned",
                          "${caloriesBurned.toStringAsFixed(2)} cal"),
                      _buildSessionTile(
                          "Speed", "${speed.toStringAsFixed(2)} km/h"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: isSessionActive ? stopSession : startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSessionActive ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    //border raious
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //width 100%
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child:
                      Text(isSessionActive ? "Stop Session" : "Start Session"),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Past Walkings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Column(
                children: [
                  for (var i in data)
                    Walkingpastdetails(pastData: i, onDelete: ondelete)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
