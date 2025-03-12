import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  double accelX = 0.0, accelY = 0.0, accelZ = 0.0;
  double gyroX = 0.0, gyroY = 0.0, gyroZ = 0.0;
  double magX = 0.0, magY = 0.0, magZ = 0.0;

  @override
  void initState() {
    super.initState();

    // Accelerometer
    accelerometerEvents.listen((event) {
      setState(() {
        accelX = event.x;
        accelY = event.y;
        accelZ = event.z;
      });
    });

    // Gyroscope
    gyroscopeEvents.listen((event) {
      setState(() {
        gyroX = event.x;
        gyroY = event.y;
        gyroZ = event.z;
      });
    });

    // Magnetometer
    magnetometerEvents.listen((event) {
      setState(() {
        magX = event.x;
        magY = event.y;
        magZ = event.z;
      });
    });
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
            Text('Accelerometer:', style: _headerStyle()),
            _buildSensorRow(accelX, accelY, accelZ),

            SizedBox(height: 10),
            Text('Gyroscope:', style: _headerStyle()),
            _buildSensorRow(gyroX, gyroY, gyroZ),

            SizedBox(height: 10),
            Text('Magnetometer:', style: _headerStyle()),
            _buildSensorRow(magX, magY, magZ),
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

  TextStyle _headerStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }

  TextStyle _valueStyle() {
    return TextStyle(fontSize: 16, color: Colors.black54);
  }
}
