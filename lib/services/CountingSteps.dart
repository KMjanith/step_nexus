import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class Countingsteps {
  static List<String> countSteps(List<AccelerometerEvent> data) {
    List<String> detectedSteps = [];
    if (data.length < 3) return detectedSteps;

    double threshold = 11.5;
    int minStepIntervalMs = 400;

    double value1 = magnitude(data[0]);
    double value2 = magnitude(data[1]);
    double value3 = magnitude(data[2]);

    int lastStepTime = data[1].timestamp.millisecondsSinceEpoch;

    if (isStep(value1, value2, value3, threshold)) {
      detectedSteps.add("M: ${value2.toStringAsFixed(2)}, time: $lastStepTime");
    }

    for (int i = 3; i < data.length; i++) {
      value1 = value2;
      value2 = value3;
      value3 = magnitude(data[i]);

      int currentTime = data[i].timestamp.millisecondsSinceEpoch;

      if (isStep(value1, value2, value3, threshold)) {
        if (currentTime - lastStepTime > minStepIntervalMs) {
          detectedSteps
              .add("M: ${value2.toStringAsFixed(2)}, time: $currentTime");
          lastStepTime = currentTime;
        }
      }
    }

    return detectedSteps;
  }

  static bool isStep(double v1, double v2, double v3, double threshold) {
    return v2 > v1 && v2 > v3 && v2 > threshold;
  }

  static double magnitude(AccelerometerEvent e) {
    return sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
  }
}
