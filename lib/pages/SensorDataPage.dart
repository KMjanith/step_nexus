import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:csv/csv.dart';

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  double accelX = 0.0, accelY = 0.0, accelZ = 0.0;
  double gyroX = 0.0, gyroY = 0.0, gyroZ = 0.0;
  bool isRecording = false;
  List<List<dynamic>> sensorData = [];
  Timer? _timer;
  int elapsedSeconds = 0;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
  }

  void startRecording() {
    setState(() {
      isRecording = true;
      elapsedSeconds = 0;
      sensorData.clear();
    });

    // Start Timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });

    // Start Listening to Sensors
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        accelX = event.x;
        accelY = event.y;
        accelZ = event.z;
      });
      if (isRecording) {
        sensorData.add([
          DateTime.now().toIso8601String(),
          'Accelerometer',
          accelX,
          accelY,
          accelZ
        ]);
      }
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      setState(() {
        gyroX = event.x;
        gyroY = event.y;
        gyroZ = event.z;
      });
      if (isRecording) {
        sensorData.add([
          DateTime.now().toIso8601String(),
          'Gyroscope',
          gyroX,
          gyroY,
          gyroZ
        ]);
      }
    });
  }

  void stopRecording() async {
    setState(() {
      isRecording = false;
    });

    _timer?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    await saveToCSV();
  }

  Future<void> saveToCSV() async {
    Directory? directory =
        Directory('/storage/emulated/0/Download'); // Public folder

    if (!await directory.exists()) {
      await directory.create(recursive: true); // Create if it doesn’t exist
    }

    String filePath = '${directory.path}/sensor_data.csv';
    String csvData = const ListToCsvConverter().convert(sensorData);

    File file = File(filePath);
    await file.writeAsString(csvData);

    print("CSV saved at: $filePath");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('CSV Saved: $filePath')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recording Time: $elapsedSeconds sec', style: _headerStyle()),
            SizedBox(height: 10),
            Text('Accelerometer:', style: _headerStyle()),
            _buildSensorRow(accelX, accelY, accelZ),
            SizedBox(height: 10),
            Text('Gyroscope:', style: _headerStyle()),
            _buildSensorRow(gyroX, gyroY, gyroZ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isRecording ? stopRecording : startRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecording ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorRow(double x, double y, double z) {
    return Column(
      children: [
        Text("X: $x", style: _valueStyle()),
        Text("Y: $y", style: _valueStyle()),
        Text("Z: $z", style: _valueStyle()),
      ],
    );
  }

  TextStyle _headerStyle() =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle _valueStyle() => TextStyle(fontSize: 16, color: Colors.black54);
}
